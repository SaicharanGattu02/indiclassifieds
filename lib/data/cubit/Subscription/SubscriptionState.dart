
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../model/PlanModel.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<PlanModel> plans;
  final List<ProductDetails> products;
  SubscriptionLoaded(this.plans, this.products);
}

class SubscriptionVerifying extends SubscriptionState {}

class SubscriptionSuccess extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}
