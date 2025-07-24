using System;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.Maui.Controls;
using Firebase.Auth;
using Firebase.Auth.Providers;
using Microsoft.Maui.Storage;
using System.Windows.Input;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Maui.Graphics;

namespace restaurant.ViewModels
{
    public class CheckInvenViewModel : BindableObject
    {
        private const string WebApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private const string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";

        public ObservableCollection<Ingredient> Ingredients { get; set; }

        private string _pantryTemperature;
        public string PantryTemperature { get => _pantryTemperature; set { _pantryTemperature = value; OnPropertyChanged(); } }

        private string _pantryHumidity;
        public string PantryHumidity { get => _pantryHumidity; set { _pantryHumidity = value; OnPropertyChanged(); } }

        private string _fridgeTemperature;
        public string FridgeTemperature { get => _fridgeTemperature; set { _fridgeTemperature = value; OnPropertyChanged(); } }

        private string _fridgeHumidity;
        public string FridgeHumidity { get => _fridgeHumidity; set { _fridgeHumidity = value; OnPropertyChanged(); } }

        private string _gasStatusText;
        public string GasStatusText { get => _gasStatusText; set { _gasStatusText = value; OnPropertyChanged(); } }

        private Color _gasStatusColor;
        public Color GasStatusColor { get => _gasStatusColor; set { _gasStatusColor = value; OnPropertyChanged(); } }

        private bool _isRefreshing;
        public bool IsRefreshing { get => _isRefreshing; set { _isRefreshing = value; OnPropertyChanged(); } }

        public ICommand RefreshCommand { get; }

        public CheckInvenViewModel()
        {
            Ingredients = new ObservableCollection<Ingredient>();
            RefreshCommand = new AsyncRelayCommand(ExecuteRefreshCommand);
            _ = LoadAllData();
        }

        private async Task ExecuteRefreshCommand()
        {
            IsRefreshing = true;
            await Task.Delay(200);
            await LoadAllData();
            IsRefreshing = false;
        }

        private async Task LoadAllData()
        {
            await LoadIngredients();
            await LoadAllSensors();
            await LoadGasStatus();
        }

        private async Task LoadIngredients()
        {
            try
            {
                string userId = await GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    await ShowError("No user ID found.");
                    return;
                }

                string requestUrl = $"{DatabaseUrl}/kitchen/{userId}/ingredients/list.json";
                using HttpClient client = new HttpClient();

                HttpResponseMessage response = await client.GetAsync(requestUrl);
                if (response.IsSuccessStatusCode)
                {
                    string jsonResponse = await response.Content.ReadAsStringAsync();
                    Ingredients.Clear();
                    var ingredientsList = JsonSerializer.Deserialize<List<Ingredient>>(jsonResponse);
                    if (ingredientsList != null)
                    {
                        foreach (var item in ingredientsList)
                            if (item != null) Ingredients.Add(item);
                    }
                }
                else
                {
                    await ShowError($"Failed to load ingredients: {response.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                await ShowError($"Error loading ingredients: {ex.Message}");
            }
        }

        private async Task LoadAllSensors()
        {
            try
            {
                string uid = Preferences.Get("uid", "");
                if (string.IsNullOrEmpty(uid))
                {
                    await ShowError("User ID not found in preferences.");
                    return;
                }

                using HttpClient client = new HttpClient();
                PantryTemperature = await GetSensorValue(client, uid, "camara/temp", "°C");
                PantryHumidity = await GetSensorValue(client, uid, "camara/umd", "%");
                FridgeTemperature = await GetSensorValue(client, uid, "frigider/temp", "°C");
                FridgeHumidity = await GetSensorValue(client, uid, "frigider/umd", "%");
            }
            catch (Exception ex)
            {
                await ShowError($"Error loading sensors: {ex.Message}");
            }
        }

        private async Task LoadGasStatus()
        {
            try
            {
                string uid = Preferences.Get("uid", "");
                if (string.IsNullOrEmpty(uid))
                {
                    await ShowError("User ID not found in preferences.");
                    return;
                }

                using HttpClient client = new HttpClient();
                string url = $"{DatabaseUrl}/users/{uid}/gaz_bucatarie.json";
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    string json = await response.Content.ReadAsStringAsync();
                    bool hasGas = json.Trim().ToLower() == "true";

                    if (hasGas)
                    {
                        GasStatusText = "Gas leak detected!";
                        GasStatusColor = Colors.Red;
                    }
                    else
                    {
                        GasStatusText = "Kitchen safe – no gas.";
                        GasStatusColor = Colors.Green;
                    }
                }
                else
                {
                    GasStatusText = "Unable to read gas status.";
                    GasStatusColor = Colors.Gray;
                }
            }
            catch (Exception ex)
            {
                await ShowError($"Error loading gas status: {ex.Message}");
            }
        }

        private async Task<string> GetSensorValue(HttpClient client, string uid, string path, string suffix)
        {
            string url = $"{DatabaseUrl}/users/{uid}/{path}.json";
            var response = await client.GetAsync(url);

            if (response.IsSuccessStatusCode)
            {
                string json = await response.Content.ReadAsStringAsync();
                return $"{json}{suffix}";
            }

            return "N/A";
        }

        private async Task<string> GetUserId()
        {
            try
            {
                string uid = Preferences.Get("uid", string.Empty);
                if (!string.IsNullOrEmpty(uid))
                    return uid;

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
                var user = authProvider.User;

                if (user?.Uid != null)
                {
                    Preferences.Set("uid", user.Uid);
                    return user.Uid;
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                await ShowError($"Error retrieving user ID: {ex.Message}");
                return string.Empty;
            }
        }

        private async Task ShowError(string message)
        {
            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Application.Current.MainPage.DisplayAlert("Error", message, "OK");
            });
        }
    }

    public class DhtData
    {
        public double temp { get; set; }
        public double umd { get; set; }
    }
}