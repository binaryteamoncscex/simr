using Firebase.Database;
using Firebase.Database.Query;
using System.ComponentModel;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    internal class AddCategoriesViewModel : INotifyPropertyChanged
    {
        private string _categoryName;
        public string CategoryName
        {
            get => _categoryName;
            set
            {
                if (_categoryName != value)
                {
                    _categoryName = value;
                    OnPropertyChanged(nameof(CategoryName));
                }
            }
        }

        public ICommand AddCategoryCommand { get; }

        private readonly FirebaseClient firebaseClient;

        public AddCategoriesViewModel()
        {
            firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");
            AddCategoryCommand = new Command(async () => await AddCategory());
        }

        private async Task AddCategory()
        {
            if (string.IsNullOrWhiteSpace(CategoryName))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "Category Name cannot be empty.", "OK");
                return;
            }

            try
            {
                string userId = Preferences.Get("uid", string.Empty);
                await firebaseClient
                    .Child($"kitchen/{userId}/menu/categories")
                    .PostAsync<string>(CategoryName);

                await Application.Current.MainPage.DisplayAlert("Success", $"Category '{CategoryName}' added successfully!", "OK");
                CategoryName = string.Empty;
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to add category: {ex.Message}", "OK");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
