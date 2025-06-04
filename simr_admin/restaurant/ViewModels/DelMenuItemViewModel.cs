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

namespace restaurant.ViewModels
{
    public partial class DelMenuItemViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);
        private string _userUid = Preferences.Get("uid", string.Empty);

        [ObservableProperty]
        private ObservableCollection<MenuItem> _recipies = new();

        public IAsyncRelayCommand<MenuItem> DeleteMenuItemCommand { get; }

        public DelMenuItemViewModel()
        {
            DeleteMenuItemCommand = new AsyncRelayCommand<MenuItem>(DeleteMenuItemAsync);
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

            _recipies.Clear();

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
                            _recipies.Add(menuItem);
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
                            _recipies.Add(menuItem);
                        }
                    }
                }
                else
                {
                    await App.Current.MainPage.DisplayAlert("Error", "Unexpected data format.", "OK");
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

            JToken token;
            try
            {
                token = JToken.FromObject(firebaseData);
            }
            catch (System.Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Error", $"Data format error: {ex.Message}", "OK");
                return;
            }

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
                    else
                    {
                        await App.Current.MainPage.DisplayAlert("Error", "Invalid index.", "OK");
                        return;
                    }
                }
                else
                {
                    await App.Current.MainPage.DisplayAlert("Error", "Invalid Firebase key format.", "OK");
                    return;
                }
                var newList = jArray.ToObject<List<MenuItem>>();
                await _firebaseClient
                    .Child($"kitchen/{_userUid}/menu")
                    .Child("list")
                    .PutAsync(newList);
            }
            else
            {
                await App.Current.MainPage.DisplayAlert("Error", "Unsupported data format for delete.", "OK");
                return;
            }

            await LoadMenuItemsAsync();
            await App.Current.MainPage.DisplayAlert("Success", "Menu item deleted.", "OK");
        }
    }

    public class MenuItem
    {
        public string FirebaseKey { get; set; }
        public string name { get; set; }
        public string photo { get; set; }
        public string ingredients { get; set; }
        public string quantities { get; set; }
    }
}