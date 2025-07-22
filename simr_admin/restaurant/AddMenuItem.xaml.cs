using Microsoft.Maui.Controls;
using restaurant.ViewModels;

namespace restaurant
{
    public partial class AddMenuItem : ContentPage
    {
        public AddMenuItem()
        {
            InitializeComponent();
            BindingContext = new AddMenuItemViewModel();
        }
    }
}