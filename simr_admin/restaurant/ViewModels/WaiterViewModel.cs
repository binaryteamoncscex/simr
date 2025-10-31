using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    internal class WaiterViewModel : INotifyPropertyChanged
    {
        private INavigation _navigation;

        public Command MyAccountCommand { get; }
        public Command SignOutBtn { get; }
        public Command ClockingBtn { get; }
        public Command FoodOrdersBtn { get; }

        private string _welcomeMessage;
        public string WelcomeMessage
        {
            get => _welcomeMessage;
            set { _welcomeMessage = value; OnPropertyChanged(); }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        public WaiterViewModel(INavigation navigation)
        {
            _navigation = navigation;
            MyAccountCommand = new Command(async () =>
            {
                await Application.Current.MainPage.Navigation.PushAsync(new MyAccCoWa());
            });

            SignOutBtn = new Command(SignOutBtnTappedAsync);
            ClockingBtn = new Command(async () => await _navigation.PushAsync(new ClockingEmpl()));
            FoodOrdersBtn = new Command(async () => await _navigation.PushAsync(new WaiterOrders()));
            LoadWelcomeMessage();
        }

        private async void LoadWelcomeMessage()
        {
            var uid = Preferences.Get("uid", string.Empty);
            if (string.IsNullOrEmpty(uid))
                return;

            var firebase = new FirebaseClient("https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/");
            var userEntry = await firebase.Child("users").Child(uid).OnceSingleAsync<User>();
            if (userEntry == null || string.IsNullOrEmpty(userEntry.Owner)) return;

            var ownerEntry = await firebase.Child("users").Child(userEntry.Owner).OnceSingleAsync<User>();
            WelcomeMessage = $"Welcome, {userEntry.Name} ({ownerEntry?.Name ?? "Unknown Owner"})";
        }

        private async void SignOutBtnTappedAsync(object obj)
        {
            try
            {
                Preferences.Remove("SavedUsername");
                Preferences.Remove("SavedPassword");
                Preferences.Remove("uid");
                Preferences.Remove("RememberMe");
                Application.Current.MainPage = new NavigationPage(new IntroPage(isFirstLaunch: false, rememberMe: false));
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

        public class User
        {
            public string Name { get; set; }
            public string Owner { get; set; }
        }
    }
}
