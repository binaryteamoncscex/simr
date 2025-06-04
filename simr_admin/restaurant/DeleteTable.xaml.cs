using restaurant.ViewModels;

namespace restaurant;

public partial class DeleteTable : ContentPage
{
	public DeleteTable()
	{
		InitializeComponent();
		BindingContext = new DeleteTableViewModel();
	}
}