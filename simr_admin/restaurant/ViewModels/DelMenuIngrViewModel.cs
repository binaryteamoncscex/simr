using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using Firebase.Database;
using Firebase.Database.Query;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Microsoft.Maui.Storage;
using Newtonsoft.Json.Linq;

namespace restaurant.ViewModels
{
    public partial class DelMenuIngrViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);

        private string _userUid = Preferences.Get("uid", string.Empty);

        [ObservableProperty]
        private ObservableCollection<KeyValuePair<string, Ingredient>> _ingredients = new();

        public IAsyncRelayCommand<string> DeleteIngredientCommand { get; }
        public IAsyncRelayCommand RefreshCommand { get; }   

        [ObservableProperty]
        private bool _isRefreshing;    

        public DelMenuIngrViewModel()
        {
            DeleteIngredientCommand = new AsyncRelayCommand<string>(DeleteIngredientAsync);
            RefreshCommand = new AsyncRelayCommand(LoadIngredientsAsync);   
            LoadIngredientsAsync();
        }

        public async Task LoadIngredientsAsync()
        {
            if (string.IsNullOrWhiteSpace(_userUid))
            {
                await App.Current.MainPage.DisplayAlert("Error", "User not logged in.", "OK");
                return;
            }

            try
            {
                IsRefreshing = true;        
                var firebaseItems = await _firebaseClient
                    .Child($"kitchen/{_userUid}/ingredients/list")
                    .OnceSingleAsync<dynamic>();

                _ingredients.Clear();

                if (firebaseItems == null)
                {
                    await App.Current.MainPage.DisplayAlert("Info", "No ingredient available!", "OK");
                    return;
                }

                JToken token;
                try
                {
                    token = JToken.FromObject(firebaseItems);
                }
                catch (System.Exception ex)
                {
                    await App.Current.MainPage.DisplayAlert("Error", $"Data format error: {ex.Message}", "OK");
                    return;
                }

                if (token.Type == JTokenType.Object)
                {
                    var jObject = (JObject)token;
                    foreach (var property in jObject.Properties())
                    {
                        Ingredient ingredient = property.Value.ToObject<Ingredient>();
                        if (ingredient != null && !string.IsNullOrWhiteSpace(ingredient.name))
                        {
                            _ingredients.Add(new KeyValuePair<string, Ingredient>(property.Name, ingredient));
                        }
                    }
                }
                else if (token.Type == JTokenType.Array)
                {
                    var jArray = (JArray)token;
                    for (int i = 0; i < jArray.Count; i++)
                    {
                        Ingredient ingredient = jArray[i].ToObject<Ingredient>();
                        if (ingredient != null && !string.IsNullOrWhiteSpace(ingredient.name))
                        {
                            string generatedKey = $"index_{i}";
                            _ingredients.Add(new KeyValuePair<string, Ingredient>(generatedKey, ingredient));
                        }
                    }
                }
                else
                {
                    await App.Current.MainPage.DisplayAlert("Error", "Unsupported data format.", "OK");
                    return;
                }

                if (_ingredients.Count == 0)
                {
                    await App.Current.MainPage.DisplayAlert("Info", "No ingredient available!", "OK");
                }
            }
            finally
            {
                IsRefreshing = false;        
            }
        }

        private async Task DeleteIngredientAsync(string key)
        {
            if (string.IsNullOrWhiteSpace(_userUid) || string.IsNullOrWhiteSpace(key))
                return;

            bool confirm = await App.Current.MainPage.DisplayAlert(
                "Confirm",
                "Are you sure you want to delete this ingredient?",
                "Yes",
                "No");

            if (!confirm)
                return;

            var firebaseItems = await _firebaseClient
                .Child($"kitchen/{_userUid}/ingredients/list")
                .OnceSingleAsync<dynamic>();

            if (firebaseItems == null)
            {
                await App.Current.MainPage.DisplayAlert("Error", "Nothing found in Firebase to delete.", "OK");
                return;
            }

            JToken token;
            try
            {
                token = JToken.FromObject(firebaseItems);
            }
            catch (System.Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Error", $"Data format error: {ex.Message}", "OK");
                return;
            }

            if (token.Type == JTokenType.Object)
            {
                await _firebaseClient
                    .Child($"kitchen/{_userUid}/ingredients/list/{key}")
                    .DeleteAsync();
            }
            else if (token.Type == JTokenType.Array)
            {
                var jArray = (JArray)token;

                if (key.StartsWith("index_"))
                {
                    var indexStr = key.Replace("index_", "");
                    if (int.TryParse(indexStr, out int idx))
                    {
                        if (idx >= 0 && idx < jArray.Count)
                        {
                            jArray.RemoveAt(idx);
                        }
                    }
                }

                var newList = jArray.ToObject<List<Ingredient>>();
                await _firebaseClient
                    .Child($"kitchen/{_userUid}/ingredients")
                    .Child("list")
                    .PutAsync(newList);
            }
            else
            {
                await App.Current.MainPage.DisplayAlert("Error", "Unsupported data format for delete.", "OK");
                return;
            }

            await LoadIngredientsAsync();

            await App.Current.MainPage.DisplayAlert("Success", "Ingredient deleted.", "OK");
        }
    }

    public class Ingredient
    {
        public string name { get; set; }
        public string unit { get; set; }
        public double price { get; set; }
        public double quantity { get; set; }
        public double quarepl { get; set; }
        public string provider { get; set; }
        public double replacement { get; set; }
        public bool IsSelected { get; set; }
        public string date { get; set; }
        public int days { get; set; }

        public int DaysLeft
        {
            get
            {
                if (DateTime.TryParseExact(date, "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out var loadedDate))
                {
                    var expirationDate = loadedDate.AddDays(days);
                    var remaining = (expirationDate - DateTime.Today).Days;
                    return Math.Max(0, remaining);
                }
                return -1;
            }
        }
    }
}