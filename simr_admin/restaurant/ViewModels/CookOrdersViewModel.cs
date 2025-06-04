using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Input;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace restaurant.ViewModels
{
    internal class CookOrdersViewModel : INotifyPropertyChanged
    {
        private const string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient;
        private string _userId;
        private bool _isRefreshing;
        private string _placedOrdersTitle = "Placed Orders (0)";
        private string _pendingOrdersTitle = "Pending Orders (0)";
        private readonly IDispatcherTimer _refreshTimer;    

        public ObservableCollection<OrderItemCook> PlacedOrders { get; set; } = new();
        public ObservableCollection<OrderItemCook> PendingOrders { get; set; } = new();

        public string PlacedOrdersTitle { get => _placedOrdersTitle; set { _placedOrdersTitle = value; OnPropertyChanged(); } }
        public string PendingOrdersTitle { get => _pendingOrdersTitle; set { _pendingOrdersTitle = value; OnPropertyChanged(); } }
        public bool IsRefreshing { get => _isRefreshing; set { _isRefreshing = value; OnPropertyChanged(); } }

        public ICommand MarkAsPendingCommand { get; }
        public ICommand MarkAsCookedCommand { get; }
        public ICommand RefreshCommand { get; }

        public CookOrdersViewModel()
        {
            _firebaseClient = new FirebaseClient(DatabaseUrl);
            MarkAsPendingCommand = new Command<OrderItemCook>(async (order) => await UpdateOrderStatus(order, "pending"));
            MarkAsCookedCommand = new Command<OrderItemCook>(async (order) => await UpdateOrderStatus(order, "cooked"));
            RefreshCommand = new Command(async () => await LoadOrders());

            _refreshTimer = Application.Current.Dispatcher.CreateTimer();
            _refreshTimer.Interval = TimeSpan.FromSeconds(10);       
            _refreshTimer.Tick += async (s, e) => await LoadOrders();      
            _refreshTimer.Start();

            LoadUserData();
        }

        private async Task LoadUserData()
        {
            string loggedInUserId = Preferences.Get("uid", string.Empty);
            if (string.IsNullOrEmpty(loggedInUserId))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "User ID not found!", "OK");
                return;
            }

            var userEntry = await _firebaseClient.Child("users").Child(loggedInUserId).OnceSingleAsync<User>();
            if (userEntry == null || string.IsNullOrEmpty(userEntry.Owner))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "Owner not found for this user!", "OK");
                return;
            }

            _userId = userEntry.Owner;
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

                var orders = new List<OrderItemCook>();
                if (rawOrders != null)
                {
                    foreach (var entry in rawOrders)
                    {
                        var json = JsonConvert.SerializeObject(entry.Value);
                        var order = JsonConvert.DeserializeObject<OrderItemCook>(json);
                        if (order != null)
                        {
                            string key = entry.Key;
                            order.id = entry.Key;
                            key = key.Substring(1);
                            order.ids = "Id: " + key;
                            orders.Add(order);
                        }
                    }
                }

                var newPlacedOrders = new ObservableCollection<OrderItemCook>();
                var newPendingOrders = new ObservableCollection<OrderItemCook>();

                foreach (var order in orders)
                {
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

                    order.DisplayItems = string.Join("\n", itemsList);

                    if (order.status == "placed")
                        newPlacedOrders.Add(order);
                    else if (order.status == "pending")
                        newPendingOrders.Add(order);
                }

                MainThread.BeginInvokeOnMainThread(() =>
                {
                    PlacedOrders.Clear();
                    foreach (var order in newPlacedOrders)
                    {
                        PlacedOrders.Add(order);
                    }

                    PendingOrders.Clear();
                    foreach (var order in newPendingOrders)
                    {
                        PendingOrders.Add(order);
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

        private async Task<int> GetSafeIntValue(ChildQuery reference)
        {
            try
            {
                return await reference.OnceSingleAsync<int>();
            }
            catch
            {
                return 0;
            }
        }

        private async Task UpdateOrderStatus(OrderItemCook order, string newStatus)
        {
            if (order == null) return;

            var orderPath = $"kitchen/{_userId}/menu/orders/list/{order.id}";

            await _firebaseClient
                .Child($"{orderPath}/status")
                .PutAsync($"\"{newStatus}\"");

            if (newStatus == "pending")
            {
                PlacedOrders.Remove(order);
                order.status = "pending";
                PendingOrders.Add(order);
                var quantitiesList = order.quantities?.Split(' ') ?? Array.Empty<string>();
                int totalQty = 0;
                foreach (var qtyStr in quantitiesList)
                {
                    if (int.TryParse(qtyStr, out int qty))
                        totalQty += qty;
                }
                var countRef = _firebaseClient.Child($"kitchen/{_userId}/menu/orders/count");
                int currentCount = 0;
                try
                {
                    currentCount = await countRef.OnceSingleAsync<int>();
                }
                catch
                {
                    currentCount = 0;
                }
                await countRef.PutAsync(currentCount + totalQty);
                var itemIds = order.food?.Split(' ') ?? Array.Empty<string>();
                for (int i = 0; i < itemIds.Length && i < quantitiesList.Length; i++)
                {
                    if (int.TryParse(itemIds[i], out int itemId) && int.TryParse(quantitiesList[i], out int qty))
                    {
                        var itemCountRef = _firebaseClient.Child($"kitchen/{_userId}/menu/list/{itemId}/count");
                        int currentItemCount = 0;
                        try
                        {
                            currentItemCount = await itemCountRef.OnceSingleAsync<int>();
                        }
                        catch
                        {
                            currentItemCount = 0;
                        }
                        await itemCountRef.PutAsync(currentItemCount + qty);
                    }
                }
            }
            else if (newStatus == "cooked")
            {
                PendingOrders.Remove(order);
            }
            UpdateTitles();
        }
        private void UpdateTitles()
        {
            PlacedOrdersTitle = $"Placed Orders ({PlacedOrders.Count})";
            PendingOrdersTitle = $"Pending Orders ({PendingOrders.Count})";
        }

        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public class OrderItemCook
        {
            public string id { get; set; }
            public string food { get; set; }
            public string payment { get; set; }
            public string price { get; set; }
            public string quantities { get; set; }
            public string table { get; set; }
            public string status { get; set; }
            public string ids { get; set; }
            public string DisplayItems { get; set; }
            public string observations { get; set; }
        }

        public class MenuItem
        {
            public string name { get; set; }
        }

        public class User
        {
            public string Owner { get; set; }
        }

        public class IngredientItem
        {
            public string name { get; set; }
            public double price { get; set; }
            public double quantity { get; set; }
            public double quarepl { get; set; }
            public double replacement { get; set; }
            public string unit { get; set; }
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }
}