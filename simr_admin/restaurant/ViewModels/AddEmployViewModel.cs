 using Firebase.Auth.Providers;
using Firebase.Auth;
using Firebase.Database;
using System;
using System.ComponentModel;
using System.Threading.Tasks;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;
using Microsoft.Maui.Controls;
using System.Collections.ObjectModel;

namespace restaurant.ViewModels
{
    internal class AddEmployViewModel : INotifyPropertyChanged
    {
        private const string WebApiKey = "AIzaSyA531Jgr1ur5VjbloyRdAm6rKMtzk6VQ9w";
        private readonly FirebaseClient _firebaseClient = new FirebaseClient("https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/");
        private readonly FirebaseAuthClient _authClient;

        private string _email;
        private string _password;
        private string _name;
        private string _type;
        private string _norm;
        private string _wagePerHour;
        private string _owner = Preferences.Get("uid", string.Empty);

        public ObservableCollection<string> Roles { get; } = new ObservableCollection<string> { "Cook", "Waiter" };
        public event PropertyChangedEventHandler PropertyChanged;

        public string Email
        {
            get => _email;
            set
            {
                _email = value;
                RaisePropertyChanged(nameof(Email));
            }
        }

        public string Password
        {
            get => _password;
            set
            {
                _password = value;
                RaisePropertyChanged(nameof(Password));
            }
        }

        public string Name
        {
            get => _name;
            set
            {
                _name = value;
                RaisePropertyChanged(nameof(Name));
            }
        }

        public string Type
        {
            get => _type;
            set
            {
                _type = value;
                RaisePropertyChanged(nameof(Type));
            }
        }

        public string Norm
        {
            get => _norm;
            set
            {
                _norm = value;
                RaisePropertyChanged(nameof(Norm));
            }
        }

        public string WagePerHour
        {
            get => _wagePerHour;
            set
            {
                _wagePerHour = value;
                RaisePropertyChanged(nameof(WagePerHour));
            }
        }

        public Command RegisterUser { get; }

        public AddEmployViewModel()
        {
            var authConfig = new FirebaseAuthConfig
            {
                ApiKey = WebApiKey,
                AuthDomain = "restaurant-ad63f.firebaseapp.com",
                Providers = new FirebaseAuthProvider[] { new EmailProvider() }
            };
            _authClient = new FirebaseAuthClient(authConfig);
            RegisterUser = new Command(async () => await RegisterUserTappedAsync());
        }

        private async Task RegisterUserTappedAsync()
        {
            try
            {

                string ownerEmail = Preferences.Get("SavedUsername", string.Empty);
                string ownerPassword = Preferences.Get("SavedPassword", string.Empty);

                if (string.IsNullOrEmpty(ownerPassword))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Owner password not found. Please re-login.", "OK");
                    return;
                }
                if (string.IsNullOrEmpty(ownerEmail))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "Owner email not found. Please re-login.", "OK");
                    return;
                }

                var auth = await _authClient.CreateUserWithEmailAndPasswordAsync(Email, Password);
                string uid = auth.User.Uid;

                if (!string.IsNullOrEmpty(uid))
                {
                    var userData = new
                    {
                        Name = Name,
                        Type = _type,
                        Owner = _owner,
                        Norm = Norm,
                        WagePerHour = WagePerHour
                    };

                    await _firebaseClient.Child("users").Child(uid).PutAsync(userData);
                    await Application.Current.MainPage.DisplayAlert("Success", "Employee Registered Successfully", "OK");

                    await _authClient.SignInWithEmailAndPasswordAsync(ownerEmail, ownerPassword);

                    Email = string.Empty;
                    Password = string.Empty;
                    Name = string.Empty;
                    Type = string.Empty;
                    Norm = string.Empty;
                    WagePerHour = string.Empty;

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
