namespace restaurant;

public partial class Setup : ContentPage
{
	public Setup()
	{
		InitializeComponent();
		BindingContext = new ViewModels.SetupViewModel();
    }
}