using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Firebase.Auth;
using Firebase.Database;
using Firebase.Database.Query;
using Newtonsoft.Json;
using Microsoft.Maui.Controls;
using Firebase.Auth.Providers;
using System.ComponentModel;

namespace restaurant.ViewModels
{
    internal class AddTableViewModel
    {
        private const string WebApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private const string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";

        private FirebaseAuthClient _authClient;
        private FirebaseClient _firebaseClient;

        public ICommand AddTables_Click { get; }

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
        public AddTableViewModel()
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

            AddTables_Click = new Command(async () => await AddTablesToDatabase());
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

        private async Task AddTablesToDatabase()
        {
            string userUid = await GetUserUidAsync();
            if (string.IsNullOrEmpty(userUid))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "User not authenticated.", "OK");
                return;
            }

            int tables;
            if (!int.TryParse(TableCount, out tables) || tables < 1)
            {
                await Application.Current.MainPage.DisplayAlert("Error", "Invalid number of tables.", "OK");
                return;
            }

            try
            {
                var userRef = _firebaseClient.Child("users").Child(userUid);

                var userData = await userRef.OnceSingleAsync<dynamic>();

                if (userData != null && userData.Tables != null)
                {
                    tables += (int)userData.Tables;
                }

                await userRef.PatchAsync(new { Tables = tables });

                await Application.Current.MainPage.DisplayAlert("Success", "Tables added successfully!", "OK");
                await Application.Current.MainPage.Navigation.PopAsync();
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to update tables: {ex.Message}", "OK");
            }
        }
    }
}
