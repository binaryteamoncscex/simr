using restaurant.ViewModels;

namespace restaurant;

public partial class Cook : ContentPage
{
    public Cook()
    {
        InitializeComponent();
        BindingContext = new CookViewModel(Navigation);
    }
}
