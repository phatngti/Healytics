//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerBookingStatus {
  /// Instantiate a new enum with the provided [value].
  const PartnerBookingStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const waiting = PartnerBookingStatus._(r'Waiting');
  static const onProcess = PartnerBookingStatus._(r'OnProcess');
  static const canceled = PartnerBookingStatus._(r'Canceled');
  static const finished = PartnerBookingStatus._(r'Finished');

  /// List of all possible values in this [enum][PartnerBookingStatus].
  static const values = <PartnerBookingStatus>[
    waiting,
    onProcess,
    canceled,
    finished,
  ];

  static PartnerBookingStatus? fromJson(dynamic value) => PartnerBookingStatusTypeTransformer().decode(value);

  static List<PartnerBookingStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerBookingStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerBookingStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerBookingStatus] to String,
/// and [decode] dynamic data back to [PartnerBookingStatus].
class PartnerBookingStatusTypeTransformer {
  factory PartnerBookingStatusTypeTransformer() => _instance ??= const PartnerBookingStatusTypeTransformer._();

  const PartnerBookingStatusTypeTransformer._();

  String encode(PartnerBookingStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerBookingStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerBookingStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Waiting': return PartnerBookingStatus.waiting;
        case r'OnProcess': return PartnerBookingStatus.onProcess;
        case r'Canceled': return PartnerBookingStatus.canceled;
        case r'Finished': return PartnerBookingStatus.finished;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerBookingStatusTypeTransformer] instance.
  static PartnerBookingStatusTypeTransformer? _instance;
}

