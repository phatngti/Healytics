//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class BusinessType {
  /// Instantiate a new enum with the provided [value].
  const BusinessType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MASSAGE_THERAPY = BusinessType._(r'MASSAGE_THERAPY');
  static const MASSAGE_REHABILITATION = BusinessType._(r'MASSAGE_REHABILITATION');
  static const SPA_BEAUTY = BusinessType._(r'SPA_BEAUTY');
  static const FITNESS = BusinessType._(r'FITNESS');
  static const PHARMACY = BusinessType._(r'PHARMACY');
  static const DENTAL = BusinessType._(r'DENTAL');
  static const TRADITIONAL_MEDICINE = BusinessType._(r'TRADITIONAL_MEDICINE');
  static const PSYCHOLOGY = BusinessType._(r'PSYCHOLOGY');
  static const DERMATOLOGY = BusinessType._(r'DERMATOLOGY');
  static const NUTRITION = BusinessType._(r'NUTRITION');
  static const PSYCHIATRY = BusinessType._(r'PSYCHIATRY');

  /// List of all possible values in this [enum][BusinessType].
  static const values = <BusinessType>[
    MASSAGE_THERAPY,
    MASSAGE_REHABILITATION,
    SPA_BEAUTY,
    FITNESS,
    PHARMACY,
    DENTAL,
    TRADITIONAL_MEDICINE,
    PSYCHOLOGY,
    DERMATOLOGY,
    NUTRITION,
    PSYCHIATRY,
  ];

  static BusinessType? fromJson(dynamic value) => BusinessTypeTypeTransformer().decode(value);

  static List<BusinessType> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BusinessType>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BusinessType.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BusinessType] to String,
/// and [decode] dynamic data back to [BusinessType].
class BusinessTypeTypeTransformer {
  factory BusinessTypeTypeTransformer() => _instance ??= const BusinessTypeTypeTransformer._();

  const BusinessTypeTypeTransformer._();

  String encode(BusinessType data) => data.value;

  /// Decodes a [dynamic value][data] to a BusinessType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BusinessType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MASSAGE_THERAPY': return BusinessType.MASSAGE_THERAPY;
        case r'MASSAGE_REHABILITATION': return BusinessType.MASSAGE_REHABILITATION;
        case r'SPA_BEAUTY': return BusinessType.SPA_BEAUTY;
        case r'FITNESS': return BusinessType.FITNESS;
        case r'PHARMACY': return BusinessType.PHARMACY;
        case r'DENTAL': return BusinessType.DENTAL;
        case r'TRADITIONAL_MEDICINE': return BusinessType.TRADITIONAL_MEDICINE;
        case r'PSYCHOLOGY': return BusinessType.PSYCHOLOGY;
        case r'DERMATOLOGY': return BusinessType.DERMATOLOGY;
        case r'NUTRITION': return BusinessType.NUTRITION;
        case r'PSYCHIATRY': return BusinessType.PSYCHIATRY;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [BusinessTypeTypeTransformer] instance.
  static BusinessTypeTypeTransformer? _instance;
}

