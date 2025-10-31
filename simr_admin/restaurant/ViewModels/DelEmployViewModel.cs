using Firebase.Auth;
using Firebase.Auth.Providers;
using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using System;
using System.ComponentModel;
using System.Threading.Tasks;

namespace restaurant.ViewModels
{
    internal class DelEmployViewModel : INotifyPropertyChanged
    {
        private const string WebApiKey = "AIzaSyA531Jgr1ur5VjbloyRdAm6rKMtzk6VQ9w";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient("https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/");
        private readonly FirebaseAuthClient _authClient;

        private string _email;
        private string _password;

        public event PropertyChangedEventHandler PropertyChanged;

        public string Email
        {
            get => _email;
            set
            {
                _email = value;
                RaisePropertyChanged("Email");
            }
        }

        public string Password
        {
            get => _password;
            set
            {
                _password = value;
                RaisePropertyChanged("Password");
            }
        }

        public Command DeleteUser { get; }

        public DelEmployViewModel()
        {
            var authConfig = new FirebaseAuthConfig
            {
                ApiKey = WebApiKey,
                AuthDomain = "restaurant-ad63f.firebaseapp.com",
                Providers = new FirebaseAuthProvider[] { new EmailProvider() }
            };
            _authClient = new FirebaseAuthClient(authConfig);
            DeleteUser = new Command(async () => await DeleteUserTappedAsync());
        }

        private async Task DeleteUserTappedAsync()
        {
            try
            {
                string ownerEmail = Preferences.Get("SavedUsername", string.Empty);
                string ownerPassword = Preferences.Get("SavedPassword", string.Empty);
                if(string.IsNullOrEmpty(ownerEmail))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Owner email not found. Please re-login.", "OK");
                    return;
                }
                if (string.IsNullOrEmpty(ownerPassword))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Owner password not found. Please re-login.", "OK");
                    return;
                }

                var employeeAuth = await _authClient.SignInWithEmailAndPasswordAsync(Email, Password);
                string uid = employeeAuth.User.Uid;

                if (!string.IsNullOrEmpty(uid))
                {
                    await _firebaseClient.Child("users").Child(uid).DeleteAsync();
                    await employeeAuth.User.DeleteAsync();
                    await Application.Current.MainPage.DisplayAlert("Success", "Employee Deleted Successfully", "OK");

                    await _authClient.SignInWithEmailAndPasswordAsync(ownerEmail, ownerPassword);
                    Email = string.Empty;
                    Password = string.Empty;
                    await Application.Current.MainPage.Navigation.PopAsync();
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", ex.Message, "OK");
            }
        }

        private void RaisePropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
