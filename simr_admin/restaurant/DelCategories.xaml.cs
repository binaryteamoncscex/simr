namespace restaurant;
using restaurant.ViewModels;
public partial class DelCategories : ContentPage
{
	public DelCategories()
	{
		InitializeComponent();
        BindingContext = new DelCategoriesViewModel(Navigation);
    }
    protected override async void OnAppearing()
    {
        base.OnAppearing();
        if (BindingContext is DelCategoriesViewModel vm)
        {
            await vm.LoadCategoriesAsync();
        }
    }
}