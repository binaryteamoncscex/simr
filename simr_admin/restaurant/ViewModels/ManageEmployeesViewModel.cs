using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    internal class ManageEmployeesViewModel
    {
        public INavigation Navigation { get; }
        public ICommand AddEmplCommand { get; }
        public ICommand DeleteEmplCommand { get; }
        public ICommand ManageClockingCommand { get; }

        public ManageEmployeesViewModel(INavigation navigation)
        {
            Navigation = navigation;

            AddEmplCommand = new Command(async () => await GoToAddEmplPage());
            DeleteEmplCommand = new Command(async () => await GoToDeleteEmplPage());
            ManageClockingCommand = new Command(async () => await Navigation.PushAsync(new ManageClocking()));
        }

        private async Task GoToAddEmplPage()
        {
            await Navigation.PushAsync(new AddEmploy());
        }

        private async Task GoToDeleteEmplPage()
        {
            await Navigation.PushAsync(new DeleteEmploy());
        }
    }
}
