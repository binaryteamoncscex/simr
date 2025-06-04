namespace restaurant;

public partial class Statistics : ContentPage
{
    private ViewModels.StatisticsViewModel _viewModel;

    public Statistics()
    {
        InitializeComponent();
        BindingContext = _viewModel = new ViewModels.StatisticsViewModel(Navigation);

    }

    protected override async void OnAppearing()
    {
        base.OnAppearing();
        await _viewModel.LoadStatistics();
    }
}