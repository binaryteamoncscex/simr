using Firebase.Auth.Providers;
using Firebase.Auth;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using static restaurant.ViewModels.WaiterViewModel;

namespace restaurant.ViewModels
{
    internal class CookViewModel : INotifyPropertyChanged
    {
        private const string DatabaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private const string WebApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private readonly FirebaseClient _firebaseClient;

        public Command SignOutBtn { get; }
        public Command FoodOrdersBtn { get; }
        public Command MenuRecipiesBtn { get; }
        public Command MyAccountCommand { get; }

        private string _userId;
        private string _welcomeMessage;

        public string WelcomeMessage
        {
            get => _welcomeMessage;
            set { _welcomeMessage = value; OnPropertyChanged(); }
        }

        public event PropertyChangedEventHandler? PropertyChanged;
        private readonly INavigation _navigation;
        public CookViewModel(INavigation navigation)
        {
            _firebaseClient = new FirebaseClient(DatabaseUrl);
            SignOutBtn = new Command(SignOutBtnTappedAsync);
            FoodOrdersBtn = new Command(FoodOrdersBtnTappedAsync);
            MenuRecipiesBtn = new Command(MenuRecipiesBtnTappedAsync);
            MyAccountCommand = new Command(async () => await _navigation.PushAsync(new MyAccCoWa()));
            LoadUserData();
            _navigation = navigation;
        }

        private async void FoodOrdersBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new CookOrders());
        }
        private async void MenuRecipiesBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new CookMenu());
        }

        private async void LoadUserData()
        {
            try
            {
                string loggedInUserId = Preferences.Get("uid", string.Empty);
                if (string.IsNullOrEmpty(loggedInUserId))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "User ID not found!", "OK");
                    return;
                }

                var userEntry = await _firebaseClient.Child("users").Child(loggedInUserId).OnceSingleAsync<restaurant.ViewModels.WaiterViewModel.User>();
                if (userEntry == null || string.IsNullOrEmpty(userEntry.Owner))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Owner not found for this user!", "OK");
                    return;
                }

                _userId = userEntry.Owner;
                var ownerEntry = await _firebaseClient.Child("users").Child(_userId).OnceSingleAsync<restaurant.ViewModels.WaiterViewModel.User>();
                WelcomeMessage = $"Welcome, {userEntry.Name} ({ownerEntry?.Name ?? "Unknown Owner"})";
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load user data: {ex.Message}", "OK");
            }
        }
        private async void SignOutBtnTappedAsync(object obj)
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
            var authProvider = new FirebaseAuthClient(authConfig);
            try
            {
                authProvider.SignOut();
                Preferences.Remove("SavedUsername");
                Preferences.Remove("SavedPassword");
                Application.Current.MainPage = new NavigationPage(new LoginPage());
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Alert", ex.Message, "OK");
            }
        }
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
