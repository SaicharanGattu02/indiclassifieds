// lib/cubit/subscription_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../model/PlanModel.dart';
import 'SubscriptionRepository.dart';
import 'SubscriptionState.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository repository;
  final InAppPurchase _iap = InAppPurchase.instance;

  SubscriptionCubit(this.repository) : super(SubscriptionInitial());

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  List<PurchaseDetails> get purchases => _purchases; // ✅ added getter

  Future<void> loadPlans(List<PlanModel> plans) async {
    emit(SubscriptionLoading());
    try {
      final ids = plans.map((p) => p.productId).toSet();
      final response = await _iap.queryProductDetails(ids);
      _products = response.productDetails;
      emit(SubscriptionLoaded(plans, _products));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> buyPlan(PlanModel plan) async {
    final product = _products.firstWhere((p) => p.id == plan.productId);
    final purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void listenToPurchaseUpdates() {
    _iap.purchaseStream.listen((purchases) async {
      for (var purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchase);
          if (valid) {
            _purchases.add(purchase);
            await _sendPurchaseToServer(purchase);
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
            emit(SubscriptionSuccess());
          } else {
            emit(SubscriptionError('Purchase verification failed'));
          }
        } else if (purchase.status == PurchaseStatus.error) {
          emit(SubscriptionError(purchase.error?.message ?? 'Unknown error'));
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    return true; // For sandbox
  }

  Future<void> _sendPurchaseToServer(PurchaseDetails purchase) async {
    final plan = _products.firstWhere((p) => p.id == purchase.productID);
    final duration = 30;
    final adsCount = 50;

    await repository.sendPurchaseToServer({
      "product_id": purchase.productID,
      "receipt_data": purchase.verificationData.serverVerificationData,
      "duration_days": duration,
      "ads_count": adsCount,
    });
  }
}
