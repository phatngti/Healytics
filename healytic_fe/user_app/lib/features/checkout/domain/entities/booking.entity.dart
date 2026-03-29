/// Booking status as defined by the backend.
enum BookingStatus {
  pendingPayment,
  confirmed,
  cancelled,
  completed,
  noShow;

  /// Parses a raw API string into a [BookingStatus].
  static BookingStatus fromString(String raw) {
    return switch (raw) {
      'PENDING_PAYMENT' => pendingPayment,
      'CONFIRMED' => confirmed,
      'CANCELLED' => cancelled,
      'COMPLETED' => completed,
      'NO_SHOW' => noShow,
      _ => pendingPayment,
    };
  }
}

/// Checkout ticket processing status.
enum CheckoutTicketStatus {
  queued,
  processing,
  success,
  failed;

  /// Parses a raw API string into a
  /// [CheckoutTicketStatus].
  static CheckoutTicketStatus fromString(String raw) {
    return switch (raw) {
      'QUEUED' => queued,
      'PROCESSING' => processing,
      'SUCCESS' => success,
      'FAILED' => failed,
      _ => queued,
    };
  }
}

/// Domain entity representing a confirmed booking.
class BookingEntity {
  final String id;
  final String userId;
  final String staffId;
  final String? productId;
  final DateTime startTime;
  final DateTime? endTime;
  final BookingStatus status;
  final String? paymentUrl;
  final DateTime? paymentExpiresAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.staffId,
    this.productId,
    required this.startTime,
    this.endTime,
    required this.status,
    this.paymentUrl,
    this.paymentExpiresAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Domain entity for an async checkout ticket.
class CheckoutTicketEntity {
  final String id;
  final String userId;
  final String staffId;
  final DateTime startTime;
  final CheckoutTicketStatus status;
  final String idempotencyKey;
  final String? bookingId;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CheckoutTicketEntity({
    required this.id,
    required this.userId,
    required this.staffId,
    required this.startTime,
    required this.status,
    required this.idempotencyKey,
    this.bookingId,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Result of an async checkout initiation.
class AsyncCheckoutResult {
  final String ticketId;
  final String status;
  final String message;

  const AsyncCheckoutResult({
    required this.ticketId,
    required this.status,
    required this.message,
  });
}

/// Result of a micro-lock acquisition attempt.
class MicroLockResult {
  final bool locked;
  final int expiresIn;

  const MicroLockResult({
    required this.locked,
    required this.expiresIn,
  });
}
