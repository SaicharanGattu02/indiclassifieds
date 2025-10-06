import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _available = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  static const Set<String> _productIds = {
    'com.yourapp.sub.essential_30d_50ads',
    'com.yourapp.sub.power_60d_100ads',
    'com.yourapp.sub.pro_90d_500ads',
  };

  @override
  void initState() {
    super.initState();
    _initStore();
    _subscription = _iap.purchaseStream.listen(_listenToPurchaseUpdated);
  }

  Future<void> _initStore() async {
    _available = await _iap.isAvailable();
    if (!_available) {
      print('In-App Purchases not available');
      return;
    }

    final ProductDetailsResponse response =
    await _iap.queryProductDetails(_productIds);

    if (response.notFoundIDs.isNotEmpty) {
      print('Products not found: ${response.notFoundIDs}');
    }

    setState(() {
      _products = response.productDetails;
    });

    // Restore previous purchases (optional)
    await _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        // Show pending UI
        print('Purchase pending...');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Verify the purchase with Apple server / backend
        bool valid = await _verifyPurchase(purchase);
        if (valid) {
          print('Purchase successful: ${purchase.productID}');
          setState(() {
            _purchases.add(purchase);
          });
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
        } else {
          print('Purchase verification failed');
        }
      } else if (purchase.status == PurchaseStatus.error) {
        print('Purchase error: ${purchase.error}');
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // Ideally send receipt to your backend for verification with Apple
    // For testing, we assume sandbox purchases are valid
    return true;
  }

  void _buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam =
    PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
    // For subscriptions, buyNonConsumable works; in_app_purchase handles auto-renewable
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boost & Promotion Plans'),
      ),
      body: _available
          ? _products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          bool purchased = _purchases
              .any((p) => p.productID == product.id);
          return Card(
            margin:
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(product.title),
              subtitle: Text(product.description),
              trailing: purchased
                  ? Icon(Icons.check, color: Colors.green)
                  : TextButton(
                child: Text(product.price),
                onPressed: () => _buyProduct(product),
              ),
            ),
          );
        },
      )
          : Center(
        child: Text('In-App Purchases not available on this device'),
      ),
    );
  }
}
