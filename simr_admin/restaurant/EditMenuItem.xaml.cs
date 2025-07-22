using restaurant.ViewModels;

namespace restaurant;

public partial class EditMenuItem : ContentPage
{
    private readonly EditMenuItemViewModel _viewModel;

    public EditMenuItem(string key, ViewModels.MenuItem menuItem)
    {
        InitializeComponent();
        _viewModel = new EditMenuItemViewModel(key, menuItem);
        BindingContext = _viewModel;
    }

    protected override async void OnAppearing()
    {
        base.OnAppearing();
        await _viewModel.InitializeAsync();
    }
}
