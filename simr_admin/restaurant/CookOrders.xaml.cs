using restaurant.ViewModels;

namespace restaurant;

public partial class CookOrders : ContentPage
{
	public CookOrders()
	{
		InitializeComponent();
		BindingContext = new CookOrdersViewModel();
	}
}