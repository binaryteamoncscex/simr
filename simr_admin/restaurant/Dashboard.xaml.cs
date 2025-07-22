using restaurant.ViewModels;
using Microsoft.Maui.Controls;

namespace restaurant
{
    public partial class Dashboard : ContentPage
    {
        private DashboardViewModel _viewModel;

        public Dashboard()
        {
            InitializeComponent();
            Padding = new Thickness(0, 30, 0, 0);
            _viewModel = new DashboardViewModel(Navigation);
            BindingContext = _viewModel;
        }

        protected override async void OnAppearing()
        {
            base.OnAppearing();
            NavigationPage.SetHasBackButton(this, false);
            await _viewModel.LoadStatistics();
        }
    }
}