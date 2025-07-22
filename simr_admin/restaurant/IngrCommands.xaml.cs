using restaurant.ViewModels;

namespace restaurant;

public partial class IngrCommands : ContentPage
{
    private IngrCommandsViewModel viewModel;

    public IngrCommands()
    {
        InitializeComponent();
        viewModel = new IngrCommandsViewModel();
        BindingContext = viewModel;
    }

    protected override async void OnAppearing()
    {
        base.OnAppearing();
        await viewModel.LoadOrdersAsync();
    }
}
