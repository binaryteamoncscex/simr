using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Firebase.Database;
using Microsoft.Maui.Storage;
using System.Threading.Tasks;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    public partial class DelCategoriesViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient(FirebaseUrl);
        private string _userUid = Preferences.Get("uid", string.Empty);

        [ObservableProperty]
        private ObservableCollection<CategoryItem> categories = new();
        public ICommand AddMenuCat { get; }
        public IAsyncRelayCommand<CategoryItem> DeleteCategoryCommand { get; }

        private readonly INavigation _navigation;

        public DelCategoriesViewModel(INavigation navigation)
        {
            _navigation = navigation;
            DeleteCategoryCommand = new AsyncRelayCommand<CategoryItem>(DeleteCategoryAsync);
            AddMenuCat = new Command(async () =>
            {
                await _navigation.PushAsync(new AddCategories());
            });
        }
        public async Task LoadCategoriesAsync()
        {
            Categories.Clear();
            var data = await _firebaseClient
                .Child($"kitchen/{_userUid}/menu/categories")
                .OnceAsync<string>();

            foreach (var item in data)
            {
                Categories.Add(new CategoryItem
                {
                    FirebaseKey = item.Key,
                    Value = item.Object
                });
            }
        }

        private async Task DeleteCategoryAsync(CategoryItem category)
        {
            if (category == null || string.IsNullOrWhiteSpace(category.FirebaseKey))
                return;

            bool confirm = await App.Current.MainPage.DisplayAlert(
                "Confirm",
                $"Delete category '{category.Value}'?",
                "Yes", "No");

            if (!confirm)
                return;

            await _firebaseClient
                .Child($"kitchen/{_userUid}/menu/categories/{category.FirebaseKey}")
                .DeleteAsync();

            await LoadCategoriesAsync();
            await App.Current.MainPage.DisplayAlert("Success", "Category deleted.", "OK");
        }
    }

    public class CategoryItem
    {
        public string FirebaseKey { get; set; }
        public string Value { get; set; }
    }
}
