import 'package:user_app/features/checkout/domain/entities/booking.entity.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';
import 'package:user_app/features/checkout/domain/entities/momo_payment.entity.dart';
import 'package:user_app/features/checkout/domain/entities/payment_card.entity.dart';
import 'package:user_app/features/checkout/domain/entities/stripe_payment.entity.dart';

/// Abstract repository contract for the checkout feature.
abstract class CheckoutRepository {
  /// Fetches all data required to render the checkout
  /// screen.
  Future<CheckoutData> getCheckoutData();

  /// Initiates an async checkout and returns a ticket.
  Future<AsyncCheckoutResult> asyncCheckout({
    required String userId,
    required String staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
    bool payLater = false,
  });

  /// Polls the status of a checkout ticket.
  Future<CheckoutTicketEntity> getTicketStatus(String ticketId);

  /// Fetches a booking by its ID.
  Future<BookingEntity> getBookingById(String bookingId);

  /// Acquires a micro-lock on a time slot (120s TTL).
  Future<MicroLockResult> acquireMicroLock({
    required String staffId,
    required String startTime,
    String? productId,
  });

  /// Creates a MoMo one-time payment for an existing
  /// booking and returns the payment URL / deeplink.
  Future<MoMoPaymentResult> createMoMoPayment(String bookingId);

  /// Confirms a signed MoMo return payload received
  /// from the app deeplink.
  Future<void> confirmMoMoReturn({
    required String bookingId,
    required Map<String, String> returnParams,
  });

  /// Requests a MoMo refund for a completed payment.
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  });

  /// Creates a Stripe PaymentIntent for the booking
  /// and returns the client secret for on-device
  /// confirmation.
  Future<StripePaymentResult> createStripePayment(
    String bookingId, {
    String? cardId,
  });

  /// Returns the user's saved Stripe cards.
  Future<List<SavedPaymentCard>> listSavedPaymentCards();

  /// Creates a Stripe SetupIntent used by PaymentSheet
  /// to collect and attach a new card.
  Future<StripeSetupIntentResult> createStripeSetupIntent();

  /// Confirms a completed SetupIntent with the backend
  /// so display metadata can be persisted locally.
  Future<SavedPaymentCard> confirmStripeSetupIntent({
    required String setupIntentId,
    bool setDefault = false,
  });

  /// Makes one saved card the default card.
  Future<SavedPaymentCard> setDefaultPaymentCard(String cardId);

  /// Deletes a saved card and returns the refreshed list.
  Future<List<SavedPaymentCard>> deletePaymentCard(String cardId);

  /// Requests a full Stripe refund for a paid
  /// booking.
  Future<StripeRefundResult> refundStripePayment(String bookingId);
}
