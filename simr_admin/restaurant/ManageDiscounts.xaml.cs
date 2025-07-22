namespace restaurant;

public partial class ManageDiscounts : ContentPage
{
	public ManageDiscounts()
	{
		InitializeComponent();
		BindingContext = new ViewModels.ManageDiscountsViewModel();
    }
}