import 'dart:convert';
import 'dart:developer' as AppLogger;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:indiclassifieds/services/ApiClient.dart';
import 'package:indiclassifieds/services/SecureStorageService.dart';
import 'package:indiclassifieds/state_injector.dart';
import 'package:indiclassifieds/theme/AppTheme.dart';
import 'app_routes/router.dart';
import 'data/cubit/theme_cubit.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

Future<void> main() async {
  ApiClient.setupInterceptors();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final storage = SecureStorageService.instance;
  final themeCubit = ThemeCubit(storage);
  // Hydrate from secure storage before the UI builds
  await themeCubit.hydrate();


  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  await _requestPushPermissions();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  //
  // Get the APNs token (iOS)
  if (Platform.isIOS) {
    String? apnsToken = await messaging.getAPNSToken();
    AppLogger.log("APNs Token: $apnsToken");
  }

  // Get the FCM token
  String? fcmToken = await messaging.getToken();
  AppLogger.log("FCM Token: $fcmToken");
  if (fcmToken != null) {
    SecureStorageService.instance.setString("fb_token", fcmToken);
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Create notification channel (Android)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  const DarwinInitializationSettings iosInitSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: iosInitSettings,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      // Handle notification tapped logic
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      showNotification(notification, android, message.data);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle notification opened when app was in background
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiBlocProvider(
        providers: StateInjector.blocProviders(themeCubit), // 👈 pass it in
        child: MyApp(),
      ),
    ),
  );
}

Future<void> _requestPushPermissions() async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  } else if (Platform.isAndroid) {
    // Android 13+ runtime permission
    final plugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await plugin?.requestNotificationsPermission();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //  AppLogger.log('A Background message just showed up :  ${message.data}');
}

// Function to display local notifications
void showNotification(
  RemoteNotification notification,
  AndroidNotification android,
  Map<String, dynamic> data,
) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: jsonEncode(data),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, appThemeMode) {
        ThemeMode themeMode;
        switch (appThemeMode) {
          case AppThemeMode.light:
            themeMode = ThemeMode.light;
            break;
          case AppThemeMode.dark:
            themeMode = ThemeMode.dark;
            break;
          case AppThemeMode.system:
          default:
            themeMode = ThemeMode.system;
        }
        return MaterialApp.router(
          title: 'IND Classifieds',
          theme: AppTheme.getLightTheme(),
          darkTheme: AppTheme.getDarkTheme(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        );
      },
    );
  }
}
