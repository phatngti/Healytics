import 'package:flutter/material.dart' show DateTimeRange;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_status.dart';

part 'booking_filters.entity.freezed.dart';

/// Immutable value object describing the active filter selections for
/// the partner bookings dashboard.
///
/// Carries the three independent filter axes exposed by the
/// `FilterBar`:
///
/// - [statuses] — the multi-select [BookingStatus] set. An empty set is
///   the canonical encoding of the `All` option per requirement 5.1, so
///   no status predicate is applied when the set is empty.
/// - [dateRange] — an inclusive day window evaluated against
///   `Booking.slot.start` in the partner's local timezone per
///   requirement 5.2. `null` means no date filter is active.
/// - [searchQuery] — the free-text search string per requirement 5.4.
///   Already trimmed and lowercased upstream by the controller before
///   being stored here, so the empty string canonically encodes
///   "no search filter".
///
/// Used by the `BookingsController` and consumed by the pure
/// `applyFilters` helper. Equality is structural (Freezed-generated)
/// so Property 10 — "sort change preserves the filter struct" — can
/// be asserted with a single `==` comparison.
@freezed
abstract class BookingFilters with _$BookingFilters {
  /// Creates a new [BookingFilters] value.
  ///
  /// Defaults represent the "no filters active" state used both as
  /// the controller's initial value and as the target of
  /// `clearFilters()`.
  const factory BookingFilters({
    @Default(<BookingStatus>{}) Set<BookingStatus> statuses,
    DateTimeRange? dateRange,
    @Default('') String searchQuery,
  }) = _BookingFilters;
}
