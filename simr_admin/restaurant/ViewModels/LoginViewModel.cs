using Firebase.Auth;
using Firebase.Auth.Providers;
using Firebase.Database;
using Firebase.Database.Query;
using Newtonsoft.Json;
using System;
using System.ComponentModel;
using System.Threading.Tasks;
using Microsoft.Maui.Storage;

namespace restaurant.ViewModels
{
    internal class LoginViewModel : INotifyPropertyChanged
    {
        public string webApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private INavigation _navigation;
        public event PropertyChangedEventHandler PropertyChanged;
        private string userName, userPassword;
        private bool rememberMe;
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
        public bool RememberMe
        {
            get => rememberMe;
            set
            {
                rememberMe = value;
                RaisePropertyChanged("RememberMe");
            }
        }

        private void RaisePropertyChanged(string v)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(v));
        }

        public LoginViewModel(INavigation navigation)
        {
            this._navigation = navigation;
            RegisterBtn = new Command(RegisterBtnTappedAsync);
            LoginBtn = new Command(LoginBtnTappedAsync);
            ForgotBtn = new Command(ForgotBtnTappedAsync);
            LoadSavedCredentials();
        }

        private async void RegisterBtnTappedAsync()
        {
            await this._navigation.PushAsync(new RegisterPage());
        }
        private async void ForgotBtnTappedAsync()
        {
            await this._navigation.PushAsync(new ForgotPage());
        }

        private async void LoginBtnTappedAsync(object obj)
        {
            await AuthenticateAndNavigate(UserName, UserPassword);
        }

        private async void LoadSavedCredentials()
        {
            if (Preferences.ContainsKey("RememberMe"))
            {
                string savedUsername = Preferences.Get("SavedUsername", string.Empty);
                string savedPassword = Preferences.Get("SavedPassword", string.Empty);
                await AuthenticateAndNavigate(savedUsername, savedPassword);
            }
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
                if (RememberMe)
                    Preferences.Set("RememberMe", true);
                else
                    Preferences.Remove("RememberMe");
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
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Alert", ex.Message, "OK");
            }
        }

    }
}
