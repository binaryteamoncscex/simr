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
using System.Net.Http;
using System.Text;
using Newtonsoft.Json;

namespace restaurant.ViewModels
{
    public partial class AddMenuItemViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);
        private readonly string _userUid;

        private string _name;
        private string _photo;
        private string _price;
        private string _selectedCategory;
        private string _allergens;
        private string _nutritionalInfo;
        private bool _isBusy;

        private const string GeminiApiKey = "AIzaSyDmpZce7t--RMt2BhvltzhcWAuzc6LkROk";
        private const string GeminiApiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

        public ObservableCollection<Ingredient> IngredientsList { get; } = new ObservableCollection<Ingredient>();
        public ObservableCollection<string> Categories { get; } = new ObservableCollection<string>();

        public AddMenuItemViewModel()
        {
            _userUid = Preferences.Get("uid", string.Empty);
            _ = LoadIngredientsAsync();
            _ = LoadCategoriesAsync();
        }

        public string Name { get => _name; set => SetProperty(ref _name, value); }
        public string Photo { get => _photo; set => SetProperty(ref _photo, value); }
        public string Price { get => _price; set => SetProperty(ref _price, value); }
        public string SelectedCategory { get => _selectedCategory; set => SetProperty(ref _selectedCategory, value); }
        public string Allergens { get => _allergens; set => SetProperty(ref _allergens, value); }
        public string NutritionalInfo { get => _nutritionalInfo; set => SetProperty(ref _nutritionalInfo, value); }
        public bool IsBusy { get => _isBusy; set => SetProperty(ref _isBusy, value); }
        public bool IsNotBusy => !IsBusy;

        [RelayCommand]
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
                    nutritional = !string.IsNullOrEmpty(NutritionalInfo) ? NutritionalInfo : null,
                    count = 0
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

        [RelayCommand]
        private async Task AutoCompleteAllergensAsync()
        {
            if (IsBusy) return;

            try
            {
                IsBusy = true;

                if (!ValidateIngredientsForAI())
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Please select ingredients and enter quantities first.", "OK");
                    return;
                }

                var prompt = CreateAllergensPrompt();
                var allergens = await CallGeminiAPIAsync(prompt);
                Allergens = allergens;
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to generate allergens: {ex.Message}", "OK");
            }
            finally
            {
                IsBusy = false;
            }
        }

        [RelayCommand]
        private async Task AutoCompleteNutritionalInfoAsync()
        {
            if (IsBusy) return;

            try
            {
                IsBusy = true;

                if (!ValidateIngredientsForAI())
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Please select ingredients and enter quantities first.", "OK");
                    return;
                }

                var prompt = CreateNutritionalPrompt();
                var nutritionalInfo = await CallGeminiAPIAsync(prompt);
                NutritionalInfo = nutritionalInfo;
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to generate nutritional info: {ex.Message}", "OK");
            }
            finally
            {
                IsBusy = false;
            }
        }

        private bool ValidateIngredientsForAI()
        {
            var selectedIngredients = IngredientsList.Where(i => i.IsSelected && !string.IsNullOrWhiteSpace(i.EnteredQuantity)).ToList();
            return selectedIngredients.Any();
        }

        private string CreateAllergensPrompt()
        {
            var selectedIngredients = IngredientsList.Where(i => i.IsSelected).Select(i => $"{i.EnteredQuantity} {i.unit} of {i.name}").ToList();

            var dishInfo = !string.IsNullOrWhiteSpace(Name) ? $" for {Name}" : "";

            return $"List allergens for{dishInfo} with ingredients: {string.Join(", ", selectedIngredients)}. Respond ONLY with: 'Contains: X, Y, Z' or 'No common allergens'. No explanations.";
        }

        private string CreateNutritionalPrompt()
        {
            var selectedIngredients = IngredientsList.Where(i => i.IsSelected).Select(i => $"{i.EnteredQuantity} {i.unit} of {i.name}").ToList();

            var dishInfo = !string.IsNullOrWhiteSpace(Name) ? $" for {Name}" : "";

            return $"Calculate nutritional info{dishInfo} with ingredients: {string.Join(", ", selectedIngredients)}. Respond ONLY with: 'Calories: X kcal, Protein: Yg, Carbohydrates: Zg, Fat: Wg'. No explanations.";
        }

        private async Task<string> CallGeminiAPIAsync(string prompt)
        {
            try
            {
                using var client = new HttpClient();
                var requestBody = new
                {
                    contents = new[]
                    {
                        new
                        {
                            parts = new[]
                            {
                                new { text = prompt }
                            }
                        }
                    },
                    generationConfig = new
                    {
                        temperature = 0.1,
                        maxOutputTokens = 100,
                        topP = 0.8,
                        topK = 40
                    }
                };

                var json = JsonConvert.SerializeObject(requestBody);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync($"{GeminiApiUrl}{GeminiApiKey}", content);
                var responseString = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    var jsonResponse = JsonConvert.DeserializeObject<GeminiResponse>(responseString);
                    var generatedText = jsonResponse?.candidates?[0]?.content?.parts?[0]?.text;

                    return CleanResponse(generatedText?.Trim() ?? "Information not available");
                }
                else
                {
                    throw new Exception($"API request failed: {response.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Failed to call Gemini API: {ex.Message}");
            }
        }

        private string CleanResponse(string response)
        {
            if (string.IsNullOrEmpty(response))
                return response;

            response = response.Replace("\"", "").Replace("*", "").Replace("\n", " ").Replace("\r", " ");

            while (response.Contains("  "))
                response = response.Replace("  ", " ");

            return response.Trim();
        }

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
                    foreach (var ingredient in ingredientsData.Where(i => i != null && !string.IsNullOrWhiteSpace(i.name)))
                    {
                        ingredient.EnteredQuantity = string.Empty;
                        IngredientsList.Add(ingredient);
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
                    foreach (var categoryEntry in categoriesData.Values)
                    {
                        Categories.Add(categoryEntry);
                    }
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load categories:\n{ex}", "OK");
            }
        }
    }

    public class GeminiResponse
    {
        public List<Candidate> candidates { get; set; }
    }

    public class Candidate
    {
        public Content content { get; set; }
    }

    public class Content
    {
        public List<Part> parts { get; set; }
    }

    public class Part
    {
        public string text { get; set; }
    }
}