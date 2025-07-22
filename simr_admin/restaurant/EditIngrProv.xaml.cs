using Microsoft.Maui.Controls;
using restaurant.ViewModels;
namespace restaurant
{
    public partial class EditIngrProv : ContentPage
    {
        public EditIngrProv(string providerName, string providerEmail)
        {
            InitializeComponent();
            BindingContext = new EditIngrProvViewModel(providerName, providerEmail, Navigation);
        }
    }
}