using Firebase.Database;
using Firebase.Database.Query;
using System.ComponentModel;
using System.Threading.Tasks;
using Microsoft.Maui.Storage;
using Microsoft.Maui.Controls;
using System;

namespace restaurant.ViewModels
{
    public class MyAccCoWaViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private readonly FirebaseClient firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");

        private string _email;
        public string Email
        {
            get => _email;
            set { if (_email != value) { _email = value; OnPropertyChanged(nameof(Email)); } }
        }

        private string _name;
        public string Name         
        {
            get => _name;
            set { if (_name != value) { _name = value; OnPropertyChanged(nameof(Name)); } }
        }

        public Command UpdateNameCommand { get; }

        public MyAccCoWaViewModel()
        {
            UpdateNameCommand = new Command(async () => await OnUpdateName());
            _ = LoadData();
        }

        private async Task LoadData()
        {
            try
            {
                Email = Preferences.Get("SavedUsername", string.Empty);
                string uid = Preferences.Get("uid", string.Empty);
                if (string.IsNullOrEmpty(uid))
                {
                    System.Diagnostics.Debug.WriteLine("UID not found in preferences.");
                    return;
                }

                var userData = await firebaseClient
                    .Child("users").Child(uid)
                    .OnceSingleAsync<dynamic>();

                if (userData.Name != null)
                {
                    Name = userData.Name;
                } else
                {
                    Name = String.Empty;
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to load data: {ex.Message}", "OK");
                System.Diagnostics.Debug.WriteLine($"Error loading data: {ex.Message}");
            }
        }

        private async Task OnUpdateName()
        {
            try
            {
                string uid = Preferences.Get("uid", string.Empty);
                if (string.IsNullOrEmpty(uid))
                {
                    await Application.Current.MainPage.DisplayAlert("Error", "User not logged in. Cannot update name.", "OK");
                    return;
                }

                if (string.IsNullOrWhiteSpace(Name))
                {
                    await Application.Current.MainPage.DisplayAlert("Input Error", "Your Name cannot be empty.", "OK");
                    return;
                }

                await firebaseClient
                    .Child("users")
                    .Child(uid)
                    .Child("Name")
                    .PutAsync($"\"{Name}\"");          

                await Application.Current.MainPage.DisplayAlert("Success", "Your Name updated successfully!", "OK");
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to update name: {ex.Message}", "OK");
                System.Diagnostics.Debug.WriteLine($"Error updating name: {ex.Message}");
            }
        }

        protected void OnPropertyChanged(string propertyName) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}