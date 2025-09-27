import UIKit
import Flutter
import FirebaseCore
import UserNotifications
import GoogleMaps  // 👈 Required import

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Provide Google Maps API key
    GMSServices.provideAPIKey("AIzaSyD0-eauuJ1zBrknaL4uNexkR21cYVOkj7k")  // 🔁 Replace with your real API key

    // ✅ Firebase config
    FirebaseApp.configure()

    // ✅ Flutter plugin registration
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Request push notification permissions
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Universal Link handling for Flutter
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let incomingURL = userActivity.webpageURL {
        // You can add logic to inspect incomingURL if needed
    }

    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
