using restaurant.ViewModels;

namespace restaurant;

public partial class Waiter : ContentPage
{
	public Waiter()
	{
		InitializeComponent();
        BindingContext = new WaiterViewModel();
    }
}