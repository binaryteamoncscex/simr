namespace restaurant;

public partial class ManageTables : ContentPage
{
	public ManageTables()
	{
		InitializeComponent();
		BindingContext = new ViewModels.ManageTablesViewModel(Navigation);
    }
}