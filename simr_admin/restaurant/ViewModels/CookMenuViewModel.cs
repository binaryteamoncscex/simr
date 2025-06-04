using Firebase.Database;
using Firebase.Database.Query;
using System.Collections.ObjectModel;
using System.ComponentModel;
using Microsoft.Maui.Storage;
using System.Diagnostics;
using static restaurant.ViewModels.WaiterViewModel;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace restaurant.ViewModels
{
    public class CookMenuViewModel : INotifyPropertyChanged
    {
        private string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private FirebaseClient firebase;
        private string _userId;

        public ObservableCollection<MenuItemViewModel> MenuItems { get; set; }

        public CookMenuViewModel()
        {
            firebase = new FirebaseClient(DatabaseUrl);
            MenuItems = new ObservableCollection<MenuItemViewModel>();
            LoadUserData();
        }

        private async Task LoadUserData()
        {
            try
            {
                string loggedInUserId = Preferences.Get("uid", string.Empty);
                if (string.IsNullOrEmpty(loggedInUserId))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "User ID not found!", "OK");
                    return;
                }

                var userEntry = await firebase.Child("users").Child(loggedInUserId).OnceSingleAsync<User>();
                if (userEntry == null || string.IsNullOrEmpty(userEntry.Owner))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Owner not found for this user!", "OK");
                    return;
                }

                _userId = userEntry.Owner;
                await LoadMenuItems();
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load user data: {ex.Message}", "OK");
            }
        }

        private async Task LoadMenuItems()
        {
            try
            {
                var uid = _userId;
                if (string.IsNullOrEmpty(uid)) throw new Exception("UID not found");

                var ingredientResponse = await firebase
                    .Child($"kitchen/{uid}/ingredients/list")
                    .OnceSingleAsync<object>();
                if (ingredientResponse == null)
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Ingredients data is empty or not found.", "OK");
                    return;
                }

                var ingredientsDict = new Dictionary<string, string>();
                if (ingredientResponse is JArray ingredientArray)
                {
                    foreach (var item in ingredientArray)
                    {
                        var ingredientData = item.ToObject<IngredientFirebaseModel>();
                        if (ingredientData != null && !string.IsNullOrWhiteSpace(ingredientData.name))
                        {
                            var unit = string.IsNullOrWhiteSpace(ingredientData.unit) ? "unit" : ingredientData.unit;
                            ingredientsDict[ingredientData.name] = unit;
                        }
                    }
                }
                else if (ingredientResponse is JObject ingredientObject)
                {
                    var ingredientList = ingredientObject.ToObject<Dictionary<string, IngredientFirebaseModel>>();
                    if (ingredientList != null)
                    {
                        foreach (var kvp in ingredientList)
                        {
                            var ingredientData = kvp.Value;
                            if (ingredientData != null && !string.IsNullOrWhiteSpace(ingredientData.name))
                            {
                                var unit = string.IsNullOrWhiteSpace(ingredientData.unit) ? "unit" : ingredientData.unit;
                                ingredientsDict[ingredientData.name] = unit;
                            }
                        }
                    }
                }
                var menuResponse = await firebase
                    .Child($"kitchen/{uid}/menu/list")
                    .OnceSingleAsync<object>();
                if (menuResponse == null)
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Menu data is empty or not found.", "OK");
                    return;
                }
                if (menuResponse is JArray menuArray)
                {
                    MenuItems.Clear();
                    foreach (var item in menuArray)
                    {
                        var itemData = item.ToObject<MenuItemFirebaseModel>();
                        if (itemData != null && !string.IsNullOrWhiteSpace(itemData.name))
                        {
                            var ingredientNames = (itemData.ingredients ?? "").Split(' ', StringSplitOptions.RemoveEmptyEntries);
                            var quantities = (itemData.quantities ?? "").Split(' ', StringSplitOptions.RemoveEmptyEntries);
                            var details = new List<string>();
                            for (int i = 0; i < ingredientNames.Length; i++)
                            {
                                string ing = ingredientNames[i];
                                string qty = (i < quantities.Length) ? quantities[i] : "0";
                                string unit = ingredientsDict.ContainsKey(ing) ? ingredientsDict[ing] : "unit";
                                details.Add($"{qty} {unit} x {ing}");
                            }

                            MenuItems.Add(new MenuItemViewModel
                            {
                                Name = itemData.name,
                                IngredientDetails = new ObservableCollection<string>(details)
                            });
                        }
                    }
                }
                else
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Unexpected data format for menu items.", "OK");
                }
                if (MenuItems.Count == 0)
                {
                    await Application.Current.MainPage.DisplayAlert("Info", "No valid menu items to show.", "OK");
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"An error occurred: {ex.Message}", "OK");
            }
        }


        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }

    public class MenuItemViewModel
    {
        public string Name { get; set; }
        public ObservableCollection<string> IngredientDetails { get; set; }
    }

    public class MenuItemFirebaseModel
    {
        public string name { get; set; }
        public string ingredients { get; set; }
        public string quantities { get; set; }
    }

    public class IngredientFirebaseModel
    {
        public string name { get; set; }
        public string unit { get; set; }
    }
}
