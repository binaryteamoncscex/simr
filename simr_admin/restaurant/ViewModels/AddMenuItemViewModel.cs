using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using Firebase.Database;
using Firebase.Database.Query;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using System.Collections.Generic;

namespace restaurant.ViewModels
{
    public partial class AddMenuItemViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);
        private readonly string _userUid;

        private string _name;
        private string _photo;
        private string _price;
        private string _selectedCategory;
        private string _allergens;
        private string _nutritionalInfo;

        public ObservableCollection<Ingredient> IngredientsList { get; } = new ObservableCollection<Ingredient>();
        public ObservableCollection<string> Categories { get; } = new ObservableCollection<string>();

        public AddMenuItemViewModel()
        {
            _userUid = Preferences.Get("uid", string.Empty);
            AddMenuItemCommand = new AsyncRelayCommand(AddMenuItemAsync);
            _ = LoadIngredientsAsync();
            _ = LoadCategoriesAsync();
        }

        public string Name { get => _name; set => SetProperty(ref _name, value); }
        public string Photo { get => _photo; set => SetProperty(ref _photo, value); }
        public string Price { get => _price; set => SetProperty(ref _price, value); }
        public string SelectedCategory { get => _selectedCategory; set => SetProperty(ref _selectedCategory, value); }
        public string Allergens { get => _allergens; set => SetProperty(ref _allergens, value); }
        public string NutritionalInfo { get => _nutritionalInfo; set => SetProperty(ref _nutritionalInfo, value); }

        public ICommand AddMenuItemCommand { get; }

        private async Task LoadIngredientsAsync()
        {
            try
            {
                if (string.IsNullOrEmpty(_userUid))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "User ID not found.", "OK");
                    return;
                }

                var path = $"kitchen/{_userUid}/ingredients/list";
                var ingredientsData = await _firebaseClient.Child(path).OnceSingleAsync<List<Ingredient>>();

                IngredientsList.Clear();
                if (ingredientsData != null)
                {
                    foreach (var ingredient in ingredientsData)
                    {
                        if (ingredient != null)
                        {
                            ingredient.EnteredQuantity = string.Empty;
                            IngredientsList.Add(ingredient);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load ingredients:\n{ex}", "OK");
            }
        }

        private async Task LoadCategoriesAsync()
        {
            try
            {
                var path = $"kitchen/{_userUid}/menu/categories";
                var categoriesData = await _firebaseClient.Child(path).OnceSingleAsync<Dictionary<string, string>>();

                Categories.Clear();
                if (categoriesData != null)
                {
                    foreach (var categoryEntry in categoriesData)
                    {
                        Categories.Add(categoryEntry.Value);
                    }
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load categories:\n{ex}", "OK");
            }
        }

        private async Task AddMenuItemAsync()
        {
            try
            {
                var selectedIngredients = IngredientsList.Where(i => i.IsSelected).ToList();

                if (string.IsNullOrWhiteSpace(Name) ||
                    string.IsNullOrWhiteSpace(Photo) ||
                    string.IsNullOrWhiteSpace(Price) ||
                    !selectedIngredients.Any() ||
                    selectedIngredients.Any(i => string.IsNullOrWhiteSpace(i.EnteredQuantity)))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Please fill in all required fields.", "OK");
                    return;
                }

                var countRef = _firebaseClient.Child($"kitchen/{_userUid}/menu/count");
                int count = await countRef.OnceSingleAsync<int?>() ?? 0;
                int newMenuNumber = count + 1;

                string ingredientsString = string.Join(" ", selectedIngredients.Select(i => i.name));
                string quantitiesString = string.Join(" ", selectedIngredients.Select(i => i.EnteredQuantity));

                var basePath = $"kitchen/{_userUid}/menu/list/{newMenuNumber}";

                var menuItem = new
                {
                    name = Name,
                    photo = Photo,
                    ingredients = ingredientsString,
                    quantities = quantitiesString,
                    price = Price,
                    category = !string.IsNullOrEmpty(SelectedCategory) ? SelectedCategory : null,
                    allergens = !string.IsNullOrEmpty(Allergens) ? Allergens : null,
                    nutritional = !string.IsNullOrEmpty(NutritionalInfo) ? NutritionalInfo : null
                };

                await _firebaseClient.Child(basePath).PutAsync(menuItem);
                await countRef.PutAsync(newMenuNumber);

                await Application.Current.MainPage.DisplayAlert("Success", "Menu item added successfully!", "OK");

                Name = string.Empty;
                Photo = string.Empty;
                Price = string.Empty;
                SelectedCategory = null;
                Allergens = string.Empty;
                NutritionalInfo = string.Empty;

                foreach (var ingredient in IngredientsList)
                {
                    ingredient.IsSelected = false;
                    ingredient.EnteredQuantity = string.Empty;
                }

                await Application.Current.MainPage.Navigation.PopAsync();
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to add menu item:\n{ex}", "OK");
            }
        }
    }
}
