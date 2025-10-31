using CommunityToolkit.Maui;
using Microcharts.Maui;
using Microsoft.Extensions.Logging;
using Microsoft.Maui.LifecycleEvents;
using SkiaSharp.Views.Maui.Controls.Hosting;
using Microsoft.Maui.Storage;
using System.Diagnostics;
using System.Threading.Tasks;

#if ANDROID
using Firebase.Messaging;
using Android.Gms.Tasks;
#endif

#if WINDOWS
using Microsoft.UI;
using Microsoft.UI.Windowing;
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
                        presenter.Maximize();
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
        });
#endif

#if ANDROID
        System.Threading.Tasks.Task.Run(async () =>
        {
            try
            {
                await System.Threading.Tasks.Task.Delay(3000);
                var token = await GetFcmTokenAsync();
                if (!string.IsNullOrEmpty(token))
                    Debug.WriteLine($"FCM_TOKEN: {token}");
                else
                    Debug.WriteLine("FCM_TOKEN: Token null sau gol.");
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Eroare FCM: {ex.Message}");
            }
        });
#endif

        return builder.Build();
    }

#if ANDROID
    static System.Threading.Tasks.Task<string> GetFcmTokenAsync()
    {
        var tcs = new System.Threading.Tasks.TaskCompletionSource<string>();
        FirebaseMessaging.Instance.GetToken()
            .AddOnSuccessListener(new OnSuccessListener<string>(token => tcs.TrySetResult(token)))
            .AddOnFailureListener(new OnFailureListener(e => tcs.TrySetException(e)))
            .AddOnCanceledListener(new OnCanceledListener(() => tcs.TrySetCanceled()));
        return tcs.Task;
    }

    class OnSuccessListener<T> : Java.Lang.Object, IOnSuccessListener
    {
        readonly Action<T> _onSuccess;
        public OnSuccessListener(Action<T> onSuccess) => _onSuccess = onSuccess;
        public void OnSuccess(Java.Lang.Object result) => _onSuccess((T)(object)result.ToString());
    }

    class OnFailureListener : Java.Lang.Object, IOnFailureListener
    {
        readonly Action<Exception> _onFailure;
        public OnFailureListener(Action<Exception> onFailure) => _onFailure = onFailure;
        public void OnFailure(Java.Lang.Exception e) => _onFailure(new Exception(e.Message));
    }

    class OnCanceledListener : Java.Lang.Object, IOnCanceledListener
    {
        readonly Action _onCanceled;
        public OnCanceledListener(Action onCanceled) => _onCanceled = onCanceled;
        public void OnCanceled() => _onCanceled();
    }
#endif
}
