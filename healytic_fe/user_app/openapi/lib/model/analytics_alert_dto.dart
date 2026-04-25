//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnalyticsAlertDto {
  /// Returns a new [AnalyticsAlertDto] instance.
  AnalyticsAlertDto({
    required this.title,
    required this.detail,
    required this.tone,
  });


  /// Alert headline
  String title;

  /// Detailed explanation of the alert
  String detail;

  /// Severity tone for UI styling
  AnalyticsAlertDtoToneEnum tone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnalyticsAlertDto &&
    other.title == title &&
    other.detail == detail &&
    other.tone == tone;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (detail.hashCode) +
    (tone.hashCode);

  @override
  String toString() => 'AnalyticsAlertDto[title=$title, detail=$detail, tone=$tone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'detail'] = this.detail;
      json[r'tone'] = this.tone;
    return json;
  }

  /// Returns a new [AnalyticsAlertDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnalyticsAlertDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AnalyticsAlertDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AnalyticsAlertDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AnalyticsAlertDto(
        title: mapValueOfType<String>(json, r'title')!,
        detail: mapValueOfType<String>(json, r'detail')!,
        tone: AnalyticsAlertDtoToneEnum.fromJson(json[r'tone'])!,
      );
    }
    return null;
  }

  static List<AnalyticsAlertDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsAlertDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsAlertDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnalyticsAlertDto> mapFromJson(dynamic json) {
    final map = <String, AnalyticsAlertDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnalyticsAlertDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnalyticsAlertDto-objects as value to a dart map
  static Map<String, List<AnalyticsAlertDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnalyticsAlertDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnalyticsAlertDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'detail',
    'tone',
  };
}

/// Severity tone for UI styling
class AnalyticsAlertDtoToneEnum {
  /// Instantiate a new enum with the provided [value].
  const AnalyticsAlertDtoToneEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const critical = AnalyticsAlertDtoToneEnum._(r'critical');
  static const warning = AnalyticsAlertDtoToneEnum._(r'warning');
  static const positive = AnalyticsAlertDtoToneEnum._(r'positive');
  static const neutral = AnalyticsAlertDtoToneEnum._(r'neutral');

  /// List of all possible values in this [enum][AnalyticsAlertDtoToneEnum].
  static const values = <AnalyticsAlertDtoToneEnum>[
    critical,
    warning,
    positive,
    neutral,
  ];

  static AnalyticsAlertDtoToneEnum? fromJson(dynamic value) => AnalyticsAlertDtoToneEnumTypeTransformer().decode(value);

  static List<AnalyticsAlertDtoToneEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsAlertDtoToneEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsAlertDtoToneEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AnalyticsAlertDtoToneEnum] to String,
/// and [decode] dynamic data back to [AnalyticsAlertDtoToneEnum].
class AnalyticsAlertDtoToneEnumTypeTransformer {
  factory AnalyticsAlertDtoToneEnumTypeTransformer() => _instance ??= const AnalyticsAlertDtoToneEnumTypeTransformer._();

  const AnalyticsAlertDtoToneEnumTypeTransformer._();

  String encode(AnalyticsAlertDtoToneEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AnalyticsAlertDtoToneEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AnalyticsAlertDtoToneEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'critical': return AnalyticsAlertDtoToneEnum.critical;
        case r'warning': return AnalyticsAlertDtoToneEnum.warning;
        case r'positive': return AnalyticsAlertDtoToneEnum.positive;
        case r'neutral': return AnalyticsAlertDtoToneEnum.neutral;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AnalyticsAlertDtoToneEnumTypeTransformer] instance.
  static AnalyticsAlertDtoToneEnumTypeTransformer? _instance;
}


