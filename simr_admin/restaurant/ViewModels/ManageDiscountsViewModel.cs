using CommunityToolkit.Maui.Extensions;
using CommunityToolkit.Maui.Views;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using Microsoft.Maui.Dispatching;
using System.Threading.Tasks;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    internal class ManageDiscountsViewModel : BaseViewModel
    {
        private readonly FirebaseClient _firebase;
        private string _uid = Preferences.Default.Get("uid", "");

        public ICommand ShowPopupCommand { get; }
        public ICommand DeactivateCommand { get; }
        public ICommand ShowFidelityPopupCommand { get; }

        private bool _isActive;
        public bool IsActive
        {
            get => _isActive;
            set
            {
                SetProperty(ref _isActive, value);
                OnPropertyChanged(nameof(IsNotActive));
            }
        }

        public bool IsNotActive => !IsActive;

        public ManageDiscountsViewModel()
        {
            _firebase = new FirebaseClient("https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/");
            ShowPopupCommand = new Command(async () => await ShowPopup());
            DeactivateCommand = new Command(async () => await Deactivate());
            ShowFidelityPopupCommand = new Command(async () => await ShowFidelityPopup());
            CheckActiveStatus();
        }

        private async Task ShowPopup()
        {
            var popup = new Views.HappyHourPopup();
            popup.HappyHourSet += async (start, stop, percent) =>
            {
                await _firebase
                    .Child("users").Child(_uid).Child("HappyHour").Child("start").PutAsync(start.Hours);
                await _firebase
                    .Child("users").Child(_uid).Child("HappyHour").Child("stop").PutAsync(stop.Hours);
                await _firebase
                    .Child("users").Child(_uid).Child("HappyHour").Child("procent").PutAsync(percent);

                IsActive = true;
            };

            var page = Application.Current.MainPage as Page;
            await MainThread.InvokeOnMainThreadAsync(() =>
            {
                page.ShowPopup(popup);
            });
        }

        private async Task Deactivate()
        {
            var happyHourRef = _firebase
                .Child("users").Child(_uid).Child("HappyHour");

            await happyHourRef.Child("start").PutAsync(-1);
            await happyHourRef.Child("stop").PutAsync(-1);
            await happyHourRef.Child("procent").PutAsync(-1);

            IsActive = false;
        }

        private async void CheckActiveStatus()
        {
            try
            {
                var procent = await _firebase
                    .Child("users").Child(_uid).Child("HappyHour").Child("procent")
                    .OnceSingleAsync<int>();

                IsActive = procent != -1;
            }
            catch
            {
                IsActive = false;
            }
        }

        private async Task ShowFidelityPopup()
        {
            var popup = new Views.FidelityCardPopup();
            popup.FidelityCardSet += async (purchases, procent) =>
            {
                await _firebase
                    .Child("users").Child(_uid).Child("FidelityCard").Child("Purchases").PutAsync(purchases.ToString());

                await _firebase
                    .Child("users").Child(_uid).Child("FidelityCard").Child("procent").PutAsync(procent.ToString());
            };

            var page = Application.Current.MainPage as Page;
            await MainThread.InvokeOnMainThreadAsync(() =>
            {
                page.ShowPopup(popup);
            });
        }

    }
}
