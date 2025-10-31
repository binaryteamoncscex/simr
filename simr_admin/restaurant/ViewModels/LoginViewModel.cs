using Firebase.Auth;
using Firebase.Auth.Providers;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;
using System;
using System.ComponentModel;
using System.Threading.Tasks;
using Microsoft.Maui.Devices;

namespace restaurant.ViewModels
{
    internal class LoginViewModel : INotifyPropertyChanged
    {
        public string webApiKey = "AIzaSyA531Jgr1ur5VjbloyRdAm6rKMtzk6VQ9w";
        private INavigation _navigation;
        public event PropertyChangedEventHandler PropertyChanged;
        private string userName, userPassword;
        private FirebaseClient firebaseClient = new FirebaseClient("https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/");
        public Command RegisterBtn { get; }
        public Command LoginBtn { get; }
        public Command ForgotBtn { get; }
        public string UserName
        {
            get => userName;
            set { userName = value; PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UserName))); }
        }
        public string UserPassword
        {
            get => userPassword;
            set { userPassword = value; PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UserPassword))); }
        }
        public LoginViewModel(INavigation navigation)
        {
            _navigation = navigation;
            RegisterBtn = new Command(RegisterBtnTappedAsync);
            LoginBtn = new Command(LoginBtnTappedAsync);
            ForgotBtn = new Command(ForgotBtnTappedAsync);
        }
        private async void RegisterBtnTappedAsync() => await _navigation.PushAsync(new RegisterPage());
        private async void ForgotBtnTappedAsync() => await _navigation.PushAsync(new ForgotPage());
        private async void LoginBtnTappedAsync(object obj) => await AuthenticateAndNavigate(UserName, UserPassword);
        private async Task AuthenticateAndNavigate(string username, string password)
        {
            var authConfig = new FirebaseAuthConfig
            {
                ApiKey = webApiKey,
                AuthDomain = "restaurant-ad63f.firebaseapp.com",
                Providers = new FirebaseAuthProvider[] { new EmailProvider() }
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
                Preferences.Set("FirebaseToken", token);

                var firebaseClient = new FirebaseClient(
                    "https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/",
                    new FirebaseOptions { AuthTokenAsyncFactory = () => Task.FromResult(token) });

                var userData = await firebaseClient.Child("users").Child(uid).OnceSingleAsync<dynamic>();
                string userType = userData?.Type ?? "unknown";

                await RegisterDeviceAsync(uid, userType, firebaseClient);

                if (userType == "owner")
                {
                    var setupData = await firebaseClient.Child("users").Child(uid).Child("setup").OnceSingleAsync<dynamic>();
                    if (setupData == null || setupData == false)
                        Application.Current.MainPage = new NavigationPage(new Setup());
                    else
                        Application.Current.MainPage = new NavigationPage(new ApproveOrders());
                }
                else if (userType == "Cook")
                {
                    Application.Current.MainPage = new NavigationPage(new Cook());
                }
                else if (userType == "Waiter")
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
                if (ex.Message.Contains("INVALID_LOGIN_CREDENTIALS")) message = "Incorrect email or password.";
                else if (ex.Reason == AuthErrorReason.InvalidEmailAddress) message = "The email address format is invalid.";
                else if (ex.Reason == AuthErrorReason.UserDisabled) message = "This user account has been disabled.";
                else if (ex.Reason == AuthErrorReason.TooManyAttemptsTryLater) message = "Too many attempts. Please try again later.";
                else message = $"Authentication failed: {ex.Message}";
                await App.Current.MainPage.DisplayAlert("Login Error", message, "OK");
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Unexpected Error", ex.Message, "OK");
            }
        }

        public async Task RegisterDeviceAsync(string userId, string userType, FirebaseClient authenticatedClient)
        {
            try
            {
                var token = Preferences.Get("FCMToken", string.Empty);
                if (string.IsNullOrEmpty(token)) return;

                var deviceId = Preferences.Get("DeviceId", Guid.NewGuid().ToString());
                Preferences.Set("DeviceId", deviceId);

                await authenticatedClient.Child("users").Child(userId).Child("devices").Child(deviceId).PutAsync(new
                {
                    token = token,
                    platform = DeviceInfo.Platform.ToString(),
                    lastLogin = DateTime.UtcNow.ToString("o")
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"RegisterDeviceAsync error: {ex.Message}");
            }
        }
    }
}