using restaurant.ViewModels;

namespace restaurant;

public partial class ApproveOrders : ContentPage
{
    public ApproveOrders()
    {
        InitializeComponent();
        BindingContext = new ApproveOrdersViewModel();
    }
}
