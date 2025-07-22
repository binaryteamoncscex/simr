using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Graphics;
using Microsoft.Maui.Storage;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace restaurant.ViewModels
{
    internal class ClockingEmplViewModel : INotifyPropertyChanged
    {
        private string _norm;
        private string _wagePerHour;
        private int _hours;
        private bool _atWork;

        public string Norm
        {
            get => _norm;
            set { _norm = value; OnPropertyChanged(); }
        }

        public string WagePerHour
        {
            get => _wagePerHour;
            set { _wagePerHour = value; OnPropertyChanged(); OnPropertyChanged(nameof(WageForMonth)); }
        }

        public int Hours
        {
            get => _hours;
            set { _hours = value; OnPropertyChanged(); OnPropertyChanged(nameof(WageForMonth)); }
        }

        public string WageForMonth =>
            double.TryParse(WagePerHour, out var wage) ? (wage * Hours).ToString("0.00") : "0.00";

        public string AtWorkButtonText => _atWork ? "Clock Out" : "Clock In";

        public Color AtWorkButtonColor => _atWork ? Colors.Red : Colors.Green;

        public Command ToggleClockingCommand { get; }

        private readonly FirebaseClient _firebase;
        private readonly string _uid;

        public ClockingEmplViewModel()
        {
            _firebase = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");
            _uid = Preferences.Get("uid", "");
            ToggleClockingCommand = new Command(async () => await ToggleClocking());
            LoadEmployeeData();
        }

        private async void LoadEmployeeData()
        {
            var data = await _firebase.Child("users").Child(_uid).OnceSingleAsync<Dictionary<string, object>>();

            Norm = data.ContainsKey("Norm") ? data["Norm"]?.ToString() ?? "0" : "0";
            WagePerHour = data.ContainsKey("WagePerHour") ? data["WagePerHour"]?.ToString() ?? "0" : "0";
            Hours = data.ContainsKey("hours") && int.TryParse(data["hours"]?.ToString(), out var h) ? h : 0;
            _atWork = data.ContainsKey("at_work") && bool.TryParse(data["at_work"]?.ToString(), out var b) && b;

            OnPropertyChanged(nameof(AtWorkButtonText));
            OnPropertyChanged(nameof(AtWorkButtonColor));
        }

        private async Task ToggleClocking()
        {
            _atWork = !_atWork;

            await _firebase.Child("users").Child(_uid)
                .Child("at_work").PutAsync(_atWork);

            OnPropertyChanged(nameof(AtWorkButtonText));
            OnPropertyChanged(nameof(AtWorkButtonColor));
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }
}
