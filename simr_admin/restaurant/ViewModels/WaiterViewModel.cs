using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System;
using Firebase.Auth.Providers;
using Firebase.Auth;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    internal class WaiterViewModel : INotifyPropertyChanged
    {
        private const string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient;
        private string _userId;
        private string _welcomeMessage;
        private bool _isRefreshing;
        private string WebApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";

        private string _cookedOrdersTitle = "Cooked Orders (0)";
        private string _canceledWithFeeOrdersTitle = "Canceled with Fee Orders (0)";

        public ObservableCollection<OrderItemWaiter> CookedOrders { get; set; } = new();
        public ObservableCollection<OrderItemWaiter> CanceledWithFeeOrders { get; set; } = new();

        private readonly IDispatcherTimer _refreshTimer;    

        public event PropertyChangedEventHandler? PropertyChanged;

        public string WelcomeMessage
        {
            get => _welcomeMessage;
            set { _welcomeMessage = value; OnPropertyChanged(); }
        }

        public bool IsRefreshing
        {
            get => _isRefreshing;
            set { _isRefreshing = value; OnPropertyChanged(); }
        }

        public string CookedOrdersTitle
        {
            get => _cookedOrdersTitle;
            set { _cookedOrdersTitle = value; OnPropertyChanged(); }
        }

        public string CanceledWithFeeOrdersTitle
        {
            get => _canceledWithFeeOrdersTitle;
            set { _canceledWithFeeOrdersTitle = value; OnPropertyChanged(); }
        }

        public ICommand MarkAsFinishedCommand { get; }
        public ICommand DeleteCanceledOrderCommand { get; }
        public ICommand RefreshCommand { get; }
        public Command MyAccountCommand { get; } = new Command(async () => await Application.Current.MainPage.Navigation.PushAsync(new MyAccCoWa()));
        public Command SignOutBtn { get; }

        public WaiterViewModel()
        {
            _firebaseClient = new FirebaseClient(DatabaseUrl);

            MarkAsFinishedCommand = new Command<string>(async (orderId) => await DeleteOrder(orderId));
            DeleteCanceledOrderCommand = new Command<string>(async (orderId) => await DeleteCanceledOrder(orderId));
            RefreshCommand = new Command(async () => await LoadOrders());
            SignOutBtn = new Command(SignOutBtnTappedAsync);

            CookedOrders.CollectionChanged += (s, e) => UpdateTitles();
            CanceledWithFeeOrders.CollectionChanged += (s, e) => UpdateTitles();

            _refreshTimer = Application.Current.Dispatcher.CreateTimer();
            _refreshTimer.Interval = TimeSpan.FromSeconds(10);       
            _refreshTimer.Tick += async (s, e) => await LoadOrders();      
            _refreshTimer.Start();

            LoadUserData();
        }

        private async Task LoadUserData()
        {
            string loggedInUserId = Preferences.Get("uid", string.Empty);
            if (string.IsNullOrEmpty(loggedInUserId)) return;

            var userEntry = await _firebaseClient.Child("users").Child(loggedInUserId).OnceSingleAsync<User>();
            if (userEntry == null || string.IsNullOrEmpty(userEntry.Owner)) return;

            _userId = userEntry.Owner;
            var ownerEntry = await _firebaseClient.Child("users").Child(_userId).OnceSingleAsync<User>();
            WelcomeMessage = $"Welcome, {userEntry.Name} ({ownerEntry?.Name ?? "Unknown Owner"})";

            await LoadOrders();
        }

        private async Task LoadOrders()
        {
            try
            {
                IsRefreshing = true;

                var rawMenu = await _firebaseClient
                    .Child($"kitchen/{_userId}/menu/list")
                    .OnceSingleAsync<object>();

                var menuItems = new List<MenuItem>();
                if (rawMenu is IEnumerable<object> menuList)
                {
                    foreach (var item in menuList)
                    {
                        var json = JsonConvert.SerializeObject(item);
                        var menuItem = JsonConvert.DeserializeObject<MenuItem>(json);
                        menuItems.Add(menuItem);
                    }
                }

                var rawOrders = await _firebaseClient
                    .Child($"kitchen/{_userId}/menu/orders/list")
                    .OnceSingleAsync<Dictionary<string, object>>();

                var newCookedOrders = new ObservableCollection<OrderItemWaiter>();
                var newCanceledWithFeeOrders = new ObservableCollection<OrderItemWaiter>();

                if (rawOrders != null)
                {
                    foreach (var entry in rawOrders)
                    {
                        var json = JsonConvert.SerializeObject(entry.Value);
                        var order = JsonConvert.DeserializeObject<OrderItemWaiter>(json);

                        if (order != null)
                        {
                            string key = entry.Key;
                            order.id = entry.Key;
                            key = key.Substring(1);
                            order.ids = "Id: " + key;

                            var itemIds = order.food?.Split(' ') ?? Array.Empty<string>();
                            var quantities = order.quantities?.Split(' ') ?? Array.Empty<string>();
                            var itemsList = new List<string>();

                            for (int i = 0; i < itemIds.Length && i < quantities.Length; i++)
                            {
                                if (int.TryParse(itemIds[i], out int idx) && idx >= 0 && idx < menuItems.Count)
                                {
                                    var name = menuItems[idx]?.name ?? "[Unknown]";
                                    itemsList.Add($"{quantities[i]} x {name}");
                                }
                            }
                            var tableString = order.table?.Split(' ') ?? Array.Empty<string>();
                            if (tableString.Length > 0 && tableString[0] == "drive")
                            {
                                order.table = "Drive-thru";
                            }
                            order.DisplayItems = string.Join("\n", itemsList);

                            if (order.status == "cooked")
                            {
                                newCookedOrders.Add(order);
                            }
                            else if (order.status == "canceled_with_fee")
                            {
                                double totalPrice = 0;
                                var priceParts = order.price?.Split(' ') ?? Array.Empty<string>();
                                foreach (var part in priceParts)
                                {
                                    if (double.TryParse(part, out double p))
                                    {
                                        totalPrice += p;
                                    }
                                }

                                order.fee = Math.Round(totalPrice * 0.2, 2).ToString();
                                newCanceledWithFeeOrders.Add(order);
                            }
                        }
                    }
                }

                MainThread.BeginInvokeOnMainThread(() =>
                {
                    CookedOrders.Clear();
                    foreach (var order in newCookedOrders)
                    {
                        CookedOrders.Add(order);
                    }

                    CanceledWithFeeOrders.Clear();
                    foreach (var order in newCanceledWithFeeOrders)
                    {
                        CanceledWithFeeOrders.Add(order);
                    }
                    UpdateTitles();
                });
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load orders: {ex.Message}", "OK");
            }
            finally
            {
                IsRefreshing = false;
            }
        }

        private async Task DeleteOrder(string orderId)
        {
            if (string.IsNullOrEmpty(orderId)) return;

            try
            {
                await _firebaseClient
                    .Child($"kitchen/{_userId}/menu/orders/list/{orderId}")
                    .DeleteAsync();

                MainThread.BeginInvokeOnMainThread(() =>
                {
                    var order = CookedOrders.FirstOrDefault(o => o.id == orderId);
                    if (order != null)
                    {
                        CookedOrders.Remove(order);
                    }
                    UpdateTitles();
                });
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to delete order: {ex.Message}", "OK");
            }
        }

        private async Task DeleteCanceledOrder(string orderId)
        {
            if (string.IsNullOrEmpty(orderId)) return;

            try
            {
                await _firebaseClient
                    .Child($"kitchen/{_userId}/menu/orders/list/{orderId}")
                    .DeleteAsync();

                MainThread.BeginInvokeOnMainThread(() =>
                {
                    var order = CanceledWithFeeOrders.FirstOrDefault(o => o.id == orderId);
                    if (order != null)
                    {
                        CanceledWithFeeOrders.Remove(order);
                    }
                    UpdateTitles();
                });

                await Application.Current.MainPage.DisplayAlert("Success", "Canceled order deleted", "OK");
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to delete canceled order: {ex.Message}", "OK");
            }
        }

        private void UpdateTitles()
        {
            CookedOrdersTitle = $"Cooked Orders ({CookedOrders.Count})";
            CanceledWithFeeOrdersTitle = $"Canceled with Fee Orders ({CanceledWithFeeOrders.Count})";
        }

        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private async void SignOutBtnTappedAsync(object obj)
        {
            var authConfig = new FirebaseAuthConfig
            {
                ApiKey = WebApiKey,
                AuthDomain = "restaurant-3e115.firebaseapp.com",
                Providers = new FirebaseAuthProvider[]
                {
                    new EmailProvider()
                }
            };
            var authProvider = new FirebaseAuthClient(authConfig);
            try
            {
                authProvider.SignOut();
                Preferences.Remove("SavedUsername");
                Preferences.Remove("SavedPassword");
                Application.Current.MainPage = new NavigationPage(new LoginPage());
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Alert", ex.Message, "OK");
            }
        }

        public class OrderItemWaiter
        {
            public string id { get; set; }
            public string food { get; set; }
            public string payment { get; set; }
            public string price { get; set; }
            public string quantities { get; set; }
            public string status { get; set; }
            public string table { get; set; }
            public string ids { get; set; }
            public string DisplayItems { get; set; }
            public string observations { get; set; }
            public string fee { get; set; }
        }

        public class User
        {
            public string Name { get; set; }
            public string Owner { get; set; }
        }

        public class MenuItem
        {
            public string name { get; set; }
        }
    }
}