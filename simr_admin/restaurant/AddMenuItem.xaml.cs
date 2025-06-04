using Microsoft.Maui.Controls;
using restaurant.ViewModels;
using System.Linq;

namespace restaurant
{
    public partial class AddMenuItem : ContentPage
    {
        public AddMenuItem()
        {
            InitializeComponent();
            BindingContext = new AddMenuItemViewModel();
        }

        private void OnSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (sender is CollectionView collectionView && BindingContext is AddMenuItemViewModel viewModel)
            {
                foreach (var item in e.PreviousSelection)
                {
                    if (item is Ingredient ingredient)
                    {
                        ingredient.IsSelected = false;
                        viewModel.SelectedIngredients.Remove(ingredient);
                    }
                }

                foreach (var item in e.CurrentSelection)
                {
                    if (item is Ingredient ingredient && !viewModel.SelectedIngredients.Contains(ingredient))
                    {
                        ingredient.IsSelected = true;
                        viewModel.SelectedIngredients.Add(ingredient);
                    }
                }

                collectionView.SelectedItem = null;
            }
        }
    }
}
