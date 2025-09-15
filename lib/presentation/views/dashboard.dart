import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/presentation/views/Home.dart';
import 'package:indiclassifieds/presentation/views/ProfileScreen.dart';
import 'package:indiclassifieds/services/AuthService.dart';
import 'package:indiclassifieds/theme/AppTextStyles.dart';
import 'package:indiclassifieds/theme/app_colors.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';
import 'package:indiclassifieds/utils/color_constants.dart';
import 'package:permission_handler/permission_handler.dart' as OpenAppSettings;

import '../../data/bloc/internet_status/internet_status_bloc.dart';
import '../../data/cubit/Location/location_cubit.dart';
import '../../data/cubit/Location/location_state.dart';
import '../../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../../data/cubit/theme_cubit.dart';
import '../../main.dart';
import '../../services/SocketService.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/DeepLinkMapper.dart';
import '../../utils/NotificationIntent.dart';
import 'AddsScreen.dart';
import 'UserListScreen.dart';

class Dashboard extends StatefulWidget {
  final int initialTab;
  const Dashboard({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController pageController;
  int _selectedIndex = 0;
  bool isLocationSheetShown = false;

  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    pageController = PageController(initialPage: _selectedIndex);
    getData();
    _requestPushPermissions();
    context.read<LocationCubit>().checkLocationPermission();
    initDeepLinks(); // start deep link handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final toChat = NotificationIntent.consumePendingChat();
      if (toChat != null && toChat.isNotEmpty && mounted) {
        context.push('/chat?receiverId=$toChat');
      }
    });
  }

  Future<void> initDeepLinks() async {
    final appLinks = AppLinks();
    debugPrint('DeepLink: initDeepLinks started');
    try {
      final initialUri = await appLinks.getInitialLink();
      debugPrint('DeepLink: getInitialLink -> $initialUri');
      final loc = DeepLinkMapper.toLocation(initialUri);
      if (loc != null) {
        debugPrint('DeepLink: navigating to $loc');
        context.push(loc);
      } else {
        debugPrint('DeepLink: no mapped location for $initialUri');
      }
    } catch (e) {
      debugPrint('DeepLink: Initial app link error: $e');
    }

    // 2) Handle links while the app is running
    // _linkSubscription = appLinks.uriLinkStream.listen((uri) {
    //   debugPrint('DeepLink: uriLinkStream -> $uri');
    //   final loc = DeepLinkMapper.toLocation(uri);
    //   if (loc != null) {
    //     debugPrint('DeepLink: navigating to $loc');
    //     context.push(loc);
    //   } else {
    //     debugPrint('DeepLink: no mapped location for $uri');
    //   }
    // }, onError: (e) => debugPrint('DeepLink: Link stream error: $e'));
  }

  @override
  void dispose() {
    debugPrint('DeepLink: dispose, cancelling subscription');
    _linkSubscription?.cancel();
    super.dispose();
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

  Future<void> getData() async {
    final isGuest = await AuthService.isGuest;
    if (!isGuest) {
      final plan = await context
          .read<UserActivePlanCubit>()
          .getUserActivePlansData();
      if (plan != null) {
        AuthService.setPlanStatus(plan.goToPlansPage.toString() ?? "");
        AuthService.setFreePlanStatus(plan.isFree.toString() ?? "");
        AuthService.setSubscribeStatus(plan.plans?.length != 0 ? "true" : "false" ?? "");
      }
      final userId = await AuthService.getId();
      SocketService.connect(userId ?? "");
    }
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, mode) {
        final cardColor = ThemeHelper.cardColor(context);
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocListener<InternetStatusBloc, InternetStatusState>(
              listener: (context, state) {
                if (state is InternetStatusLostState) {
                  context.push('/no_internet');
                } else if (state is InternetStatusBackState) {
                  // context.pop();
                  // AppLogger.info("called this");
                }
              },
              child: BlocListener<LocationCubit, LocationState>(
                listener: (context, state) {
                  if (state is LocationPermissionDenied ||
                      state is LocationServiceDisabled) {
                    showLocationBottomSheet(context);
                  }
                },
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _selectedIndex = value);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HomeScreen(),
                    AdsScreen(),
                    UserListScreen(),
                    ProfileScreen(),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: MediaQuery.removeViewInsets(
              context: context,
              removeBottom: true,
              child: Container(
                width: 50,
                height: 65,
                margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 6,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          context.push("/category");
                          // context.read<LocationCubit>().checkLocationPermission();
                        },
                        child: const Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "Sell",
                      style: AppTextStyles.titleSmall(AppColors.unselect),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 65,
                decoration: BoxDecoration(
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      // subtle top shadow
                      color: Colors.black.withOpacity(
                        Theme.of(context).brightness == Brightness.dark
                            ? 0.35
                            : 0.08,
                      ),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, -4), // cast UPWARDS
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home, "Home", 0),
                    _buildNavItem(Icons.archive, "My Ads", 1),
                    const SizedBox(width: 40), // space for FAB
                    _buildNavItem(Icons.chat, "Chat", 2),
                    _buildNavItem(Icons.person, "Profile", 3),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? AppColors.primary : AppColors.unselect,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.unselect,
            ),
          ),
        ],
      ),
    );
  }

  void showLocationBottomSheet(BuildContext context) {
    if (isLocationSheetShown) return; // Avoid opening another sheet

    isLocationSheetShown = true;
    bool hasRequestedPermission = false; // Prevent multiple requests

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext bottomSheetContext) {
        return BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(bottomSheetContext).pop();
              });
            } else if (state is LocationPermissionDenied ||
                state is LocationError ||
                state is LocationServiceDisabled) {
              // Reset hasRequestedPermission when permission request fails
              hasRequestedPermission = false;
            }
          },
          builder: (context, state) {
            bool isLoading = state is LocationLoading;
            bool isServiceDisabled = state is LocationServiceDisabled;
            bool isPermanentlyDenied =
                state is LocationError &&
                state.message.contains("permanently denied");
            bool isDenied = state is LocationPermissionDenied;

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.grey[50]!],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primarycolor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: primarycolor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isServiceDisabled
                              ? 'Location Services Disabled'
                              : isPermanentlyDenied
                              ? 'Location Permissions Denied'
                              : isDenied
                              ? 'Location Access Needed'
                              : 'Allow Location Access',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isServiceDisabled
                        ? 'Please enable location services to show your current location on the dashboard.'
                        : isPermanentlyDenied
                        ? 'Location permissions are permanently denied. To show your location on the dashboard, please enable them in Settings.'
                        : isDenied
                        ? 'We need your location to display your current position on the dashboard.'
                        : 'Allow access to your location to display your current position on the dashboard for a personalized experience.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 48,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  hasRequestedPermission = true;
                                  if (isPermanentlyDenied) {
                                    context.pop();
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        titlePadding: const EdgeInsets.fromLTRB(
                                          24,
                                          24,
                                          24,
                                          8,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                              24,
                                              8,
                                              24,
                                              0,
                                            ),
                                        actionsPadding:
                                            const EdgeInsets.fromLTRB(
                                              16,
                                              0,
                                              16,
                                              16,
                                            ),
                                        title: Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                'Permission Required',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          'Location access has been permanently denied. To use this feature, please enable location permissions in the device settings.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primarycolor,
                                              foregroundColor: primarycolor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              OpenAppSettings.openAppSettings();
                                            },
                                            child: const Text(
                                              'Open Settings',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    context
                                        .read<LocationCubit>()
                                        .requestLocationPermission();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarycolor,
                            foregroundColor: primarycolor,
                            disabledForegroundColor: primarycolor,
                            disabledBackgroundColor: primarycolor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Continue',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Reset flag when the bottom sheet is dismissed
      isLocationSheetShown = false;
    });
  }
}
