using restaurant.ViewModels;

namespace restaurant
{
    public partial class Dashboard : ContentPage
    {
        public Dashboard()
        {
            InitializeComponent();
            Padding = new Thickness(0, 30, 0, 0);
            NavigationPage.SetHasBackButton(this, false);
            NavigationPage.SetBackButtonTitle(this, "");
            BindingContext = new DashboardViewModel(Navigation);
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
            NavigationPage.SetHasBackButton(this, false);
            NavigationPage.SetBackButtonTitle(this, "");
        }
    }


}
