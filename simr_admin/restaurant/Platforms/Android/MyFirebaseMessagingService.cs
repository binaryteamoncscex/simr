using Android.App;
using Android.Content;
using Android.OS;
using Android.Util;
using Firebase.Messaging;
using System.Diagnostics;

namespace restaurant
{
    [Service(Exported = false)]
    [IntentFilter(new[] { "com.google.firebase.MESSAGING_EVENT" })]
    public class MyFirebaseMessagingService : FirebaseMessagingService
    {
        const string TAG = "FCMService";

        public override void OnMessageReceived(RemoteMessage message)
        {
            try
            {
                string title = message.GetNotification()?.Title ?? "New ingredients order";
                string body = message.GetNotification()?.Body ?? "Verify the orders";
                System.Diagnostics.Debug.WriteLine($"[FCM] {title} - {body}");
                SendNotification(title, body);
            }
            catch (System.Exception ex)
            {
                Log.Error(TAG, $"Error in OnMessageReceived: {ex.Message}");
            }
        }

        public override void OnNewToken(string token)
        {
            System.Diagnostics.Debug.WriteLine($"[FCM] New token: {token}");
            Preferences.Set("FCMToken", token);
        }

        void SendNotification(string title, string body)
        {
            var channelId = $"{PackageName}.general";

            var intent = new Intent(this, typeof(MainActivity));
            intent.AddFlags(ActivityFlags.ClearTop);
            intent.PutExtra("openPage", "ApproveOrders");

            var pendingIntent = PendingIntent.GetActivity(this, 0, intent, PendingIntentFlags.OneShot | PendingIntentFlags.Immutable);

            var notificationBuilder = new Notification.Builder(this, channelId)
                .SetContentTitle(title)
                .SetContentText(body)
                .SetSmallIcon(global::restaurant.Resource.Mipmap.appicon)
                .SetAutoCancel(true)
                .SetContentIntent(pendingIntent)
                .SetPriority((int)NotificationPriority.High);

            var notificationManager = NotificationManager.FromContext(this);

            if (Build.VERSION.SdkInt >= BuildVersionCodes.O)
            {
                var channel = new NotificationChannel(channelId, "General Notifications", NotificationImportance.High);
                notificationManager.CreateNotificationChannel(channel);
            }

            notificationManager.Notify(0, notificationBuilder.Build());
        }
    }
}