using Microsoft.Maui.Controls;
using Microsoft.Maui.Devices;
using Microsoft.Maui.Storage;
using System;

namespace restaurant;

public partial class LoadingScreen : ContentPage
{
    public LoadingScreen()
    {
        InitializeComponent();
        Loaded += OnPageLoaded;
    }

    private async void OnPageLoaded(object sender, EventArgs e)
    {
        await Task.Delay(100);     

        bool isFirstLaunch = !Preferences.ContainsKey("HasLaunched");
        bool rememberMe = Preferences.Get("RememberMe", false);

        Preferences.Set("HasLaunched", true);

        if (!isFirstLaunch && rememberMe)
        {
            Application.Current.MainPage = new NavigationPage(new ApproveOrders());
            Navigation.RemovePage(this);    
            return;
        }

        var introPage = new IntroPage(isFirstLaunch, rememberMe);
        Application.Current.MainPage = new NavigationPage(introPage);
        Navigation.RemovePage(this);
    }
}