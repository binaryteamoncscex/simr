using CommunityToolkit.Maui.Views;
using System;

namespace restaurant.Views
{
    public partial class HappyHourPopup : Popup
    {
        public event Action<TimeSpan, TimeSpan, int> HappyHourSet;

        public HappyHourPopup()
        {
            InitializeComponent();

            StartHourStepper.ValueChanged += (s, e) =>
            {
                StartHourEntry.Text = ((int)e.NewValue).ToString("D2");
            };

            EndHourStepper.ValueChanged += (s, e) =>
            {
                EndHourEntry.Text = ((int)e.NewValue).ToString("D2");
            };

            StartHourEntry.TextChanged += (s, e) =>
            {
                if (int.TryParse(StartHourEntry.Text, out int val))
                {
                    if (val >= 1 && val <= 24)
                        StartHourStepper.Value = val;
                }
            };

            EndHourEntry.TextChanged += (s, e) =>
            {
                if (int.TryParse(EndHourEntry.Text, out int val))
                {
                    if (val >= 1 && val <= 24)
                        EndHourStepper.Value = val;
                }
            };
        }

        private async void OnApplyClicked(object sender, EventArgs e)
        {
            if (!int.TryParse(DiscountEntry.Text, out int discount))
            {
                await Application.Current.MainPage.DisplayAlert("Error", "Please enter a valid discount.", "OK");
                return;
            }

            int startHour = (int)StartHourStepper.Value;
            int endHour = (int)EndHourStepper.Value;

            if (startHour == 24) startHour = 0;
            if (endHour == 24) endHour = 0;

            var start = new TimeSpan(startHour, 0, 0);
            var stop = new TimeSpan(endHour, 0, 0);

            HappyHourSet?.Invoke(start, stop, discount);
            await CloseAsync();
        }
    }
}
