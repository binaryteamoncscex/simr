using Android.App;
using Android.Runtime;
using Firebase;
using Microsoft.Maui;

namespace restaurant
{
    [Application]
    public class MainApplication : MauiApplication
    {
        public MainApplication(IntPtr handle, JniHandleOwnership ownerShip)
            : base(handle, ownerShip) { }

        public override void OnCreate()
        {
            base.OnCreate();
            FirebaseApp.InitializeApp(this);
        }

        protected override MauiApp CreateMauiApp() => MauiProgram.CreateMauiApp();
    }
}
