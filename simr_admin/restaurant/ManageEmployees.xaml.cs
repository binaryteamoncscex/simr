namespace restaurant;

public partial class ManageEmployees : ContentPage
{
	public ManageEmployees()
	{
		InitializeComponent();
		BindingContext = new ViewModels.ManageEmployeesViewModel(Navigation);
    }
}