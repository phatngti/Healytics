//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerPriority {
  /// Instantiate a new enum with the provided [value].
  const PartnerPriority._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const low = PartnerPriority._(r'low');
  static const normal = PartnerPriority._(r'normal');
  static const high = PartnerPriority._(r'high');
  static const urgent = PartnerPriority._(r'urgent');

  /// List of all possible values in this [enum][PartnerPriority].
  static const values = <PartnerPriority>[
    low,
    normal,
    high,
    urgent,
  ];

  static PartnerPriority? fromJson(dynamic value) => PartnerPriorityTypeTransformer().decode(value);

  static List<PartnerPriority> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerPriority>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerPriority.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerPriority] to String,
/// and [decode] dynamic data back to [PartnerPriority].
class PartnerPriorityTypeTransformer {
  factory PartnerPriorityTypeTransformer() => _instance ??= const PartnerPriorityTypeTransformer._();

  const PartnerPriorityTypeTransformer._();

  String encode(PartnerPriority data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerPriority.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerPriority? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'low': return PartnerPriority.low;
        case r'normal': return PartnerPriority.normal;
        case r'high': return PartnerPriority.high;
        case r'urgent': return PartnerPriority.urgent;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerPriorityTypeTransformer] instance.
  static PartnerPriorityTypeTransformer? _instance;
}

