import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_slot.entity.dart';
import 'booking_status.dart';
import 'customer.entity.dart';
import 'service.entity.dart';
import 'specialist.entity.dart';

part 'booking.entity.freezed.dart';
part 'booking.entity.g.dart';

/// Aggregate domain entity representing a single partner booking.
///
/// A [Booking] groups the four user-facing aggregates rendered by the
/// booking card — [customer], [specialist], [service], and [slot] —
/// alongside an `id` and the lifecycle [status]. Each nested aggregate
/// is itself a Freezed entity, so [Booking.fromJson] delegates to the
/// nested `fromJson` factories transparently via the generated
/// serializer (see Requirements 2.1–2.5).
///
/// The `status` field is decoded with [statusFromWire] so unknown,
/// null, empty, or mixed-case wire values coerce to
/// [BookingStatus.waiting] and emit a `dart:developer` `log` entry,
/// per Requirement 3.5. The reverse `toJson` mapping uses
/// [_statusToWire] to emit the canonical wire strings.
///
/// Pure Dart: no Flutter imports per Clean Architecture domain rules.
@freezed
abstract class Booking with _$Booking {
  /// Creates a new [Booking] aggregate.
  ///
  /// Records missing any required nested field are dropped upstream
  /// by the bookings repository per Requirement 6.7; the entity
  /// itself imposes no additional invariants beyond the field types.
  const factory Booking({
    required String id,
    required Customer customer,
    required Specialist specialist,
    required Service service,
    required BookingSlot slot,
    @JsonKey(fromJson: statusFromWire, toJson: _statusToWire)
    required BookingStatus status,
  }) = _Booking;

  /// Creates a [Booking] from JSON.
  ///
  /// Snake-case wire keys (`full_name`, `avatar_url`,
  /// `currency_code`, etc.) are mapped via `FieldRename.snake`. The
  /// nested `customer`, `specialist`, `service`, and `slot` objects
  /// are decoded by their respective generated `fromJson` factories.
  /// The `status` field is coerced through [statusFromWire].
  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

/// Encodes a [BookingStatus] back to its canonical wire string.
///
/// The mapping is the inverse of [statusFromWire] for the four
/// canonical values:
///
/// - [BookingStatus.waiting]    → `"Waiting"`
/// - [BookingStatus.onProcess]  → `"OnProcess"`
/// - [BookingStatus.canceled]   → `"Canceled"`
/// - [BookingStatus.finished]   → `"Finished"`
String _statusToWire(BookingStatus status) => switch (status) {
  BookingStatus.waiting => 'Waiting',
  BookingStatus.onProcess => 'OnProcess',
  BookingStatus.canceled => 'Canceled',
  BookingStatus.finished => 'Finished',
};
