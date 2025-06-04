namespace restaurant;

public partial class MyAccCoWa : ContentPage
{
	public MyAccCoWa()
	{
		InitializeComponent();
        BindingContext = new ViewModels.MyAccCoWaViewModel();
    }
}