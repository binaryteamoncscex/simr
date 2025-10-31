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

namespace restaurant.ViewModels
{
    internal partial class IngrCommandsViewModel : ObservableObject
    {
        private readonly FirebaseClient _firebaseClient;
        private readonly string _userId;
        private readonly string _databaseUrl = "https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/";
        private bool _navigated = false;

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
        }

        public async Task LoadOrdersAsync()
        {
            try
            {
                IsRefreshing = true;

                var currency = await _firebaseClient
                    .Child($"users/{_userId}/currency")
                    .OnceSingleAsync<string>() ?? "RON";

                var ingredientList = await _firebaseClient
                    .Child($"kitchen/{_userId}/ingredients/list")
                    .OnceSingleAsync<List<Ingredient>>();

                var ingredientDict = new Dictionary<string, Ingredient>();
                if (ingredientList != null)
                {
                    for (int i = 0; i < ingredientList.Count; i++)
                    {
                        var ingr = ingredientList[i];
                        if (ingr != null)
                            ingredientDict[i.ToString()] = ingr;
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

                        if (ingredientDict.TryGetValue(key, out var ingr))
                            formatted.Add($"{qty} {ingr.unit} x {ingr.name}");
                        else
                            formatted.Add($"{qty} ? x Unknown({key})");
                    }

                    order.FormattedIngredients = string.Join("\n", formatted);
                    if (!string.IsNullOrEmpty(order.Price))
                        order.Price = $"{order.Price} {currency}";

                    Orders.Add(order);
                }

                if (!Orders.Any() && !_navigated)
                {
                    _navigated = true;
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
                var quants = order.Quantity?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();

                for (int i = 0; i < ids.Length; i++)
                {
                    var ingredientId = ids[i].Trim();
                    var quantityToAdd = (i < quants.Length) ? quants[i].Trim() : "0";

                    var ingredient = await _firebaseClient
                        .Child($"kitchen/{_userId}/ingredients/list/{ingredientId}")
                        .OnceSingleAsync<Ingredient>();

                    if (ingredient != null)
                    {
                        if (int.TryParse(ingredient.quantity.ToString(), out int currentQty) &&
                            int.TryParse(quantityToAdd, out int addQty))
                        {
                            int newQuantity = currentQty + addQty;

                            await _firebaseClient
                                .Child($"kitchen/{_userId}/ingredients/list/{ingredientId}")
                                .PatchAsync(new
                                {
                                    quantity = newQuantity,
                                    date = todayDate
                                });
                        }
                    }
                }

                await Application.Current.MainPage.DisplayAlert("Success", "Order delivered and ingredients stock updated.", "OK");
                await LoadOrdersAsync();
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to update status or ingredient stock: {ex.Message}", "OK");
            }
        }
    }
}
