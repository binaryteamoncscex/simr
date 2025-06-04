using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    internal class ApproveOrdersViewModel : BindableObject
    {
        private readonly FirebaseClient _firebaseClient;
        private readonly string _userId;
        private readonly string _databaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private const string SendGridApiKey = "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";
        private const string SenderEmail = "no-reply@management-restaurant.eu";
        private const string SenderName = "SIMR Orders";

        public ObservableCollection<OrderItem> Orders { get; } = new();
        public ICommand ApproveOrderCommand { get; }
        public ICommand DisapproveOrderCommand { get; }

        public ApproveOrdersViewModel()
        {
            _userId = Preferences.Get("uid", string.Empty);
            _firebaseClient = new FirebaseClient(_databaseUrl);
            ApproveOrderCommand = new Command<string>(async id => await UpdateOrderStatus(id, "approved"));
            DisapproveOrderCommand = new Command<string>(async id => await UpdateOrderStatus(id, "disapproved"));

            _ = InitAsync();
        }

        private async Task InitAsync()
        {
            bool hasOrders = await LoadOrdersAsync();
            if (!hasOrders)
            {
                MainThread.BeginInvokeOnMainThread(() =>
                {
                    Application.Current.MainPage = new NavigationPage(new Dashboard());
                });
            }
        }

        private async Task<bool> LoadOrdersAsync()
        {
            try
            {
                // Preluăm moneda din baza de date
                var currency = await _firebaseClient
                    .Child($"users/{_userId}/currency")
                    .OnceSingleAsync<string>() ?? "RON";

                var ingredientList = await _firebaseClient
                    .Child($"kitchen/{_userId}/ingredients/list")
                    .OnceSingleAsync<List<Ingredient>>();

                var ingDict = new Dictionary<string, Ingredient>();
                for (int i = 0; i < ingredientList.Count; i++)
                {
                    var ingredient = ingredientList[i];
                    if (ingredient != null)
                        ingDict[i.ToString()] = ingredient;
                }

                var orderSnapshots = await _firebaseClient
                    .Child($"kitchen/{_userId}/ingredients/orders")
                    .OnceAsync<OrderItem>();

                Orders.Clear();
                foreach (var snap in orderSnapshots)
                {
                    var order = snap.Object;
                    order.Id = snap.Key;
                    var skey = snap.Key.Substring(1);
                    order.id = skey;
                    order.IDS = "Id: " + skey;

                    if (!string.Equals(order.Status, "requested", StringComparison.OrdinalIgnoreCase))
                        continue;

                    // Adăugăm moneda la preț
                    if (!string.IsNullOrEmpty(order.Price))
                        order.Price = $"{order.Price} {currency}";

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

                return Orders.Any();
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", ex.Message, "OK");
                return true;
            }
        }

        private async Task UpdateOrderStatus(string orderId, string newStatus)
        {
            await _firebaseClient
                .Child($"kitchen/{_userId}/ingredients/orders/{orderId}/status")
                .PutAsync($"\"{newStatus}\"");

            var order = Orders.FirstOrDefault(o => o.Id == orderId);
            if (order != null)
            {
                Orders.Remove(order);

                if (string.Equals(newStatus, "approved", StringComparison.OrdinalIgnoreCase))
                {
                    await UpdateUsedIngredients(order);
                    await SendEmailNotification(order);
                }

                bool hasOrders = Orders.Any();
                if (!hasOrders)
                {
                    MainThread.BeginInvokeOnMainThread(async () =>
                    {
                        await Application.Current.MainPage.DisplayAlert("Notification", "No pending orders.", "OK");
                        Application.Current.MainPage = new NavigationPage(new Dashboard());
                    });
                }
            }
        }

        private async Task UpdateUsedIngredients(OrderItem order)
        {
            var ids = order.Ingredient?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();
            var quants = order.Quantity?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();
            double totalUsed = 0;
            for (int i = 0; i < ids.Length; i++)
            {
                string ingrId = ids[i].Trim();
                if (i >= quants.Length) continue;
                if (!double.TryParse(quants[i].Trim(), out double qty)) continue;
                totalUsed += qty;
                var usedRef = _firebaseClient.Child($"kitchen/{_userId}/ingredients/list/{ingrId}/used");
                var currentUsed = await usedRef.OnceSingleAsync<double?>() ?? 0;
                await usedRef.PutAsync(currentUsed + qty);
            }
            var totalUsedRef = _firebaseClient.Child($"kitchen/{_userId}/ingredients/used");
            var currentTotalUsed = await totalUsedRef.OnceSingleAsync<double?>() ?? 0;
            await totalUsedRef.PutAsync(currentTotalUsed + totalUsed);
        }

        private async Task SendEmailNotification(OrderItem order)
        {
            try
            {
                var firebaseClient = new FirebaseClient(_databaseUrl);
                var restaurantData = await firebaseClient
                    .Child("users")
                    .Child(_userId)
                    .OnceSingleAsync<dynamic>();

                var ids = order.Ingredient?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();
                var quants = order.Quantity?.Split(',', StringSplitOptions.RemoveEmptyEntries) ?? Array.Empty<string>();

                var providerMap = new Dictionary<string, List<(string name, string unit, double quantity, double price)>>();
                var providerTotals = new Dictionary<string, double>();

                for (int i = 0; i < ids.Length; i++)
                {
                    string id = ids[i].Trim();
                    string quantityStr = (i < quants.Length) ? quants[i].Trim() : "0";
                    if (!double.TryParse(quantityStr, out double quantity)) continue;

                    var ingredientRef = firebaseClient.Child($"kitchen/{_userId}/ingredients/list/{id}");
                    var ingredient = await ingredientRef.OnceSingleAsync<Ingredient>();

                    if (ingredient == null || string.IsNullOrEmpty(ingredient.provider)) continue;

                    double totalPrice = quantity * ingredient.price;

                    if (!providerMap.ContainsKey(ingredient.provider))
                        providerMap[ingredient.provider] = new List<(string, string, double, double)>();

                    providerMap[ingredient.provider].Add((ingredient.name, ingredient.unit, quantity, totalPrice));

                    if (!providerTotals.ContainsKey(ingredient.provider))
                        providerTotals[ingredient.provider] = 0;

                    providerTotals[ingredient.provider] += totalPrice;
                }

                var providersDict = await firebaseClient
                    .Child($"users/{_userId}/providers")
                    .OnceSingleAsync<Dictionary<string, string>>();

                foreach (var kvp in providerMap)
                {
                    string providerId = kvp.Key;
                    var ingredients = kvp.Value;

                    if (providersDict == null || !providersDict.TryGetValue(providerId, out string email))
                        continue;

                    var client = new SendGridClient(SendGridApiKey);
                    var from = new EmailAddress(SenderEmail, SenderName);
                    var to = new EmailAddress(email);
                    var subject = $"Ingredients Order from {restaurantData?.Name ?? "Restaurant"}";

                    string ingredientListText = string.Join("\n", ingredients.Select(x => $"{x.quantity} {x.unit} x {x.name} ({x.price:F2} RON)"));
                    string ingredientListHtml = string.Join("<br/>", ingredients.Select(x => $"{x.quantity} {x.unit} x {x.name} ({x.price:F2} RON)"));

                    double total = providerTotals[providerId];
                    string plainTextContent = $"Order {order.id}\nIngredients:\n{ingredientListText}\nTotal price: {total:F2} RON";
                    string htmlContent = $"<strong>Order {order.id}</strong><br/>Ingredients:<br/>{ingredientListHtml}<br/><br/>Total price: <strong>{total:F2} RON</strong>";

                    var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
                    var response = await client.SendEmailAsync(msg);

                    if ((int)response.StatusCode >= 400)
                    {
                        await Application.Current.MainPage.DisplayAlert("Email Error", $"Failed to send email to {email}: {response.StatusCode}", "OK");
                    }
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Email Exception", ex.Message, "OK");
            }
        }

        public class OrderItem
        {
            public string Id { get; set; }
            public string IDS { get; set; }
            public string id { get; set; }
            public string Ingredient { get; set; }
            public string Quantity { get; set; }
            public string Price { get; set; }
            public string Status { get; set; }
            public string FormattedIngredients { get; set; }
        }
    }
}
