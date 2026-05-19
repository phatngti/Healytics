//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class BookingStatusUpdate {
  /// Instantiate a new enum with the provided [value].
  const BookingStatusUpdate._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PROCESSING = BookingStatusUpdate._(r'PROCESSING');
  static const COMPLETED = BookingStatusUpdate._(r'COMPLETED');

  /// List of all possible values in this [enum][BookingStatusUpdate].
  static const values = <BookingStatusUpdate>[
    PROCESSING,
    COMPLETED,
  ];

  static BookingStatusUpdate? fromJson(dynamic value) => BookingStatusUpdateTypeTransformer().decode(value);

  static List<BookingStatusUpdate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingStatusUpdate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingStatusUpdate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BookingStatusUpdate] to String,
/// and [decode] dynamic data back to [BookingStatusUpdate].
class BookingStatusUpdateTypeTransformer {
  factory BookingStatusUpdateTypeTransformer() => _instance ??= const BookingStatusUpdateTypeTransformer._();

  const BookingStatusUpdateTypeTransformer._();

  String encode(BookingStatusUpdate data) => data.value;

  /// Decodes a [dynamic value][data] to a BookingStatusUpdate.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BookingStatusUpdate? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PROCESSING': return BookingStatusUpdate.PROCESSING;
        case r'COMPLETED': return BookingStatusUpdate.COMPLETED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [BookingStatusUpdateTypeTransformer] instance.
  static BookingStatusUpdateTypeTransformer? _instance;
}

