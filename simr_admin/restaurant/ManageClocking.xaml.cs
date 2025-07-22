namespace restaurant;

public partial class ManageClocking : ContentPage
{
	public ManageClocking()
	{
		InitializeComponent();
        BindingContext = new ViewModels.ManageClockingViewModel();
    }
}