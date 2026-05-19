//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PublicBookingStatus {
  /// Instantiate a new enum with the provided [value].
  const PublicBookingStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PROCESSING = PublicBookingStatus._(r'PROCESSING');
  static const COMPLETED = PublicBookingStatus._(r'COMPLETED');

  /// List of all possible values in this [enum][PublicBookingStatus].
  static const values = <PublicBookingStatus>[
    PROCESSING,
    COMPLETED,
  ];

  static PublicBookingStatus? fromJson(dynamic value) => PublicBookingStatusTypeTransformer().decode(value);

  static List<PublicBookingStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicBookingStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicBookingStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PublicBookingStatus] to String,
/// and [decode] dynamic data back to [PublicBookingStatus].
class PublicBookingStatusTypeTransformer {
  factory PublicBookingStatusTypeTransformer() => _instance ??= const PublicBookingStatusTypeTransformer._();

  const PublicBookingStatusTypeTransformer._();

  String encode(PublicBookingStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a PublicBookingStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PublicBookingStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PROCESSING': return PublicBookingStatus.PROCESSING;
        case r'COMPLETED': return PublicBookingStatus.COMPLETED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PublicBookingStatusTypeTransformer] instance.
  static PublicBookingStatusTypeTransformer? _instance;
}

