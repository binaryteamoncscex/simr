using restaurant.ViewModels;

namespace restaurant;

public partial class DelMenuItem : ContentPage
{
	private DelMenuItemViewModel _viewModel;
    public DelMenuItem()
	{
		InitializeComponent();
        _viewModel = new DelMenuItemViewModel();
        BindingContext = _viewModel;
    }
    protected override async void OnAppearing()
    {
        base.OnAppearing();
        await _viewModel.LoadMenuItemsAsync();
    }
}