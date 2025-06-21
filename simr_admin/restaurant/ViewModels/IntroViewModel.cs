using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;

namespace restaurant.ViewModels
{
    public class IntroViewModel : INotifyPropertyChanged
    {
        private int _currentIndex;
        public int CurrentIndex
        {
            get => _currentIndex;
            set
            {
                if (_currentIndex != value)
                {
                    _currentIndex = value;
                    OnPropertyChanged();
                    OnPropertyChanged(nameof(IsFirstPage));
                    OnPropertyChanged(nameof(IsNotFirstPage));
                    OnPropertyChanged(nameof(IsLastPage));
                    OnPropertyChanged(nameof(IsNotLastPage));
                }
            }
        }

        public ObservableCollection<IntroPageModel> Pages { get; } = new()
        {
            new() { Title = "Welcome!", Description = "Manage your restaurant with SIMR Admin.", Image = "intro1.png" },
            new() { Title = "Track Orders", Description = "Monitor food orders and ingredients.", Image = "intro2.png" },
            new() { Title = "Analyze Statistics", Description = "Gain insights on your restaurant's performance.", Image = "intro3.png" },
            new() { Title = "Get Started", Description = "Login or sign up to begin using SIMR Admin.", Image = "intro4.png" }
        };

        public bool IsFirstPage => CurrentIndex == 0;
        public bool IsNotFirstPage => !IsFirstPage;
        public bool IsLastPage => CurrentIndex == Pages.Count - 1;
        public bool IsNotLastPage => !IsLastPage;

        public ICommand PreviousCommand { get; }
        public ICommand NextCommand { get; }
        public ICommand LoginCommand { get; }
        public ICommand SignUpCommand { get; }
        public INavigation Navigation { get; set; }

        public IntroViewModel(INavigation navigation)
        {
            Navigation = navigation;
            PreviousCommand = new Command(() =>
            {
                if (IsNotFirstPage)
                    CurrentIndex--;
            });

            NextCommand = new Command(() =>
            {
                if (IsNotLastPage)
                    CurrentIndex++;
            });

            LoginCommand = new Command(async () =>
                await this.Navigation.PushAsync(new LoginPage()));

            SignUpCommand = new Command(async () =>
                await this.Navigation.PushAsync(new RegisterPage()));
        }

        public event PropertyChangedEventHandler PropertyChanged;
        public void OnPropertyChanged([CallerMemberName] string name = "") =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }

    public class IntroPageModel
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Image { get; set; }
    }
}