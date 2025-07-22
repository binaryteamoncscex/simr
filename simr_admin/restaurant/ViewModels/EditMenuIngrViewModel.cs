using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;
using System.Collections.ObjectModel;

namespace restaurant.ViewModels
{
    internal partial class EditMenuIngrViewModel : ObservableObject
    {
        private readonly FirebaseClient _firebaseClient;
        private readonly string _userUid;
        private readonly string _key;
        private readonly string _initialProvider;

        [ObservableProperty] private string name;
        [ObservableProperty] private string unit;
        [ObservableProperty] private double restockThreshold;
        [ObservableProperty] private double supplyQuantity;
        [ObservableProperty] private int days;
        [ObservableProperty] private double price;
        [ObservableProperty] private ObservableCollection<string> providerKeys = new();
        [ObservableProperty] private string selectedProvider;

        public IRelayCommand SaveCommand { get; }

        public EditMenuIngrViewModel(string key, Ingredient ingredient)
        {
            _key = key;
            _userUid = Preferences.Get("uid", string.Empty);
            _firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");

            Name = ingredient.name;
            Unit = ingredient.unit;
            RestockThreshold = ingredient.replacement;
            SupplyQuantity = ingredient.quarepl;
            Days = ingredient.days;
            Price = ingredient.price;
            _initialProvider = ingredient.provider;

            SaveCommand = new AsyncRelayCommand(SaveAsync);
        }

        public async Task InitializeAsync()
        {
            await LoadProviders();

            if (!string.IsNullOrEmpty(_initialProvider) && ProviderKeys.Contains(_initialProvider))
            {
                SelectedProvider = _initialProvider;
            }
        }

        private async Task LoadProviders()
        {
            var data = await _firebaseClient
                .Child($"users/{_userUid}/providers")
                .OnceAsync<object>();

            ProviderKeys.Clear();

            foreach (var item in data)
            {
                ProviderKeys.Add(item.Key);
            }
        }

        private async Task SaveAsync()
        {
            var updatedFields = new Dictionary<string, object>
            {
                ["name"] = Name,
                ["unit"] = Unit,
                ["price"] = Price,
                ["quarepl"] = SupplyQuantity,
                ["provider"] = SelectedProvider,
                ["replacement"] = RestockThreshold,
                ["days"] = Days
            };

            await _firebaseClient
                .Child($"kitchen/{_userUid}/ingredients/list")
                .Child(_key)
                .PatchAsync(updatedFields);

            await Application.Current.MainPage.DisplayAlert("Success", "Ingredient updated.", "OK");
            await Application.Current.MainPage.Navigation.PopAsync();
        }
    }
}
