using CommunityToolkit.Maui;
using Microcharts.Maui;
using Microsoft.Extensions.Logging;
using Microsoft.Maui.LifecycleEvents;
using SkiaSharp.Views.Maui.Controls.Hosting;

#if WINDOWS
using Microsoft.UI;
using Microsoft.UI.Windowing;
using Windows.Graphics;
using WinRT.Interop;
#endif

#if MACCATALYST
using UIKit;
using CoreGraphics;
#endif

namespace restaurant;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();

        builder
            .UseMauiApp<App>()
            .UseMauiCommunityToolkit()
            .UseSkiaSharp()
            .UseMicrocharts()
            .ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
            });

#if DEBUG
        builder.Logging.AddDebug();
#endif

        builder.ConfigureLifecycleEvents(events =>
        {
#if WINDOWS
            events.AddWindows(windows =>
            {
                windows.OnWindowCreated(window =>
                {
                    var hwnd = WindowNative.GetWindowHandle(window);
                    var windowId = Win32Interop.GetWindowIdFromWindow(hwnd);
                    var appWindow = AppWindow.GetFromWindowId(windowId);
                    appWindow.Title = "SIMR Admin";
                    if (appWindow.Presenter is OverlappedPresenter presenter)
                    {
                        presenter.Maximize();
                    }
                });
            });
#endif

#if MACCATALYST
            events.AddiOS(maccatalyst =>
            {
                maccatalyst.SceneWillConnect((scene, session, options) =>
                {
                    if (scene is UIWindowScene windowScene)
                    {
                        var window = new UIWindow(windowScene)
                        {
                            Frame = UIScreen.MainScreen.Bounds
                        };

                        window.MakeKeyAndVisible();
                        window.RootViewController = new UIViewController();
                        window.RootViewController.View!.BackgroundColor = UIColor.White;
                    }
                });
            });
#endif
        });

#if WINDOWS
        Microsoft.Maui.Handlers.WindowHandler.Mapper.AppendToMapping("MyCustomTitle", (handler, view) =>
        {
            var nativeWindow = handler.PlatformView;
            var hwnd = WinRT.Interop.WindowNative.GetWindowHandle(nativeWindow);
            var windowId = Microsoft.UI.Win32Interop.GetWindowIdFromWindow(hwnd);
            var appWindow = Microsoft.UI.Windowing.AppWindow.GetFromWindowId(windowId);

            appWindow.Title = "SIMR Admin";
            System.Diagnostics.Debug.WriteLine("Setat titlul la SIMR Admin din WindowHandler.Mapper");
        });
#endif

        return builder.Build();
    }
}
