import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/booking.entity.dart';
import '../../domain/entities/booking_filters.entity.dart';
import '../../domain/entities/booking_sort.dart';

part 'bookings_state.freezed.dart';

/// Immutable state held by the `BookingsController` notifier.
///
/// Separates the raw post-coercion list ([all]) from the
/// user-visible subset ([visible]) so the controller can
/// recompute the visible list on filter or sort changes
/// without re-fetching from the repository.
///
/// [refresh] is modelled independently from the outer
/// `AsyncValue` wrapper so the UI can overlay a linear
/// progress indicator while keeping the previous list
/// visible and interactive (Requirement 6.6).
@freezed
abstract class BookingsState with _$BookingsState {
  /// Creates a new [BookingsState].
  const factory BookingsState({
    /// All bookings returned by the repository after
    /// malformed-record dropping and status coercion.
    required List<Booking> all,

    /// The subset of [all] that satisfies the active
    /// [filters], ordered by [sort].
    required List<Booking> visible,

    /// The currently active filter selections.
    required BookingFilters filters,

    /// The currently active sort ordering.
    required BookingSort sort,

    /// The refresh lifecycle status, independent of the
    /// outer `AsyncValue` load status.
    required RefreshStatus refresh,
  }) = _BookingsState;
}

/// Sealed union representing the refresh lifecycle.
///
/// - [idle] — no refresh in progress.
/// - [refreshing] — a refresh request is in flight; the UI
///   renders a non-blocking linear indicator above the grid.
/// - [failed] — the most recent refresh failed; carries a
///   human-readable [message] for the error state.
@freezed
sealed class RefreshStatus with _$RefreshStatus {
  /// No refresh in progress.
  const factory RefreshStatus.idle() = RefreshIdle;

  /// A refresh request is currently in flight.
  const factory RefreshStatus.refreshing() = RefreshRefreshing;

  /// The most recent refresh failed with [message].
  const factory RefreshStatus.failed(String message) = RefreshFailed;
}
