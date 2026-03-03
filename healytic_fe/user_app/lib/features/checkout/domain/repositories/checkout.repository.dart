import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';

/// Abstract repository contract for the checkout feature.
abstract class CheckoutRepository {
  /// Fetches all data required to render the checkout screen.
  Future<CheckoutData> getCheckoutData();
}
