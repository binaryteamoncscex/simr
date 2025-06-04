using restaurant.ViewModels;

namespace restaurant;

public partial class LoginPage : ContentPage
{
    public LoginPage()
    {
        InitializeComponent();
        BindingContext = new LoginViewModel(Navigation);
        NavigationPage.SetHasNavigationBar(this, false);
    }
}