using Firebase.Auth;
using Firebase.Auth.Providers;
using Firebase.Database;
using Firebase.Database.Query;
using System.ComponentModel;
using System.Threading.Tasks;

namespace restaurant.ViewModels
{
    internal class DashboardViewModel : INotifyPropertyChanged
    {
        private const string WebApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly INavigation _navigation;
        private string _restaurantName;

        public DashboardViewModel(INavigation navigation)
        {
            _navigation = navigation;
            AddEmployBtn = new Command(AddEmployBtnTappedAsync);
            AddTableBtn = new Command(AddTableBtnTappedAsync);
            CheckInvenBtn = new Command(CheckInvenBtnTappedAsync);
            DelEmployBtn = new Command(DelEmployBtnTappedAsync);
            DelTableBtn = new Command(DelTableBtnTappedAsync);
            SignOutBtn = new Command(SignOutBtnTappedAsync);
            AddMenuItemBtn = new Command(AddMenuItemBtnTappedAsync);
            DelMenuItemBtn = new Command(DelMenuItemBtnTappedAsync);
            AddMenuIngrBtn = new Command(AddMenuIngrBtnTappedAsync);
            DelMenuIngrBtn = new Command(DelMenuIngrBtnTappedAsync);
            IngrCommands = new Command(IngrCommandsTappedAsync);
            MyAccountBtn = new Command(MyAccountBtnTappedAsync);
            StatisticsBtn = new Command(StatisticsBtnTappedAsync);
            AddIngrProvBtn = new Command(AddIngrProvBtnTappedAsync);
            DelIngrProvBtn = new Command(DelIngrProvBtnTappedAsync);
            AddMenuCatBtn = new Command(AddMenuCatBtnTappedAsync);
            DelMenuCatBtn = new Command(DelMenuCatBtnTappedAsync);
            LoadRestaurantName();
        }
        private async void AddMenuCatBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new AddCategories());
        }
        private async void DelMenuCatBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new DelCategories());
        }
        private async void DelIngrProvBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new DelIngrProv());
        }

        private async void AddIngrProvBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new AddIngrProv());
        }

        private async void AddMenuItemBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new AddMenuItem());
        }
        private async void DelMenuItemBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new DelMenuItem());
        }
        private async void AddMenuIngrBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new AddMenuIngr());
        }
        private async void DelMenuIngrBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new DelMenuIngr());
        }
        private async void IngrCommandsTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new IngrCommands());
        }

        public string RestaurantName
        {
            get => _restaurantName;
            set
            {
                _restaurantName = value;
                OnPropertyChanged(nameof(RestaurantName));
            }
        }

        private async void LoadRestaurantName()
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
            var user = authProvider.User;
            if (user != null)
            {
                var firebaseClient = new FirebaseClient(FirebaseUrl);
                var restaurantData = await firebaseClient
                    .Child("users")
                    .Child(user.Uid)
                    .OnceSingleAsync<dynamic>();
                if (restaurantData.Name != null)
                {
                    RestaurantName = restaurantData.Your_Name + " (" + restaurantData.Name + ")";
                }
                else
                {
                    RestaurantName = "Invalid";
                }
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
        private async void DelTableBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new DeleteTable());
        }
        private async void DelEmployBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new DeleteEmploy());
        }
        private async void CheckInvenBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new CheckInven());
        }
        private async void AddTableBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new AddTable());
        }
        private async void AddEmployBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new AddEmploy());
        }
        private async void MyAccountBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new MyAccount());
        }
        private async void StatisticsBtnTappedAsync(object obj)
        {
            await this._navigation.PushAsync(new Statistics());
        }
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
        public Command AddEmployBtn { get; }
        public Command AddTableBtn { get; }
        public Command CheckInvenBtn { get; }
        public Command DelEmployBtn { get; }
        public Command DelTableBtn { get; }
        public Command AddMenuItemBtn { get; }
        public Command DelMenuItemBtn { get; }
        public Command AddMenuIngrBtn { get; }
        public Command DelMenuIngrBtn { get; }
        public Command IngrCommands { get; }
        public Command SignOutBtn { get; }
        public Command MyAccountBtn { get; }
        public Command StatisticsBtn { get; }
        public Command AddIngrProvBtn { get; }
        public Command DelIngrProvBtn { get; }
        public Command AddMenuCatBtn { get; }
        public Command DelMenuCatBtn { get; }
    }
}