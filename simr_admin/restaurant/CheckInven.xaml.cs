using restaurant.ViewModels;

namespace restaurant;

public partial class CheckInven : ContentPage
{
	public CheckInven()
	{
		InitializeComponent();
        BindingContext = new CheckInvenViewModel();
    }
}