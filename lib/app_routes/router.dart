import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/presentation/PostAdds/EducationalAd.dart';
import 'package:indiclassifieds/presentation/PostAdds/VechileAd.dart';
import 'package:indiclassifieds/presentation/views/SplashScreen.dart';
import '../presentation/PostAdds/AdElectronics.dart';
import '../presentation/PostAdds/AstrologyAd.dart';
import '../presentation/PostAdds/BikeAd.dart';
import '../presentation/PostAdds/CoWorkSpaceAd.dart';
import '../presentation/PostAdds/JobAd.dart';
import '../presentation/PostAdds/LifeStyleAd.dart';
import '../presentation/PostAdds/MobileAd.dart';
import '../presentation/PostAdds/RealEstateAd.dart';
import '../presentation/PostAdds/ServiceAd.dart';
import '../presentation/views/DetailsScreen.dart';
import '../presentation/views/NotificationScreen.dart';
import '../presentation/views/PostCategoryScreen.dart';
import '../presentation/views/ProfileScreen.dart';
import '../presentation/views/dashboard.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Splashscreen(), state),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(NotificationScreen(), state),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Dashboard(), state),
    ),
    GoRoute(
      path: '/sub_categories',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AdElectronics(), state),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Dashboard(), state),
    ),
    GoRoute(
      path: '/ad_electronics',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(AdElectronics(), state),
    ),
    GoRoute(
      path: '/real_estate',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(RealEstate(), state),
    ),
    GoRoute(
      path: '/details_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(DetailsScreen(), state),
    ),
    GoRoute(
      path: '/profile_screen',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProfileScreen(), state),
    ),
    GoRoute(
      path: '/post_category',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(PostCategoryScreen(), state),
    ),
    GoRoute(
      path: '/vechile_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(VechileAd(), state),
    ),
    GoRoute(
      path: '/job_ad',
      pageBuilder: (context, state) => buildSlideFromBottomPage(JobAd(), state),
    ),
    GoRoute(
      path: '/bike_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(BikeAd(), state),
    ),
    GoRoute(
      path: '/educational_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(EducationalAd(), state),
    ),
    GoRoute(
      path: '/mobile_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(MobileAd(), state),
    ),
    GoRoute(
      path: '/life_style_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(LifeStyleAd(), state),
    ),
    GoRoute(
      path: '/astrology_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(AstrologyAd(), state),
    ),
    GoRoute(
      path: '/service_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(ServiceAd(), state),
    ),
    GoRoute(
      path: '/co_work_space_ad',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(CoWorkingSpaceAd(), state),
    ),
  ],
);

Page<dynamic> buildSlideTransitionPage(Widget child, GoRouterState state) {
  // if (Platform.isIOS) {
  //   // Use default Cupertino transition on iOS
  //   return CupertinoPage(key: state.pageKey, child: child);
  // }

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Page<dynamic> buildSlideFromBottomPage(Widget child, GoRouterState state) {
  // if (Platform.isIOS) {
  //   // Use default Cupertino transition on iOS
  //   return CupertinoPage(key: state.pageKey, child: child);
  // }
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // bottom to top
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
