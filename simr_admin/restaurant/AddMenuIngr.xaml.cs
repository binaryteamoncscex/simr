using restaurant.ViewModels;

namespace restaurant;

public partial class AddMenuIngr : ContentPage
{
	public AddMenuIngr()
	{
		InitializeComponent();
		BindingContext = new AddMenuIngrViewModel();
    }
}