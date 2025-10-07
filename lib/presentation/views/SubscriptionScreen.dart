import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';

import '../../data/cubit/Subscription/SubscriptionCubit.dart';
import '../../data/cubit/Subscription/SubscriptionRepository.dart';
import '../../data/cubit/Subscription/SubscriptionState.dart';
import '../../model/PlanModel.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late SubscriptionCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = SubscriptionCubit(SubscriptionRepository());
    cubit.loadPlans([
      PlanModel(
          productId: 'com.ind.classifieds.essential_30d_50ads',
          title: '30 Days - 50 Ads',
          description: 'Boost your posts for 30 days',
          durationDays: 30,
          adsCount: 50),
    ]);
    cubit.listenToPurchaseUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is SubscriptionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SubscriptionLoaded) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              bool purchased = cubit.purchases.any((p) => p.productID == product.id);
              return Card(
                child: ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.description),
                  trailing: purchased
                      ? Icon(Icons.check, color: Colors.green)
                      : TextButton(
                    child: Text(product.price),
                    onPressed: () {
                      final plan = state.plans
                          .firstWhere((p) => p.productId == product.id);
                      cubit.buyPlan(plan);
                    },
                  ),
                ),
              );
            },
          );
        } else if (state is SubscriptionError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}


// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   final InAppPurchase _iap = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   bool _available = false;
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//
//   static const Set<String> _productIds = {
//     'com.ind.classifieds.essential_30d_50ads',
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _initStore();
//     _subscription = _iap.purchaseStream.listen(_listenToPurchaseUpdated);
//   }
//
//   Future<void> _initStore() async {
//     _available = await _iap.isAvailable();
//     if (!_available) {
//       print('In-App Purchases not available');
//       return;
//     }
//
//     final ProductDetailsResponse response =
//     await _iap.queryProductDetails(_productIds);
//
//     if (response.notFoundIDs.isNotEmpty) {
//       print('Products not found: ${response.notFoundIDs}');
//     }
//
//     setState(() {
//       _products = response.productDetails;
//     });
//
//     // Restore previous purchases (optional)
//     await _iap.restorePurchases();
//   }
//
//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
//     for (var purchase in purchases) {
//       if (purchase.status == PurchaseStatus.pending) {
//         // Show pending UI
//         print('Purchase pending...');
//       } else if (purchase.status == PurchaseStatus.purchased ||
//           purchase.status == PurchaseStatus.restored) {
//         // Verify the purchase with Apple server / backend
//         bool valid = await _verifyPurchase(purchase);
//         if (valid) {
//           print('Purchase successful: ${purchase.productID}');
//           setState(() {
//             _purchases.add(purchase);
//           });
//           if (purchase.pendingCompletePurchase) {
//             await _iap.completePurchase(purchase);
//           }
//         } else {
//           print('Purchase verification failed');
//         }
//       } else if (purchase.status == PurchaseStatus.error) {
//         print('Purchase error: ${purchase.error}');
//       }
//     }
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
//     // Ideally send receipt to your backend for verification with Apple
//     // For testing, we assume sandbox purchases are valid
//     return true;
//   }
//
//   void _buyProduct(ProductDetails product) {
//     final PurchaseParam purchaseParam =
//     PurchaseParam(productDetails: product);
//     _iap.buyNonConsumable(purchaseParam: purchaseParam);
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = ThemeHelper.isDarkMode(context);
//     final Color textColor = ThemeHelper.textColor(context);
//     final Color bgColor = ThemeHelper.backgroundColor(context);
//     final Color cardColor = ThemeHelper.cardColor(context);
//
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: CustomAppBar1(
//         title: "Boost & Promotion Plans",
//         actions: [],
//       ),
//       body: _available
//           ? _products.isEmpty
//           ? Center(
//         child: Text(
//           "No Products Found!",
//           style: AppTextStyles.titleMedium(textColor),
//         ),
//       )
//           : ListView.builder(
//         itemCount: _products.length,
//         itemBuilder: (context, index) {
//           final product = _products[index];
//           bool purchased = _purchases.any((p) => p.productID == product.id);
//           return Card(
//             color: cardColor,
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: ListTile(
//               title: Text(
//                 product.title,
//                 style: AppTextStyles.titleLarge(textColor),
//               ),
//               subtitle: Text(
//                 product.description,
//                 style: AppTextStyles.bodyMedium(textColor.withOpacity(0.8)),
//               ),
//               trailing: purchased
//                   ? Icon(Icons.check, color: Colors.green)
//                   : TextButton(
//                 child: Text(
//                   product.price,
//                   style: AppTextStyles.bodyMedium(textColor),
//                 ),
//                 onPressed: () => _buyProduct(product),
//               ),
//             ),
//           );
//         },
//       )
//           : Center(
//         child: Text(
//           'In-App Purchases not available on this device',
//           style: AppTextStyles.titleMedium(textColor),
//         ),
//       ),
//     );
//   }
//
// }
