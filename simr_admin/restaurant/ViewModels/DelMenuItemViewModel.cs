using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using Firebase.Database;
using Firebase.Database.Query;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Maui.Storage;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    public partial class DelMenuItemViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);
        private string _userUid = Preferences.Get("uid", string.Empty);
        private readonly INavigation _navigation;

        [ObservableProperty]
        private ObservableCollection<MenuItem> recipies = new();

        public IAsyncRelayCommand<MenuItem> DeleteMenuItemCommand { get; }
        public IAsyncRelayCommand<MenuItem> EditMenuItemCommand { get; }
        public ICommand AddMenuItem { get; }

        public DelMenuItemViewModel(INavigation navigation)
        {
            _navigation = navigation;
            DeleteMenuItemCommand = new AsyncRelayCommand<MenuItem>(DeleteMenuItemAsync);
            EditMenuItemCommand = new AsyncRelayCommand<MenuItem>(EditMenuItemAsync);
            AddMenuItem = new Command(async () => await _navigation.PushAsync(new AddMenuItem()));
        }

        public async Task LoadMenuItemsAsync()
        {
            if (string.IsNullOrWhiteSpace(_userUid))
            {
                await App.Current.MainPage.DisplayAlert("Error", "User not logged in.", "OK");
                return;
            }

            var firebaseData = await _firebaseClient
                .Child($"kitchen/{_userUid}/menu/list")
                .OnceSingleAsync<dynamic>();

            recipies.Clear();

            if (firebaseData == null)
            {
                await App.Current.MainPage.DisplayAlert("Info", "No menu items available!", "OK");
                return;
            }

            try
            {
                JToken token = JToken.FromObject(firebaseData);
                if (token.Type == JTokenType.Object)
                {
                    var jObject = (JObject)token;
                    foreach (var property in jObject.Properties())
                    {
                        if (property.Value.Type != JTokenType.Null)
                        {
                            MenuItem menuItem = property.Value.ToObject<MenuItem>();
                            menuItem.FirebaseKey = property.Name;
                            recipies.Add(menuItem);
                        }
                    }
                }
                else if (token.Type == JTokenType.Array)
                {
                    JArray arr = (JArray)token;
                    for (int i = 0; i < arr.Count; i++)
                    {
                        if (arr[i].Type != JTokenType.Null)
                        {
                            MenuItem menuItem = arr[i].ToObject<MenuItem>();
                            menuItem.FirebaseKey = i.ToString();
                            recipies.Add(menuItem);
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Error", $"Data processing error: {ex.Message}", "OK");
            }
        }

        private async Task DeleteMenuItemAsync(MenuItem menuItem)
        {
            if (menuItem == null || string.IsNullOrWhiteSpace(menuItem.FirebaseKey))
                return;

            bool confirm = await App.Current.MainPage.DisplayAlert(
                "Confirm",
                "Are you sure you want to delete this menu item?",
                "Yes",
                "No");

            if (!confirm)
                return;

            var firebaseData = await _firebaseClient
                .Child($"kitchen/{_userUid}/menu/list")
                .OnceSingleAsync<dynamic>();

            if (firebaseData == null)
                return;

            JToken token = JToken.FromObject(firebaseData);

            if (token.Type == JTokenType.Object)
            {
                await _firebaseClient
                    .Child($"kitchen/{_userUid}/menu/list/{menuItem.FirebaseKey}")
                    .DeleteAsync();
            }
            else if (token.Type == JTokenType.Array)
            {
                JArray jArray = (JArray)token;
                if (int.TryParse(menuItem.FirebaseKey, out int deleteIndex))
                {
                    if (deleteIndex >= 0 && deleteIndex < jArray.Count)
                    {
                        jArray[deleteIndex] = null;
                    }
                }
                var newList = jArray.ToObject<List<MenuItem>>();
                await _firebaseClient
                    .Child($"kitchen/{_userUid}/menu")
                    .Child("list")
                    .PutAsync(newList);
            }

            await LoadMenuItemsAsync();
            await App.Current.MainPage.DisplayAlert("Success", "Menu item deleted.", "OK");
        }

        private async Task EditMenuItemAsync(MenuItem item)
        {
            if (item == null || string.IsNullOrWhiteSpace(item.FirebaseKey))
                return;

            await _navigation.PushAsync(new EditMenuItem(item.FirebaseKey, item));
        }
    }

    public class MenuItem
    {
        public string FirebaseKey { get; set; }
        public string name { get; set; }
        public string photo { get; set; }
        public string ingredients { get; set; }
        public string quantities { get; set; }
        public string category { get; set; }
        public string allergens { get; set; }
        public string nutritional { get; set; }
        public string price { get; set; }
    }
}
