namespace restaurant;

public partial class MyAccount : ContentPage
{
	public MyAccount()
	{
		InitializeComponent();
        BindingContext = new ViewModels.MyAccountViewModel();
    }
}