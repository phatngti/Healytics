/// Enum representing the available orderings for the partner
/// bookings dashboard `Sort_Selector`.
///
/// Three orderings cover the requirements:
///
/// - [startAsc] — order by `BookingSlot.start` ascending. This is
///   the default ordering used when no sort is explicitly chosen
///   (Requirement 5.9).
/// - [startDesc] — order by `BookingSlot.start` descending.
/// - [statusGrouping] — group bookings by `BookingStatus` in the
///   order Waiting → OnProcess → Finished → Canceled, with
///   `BookingSlot.start` ascending as the secondary tiebreaker
///   within each group (Requirements 5.6 and 5.7).
///
/// Pure Dart — must not import Flutter. The actual ordering logic
/// lives in `booking_filter_predicates.dart` (`applySort`); this
/// enum only enumerates the available choices so the controller
/// and the `SortSelector` widget can speak a shared vocabulary.
enum BookingSort {
  /// Order by `BookingSlot.start` ascending.
  ///
  /// This is the default ordering used by the bookings controller
  /// when the user has not explicitly chosen a sort, per
  /// Requirement 5.9.
  startAsc,

  /// Order by `BookingSlot.start` descending.
  startDesc,

  /// Group bookings by `BookingStatus` in the canonical order
  /// `waiting → onProcess → finished → canceled` and order
  /// bookings within each group by `BookingSlot.start` ascending
  /// as the secondary tiebreaker, per Requirements 5.6 and 5.7.
  statusGrouping;

  /// Human-readable label for display in the `SortSelector`.
  String get label => switch (this) {
    BookingSort.startAsc => 'Earliest first',
    BookingSort.startDesc => 'Latest first',
    BookingSort.statusGrouping => 'By status',
  };
}

/// The default [BookingSort] applied when no sort is explicitly
/// chosen, per Requirement 5.9.
const BookingSort defaultBookingSort = BookingSort.startAsc;
