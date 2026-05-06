//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class BookingStatus {
  /// Instantiate a new enum with the provided [value].
  const BookingStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING_PAYMENT = BookingStatus._(r'PENDING_PAYMENT');
  static const CONFIRMED = BookingStatus._(r'CONFIRMED');
  static const IN_PROGRESS = BookingStatus._(r'IN_PROGRESS');
  static const CANCELLED = BookingStatus._(r'CANCELLED');
  static const COMPLETED = BookingStatus._(r'COMPLETED');
  static const NO_SHOW = BookingStatus._(r'NO_SHOW');

  /// List of all possible values in this [enum][BookingStatus].
  static const values = <BookingStatus>[
    PENDING_PAYMENT,
    CONFIRMED,
    IN_PROGRESS,
    CANCELLED,
    COMPLETED,
    NO_SHOW,
  ];

  static BookingStatus? fromJson(dynamic value) => BookingStatusTypeTransformer().decode(value);

  static List<BookingStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BookingStatus] to String,
/// and [decode] dynamic data back to [BookingStatus].
class BookingStatusTypeTransformer {
  factory BookingStatusTypeTransformer() => _instance ??= const BookingStatusTypeTransformer._();

  const BookingStatusTypeTransformer._();

  String encode(BookingStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a BookingStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BookingStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING_PAYMENT': return BookingStatus.PENDING_PAYMENT;
        case r'CONFIRMED': return BookingStatus.CONFIRMED;
        case r'IN_PROGRESS': return BookingStatus.IN_PROGRESS;
        case r'CANCELLED': return BookingStatus.CANCELLED;
        case r'COMPLETED': return BookingStatus.COMPLETED;
        case r'NO_SHOW': return BookingStatus.NO_SHOW;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [BookingStatusTypeTransformer] instance.
  static BookingStatusTypeTransformer? _instance;
}

