import 'dart:async';
import 'dart:convert';
import 'dart:developer' as AppLogger;
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/services/ApiClient.dart';
import 'package:indiclassifieds/services/SecureStorageService.dart';
import 'package:indiclassifieds/state_injector.dart';
import 'package:indiclassifieds/theme/AppTheme.dart';
import 'package:indiclassifieds/utils/DeepLinkMapper.dart';
import 'package:indiclassifieds/utils/NotificationIntent.dart';
import 'package:indiclassifieds/utils/constants.dart';
import 'app_routes/router.dart';
import 'data/cubit/theme_cubit.dart';
import 'firebase_options.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';

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
  await themeCubit.hydrate();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized");
  } catch (e) {
    print("❌ Error initializing Firebase: $e");
  }

  await _requestPushPermissions();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (Platform.isIOS) {
    String? apnsToken = await messaging.getAPNSToken();
    AppLogger.log("📱 APNs Token: $apnsToken");
  }

  String? fcmToken = await messaging.getToken();
  AppLogger.log("🔥 FCM Token: $fcmToken");
  if (fcmToken != null) {
    SecureStorageService.instance.setString("fb_token", fcmToken);
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
    onDidReceiveNotificationResponse: (resp) async {
      final p = resp.payload;
      if (p?.isNotEmpty == true) {
        final data = jsonDecode(p!) as Map<String, dynamic>;
        _navigateFromPushData(data);
      }
    },
  );

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📥 Foreground message received:");
    print("  ▶ Title: ${message.notification?.title}");
    print("  ▶ Body: ${message.notification?.body}");
    print("  ▶ Data: ${message.data}");

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      showNotification(notification, android, message.data);
    }
  });

  // 1) Background → user tapped push and app was in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📲 Notification opened (background): ${message.data}");
    _navigateFromPushData(message.data);
  });

  // 2) Killed → user tapped push and app cold-started
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print(
      "🧊 App opened from terminated state via notif: ${initialMessage.data}",
    );
    // Schedule navigation after first frame so context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateFromPushData(initialMessage.data);
    });
  }

  // Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiBlocProvider(
        providers: StateInjector.blocProviders(themeCubit),
        child: MyApp(),
      ),
    ),
  );
}

// Extract and navigate
void _navigateFromPushData(Map<String, dynamic> data) {
  final receiverId =
      (data['receiverId'] ??
              data['receiver_id'] ??
              data['senderId'] ??
              data['rid'])
          ?.toString();
  if (receiverId == null || receiverId.isEmpty) {
    print("ℹ️ No receiverId/senderId in payload: $data");
    return;
  }

  final ctx = navigatorKey.currentContext;
  if (ctx != null && GoRouter.of(ctx).canPop()) {
    // App already has a stack → push directly
    GoRouter.of(ctx).push('/chat?receiverId=${data['senderId']}');
    return;
  }

  // Cold start / no stack → remember intent and land on Dashboard first
  NotificationIntent.setPendingChat(data['senderId']);
  // If you use splash, ensure splash does a `context.go('/dashboard')` (not push)
  final router = GoRouter.of(navigatorKey.currentContext!);
  router.go('/');
}

/// Background handler (must be a top-level function or static)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🌙 Background message received:");
  print("  ▶ Title: ${message.notification?.title}");
  print("  ▶ Body: ${message.notification?.body}");
  print("  ▶ Data: ${message.data}");
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
  // StreamSubscription<Uri>? _linkSubscription;
  // String? _queuedLocation;         // queue if router not ready yet
  // String? _lastHandled;            // de-dupe
  // bool _routerReady = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // Mark router ready after first frame (MaterialApp.router is built)
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _routerReady = true;
  //     if (_queuedLocation != null) {
  //       appRouter.go(_queuedLocation!);
  //       _lastHandled = _queuedLocation;
  //       _queuedLocation = null;
  //     }
  //   });
  //   _initDeepLinks();
  // }
  //
  //
  // void _navigateSafely(String location) {
  //   if (_lastHandled == location) return;
  //   if (_routerReady) {
  //     appRouter.go(location);
  //     _lastHandled = location;
  //   } else {
  //     _queuedLocation = location;
  //   }
  // }
  //
  //
  //
  // Future<void> _initDeepLinks() async {
  //   final appLinks = AppLinks();
  //   debugPrint('DeepLink: initDeepLinks started');
  //
  //   // Initial link (cold start)
  //   try {
  //     final initialUri = await appLinks.getInitialLink();
  //     debugPrint('DeepLink: getInitialLink -> $initialUri');
  //     final loc = DeepLinkMapper.toLocation(initialUri);
  //     if (loc != null) {
  //       debugPrint('DeepLink: (initial) navigating to $loc');
  //       _navigateSafely(loc);
  //     }
  //   } catch (e) {
  //     debugPrint('DeepLink: Initial app link error: $e');
  //   }
  //
  //   // Stream for runtime links
  //   _linkSubscription = appLinks.uriLinkStream.listen(
  //         (uri) {
  //       debugPrint('DeepLink: uriLinkStream -> $uri');
  //       final loc = DeepLinkMapper.toLocation(uri);
  //       if (loc != null) {
  //         debugPrint('DeepLink: navigating to $loc');
  //         _navigateSafely(loc);
  //       }
  //     },
  //     onError: (e) => debugPrint('DeepLink: Link stream error: $e'),
  //   );
  // }
  //
  // @override
  // void dispose() {
  //   debugPrint('DeepLink: dispose, cancelling subscription');
  //   _linkSubscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, appThemeMode) {
        final themeMode = switch (appThemeMode) {
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
          _ => ThemeMode.system,
        };
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
