using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;
using Newtonsoft.Json.Linq;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Input;
namespace restaurant.ViewModels
{
    public partial class DelMenuIngrViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);
        private readonly string _userUid = Preferences.Get("uid", string.Empty);

        [ObservableProperty]
        private ObservableCollection<IngredientEntry> _ingredients = new();

        [ObservableProperty]
        private bool _isRefreshing;

        public IAsyncRelayCommand<string> DeleteIngredientCommand { get; }
        public IAsyncRelayCommand RefreshCommand { get; }
        public ICommand AddMenuIngr { get; }
        public IAsyncRelayCommand<IngredientEntry> EditIngredientCommand { get; }


        public DelMenuIngrViewModel(INavigation navigation)
        {
            DeleteIngredientCommand = new AsyncRelayCommand<string>(DeleteIngredientAsync);
            RefreshCommand = new AsyncRelayCommand(LoadIngredientsAsync);
            AddMenuIngr = new Command(async () => await navigation.PushAsync(new AddMenuIngr()));
            EditIngredientCommand = new AsyncRelayCommand<IngredientEntry>(async (entry) => await EditIngredientAsync(entry, navigation));
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

                Ingredients.Clear();

                if (firebaseItems == null)
                    return;

                var token = JToken.FromObject(firebaseItems);

                if (token.Type == JTokenType.Object)
                {
                    foreach (var prop in ((JObject)token).Properties())
                    {
                        var ingr = prop.Value.ToObject<Ingredient>();
                        if (ingr != null)
                        {
                            Ingredients.Add(new IngredientEntry { Key = prop.Name, Value = ingr });
                        }
                    }
                }
                else if (token.Type == JTokenType.Array)
                {
                    var array = (JArray)token;
                    for (int i = 0; i < array.Count; i++)
                    {
                        var ingr = array[i].ToObject<Ingredient>();
                        if (ingr != null)
                        {
                            Ingredients.Add(new IngredientEntry { Key = $"index_{i}", Value = ingr });
                        }
                    }
                }
            }
            finally
            {
                IsRefreshing = false;
            }
        }
        private async Task EditIngredientAsync(IngredientEntry entry, INavigation navigation)
        {
            if (entry == null || entry.Value == null) return;
            await navigation.PushAsync(new EditMenuIngr(entry.Key.Substring("index_".Length), entry.Value));
        }
        private async Task DeleteIngredientAsync(string key)
        {
            if (string.IsNullOrWhiteSpace(_userUid) || string.IsNullOrWhiteSpace(key))
                return;

            bool confirm = await App.Current.MainPage.DisplayAlert("Confirm", "Delete ingredient?", "Yes", "No");
            if (!confirm) return;

            var firebaseItems = await _firebaseClient
                .Child($"kitchen/{_userUid}/ingredients/list")
                .OnceSingleAsync<dynamic>();

            if (firebaseItems == null)
                return;

            var token = JToken.FromObject(firebaseItems);

            if (token.Type == JTokenType.Object)
            {
                await _firebaseClient
                    .Child($"kitchen/{_userUid}/ingredients/list/{key}")
                    .DeleteAsync();
            }
            else if (token.Type == JTokenType.Array)
            {
                var array = (JArray)token;
                if (key.StartsWith("index_") && int.TryParse(key.Replace("index_", ""), out int idx))
                {
                    if (idx >= 0 && idx < array.Count)
                        array.RemoveAt(idx);

                    await _firebaseClient
                        .Child($"kitchen/{_userUid}/ingredients/list")
                        .PutAsync(array.ToObject<List<Ingredient>>());
                }
            }

            await LoadIngredientsAsync();
            await App.Current.MainPage.DisplayAlert("Success", "Ingredient deleted.", "OK");
        }
    }
    public class IngredientEntry
    {
        public string Key { get; set; }
        public Ingredient Value { get; set; }
    }
    public class Ingredient : INotifyPropertyChanged
    {
        public string name { get; set; }
        public string unit { get; set; }
        public double price { get; set; }
        public double quantity { get; set; }
        public double quarepl { get; set; }
        public string provider { get; set; }
        public double replacement { get; set; }
        public string date { get; set; }
        public int days { get; set; }
        private bool _isSelected;
        public bool IsSelected
        {
            get => _isSelected;
            set
            {
                if (_isSelected != value)
                {
                    _isSelected = value;
                    OnPropertyChanged();
                    if (!_isSelected)
                        EnteredQuantity = string.Empty;
                }
            }
        }
        private string _enteredQuantity;
        public string EnteredQuantity
        {
            get => _enteredQuantity;
            set
            {
                if (_enteredQuantity != value)
                {
                    _enteredQuantity = value;
                    OnPropertyChanged();
                }
            }
        }
        public int DaysLeft
        {
            get
            {
                if (DateTime.TryParseExact(date, "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out var loadedDate))
                {
                    var expirationDate = loadedDate.AddDays(days);
                    return Math.Max(0, (expirationDate - DateTime.Today).Days);
                }
                return -1;
            }
        }
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propName));
        }
    }
}