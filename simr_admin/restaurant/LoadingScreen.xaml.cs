using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using System;
using System.Threading.Tasks;

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
            string uid = Preferences.Get("uid", null);

            if (!string.IsNullOrEmpty(uid))
            {
                var firebase = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");
                var userType = await firebase
                    .Child("users")
                    .Child(uid)
                    .Child("Type")
                    .OnceSingleAsync<string>();

                Page nextPage = userType switch
                {
                    "cook" => new Cook(),
                    "waiter" => new Waiter(),
                    _ => new ApproveOrders()
                };

                Application.Current.MainPage = new NavigationPage(nextPage);
                return;
            }
        }
        var introPage = new IntroPage(isFirstLaunch, rememberMe);
        Application.Current.MainPage = new NavigationPage(introPage);
    }
}
