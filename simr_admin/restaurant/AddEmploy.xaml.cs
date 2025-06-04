using restaurant.ViewModels;

namespace restaurant;

public partial class AddEmploy : ContentPage
{
	public AddEmploy()
	{
		InitializeComponent();
        BindingContext = new AddEmployViewModel();
    }
}