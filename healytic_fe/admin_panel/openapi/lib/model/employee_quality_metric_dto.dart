//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeQualityMetricDto {
  /// Returns a new [EmployeeQualityMetricDto] instance.
  EmployeeQualityMetricDto({
    required this.label,
    required this.value,
    required this.detail,
    required this.tone,
  });


  /// Quality metric name
  String label;

  /// Display value (intentionally a string for flexible formatting)
  String value;

  /// Detailed context for the metric
  String detail;

  /// Severity tone for UI styling
  EmployeeQualityMetricDtoToneEnum tone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeQualityMetricDto &&
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
  String toString() => 'EmployeeQualityMetricDto[label=$label, value=$value, detail=$detail, tone=$tone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
      json[r'value'] = this.value;
      json[r'detail'] = this.detail;
      json[r'tone'] = this.tone;
    return json;
  }

  /// Returns a new [EmployeeQualityMetricDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeQualityMetricDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeQualityMetricDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeQualityMetricDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeQualityMetricDto(
        label: mapValueOfType<String>(json, r'label')!,
        value: mapValueOfType<String>(json, r'value')!,
        detail: mapValueOfType<String>(json, r'detail')!,
        tone: EmployeeQualityMetricDtoToneEnum.fromJson(json[r'tone'])!,
      );
    }
    return null;
  }

  static List<EmployeeQualityMetricDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeQualityMetricDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeQualityMetricDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeQualityMetricDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeQualityMetricDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeQualityMetricDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeQualityMetricDto-objects as value to a dart map
  static Map<String, List<EmployeeQualityMetricDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeQualityMetricDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeQualityMetricDto.listFromJson(entry.value, growable: growable,);
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
class EmployeeQualityMetricDtoToneEnum {
  /// Instantiate a new enum with the provided [value].
  const EmployeeQualityMetricDtoToneEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const neutral = EmployeeQualityMetricDtoToneEnum._(r'neutral');
  static const positive = EmployeeQualityMetricDtoToneEnum._(r'positive');
  static const warning = EmployeeQualityMetricDtoToneEnum._(r'warning');
  static const critical = EmployeeQualityMetricDtoToneEnum._(r'critical');

  /// List of all possible values in this [enum][EmployeeQualityMetricDtoToneEnum].
  static const values = <EmployeeQualityMetricDtoToneEnum>[
    neutral,
    positive,
    warning,
    critical,
  ];

  static EmployeeQualityMetricDtoToneEnum? fromJson(dynamic value) => EmployeeQualityMetricDtoToneEnumTypeTransformer().decode(value);

  static List<EmployeeQualityMetricDtoToneEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeQualityMetricDtoToneEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeQualityMetricDtoToneEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeQualityMetricDtoToneEnum] to String,
/// and [decode] dynamic data back to [EmployeeQualityMetricDtoToneEnum].
class EmployeeQualityMetricDtoToneEnumTypeTransformer {
  factory EmployeeQualityMetricDtoToneEnumTypeTransformer() => _instance ??= const EmployeeQualityMetricDtoToneEnumTypeTransformer._();

  const EmployeeQualityMetricDtoToneEnumTypeTransformer._();

  String encode(EmployeeQualityMetricDtoToneEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeQualityMetricDtoToneEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeQualityMetricDtoToneEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'neutral': return EmployeeQualityMetricDtoToneEnum.neutral;
        case r'positive': return EmployeeQualityMetricDtoToneEnum.positive;
        case r'warning': return EmployeeQualityMetricDtoToneEnum.warning;
        case r'critical': return EmployeeQualityMetricDtoToneEnum.critical;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeQualityMetricDtoToneEnumTypeTransformer] instance.
  static EmployeeQualityMetricDtoToneEnumTypeTransformer? _instance;
}


