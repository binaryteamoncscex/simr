using Firebase.Auth;
using Firebase.Auth.Providers;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;
using Newtonsoft.Json;
using System;
using System.ComponentModel;
using System.Threading.Tasks;

namespace restaurant.ViewModels
{
    internal class LoginViewModel : INotifyPropertyChanged
    {
        public string webApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private INavigation _navigation;
        public event PropertyChangedEventHandler PropertyChanged;

        private string userName, userPassword;

        private FirebaseClient firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");

        public Command RegisterBtn { get; }
        public Command LoginBtn { get; }
        public Command ForgotBtn { get; }

        public string UserName
        {
            get => userName;
            set
            {
                userName = value;
                RaisePropertyChanged("UserName");
            }
        }

        public string UserPassword
        {
            get => userPassword;
            set
            {
                userPassword = value;
                RaisePropertyChanged("UserPassword");
            }
        }

        private void RaisePropertyChanged(string propName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propName));
        }

        public LoginViewModel(INavigation navigation)
        {
            _navigation = navigation;
            RegisterBtn = new Command(RegisterBtnTappedAsync);
            LoginBtn = new Command(LoginBtnTappedAsync);
            ForgotBtn = new Command(ForgotBtnTappedAsync);
        }

        private async void RegisterBtnTappedAsync()
        {
            await _navigation.PushAsync(new RegisterPage());
        }

        private async void ForgotBtnTappedAsync()
        {
            await _navigation.PushAsync(new ForgotPage());
        }

        private async void LoginBtnTappedAsync(object obj)
        {
            await AuthenticateAndNavigate(UserName, UserPassword);
        }

        private async Task AuthenticateAndNavigate(string username, string password)
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

            try
            {
                var auth = await authProvider.SignInWithEmailAndPasswordAsync(username, password);
                var uid = auth.User.Uid;
                var token = await auth.User.GetIdTokenAsync();

                Preferences.Set("uid", uid);
                Preferences.Set("SavedUsername", username);
                Preferences.Set("SavedPassword", password);

                Preferences.Set("RememberMe", true);

                var firebaseClient = new FirebaseClient(
                    "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/",
                    new FirebaseOptions
                    {
                        AuthTokenAsyncFactory = () => Task.FromResult(token)
                    });

                var userData = await firebaseClient.Child("users").Child(uid).OnceSingleAsync<dynamic>();
                string userType = userData?.Type ?? "unknown";

                if (userType == "owner")
                {
                    var setupData = await firebaseClient.Child("users").Child(uid).Child("setup").OnceSingleAsync<dynamic>();
                    if (setupData == null || setupData == false)
                        Application.Current.MainPage = new NavigationPage(new Setup());
                    else
                        Application.Current.MainPage = new NavigationPage(new ApproveOrders());
                }
                else if (userType == "cook")
                {
                    Application.Current.MainPage = new NavigationPage(new Cook());
                }
                else if (userType == "waiter")
                {
                    Application.Current.MainPage = new NavigationPage(new Waiter());
                }
                else
                {
                    await App.Current.MainPage.DisplayAlert("Alert", "User type not recognized!", "OK");
                }
            }
            catch (FirebaseAuthException ex)
            {
                string message;

                if (ex.Message.Contains("INVALID_LOGIN_CREDENTIALS"))
                {
                    message = "Incorrect email or password.";
                }
                else if (ex.Reason == AuthErrorReason.InvalidEmailAddress)
                {
                    message = "The email address format is invalid.";
                }
                else if (ex.Reason == AuthErrorReason.UserDisabled)
                {
                    message = "This user account has been disabled.";
                }
                else if (ex.Reason == AuthErrorReason.TooManyAttemptsTryLater)
                {
                    message = "Too many attempts. Please try again later.";
                }
                else
                {
                    message = $"Authentication failed: {ex.Message}";
                }

                await App.Current.MainPage.DisplayAlert("Login Error", message, "OK");
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Unexpected Error", ex.Message, "OK");
            }
        }
    }
}
