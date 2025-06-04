namespace restaurant;
using restaurant.ViewModels;
public partial class DelIngrProv : ContentPage
{
	public DelIngrProv()
	{
		InitializeComponent();
		BindingContext = new DelIngrProvViewModel();
	}
}