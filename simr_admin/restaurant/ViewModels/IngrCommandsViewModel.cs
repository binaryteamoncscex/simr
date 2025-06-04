using Firebase.Database;
using Firebase.Database.Query;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using Microsoft.Maui.Controls;
using static restaurant.ViewModels.ApproveOrdersViewModel;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Newtonsoft.Json.Linq;        

namespace restaurant.ViewModels
{
    internal partial class IngrCommandsViewModel : ObservableObject
    {
        private readonly FirebaseClient _firebaseClient;
        private readonly string _userId;
        private readonly string _databaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";

        public ObservableCollection<OrderItem> Orders { get; set; } = new();
        public ICommand MarkAsDeliveredCommand { get; }
        public IAsyncRelayCommand RefreshCommand { get; }

        [ObservableProperty]
        private bool _isRefreshing;

        public IngrCommandsViewModel()
        {
            _userId = Preferences.Get("uid", string.Empty);
            _firebaseClient = new FirebaseClient(_databaseUrl);
            MarkAsDeliveredCommand = new Command<OrderItem>(async (order) => await UpdateOrderStatus(order, "delivered"));
            RefreshCommand = new AsyncRelayCommand(LoadOrdersAsync);
            _ = LoadOrdersAsync();
        }

        private async Task LoadOrdersAsync()
        {
            try
            {
                IsRefreshing = true;
                var ingredientList = await _firebaseClient
                    .Child($"kitchen/{_userId}/ingredients/list")
                    .OnceSingleAsync<List<Ingredient>>();

                var ingDict = new Dictionary<string, Ingredient>();

                for (int i = 0; i < ingredientList.Count; i++)
                {
                    var ingredient = ingredientList[i];
                    if (ingredient != null)
                    {
                        ingDict[i.ToString()] = ingredient;
                    }
                }

                var orderSnapshots = await _firebaseClient
                    .Child($"kitchen/{_userId}/ingredients/orders")
                    .OnceAsync<OrderItem>();

                Orders.Clear();

                foreach (var snap in orderSnapshots)
                {
                    var order = snap.Object;
                    order.Id = snap.Key;
                    string skey = snap.Key;
                    skey = skey.Substring(1);
                    order.id = skey;
                    order.IDS = "Id: " + skey;
                    if (!string.Equals(order.Status, "approved", StringComparison.OrdinalIgnoreCase))
                        continue;

                    var ids = order.Ingredient?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();
                    var quants = order.Quantity?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();
                    var formatted = new List<string>();

                    for (int i = 0; i < ids.Length; i++)
                    {
                        var key = ids[i].Trim();
                        var qty = (i < quants.Length ? quants[i].Trim() : "?");

                        if (ingDict.TryGetValue(key, out var ingr))
                            formatted.Add($"{qty} {ingr.unit} x {ingr.name}");
                        else
                            formatted.Add($"{qty} ? x Unknown({key})");
                    }

                    order.FormattedIngredients = string.Join("\n", formatted);
                    Orders.Add(order);
                }

                if (!Orders.Any())
                {
                    await Application.Current.MainPage.DisplayAlert("Notification", "No pending orders.", "OK");
                    Application.Current.MainPage = new NavigationPage(new Dashboard());
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", ex.Message, "OK");
            }
            finally
            {
                IsRefreshing = false;
            }
        }

        public async Task UpdateOrderStatus(OrderItem order, string newStatus)
        {
            try
            {
                await _firebaseClient
                    .Child($"kitchen/{_userId}/ingredients/orders/{order.Id}/status")
                    .PutAsync($"\"finished\"");

                var todayDate = DateTime.Today.ToString("dd/MM/yyyy");

                var ids = order.Ingredient?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();

                foreach (var ingredientId in ids)
                {
                    var trimmedIngredientId = ingredientId.Trim();
                    await _firebaseClient
                        .Child($"kitchen/{_userId}/ingredients/list/{trimmedIngredientId}/date")
                        .PutAsync($"\"{todayDate}\"");
                }


                await LoadOrdersAsync();            
                await Application.Current.MainPage.DisplayAlert("Success", "Order delivered and ingredients updated.", "OK");
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to update status or ingredient dates: {ex.Message}", "OK");
            }
        }
    }
}