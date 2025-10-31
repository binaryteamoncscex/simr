using Microsoft.Maui.Controls;
using Microsoft.Maui.Devices;
using Microsoft.Maui.Storage;
using restaurant.ViewModels;
using System;

namespace restaurant;

public partial class IntroPage : ContentPage
{
    private readonly bool _isFirstLaunch;
    private readonly bool _rememberMe;
    private readonly IntroViewModel viewModel;
    private static INavigation navigation;
    public IntroPage(bool isFirstLaunch, bool rememberMe)
    {
        InitializeComponent();
        _isFirstLaunch = isFirstLaunch;
        _rememberMe = rememberMe;
        navigation = Navigation;
        viewModel = new IntroViewModel(navigation);
        BindingContext = viewModel;
        Loaded += OnPageLoaded;
    }

    private void OnPageLoaded(object sender, EventArgs e)
    {
        if (!_isFirstLaunch && !_rememberMe)
        {
            if (DeviceInfo.Platform == DevicePlatform.WinUI || DeviceInfo.Platform == DevicePlatform.MacCatalyst)
            {
                FirstPagesContainer.IsVisible = false;
                NextButton.IsVisible = false;
                LastPage.IsVisible = true;
            }
            else if (DeviceInfo.Platform == DevicePlatform.Android || DeviceInfo.Platform == DevicePlatform.iOS)
            {
                Device.BeginInvokeOnMainThread(() =>
                {
                    viewModel.CurrentIndex = viewModel.Pages.Count - 1;
                });
            }
        }

        if (DeviceInfo.Platform == DevicePlatform.WinUI || DeviceInfo.Platform == DevicePlatform.MacCatalyst)
        {
            NextButton.Clicked += OnNextButtonClicked;
        }
    }

    private void OnNextButtonClicked(object sender, EventArgs e)
    {
        FirstPagesContainer.IsVisible = false;
        NextButton.IsVisible = false;
        LastPage.IsVisible = true;
    }
}

