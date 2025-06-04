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

namespace restaurant.ViewModels
{
    public class CheckInvenViewModel : BindableObject
    {
        private const string WebApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private const string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";

        private ObservableCollection<Ingredient> _ingredients;
        public ObservableCollection<Ingredient> Ingredients
        {
            get => _ingredients;
            set { _ingredients = value; OnPropertyChanged(); }
        }

        private string _temperature;
        public string Temperature
        {
            get => _temperature;
            set { _temperature = value; OnPropertyChanged(); }
        }

        private string _humidity;
        public string Humidity
        {
            get => _humidity;
            set { _humidity = value; OnPropertyChanged(); }
        }

        private bool _isRefreshing;
        public bool IsRefreshing
        {
            get => _isRefreshing;
            set
            {
                if (_isRefreshing != value)
                {
                    _isRefreshing = value;
                    OnPropertyChanged();
                }
            }
        }

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
            await LoadDhtData();
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
                    if (string.IsNullOrWhiteSpace(jsonResponse) || jsonResponse == "null")
                    {
                        await ShowError("No ingredients found.");
                        Ingredients.Clear();         
                        return;
                    }

                    var ingredientsList = JsonSerializer.Deserialize<List<Ingredient>>(jsonResponse);
                    Ingredients.Clear();
                    if (ingredientsList != null)
                    {
                        foreach (var item in ingredientsList)
                        {
                            if (item != null) Ingredients.Add(item);
                        }
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

        private async Task LoadDhtData()
        {
            try
            {
                string uid = Preferences.Get("uid", "");
                if (string.IsNullOrEmpty(uid))
                {
                    await ShowError("User ID not found in preferences.");
                    return;
                }

                string tempUnitUrl = $"{DatabaseUrl}/users/{uid}/tu.json";
                using HttpClient client = new HttpClient();
                var tempUnitResponse = await client.GetAsync(tempUnitUrl);
                string temperatureUnit = "C";    

                if (tempUnitResponse.IsSuccessStatusCode)
                {
                    string tuJson = await tempUnitResponse.Content.ReadAsStringAsync();
                    if (!string.IsNullOrEmpty(tuJson) && tuJson != "null")
                    {
                        temperatureUnit = JsonSerializer.Deserialize<string>(tuJson)?.Trim('"') ?? "C";
                    }
                }
                else
                {
                    Console.WriteLine($"Warning: Could not fetch temperature unit. Status code: {tempUnitResponse.StatusCode}");
                }

                string dhtUrl = $"{DatabaseUrl}/users/{uid}/DHT.json";
                var dhtResponse = await client.GetAsync(dhtUrl);

                if (dhtResponse.IsSuccessStatusCode)
                {
                    string json = await dhtResponse.Content.ReadAsStringAsync();
                    var data = JsonSerializer.Deserialize<DhtData>(json);
                    if (data != null)
                    {
                        double displayedTemperature = data.temp;
                        string unitSymbol = "°C";

                        if (temperatureUnit.Equals("F", StringComparison.OrdinalIgnoreCase))
                        {
                            displayedTemperature = (data.temp * 9 / 5) + 32;
                            unitSymbol = "°F";
                        }
                        else if (temperatureUnit.Equals("K", StringComparison.OrdinalIgnoreCase))
                        {
                            displayedTemperature = data.temp + 273.15;        
                            unitSymbol = "K";
                        }

                        Temperature = $"Temperature: {displayedTemperature:F1}{unitSymbol}";
                        Humidity = $"Humidity: {data.umd:F1}%";
                    }
                }
                else
                {
                    await ShowError($"Failed to load DHT data: {dhtResponse.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                await ShowError($"Error loading DHT data: {ex.Message}");
            }
        }

        private async Task<string> GetUserId()
        {
            try
            {
                string uid = Preferences.Get("uid", string.Empty);
                if (!string.IsNullOrEmpty(uid))
                {
                    return uid;
                }

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