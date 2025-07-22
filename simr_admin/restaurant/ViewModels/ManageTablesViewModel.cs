using System.Windows.Input;
using Microsoft.Maui.Controls;

namespace restaurant.ViewModels
{
    internal class ManageTablesViewModel
    {
        public INavigation Navigation { get; }

        public ICommand AddTablesCommand { get; }
        public ICommand DeleteTablesCommand { get; }

        public ManageTablesViewModel(INavigation navigation)
        {
            Navigation = navigation;

            AddTablesCommand = new Command(async () => await GoToAddTablePage());
            DeleteTablesCommand = new Command(async () => await GoToDeleteTablePage());
        }

        private async Task GoToAddTablePage()
        {
            await Navigation.PushAsync(new AddTable());
        }

        private async Task GoToDeleteTablePage()
        {
            await Navigation.PushAsync(new DeleteTable());
        }
    }
}
