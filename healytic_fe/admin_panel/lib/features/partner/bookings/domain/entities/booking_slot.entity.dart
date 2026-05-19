import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_slot.entity.freezed.dart';
part 'booking_slot.entity.g.dart';

/// Domain entity describing the time window of a partner [Booking].
///
/// A [BookingSlot] is the pair of timestamps (`start`, `end`) at which
/// a booking is scheduled to occur. The wire schema emits both values
/// as ISO-8601 strings with offsets (for example
/// `"2025-03-14T09:00:00+07:00"`) and `json_serializable` decodes them
/// to `DateTime` automatically.
///
/// Domain invariants per requirement 2.4:
///
/// 1. `end` is strictly after `start`.
/// 2. `start` and `end` fall on the same calendar day in the partner's
///    local timezone.
///
/// These invariants are not enforced inside the constructor: malformed
/// records are dropped upstream by the bookings repository per
/// requirement 6.7. Keeping the entity unconstrained leaves it pure
/// data and trivially serialisable.
///
/// Pure Dart: no Flutter imports per Clean Architecture domain rules.
@freezed
abstract class BookingSlot with _$BookingSlot {
  /// Creates a new [BookingSlot] domain entity.
  ///
  /// Both [start] and [end] are required. Callers (the data layer)
  /// are responsible for validating that `end > start` and that both
  /// timestamps fall on the same calendar day before constructing
  /// the entity.
  const factory BookingSlot({required DateTime start, required DateTime end}) =
      _BookingSlot;

  /// Creates a [BookingSlot] from JSON.
  ///
  /// Both `start` and `end` are decoded from ISO-8601 strings to
  /// `DateTime` by the generated serializer.
  factory BookingSlot.fromJson(Map<String, dynamic> json) =>
      _$BookingSlotFromJson(json);
}
