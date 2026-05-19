import 'package:user_app/features/checkout/data/datasources/remote/checkout_remote_datasource.dart';
import 'package:user_app/features/checkout/domain/entities/booking.entity.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';
import 'package:user_app/features/checkout/domain/entities/momo_payment.entity.dart';
import 'package:user_app/features/checkout/domain/entities/payment_card.entity.dart';
import 'package:user_app/features/checkout/domain/entities/stripe_payment.entity.dart';
import 'package:user_app/features/checkout/domain/repositories/checkout.repository.dart';

/// Concrete [CheckoutRepository] backed by a remote
/// datasource.
class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDatasource remoteDatasource;

  CheckoutRepositoryImpl({required this.remoteDatasource});

  @override
  Future<CheckoutData> getCheckoutData() async {
    return remoteDatasource.getCheckoutData();
  }

  @override
  Future<AsyncCheckoutResult> asyncCheckout({
    required String userId,
    required String staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
    bool payLater = false,
  }) {
    return remoteDatasource.asyncCheckout(
      userId: userId,
      staffId: staffId,
      startTime: startTime,
      productId: productId,
      idempotencyKey: idempotencyKey,
      payLater: payLater,
    );
  }

  @override
  Future<CheckoutTicketEntity> getTicketStatus(String ticketId) {
    return remoteDatasource.getTicketStatus(ticketId);
  }

  @override
  Future<BookingEntity> getBookingById(String bookingId) {
    return remoteDatasource.getBookingById(bookingId);
  }

  @override
  Future<MicroLockResult> acquireMicroLock({
    required String staffId,
    required String startTime,
    String? productId,
  }) {
    return remoteDatasource.acquireMicroLock(
      staffId: staffId,
      startTime: startTime,
      productId: productId,
    );
  }

  @override
  Future<MoMoPaymentResult> createMoMoPayment(String bookingId) {
    return remoteDatasource.createMoMoPayment(bookingId);
  }

  @override
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  }) {
    return remoteDatasource.refundMoMoPayment(
      bookingId: bookingId,
      transId: transId,
    );
  }

  @override
  Future<StripePaymentResult> createStripePayment(
    String bookingId, {
    String? cardId,
  }) {
    return remoteDatasource.createStripePayment(bookingId, cardId: cardId);
  }

  @override
  Future<StripeRefundResult> refundStripePayment(String bookingId) {
    return remoteDatasource.refundStripePayment(bookingId);
  }

  @override
  Future<List<SavedPaymentCard>> listSavedPaymentCards() {
    return remoteDatasource.listSavedPaymentCards();
  }

  @override
  Future<StripeSetupIntentResult> createStripeSetupIntent() {
    return remoteDatasource.createStripeSetupIntent();
  }

  @override
  Future<SavedPaymentCard> confirmStripeSetupIntent({
    required String setupIntentId,
    bool setDefault = false,
  }) {
    return remoteDatasource.confirmStripeSetupIntent(
      setupIntentId: setupIntentId,
      setDefault: setDefault,
    );
  }

  @override
  Future<SavedPaymentCard> setDefaultPaymentCard(String cardId) {
    return remoteDatasource.setDefaultPaymentCard(cardId);
  }

  @override
  Future<List<SavedPaymentCard>> deletePaymentCard(String cardId) {
    return remoteDatasource.deletePaymentCard(cardId);
  }
}
