using Firebase.Database;
using Firebase.Database.Query;
using System.Collections.ObjectModel;
using System.Windows.Input;
using Microsoft.Maui.Storage;
using CommunityToolkit.Mvvm.Input;
using System.ComponentModel;

namespace restaurant.ViewModels
{
    internal class DelIngrProvViewModel : INotifyPropertyChanged
    {
        private readonly string firebaseUrl = "https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient firebaseClient;
        private readonly string uid;
        public event PropertyChangedEventHandler PropertyChanged;
        public INavigation _navigation { get; set; }
        protected void OnPropertyChanged(string propertyName) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        public ObservableCollection<string> Providers { get; set; } = new ObservableCollection<string>();
        public ICommand EditCommand { get; }
        public ICommand DeleteCommand { get; }
        public ICommand RefreshCommand { get; }
        public ICommand AddIngrProv { get; }

        private bool _isRefreshing;
        public bool IsRefreshing
        {
            get => _isRefreshing;
            set
            {
                if (_isRefreshing != value)
                {
                    _isRefreshing = value;
                    OnPropertyChanged(nameof(IsRefreshing));
                }
            }
        }

        public DelIngrProvViewModel(INavigation navigation)
        {
            firebaseClient = new FirebaseClient(firebaseUrl);
            uid = Preferences.Get("uid", string.Empty);
            _navigation = navigation;
            DeleteCommand = new RelayCommand<string>(async (provider) => await DeleteProvider(provider));
            RefreshCommand = new AsyncRelayCommand(LoadProviders);
            EditCommand = new AsyncRelayCommand<string>(async (provider) => await EditProvider(provider));
            AddIngrProv = new Command(async () =>
            {
                var page = new AddIngrProv();
                page.Disappearing += async (s, e) => await LoadProviders();
                await navigation.PushAsync(page);
            });
            LoadProviders();
        }

        private async Task EditProvider(string providerKey)
        {
            if (string.IsNullOrEmpty(providerKey)) return;
            var emailNode = await firebaseClient
                .Child($"users/{uid}/providers")
                .Child(providerKey)
                .OnceSingleAsync<string>();
            var page = new EditIngrProv(providerKey, emailNode);
            page.Disappearing += async (s, e) => await LoadProviders();
            await _navigation.PushAsync(page);
        }

        private async Task LoadProviders()
        {
            try
            {
                IsRefreshing = true;
                var firebaseData = await firebaseClient
                    .Child($"users/{uid}/providers")
                    .OnceAsync<object>();
                Providers.Clear();
                if (firebaseData != null && firebaseData.Count > 0)
                {
                    foreach (var item in firebaseData)
                    {
                        Providers.Add(item.Key);
                    }
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load providers: {ex.Message}", "OK");
            }
            finally
            {
                IsRefreshing = false;
            }
        }

        private async Task DeleteProvider(string providerKey)
        {
            if (string.IsNullOrEmpty(providerKey)) return;
            await firebaseClient
                .Child($"users/{uid}/providers")
                .Child(providerKey)
                .DeleteAsync();
            await LoadProviders();
        }
    }
}
