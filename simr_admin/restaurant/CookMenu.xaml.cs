using restaurant.ViewModels;

namespace restaurant;

public partial class CookMenu : ContentPage
{
	public CookMenu()
	{
		InitializeComponent();
		BindingContext = new CookMenuViewModel();
	}
}