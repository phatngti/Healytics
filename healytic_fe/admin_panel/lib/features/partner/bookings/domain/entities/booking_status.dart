import 'dart:developer' as developer;

/// Enum representing the lifecycle status of a partner [Booking].
///
/// The four members map one-to-one to the canonical wire values
/// `"Waiting"`, `"OnProcess"`, `"Canceled"`, and `"Finished"`
/// emitted by both the OpenAPI client and the local mock data
/// source.
///
/// Pure Dart — must not import Flutter. The presentation layer
/// resolves colours via the `BookingStatusColors` `ThemeExtension`
/// and never inspects this enum to pick a literal `Color`.
enum BookingStatus {
  /// Booking placed but not yet started.
  ///
  /// Also the safe fallback used by [statusFromWire] when an
  /// unknown, null, empty, or mixed-case wire value is received,
  /// per Requirement 3.5.
  waiting,

  /// Booking is currently being served by the specialist.
  onProcess,

  /// Booking was cancelled before completion.
  canceled,

  /// Booking completed normally.
  finished,
}

/// Canonical wire string for the [BookingStatus.waiting] member.
const String _wireWaiting = 'Waiting';

/// Canonical wire string for the [BookingStatus.onProcess] member.
const String _wireOnProcess = 'OnProcess';

/// Canonical wire string for the [BookingStatus.canceled] member.
const String _wireCanceled = 'Canceled';

/// Canonical wire string for the [BookingStatus.finished] member.
const String _wireFinished = 'Finished';

/// Logger tag used when [statusFromWire] coerces an unknown raw
/// value. Centralised so tests can match it deterministically.
const String _coercionLogName =
    'partner.bookings.booking_status.statusFromWire';

/// Coerces a raw wire status string into a [BookingStatus].
///
/// Maps the canonical strings `"Waiting"`, `"OnProcess"`,
/// `"Canceled"`, and `"Finished"` to the matching enum value.
/// Everything else — including `null`, the empty string, and
/// mixed-case noise such as `"waiting"` or `"ON_PROCESS"` —
/// coerces to [BookingStatus.waiting] and emits a
/// `dart:developer` `log` entry containing the offending raw
/// value.
///
/// This function is total: it always returns one of the four
/// enum members and never throws.
///
/// Validates Requirements 3.5 and is exercised by Property 7.
BookingStatus statusFromWire(String? raw) {
  switch (raw) {
    case _wireWaiting:
      return BookingStatus.waiting;
    case _wireOnProcess:
      return BookingStatus.onProcess;
    case _wireCanceled:
      return BookingStatus.canceled;
    case _wireFinished:
      return BookingStatus.finished;
  }
  developer.log(
    'Unknown BookingStatus wire value: ${raw ?? '<null>'}',
    name: _coercionLogName,
  );
  return BookingStatus.waiting;
}

/// Returns the human-readable label for [status].
///
/// Total mapping per Requirements 2.5 and 3.1:
///
/// - [BookingStatus.waiting]    → `"Waiting"`
/// - [BookingStatus.onProcess]  → `"On process"`
/// - [BookingStatus.canceled]   → `"Canceled"`
/// - [BookingStatus.finished]   → `"Finished"`
///
/// The result is always a non-empty string and the function
/// never throws. Exercised by Property 4.
String labelFor(BookingStatus status) => switch (status) {
  BookingStatus.waiting => 'Waiting',
  BookingStatus.onProcess => 'On process',
  BookingStatus.canceled => 'Canceled',
  BookingStatus.finished => 'Finished',
};
