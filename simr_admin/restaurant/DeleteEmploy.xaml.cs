using restaurant.ViewModels;

namespace restaurant;

public partial class DeleteEmploy : ContentPage
{
	public DeleteEmploy()
	{
		InitializeComponent();
		BindingContext = new DelEmployViewModel();
	}
}