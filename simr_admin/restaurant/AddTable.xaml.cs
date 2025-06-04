using restaurant.ViewModels;

namespace restaurant;

public partial class AddTable : ContentPage
{
	public AddTable()
	{
		InitializeComponent();
		BindingContext = new AddTableViewModel();
	}
}