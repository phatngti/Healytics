//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerServiceRuleDto {
  /// Returns a new [PartnerServiceRuleDto] instance.
  PartnerServiceRuleDto({
    required this.iconSlug,
    required this.title,
    required this.description,
  });

  String iconSlug;

  String title;

  String description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerServiceRuleDto &&
    other.iconSlug == iconSlug &&
    other.title == title &&
    other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (iconSlug.hashCode) +
    (title.hashCode) +
    (description.hashCode);

  @override
  String toString() => 'PartnerServiceRuleDto[iconSlug=$iconSlug, title=$title, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'iconSlug'] = this.iconSlug;
      json[r'title'] = this.title;
      json[r'description'] = this.description;
    return json;
  }

  /// Returns a new [PartnerServiceRuleDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerServiceRuleDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerServiceRuleDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerServiceRuleDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerServiceRuleDto(
        iconSlug: mapValueOfType<String>(json, r'iconSlug')!,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description')!,
      );
    }
    return null;
  }

  static List<PartnerServiceRuleDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerServiceRuleDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerServiceRuleDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerServiceRuleDto> mapFromJson(dynamic json) {
    final map = <String, PartnerServiceRuleDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerServiceRuleDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerServiceRuleDto-objects as value to a dart map
  static Map<String, List<PartnerServiceRuleDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerServiceRuleDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerServiceRuleDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'iconSlug',
    'title',
    'description',
  };
}

