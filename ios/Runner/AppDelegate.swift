import UIKit
import Flutter
import FirebaseCore
import UserNotifications
import GoogleMaps
import FBSDKCoreKit  // ✅ Import Facebook SDK

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Initialize Meta SDK
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )

    // ✅ Enable App Event tracking
    Settings.shared.isAdvertiserTrackingEnabled = true
    Settings.shared.isAutoLogAppEventsEnabled = true
    Settings.shared.isCodelessDebugLogEnabled = true

    // ✅ Activate app events (app_activate)
    AppEvents.shared.activateApp()

    // ✅ Provide Google Maps API key
    GMSServices.provideAPIKey("AIzaSyD0-eauuJ1zBrknaL4uNexkR21cYVOkj7k")

    // ✅ Firebase config
    FirebaseApp.configure()

    // ✅ Register Flutter plugins
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

  // ✅ Handle Facebook event routing if needed
  override func application(_ app: UIApplication, open url: URL,
                            options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ApplicationDelegate.shared.application(app, open: url, options: options)
    return true
  }

  // ✅ Keep your universal link handler
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let incomingURL = userActivity.webpageURL {
      // Handle deep links if necessary
    }

    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
