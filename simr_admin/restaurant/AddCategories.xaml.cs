namespace restaurant;
using restaurant.ViewModels;
public partial class AddCategories : ContentPage
{
	public AddCategories()
	{
		InitializeComponent();
		BindingContext = new AddCategoriesViewModel();
    }
}