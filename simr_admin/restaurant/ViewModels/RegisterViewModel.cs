using System;
using System.ComponentModel;
using System.Threading.Tasks;
using Firebase.Auth;
using Firebase.Auth.Providers;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;

namespace restaurant.ViewModels
{
    internal class RegisterViewModel : INotifyPropertyChanged
    {
        public string webApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private INavigation _navigation;
        private string email;
        private string password;
        private string name;

        private FirebaseClient firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");
        public event PropertyChangedEventHandler PropertyChanged;

        public string Email
        {
            get => email;
            set
            {
                email = value;
                RaisePropertyChanged("Email");
            }
        }

        public string Password
        {
            get => password;
            set
            {
                password = value;
                RaisePropertyChanged("Password");
            }
        }

        public string Name
        {
            get => name;
            set
            {
                name = value;
                RaisePropertyChanged("Name");
            }
        }

        public Command RegisterUser { get; }

        private void RaisePropertyChanged(string v)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(v));
        }

        public RegisterViewModel(INavigation navigation)
        {
            this._navigation = navigation;
            RegisterUser = new Command(RegisterUserTappedAsync);
        }

        private async void RegisterUserTappedAsync(object obj)
        {
            try
            {
                var authConfig = new FirebaseAuthConfig
                {
                    ApiKey = webApiKey,
                    AuthDomain = "restaurant-3e115.firebaseapp.com",
                    Providers = new FirebaseAuthProvider[]
                    {
                        new EmailProvider()
                    }
                };

                var authProvider = new FirebaseAuthClient(authConfig);
                var auth = await authProvider.CreateUserWithEmailAndPasswordAsync(Email, Password);
                string token = auth.User.Credential.IdToken;
                string uid = auth.User.Uid;

                if (token != null)
                {
                    var userData = new
                    {
                        Your_Name = this.Name,
                        setup = false,
                        Type = "owner",
                        Tables = 0
                    };

                    await firebaseClient
                        .Child("users")
                        .Child(uid)
                        .PutAsync(userData);

                    await App.Current.MainPage.DisplayAlert("Success", "User registered successfully.", "OK");
                    await _navigation.PopAsync();
                }
            }
            catch (FirebaseAuthException ex)
            {
                string message;

                if (ex.Message.Contains("EMAIL_EXISTS"))
                {
                    message = "This email address is already in use.";
                }
                else if (ex.Message.Contains("INVALID_EMAIL"))
                {
                    message = "The email address format is invalid.";
                }
                else if (ex.Message.Contains("WEAK_PASSWORD"))
                {
                    message = "The password is too weak. It should be at least 6 characters.";
                }
                else
                {
                    message = $"Registration failed: {ex.Message}";
                }

                await App.Current.MainPage.DisplayAlert("Registration Error", message, "OK");
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Unexpected Error", ex.Message, "OK");
            }
        }
    }
}
