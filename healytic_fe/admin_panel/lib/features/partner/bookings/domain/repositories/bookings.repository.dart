import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';

/// Abstract repository interface for partner bookings.
///
/// Defines the contract consumed by the presentation layer
/// (via Riverpod providers) to retrieve the partner's booking
/// list. The domain layer owns this interface; the data layer
/// provides the concrete implementation.
///
/// ## Drop-malformed contract
///
/// Implementations MUST drop any booking record that is missing
/// a required field (`customer.fullName`, `specialist.fullName`,
/// `service.name`, `slot`, or `status`) and log the booking id
/// plus the name of the missing field via `dart:developer`
/// `log()`. The returned list contains only fully-valid
/// [Booking] instances (Requirement 6.7).
///
/// ## Coerce-unknown contract
///
/// Implementations MUST coerce any unknown, null, or empty
/// `status` wire value to [BookingStatus.waiting] and log the
/// offending value via `dart:developer` `log()`. This ensures
/// the returned list never contains a status outside the four
/// canonical enum members (Requirement 3.5).
///
/// ## Error behaviour
///
/// When at least one valid booking remains after dropping
/// malformed records, the method MUST NOT throw. The caller
/// receives a non-empty list and the dashboard renders normally
/// (Requirement 6.8).
///
/// Pure Dart — no Flutter imports per Clean Architecture domain
/// rules.
abstract class BookingsRepository {
  /// Fetches the partner's bookings.
  ///
  /// Returns a list of valid [Booking] entities after applying
  /// the drop-malformed and coerce-unknown contracts described
  /// in the class documentation.
  ///
  /// Validates: Req 1.2, 3.5, 6.7, 6.8, Property 7,
  /// Property 11.
  Future<List<Booking>> listBookings();
}
