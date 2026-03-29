import 'package:user_app/features/checkout/domain/entities/booking.entity.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';
import 'package:user_app/features/checkout/domain/entities/momo_payment.entity.dart';

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
  });

  /// Polls the status of a checkout ticket.
  Future<CheckoutTicketEntity> getTicketStatus(
    String ticketId,
  );

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
  Future<MoMoPaymentResult> createMoMoPayment(
    String bookingId,
  );

  /// Requests a MoMo refund for a completed payment.
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  });
}
