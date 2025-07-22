using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;

namespace restaurant.ViewModels
{
    internal class EditIngrProvViewModel : INotifyPropertyChanged
    {
        private readonly FirebaseClient firebaseClient;
        private readonly string uid;

        private string providerName;
        public string ProviderName
        {
            get => providerName;
            set { providerName = value; OnPropertyChanged(); }
        }

        private string providerEmail;
        public string ProviderEmail
        {
            get => providerEmail;
            set { providerEmail = value; OnPropertyChanged(); }
        }

        public ICommand SaveCommand { get; }
        public INavigation Navigation { get; }

        public EditIngrProvViewModel(string name, string email, INavigation navigation)
        {
            ProviderName = name;
            ProviderEmail = email;
            uid = Preferences.Get("uid", null);
            firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");
            SaveCommand = new Command(async () => await SaveChanges());
            Navigation = navigation;
        }

        private async Task SaveChanges()
        {
            if (string.IsNullOrWhiteSpace(ProviderEmail))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "Email cannot be empty.", "OK");
                return;
            }

            try
            {
                await firebaseClient
                    .Child($"users/{uid}/providers")
                    .Child(ProviderName)
                    .PutAsync($"\"{ProviderEmail}\"");

                await Application.Current.MainPage.DisplayAlert("Success", "Email updated!", "OK");
                await Navigation.PopAsync();
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", ex.Message, "OK");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void OnPropertyChanged([CallerMemberName] string name = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }
}
