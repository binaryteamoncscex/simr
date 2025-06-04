namespace restaurant;
using restaurant.ViewModels;
public partial class DelCategories : ContentPage
{
	public DelCategories()
	{
		InitializeComponent();
        BindingContext = new DelCategoriesViewModel();
    }
}