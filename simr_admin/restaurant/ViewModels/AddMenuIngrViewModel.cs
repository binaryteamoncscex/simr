using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Firebase.Database;
using Firebase.Database.Query;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Maui.Storage;

namespace restaurant.ViewModels
{
    public class AddMenuIngrViewModel : ObservableObject
    {
        public class Ingredient
        {
            public string name { get; set; }
            public int days { get; set; }
            public string unit { get; set; }
            public double price { get; set; }
            public int quantity { get; set; }
            public int quarepl { get; set; }
            public int replacement { get; set; }
            public string provider { get; set; }
            public int used { get; set; }
        }

        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);
        private string _userUid = Preferences.Get("uid", string.Empty);

        private string _name;
        private string _unit;
        private string _quantity;
        private string _restockThreshold;
        private string _supplyQuantity;
        private string _price;
        private string _days;
        private string _selectedProvider;

        public string Name
        {
            get => _name;
            set => SetProperty(ref _name, value);
        }

        public string Quantity
        {
            get => _quantity;
            set => SetProperty(ref _quantity, value);
        }

        public string RestockThreshold
        {
            get => _restockThreshold;
            set => SetProperty(ref _restockThreshold, value);
        }

        public string SupplyQuantity
        {
            get => _supplyQuantity;
            set => SetProperty(ref _supplyQuantity, value);
        }

        public string Price
        {
            get => _price;
            set => SetProperty(ref _price, value);
        }

        public string Unit
        {
            get => _unit;
            set => SetProperty(ref _unit, value);
        }

        public string Days
        {
            get => _days;
            set => SetProperty(ref _days, value);
        }

        public string SelectedProvider
        {
            get => _selectedProvider;
            set => SetProperty(ref _selectedProvider, value);
        }

        private ObservableCollection<string> _providerKeys = new ObservableCollection<string>();
        public ObservableCollection<string> ProviderKeys
        {
            get => _providerKeys;
            set => SetProperty(ref _providerKeys, value);
        }

        public ICommand AddIngredientCommand { get; }

        public AddMenuIngrViewModel()
        {
            AddIngredientCommand = new AsyncRelayCommand(AddIngredientAsync);
            LoadProvidersAsync();
        }

        private async void LoadProvidersAsync()
        {
            try
            {
                var providers = await _firebaseClient
                    .Child($"users/{_userUid}/providers")
                    .OnceAsync<object>();

                ProviderKeys.Clear();
                foreach (var provider in providers)
                {
                    ProviderKeys.Add(provider.Key);
                }
            }
            catch
            {
                await App.Current.MainPage.DisplayAlert("Error", "Failed to load providers.", "OK");
            }
        }

        private async Task AddIngredientAsync()
        {
            try
            {
                if (string.IsNullOrWhiteSpace(Name) || string.IsNullOrWhiteSpace(Unit) ||
                    !int.TryParse(RestockThreshold, out int quareplValue) ||
                    !int.TryParse(SupplyQuantity, out int replacementValue) ||
                    !double.TryParse(Price, out double priceValue) ||
                    !int.TryParse(Days, out int daysValue) ||
                    string.IsNullOrWhiteSpace(SelectedProvider))
                {
                    await App.Current.MainPage.DisplayAlert("Error", "Please enter valid values and select a provider.", "OK");
                    return;
                }

                if (string.IsNullOrWhiteSpace(_userUid))
                {
                    await App.Current.MainPage.DisplayAlert("Error", "The user is not logged in.", "OK");
                    return;
                }

                var newIngredient = new Ingredient
                {
                    name = Name,
                    price = priceValue,
                    unit = Unit,
                    quantity = 0,
                    quarepl = quareplValue,
                    days = daysValue,
                    replacement = replacementValue,
                    provider = SelectedProvider,
                    used = 0
                };

                var countRef = _firebaseClient.Child($"kitchen/{_userUid}/ingredients/count");
                int count = 0;
                try
                {
                    count = await countRef.OnceSingleAsync<int>();
                }
                catch
                {
                    count = 0;
                }

                var newIngredientNumber = count + 1;

                await _firebaseClient.Child($"kitchen/{_userUid}/ingredients/list/{newIngredientNumber}").PutAsync(newIngredient);
                await countRef.PutAsync(newIngredientNumber);

                await App.Current.MainPage.DisplayAlert("Success", "Ingredient has been successfully added!", "OK");
                await Application.Current.MainPage.Navigation.PopAsync();
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Error", $"Failed to add the ingredient: {ex.Message}", "OK");
            }

            Name = string.Empty;
            Unit = string.Empty;
            Quantity = string.Empty;
            RestockThreshold = string.Empty;
            SupplyQuantity = string.Empty;
            Price = string.Empty;
            Days = string.Empty;
            SelectedProvider = null;
        }
    }
}
