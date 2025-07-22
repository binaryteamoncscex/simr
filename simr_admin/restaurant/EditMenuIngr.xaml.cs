using restaurant.ViewModels;

namespace restaurant;

public partial class EditMenuIngr : ContentPage
{
    private readonly EditMenuIngrViewModel _viewModel;

    public EditMenuIngr(string key, Ingredient ingredient)
    {
        InitializeComponent();
        _viewModel = new EditMenuIngrViewModel(key, ingredient);
        BindingContext = _viewModel;
    }

    protected override async void OnAppearing()
    {
        base.OnAppearing();
        await _viewModel.InitializeAsync();
    }
}
