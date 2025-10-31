using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;

namespace restaurant.ViewModels
{
    internal partial class EditMenuItemViewModel : ObservableObject
    {
        private readonly FirebaseClient _firebaseClient;
        private readonly string _userUid;
        private readonly string _key;
        private readonly MenuItem _original;
        private string _initialCategory;

        [ObservableProperty] private string name;
        [ObservableProperty] private string photo;
        [ObservableProperty] private string price;
        [ObservableProperty] private ObservableCollection<string> categories = new();
        [ObservableProperty] private string selectedCategory;
        [ObservableProperty] private string allergens;
        [ObservableProperty] private string nutritionalInfo;
        [ObservableProperty] private ObservableCollection<Ingredient> ingredientsList = new();

        public IRelayCommand SaveCommand { get; }

        public EditMenuItemViewModel(string key, MenuItem menuItem)
        {
            _key = key;
            _userUid = Preferences.Get("uid", string.Empty);
            _firebaseClient = new FirebaseClient("https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/");
            _original = menuItem;
            Name = menuItem.name;
            Photo = menuItem.photo ?? string.Empty;
            Price = menuItem.price ?? string.Empty;
            _initialCategory = menuItem.category ?? string.Empty;
            Allergens = menuItem.allergens ?? string.Empty;
            NutritionalInfo = menuItem.nutritional ?? string.Empty;
            SaveCommand = new AsyncRelayCommand(SaveAsync);
        }

        public async Task InitializeAsync()
        {
            await LoadCategories();
            await LoadIngredients();
            if (!string.IsNullOrEmpty(_initialCategory) && Categories.Contains(_initialCategory))
                SelectedCategory = _initialCategory;
        }

        private async Task LoadCategories()
        {
            var data = await _firebaseClient
                .Child($"kitchen/{_userUid}/menu/categories")
                .OnceSingleAsync<Dictionary<string, string>>();
            Categories.Clear();
            if (data != null)
            {
                foreach (var entry in data)
                    Categories.Add(entry.Value);
            }
        }

        private async Task LoadIngredients()
        {
            var data = await _firebaseClient
                .Child($"kitchen/{_userUid}/ingredients/list")
                .OnceSingleAsync<List<Ingredient>>();

            if (data == null)
                return;

            IngredientsList.Clear();
            var ingredientNames = _original.ingredients?.Split(' ') ?? new string[0];
            var quantities = _original.quantities?.Split(' ') ?? new string[0];

            foreach (var ingr in data)
            {
                if (ingr == null) continue;
                ingr.IsSelected = false;
                ingr.EnteredQuantity = "";
                if (ingredientNames.Contains(ingr.name))
                {
                    ingr.IsSelected = true;
                    int idx = ingredientNames.ToList().IndexOf(ingr.name);
                    if (idx < quantities.Length)
                        ingr.EnteredQuantity = quantities[idx];
                }
                IngredientsList.Add(ingr);
            }
        }

        private async Task SaveAsync()
        {
            var selectedIngredients = IngredientsList.Where(i => i.IsSelected).ToList();
            if (string.IsNullOrWhiteSpace(Photo) ||
                string.IsNullOrWhiteSpace(Price) ||
                selectedIngredients.Count == 0 ||
                selectedIngredients.Any(i => string.IsNullOrWhiteSpace(i.EnteredQuantity)))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "Please fill in all fields correctly.", "OK");
                return;
            }

            string newIngredients = string.Join(" ", selectedIngredients.Select(i => i.name));
            string newQuantities = string.Join(" ", selectedIngredients.Select(i => i.EnteredQuantity));

            var updatedFields = new Dictionary<string, object>
            {
                ["photo"] = Photo,
                ["ingredients"] = newIngredients,
                ["quantities"] = newQuantities,
                ["price"] = Price
            };

            if (!string.IsNullOrWhiteSpace(SelectedCategory))
                updatedFields["category"] = SelectedCategory;
            if (!string.IsNullOrWhiteSpace(Allergens))
                updatedFields["allergens"] = Allergens;
            if (!string.IsNullOrWhiteSpace(NutritionalInfo))
                updatedFields["nutritional"] = NutritionalInfo;

            await _firebaseClient
                .Child($"kitchen/{_userUid}/menu/list/{_key}")
                .PatchAsync(updatedFields);

            await Application.Current.MainPage.DisplayAlert("Success", "Menu item updated!", "OK");
            await Application.Current.MainPage.Navigation.PopAsync();
        }
    }
}
