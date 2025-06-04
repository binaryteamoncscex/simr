using restaurant.ViewModels;

namespace restaurant;

public partial class DelMenuIngr : ContentPage
{
    private DelMenuIngrViewModel _viewModel;

    public DelMenuIngr()
    {
        InitializeComponent();
        _viewModel = new DelMenuIngrViewModel();
        BindingContext = _viewModel;
    }

    protected override async void OnAppearing()
    {
        base.OnAppearing();
        await _viewModel.LoadIngredientsAsync();
    }
}
