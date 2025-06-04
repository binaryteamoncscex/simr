using System.Windows.Input;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace restaurant.ViewModels
{
    internal class AddIngrProvViewModel : INotifyPropertyChanged
    {
        private string providerName;
        private string providerEmail;

        public string ProviderName
        {
            get => providerName;
            set
            {
                providerName = value;
                OnPropertyChanged();
            }
        }

        public string ProviderEmail
        {
            get => providerEmail;
            set
            {
                providerEmail = value;
                OnPropertyChanged();
            }
        }

        public ICommand AddProviderCommand { get; }

        public AddIngrProvViewModel()
        {
            AddProviderCommand = new Command(async () => await AddProvider());
        }

        private async Task AddProvider()
        {
            try
            {
                if (string.IsNullOrWhiteSpace(ProviderName) || string.IsNullOrWhiteSpace(ProviderEmail))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Please enter both name and email.", "OK");
                    return;
                }

                var uid = Preferences.Get("uid", null);
                if (uid == null)
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "User not logged in.", "OK");
                    return;
                }

                var firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");

                await firebaseClient
                    .Child($"users/{uid}/providers")
                    .Child(ProviderName)
                    .PutAsync($"\"{ProviderEmail}\"");

                await Application.Current.MainPage.DisplayAlert("Success", "Provider added!", "OK");

                ProviderName = string.Empty;
                ProviderEmail = string.Empty;
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", ex.Message, "OK");
            }
        }


        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged([CallerMemberName] string name = null)
            => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }
}
