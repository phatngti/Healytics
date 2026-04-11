//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerProfileCompletionCertificationDto {
  /// Returns a new [PartnerProfileCompletionCertificationDto] instance.
  PartnerProfileCompletionCertificationDto({
    required this.id,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.sortOrder,
  });

  String id;

  String title;

  Object? subtitle;

  String iconName;

  num sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerProfileCompletionCertificationDto &&
    other.id == id &&
    other.title == title &&
    other.subtitle == subtitle &&
    other.iconName == iconName &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (subtitle == null ? 0 : subtitle!.hashCode) +
    (iconName.hashCode) +
    (sortOrder.hashCode);

  @override
  String toString() => 'PartnerProfileCompletionCertificationDto[id=$id, title=$title, subtitle=$subtitle, iconName=$iconName, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
    if (this.subtitle != null) {
      json[r'subtitle'] = this.subtitle;
    } else {
      json[r'subtitle'] = null;
    }
      json[r'iconName'] = this.iconName;
      json[r'sortOrder'] = this.sortOrder;
    return json;
  }

  /// Returns a new [PartnerProfileCompletionCertificationDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerProfileCompletionCertificationDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerProfileCompletionCertificationDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerProfileCompletionCertificationDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerProfileCompletionCertificationDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        subtitle: mapValueOfType<Object>(json, r'subtitle'),
        iconName: mapValueOfType<String>(json, r'iconName')!,
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<PartnerProfileCompletionCertificationDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerProfileCompletionCertificationDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerProfileCompletionCertificationDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerProfileCompletionCertificationDto> mapFromJson(dynamic json) {
    final map = <String, PartnerProfileCompletionCertificationDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerProfileCompletionCertificationDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerProfileCompletionCertificationDto-objects as value to a dart map
  static Map<String, List<PartnerProfileCompletionCertificationDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerProfileCompletionCertificationDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerProfileCompletionCertificationDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'iconName',
    'sortOrder',
  };
}

