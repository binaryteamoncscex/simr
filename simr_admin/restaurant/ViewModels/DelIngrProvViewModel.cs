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
        private readonly string firebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient firebaseClient;
        private readonly string uid;
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string propertyName) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        public ObservableCollection<string> Providers { get; set; } = new ObservableCollection<string>();

        public ICommand DeleteCommand { get; }
        public ICommand RefreshCommand { get; }   

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

        public DelIngrProvViewModel()
        {
            firebaseClient = new FirebaseClient(firebaseUrl);
            uid = Preferences.Get("uid", string.Empty);
            DeleteCommand = new RelayCommand<string>(async (provider) => await DeleteProvider(provider));
            RefreshCommand = new AsyncRelayCommand(LoadProviders);   

            LoadProviders();
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

                if (firebaseData == null || firebaseData.Count == 0)
                {
                    await Application.Current.MainPage.DisplayAlert("Alert", "No providers found.", "OK");
                    Application.Current.MainPage = new NavigationPage(new Dashboard());
                    return;
                }
                else
                {
                    foreach (var item in firebaseData)
                    {
                        Providers.Add(item.Key);
                    }
                }
            }
            catch (Exception ex)
            {
                await Shell.Current.DisplayAlert("Error", $"Failed to load providers: {ex.Message}", "OK");
                return;
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

            Providers.Remove(providerKey);

            if (Providers.Count == 0)
            {
                await Shell.Current.DisplayAlert("Alert", "No more providers.", "OK");

                if (Application.Current?.MainPage != null)
                {
                    Application.Current.MainPage = new NavigationPage(new Dashboard());
                }
            }
        }
    }
}