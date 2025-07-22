namespace restaurant;

public partial class WaiterOrders : ContentPage
{
	public WaiterOrders()
	{
		InitializeComponent();
		BindingContext = new ViewModels.WaiterOrdersViewModel();
    }
}