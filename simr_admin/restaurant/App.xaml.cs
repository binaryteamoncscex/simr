using Microsoft.Maui.Controls.PlatformConfiguration;
using System.Globalization;

namespace restaurant
{
    public partial class App : Application
    {
        private static bool _initialized = false;
        public App()
        {
            if (_initialized) return;
            InitializeComponent();
            _initialized = true;
            this.UserAppTheme = AppTheme.Light;
        }

        protected override Window CreateWindow(IActivationState? activationState)
        {
            return new Window(new AppShell());
        }
    }
}