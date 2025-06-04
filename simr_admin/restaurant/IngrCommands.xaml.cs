using restaurant.ViewModels;

namespace restaurant;

public partial class IngrCommands : ContentPage
{
	public IngrCommands()
	{
		InitializeComponent();
		BindingContext = new IngrCommandsViewModel();
    }
}