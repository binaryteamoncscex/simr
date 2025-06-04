using restaurant.ViewModels;

namespace restaurant;

public partial class ForgotPage : ContentPage
{
	public ForgotPage()
	{
		InitializeComponent();
        BindingContext = new ForgotViewModel(Navigation);
    }
}