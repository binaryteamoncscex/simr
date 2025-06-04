using System;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Firebase.Auth;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Firebase.Auth.Providers;

namespace restaurant.ViewModels
{
    internal class DeleteTableViewModel : INotifyPropertyChanged
    {
        private const string WebApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private const string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";

        private FirebaseAuthClient _authClient;
        private FirebaseClient _firebaseClient;

        public ICommand DeleteTables_Click { get; }

        private string _tableCount = "1";
        public string TableCount
        {
            get => _tableCount;
            set
            {
                if (_tableCount != value)
                {
                    _tableCount = value;
                    OnPropertyChanged(nameof(TableCount));
                }
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        public DeleteTableViewModel()
        {
            var authConfig = new FirebaseAuthConfig
            {
                ApiKey = WebApiKey,
                AuthDomain = "restaurant-3e115.firebaseapp.com",
                Providers = new FirebaseAuthProvider[]
                {
                    new EmailProvider()
                }
            };

            _authClient = new FirebaseAuthClient(authConfig);
            _firebaseClient = new FirebaseClient(DatabaseUrl);

            DeleteTables_Click = new Command(async () => await DeleteTablesFromDatabase());
        }

        private async Task<string> GetUserUidAsync()
        {
            try
            {
                var auth = _authClient.User;
                return auth?.Uid;
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to get UID: {ex.Message}", "OK");
                return null;
            }
        }

        private async Task DeleteTablesFromDatabase()
        {
            string userUid = await GetUserUidAsync();
            if (string.IsNullOrEmpty(userUid))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "User not authenticated.", "OK");
                return;
            }

            int tablesToRemove;
            if (!int.TryParse(TableCount, out tablesToRemove) || tablesToRemove < 1)
            {
                await Application.Current.MainPage.DisplayAlert("Error", "Invalid number of tables.", "OK");
                return;
            }

            try
            {
                var userRef = _firebaseClient.Child("users").Child(userUid);
                var userData = await userRef.OnceSingleAsync<dynamic>();

                int currentTables = userData?.Tables ?? 0;
                int updatedTables = Math.Max(currentTables - tablesToRemove, 0);

                await userRef.PatchAsync(new { Tables = updatedTables });

                await Application.Current.MainPage.DisplayAlert("Success", "Tables deleted successfully!", "OK");
                await Application.Current.MainPage.Navigation.PopAsync();
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to delete tables: {ex.Message}", "OK");
            }
        }
    }
}
