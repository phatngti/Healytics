//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeComplianceItemDto {
  /// Returns a new [EmployeeComplianceItemDto] instance.
  EmployeeComplianceItemDto({
    required this.title,
    required this.detail,
    required this.tone,
  });


  /// Compliance check headline
  String title;

  /// Detailed explanation of the compliance status
  String detail;

  /// Severity tone for UI styling
  EmployeeComplianceItemDtoToneEnum tone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeComplianceItemDto &&
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
  String toString() => 'EmployeeComplianceItemDto[title=$title, detail=$detail, tone=$tone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'detail'] = this.detail;
      json[r'tone'] = this.tone;
    return json;
  }

  /// Returns a new [EmployeeComplianceItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeComplianceItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeComplianceItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeComplianceItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeComplianceItemDto(
        title: mapValueOfType<String>(json, r'title')!,
        detail: mapValueOfType<String>(json, r'detail')!,
        tone: EmployeeComplianceItemDtoToneEnum.fromJson(json[r'tone'])!,
      );
    }
    return null;
  }

  static List<EmployeeComplianceItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeComplianceItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeComplianceItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeComplianceItemDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeComplianceItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeComplianceItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeComplianceItemDto-objects as value to a dart map
  static Map<String, List<EmployeeComplianceItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeComplianceItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeComplianceItemDto.listFromJson(entry.value, growable: growable,);
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
class EmployeeComplianceItemDtoToneEnum {
  /// Instantiate a new enum with the provided [value].
  const EmployeeComplianceItemDtoToneEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const neutral = EmployeeComplianceItemDtoToneEnum._(r'neutral');
  static const positive = EmployeeComplianceItemDtoToneEnum._(r'positive');
  static const warning = EmployeeComplianceItemDtoToneEnum._(r'warning');
  static const critical = EmployeeComplianceItemDtoToneEnum._(r'critical');

  /// List of all possible values in this [enum][EmployeeComplianceItemDtoToneEnum].
  static const values = <EmployeeComplianceItemDtoToneEnum>[
    neutral,
    positive,
    warning,
    critical,
  ];

  static EmployeeComplianceItemDtoToneEnum? fromJson(dynamic value) => EmployeeComplianceItemDtoToneEnumTypeTransformer().decode(value);

  static List<EmployeeComplianceItemDtoToneEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeComplianceItemDtoToneEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeComplianceItemDtoToneEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeComplianceItemDtoToneEnum] to String,
/// and [decode] dynamic data back to [EmployeeComplianceItemDtoToneEnum].
class EmployeeComplianceItemDtoToneEnumTypeTransformer {
  factory EmployeeComplianceItemDtoToneEnumTypeTransformer() => _instance ??= const EmployeeComplianceItemDtoToneEnumTypeTransformer._();

  const EmployeeComplianceItemDtoToneEnumTypeTransformer._();

  String encode(EmployeeComplianceItemDtoToneEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeComplianceItemDtoToneEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeComplianceItemDtoToneEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'neutral': return EmployeeComplianceItemDtoToneEnum.neutral;
        case r'positive': return EmployeeComplianceItemDtoToneEnum.positive;
        case r'warning': return EmployeeComplianceItemDtoToneEnum.warning;
        case r'critical': return EmployeeComplianceItemDtoToneEnum.critical;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeComplianceItemDtoToneEnumTypeTransformer] instance.
  static EmployeeComplianceItemDtoToneEnumTypeTransformer? _instance;
}


