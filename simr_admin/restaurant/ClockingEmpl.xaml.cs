namespace restaurant;

public partial class ClockingEmpl : ContentPage
{
	public ClockingEmpl()
	{
		InitializeComponent();
		 BindingContext = new ViewModels.ClockingEmplViewModel();
    }
}