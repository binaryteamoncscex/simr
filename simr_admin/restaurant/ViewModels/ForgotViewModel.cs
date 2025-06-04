using System;
using System.ComponentModel;
using System.Threading.Tasks;
using Firebase.Auth;
using Firebase.Auth.Providers;
using Microsoft.Maui.Controls;

namespace restaurant.ViewModels
{
    internal class ForgotViewModel : INotifyPropertyChanged
    {
        public string webApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private string email;
        private INavigation _navigation;
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

        public Command RecoverPass { get; }

        private void RaisePropertyChanged(string v)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(v));
        }

        public ForgotViewModel(INavigation navigation)
        {
            RecoverPass = new Command(RecoverPasswordTappedAsync);
            _navigation = navigation;
        }

        private async void RecoverPasswordTappedAsync(object obj)
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
                await authProvider.ResetEmailPasswordAsync(email);
                await App.Current.MainPage.DisplayAlert("Success", "Password reset email sent!", "OK");
                await this._navigation.PopAsync();
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Error", ex.Message, "OK");
            }
        }
    }
}
