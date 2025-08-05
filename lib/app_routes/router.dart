import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/presentation/PostAdds/CommunityAdScreen.dart';
import 'package:indiclassifieds/presentation/PostAdds/EducationalAd.dart';
import 'package:indiclassifieds/presentation/PostAdds/EventsAdScreen.dart';
import 'package:indiclassifieds/presentation/PostAdds/FindInventoryAdScreen.dart';
import 'package:indiclassifieds/presentation/PostAdds/VechileAd.dart';
import 'package:indiclassifieds/presentation/views/SplashScreen.dart';
import 'package:indiclassifieds/presentation/views/SubCategoriesScreen.dart';
import '../model/CategoryModel.dart';
import '../presentation/PostAdds/AdElectronics.dart';
import '../presentation/PostAdds/AstrologyAd.dart';
import '../presentation/PostAdds/BikeAd.dart';
import '../presentation/PostAdds/CoWorkSpaceAd.dart';
import '../presentation/PostAdds/CommonAd.dart';
import '../presentation/PostAdds/FilmsAd.dart';
import '../presentation/PostAdds/JobAd.dart';
import '../presentation/PostAdds/LifeStyleAd.dart';
import '../presentation/PostAdds/MobileAd.dart';
import '../presentation/PostAdds/PropertiesAdScreen.dart';
import '../presentation/PostAdds/RealEstateAd.dart';
import '../presentation/PostAdds/ServiceAd.dart';
import 'package:indiclassifieds/presentation/views/ProductsListScreen.dart';
import '../presentation/authentication/LoginScreen.dart';
import '../presentation/authentication/OTPScreen.dart';
import '../presentation/views/DetailsScreen.dart';
import '../presentation/views/NotificationScreen.dart';
import '../presentation/views/CategoryScreen.dart';
import '../presentation/views/ProfileScreen.dart';
import '../presentation/views/SelectSubCategory.dart';
import '../presentation/views/SuccessScreen.dart';
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
      path: '/login',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Loginscreen(), state),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) {
        final mobile = state.uri.queryParameters['mobile'] ?? "";
        return buildSlideTransitionPage(Otpscreen(mobile: mobile), state);
      },
    ),
    GoRoute(
      path: '/sub_categories',
      pageBuilder: (context, state) {
        // Try to get CategoriesList from extra
        final categoriesList = state.extra is CategoriesList
            ? state.extra as CategoriesList
            : null;

        return buildSlideTransitionPage(
          SubCategoriesScreen(
            categoriesList: categoriesList,
          ),
          state,
        );
      },
    ),

    GoRoute(
      path: '/select_sub_categories',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'] ?? "";
        final categoryName = state.uri.queryParameters['categoryName'] ?? "";
        return buildSlideTransitionPage(
          SelectSubCategory(categoryId: categoryId, categoryName: categoryName),
          state,
        );
      },
    ),
    GoRoute(
      path: '/products_list',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(ProductsListScreen(), state),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Dashboard(), state),
    ),
    // GoRoute(
    //   path: '/sub_categories',
    //   pageBuilder: (context, state) =>
    //       buildSlideTransitionPage(AdElectronics(), state),
    // ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Dashboard(), state),
    ),
    GoRoute(
      path: '/ad_electronics',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";

        return buildSlideTransitionPage(
          AdElectronics(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/successfully',
      pageBuilder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? "";
        final subTitle = state.uri.queryParameters['subTitle'] ?? "";
        final nextRoute = state.uri.queryParameters['next'] ?? "";

        return buildSlideTransitionPage(
          SuccessScreen(title: title, subTitle: subTitle, nextRoute: nextRoute),
          state,
        );
      },
    ),
    GoRoute(
      path: '/common_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";

        return buildSlideTransitionPage(
          CommonAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/property_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";

        return buildSlideTransitionPage(
          PropertiesAdScreen(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/real_estate',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideTransitionPage(
          RealEstate(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/details_screen',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideTransitionPage(
          DetailsScreen(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/profile_screen',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(ProfileScreen(), state);
      },
    ),
    GoRoute(
      path: '/category',
      pageBuilder: (context, state) =>
          buildSlideFromBottomPage(CategoryScreen(), state),
    ),
    GoRoute(
      path: '/vechile_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          VechileAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/job_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          JobAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/bike_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          BikeAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/educational_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          EducationalAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/mobile_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          MobileAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/life_style_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          LifeStyleAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/astrology_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          AstrologyAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    // GoRoute(
    //   path: '/service_ad',
    //   pageBuilder: (context, state) =>
    //       buildSlideFromBottomPage(ServiceAd(), state),
    // ),
    GoRoute(
      path: '/co_work_space_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          CoWorkingSpaceAd(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    // GoRoute(
    //   path: '/film_ad',
    //   pageBuilder: (context, state) =>
    //       buildSlideFromBottomPage(FilmsAdScreen(), state),
    // ),
    // GoRoute(
    //   path: '/events_ad',
    //   pageBuilder: (context, state) =>
    //       buildSlideFromBottomPage(EventsAdScreen(), state),
    // ),
    GoRoute(
      path: '/community_ad',
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['catId'] ?? "";
        final categoryName = state.uri.queryParameters['CatName'] ?? "";
        final SubCategoryName = state.uri.queryParameters['SubCatName'] ?? "";
        final subCatId = state.uri.queryParameters['subCatId'] ?? "";
        return buildSlideFromBottomPage(
          CommunityAdScreen(
            catId: categoryId,
            CatName: categoryName,
            subCatId: subCatId,
            SubCatName: SubCategoryName,
          ),
          state,
        );
      },
    ),
    // GoRoute(
    //   path: '/find_inventory_ad',
    //   pageBuilder: (context, state) =>
    //       buildSlideFromBottomPage(FindInventoryAdScreen(), state),
    // ),
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
