//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnalyticsOperationalMetricDto {
  /// Returns a new [AnalyticsOperationalMetricDto] instance.
  AnalyticsOperationalMetricDto({
    required this.label,
    required this.value,
    required this.detail,
    required this.tone,
  });


  /// Metric label
  String label;

  /// Current metric value
  String value;

  /// Contextual explanation
  String detail;

  /// Severity tone for UI styling
  AnalyticsOperationalMetricDtoToneEnum tone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnalyticsOperationalMetricDto &&
    other.label == label &&
    other.value == value &&
    other.detail == detail &&
    other.tone == tone;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (label.hashCode) +
    (value.hashCode) +
    (detail.hashCode) +
    (tone.hashCode);

  @override
  String toString() => 'AnalyticsOperationalMetricDto[label=$label, value=$value, detail=$detail, tone=$tone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
      json[r'value'] = this.value;
      json[r'detail'] = this.detail;
      json[r'tone'] = this.tone;
    return json;
  }

  /// Returns a new [AnalyticsOperationalMetricDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnalyticsOperationalMetricDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AnalyticsOperationalMetricDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AnalyticsOperationalMetricDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AnalyticsOperationalMetricDto(
        label: mapValueOfType<String>(json, r'label')!,
        value: mapValueOfType<String>(json, r'value')!,
        detail: mapValueOfType<String>(json, r'detail')!,
        tone: AnalyticsOperationalMetricDtoToneEnum.fromJson(json[r'tone'])!,
      );
    }
    return null;
  }

  static List<AnalyticsOperationalMetricDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsOperationalMetricDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsOperationalMetricDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnalyticsOperationalMetricDto> mapFromJson(dynamic json) {
    final map = <String, AnalyticsOperationalMetricDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnalyticsOperationalMetricDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnalyticsOperationalMetricDto-objects as value to a dart map
  static Map<String, List<AnalyticsOperationalMetricDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnalyticsOperationalMetricDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnalyticsOperationalMetricDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
    'value',
    'detail',
    'tone',
  };
}

/// Severity tone for UI styling
class AnalyticsOperationalMetricDtoToneEnum {
  /// Instantiate a new enum with the provided [value].
  const AnalyticsOperationalMetricDtoToneEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const critical = AnalyticsOperationalMetricDtoToneEnum._(r'critical');
  static const warning = AnalyticsOperationalMetricDtoToneEnum._(r'warning');
  static const positive = AnalyticsOperationalMetricDtoToneEnum._(r'positive');
  static const neutral = AnalyticsOperationalMetricDtoToneEnum._(r'neutral');

  /// List of all possible values in this [enum][AnalyticsOperationalMetricDtoToneEnum].
  static const values = <AnalyticsOperationalMetricDtoToneEnum>[
    critical,
    warning,
    positive,
    neutral,
  ];

  static AnalyticsOperationalMetricDtoToneEnum? fromJson(dynamic value) => AnalyticsOperationalMetricDtoToneEnumTypeTransformer().decode(value);

  static List<AnalyticsOperationalMetricDtoToneEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsOperationalMetricDtoToneEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsOperationalMetricDtoToneEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AnalyticsOperationalMetricDtoToneEnum] to String,
/// and [decode] dynamic data back to [AnalyticsOperationalMetricDtoToneEnum].
class AnalyticsOperationalMetricDtoToneEnumTypeTransformer {
  factory AnalyticsOperationalMetricDtoToneEnumTypeTransformer() => _instance ??= const AnalyticsOperationalMetricDtoToneEnumTypeTransformer._();

  const AnalyticsOperationalMetricDtoToneEnumTypeTransformer._();

  String encode(AnalyticsOperationalMetricDtoToneEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AnalyticsOperationalMetricDtoToneEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AnalyticsOperationalMetricDtoToneEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'critical': return AnalyticsOperationalMetricDtoToneEnum.critical;
        case r'warning': return AnalyticsOperationalMetricDtoToneEnum.warning;
        case r'positive': return AnalyticsOperationalMetricDtoToneEnum.positive;
        case r'neutral': return AnalyticsOperationalMetricDtoToneEnum.neutral;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AnalyticsOperationalMetricDtoToneEnumTypeTransformer] instance.
  static AnalyticsOperationalMetricDtoToneEnumTypeTransformer? _instance;
}


