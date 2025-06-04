namespace restaurant;
using restaurant.ViewModels;
public partial class AddIngrProv : ContentPage
{
	public AddIngrProv()
	{
		InitializeComponent();
		BindingContext = new AddIngrProvViewModel();
	}
}