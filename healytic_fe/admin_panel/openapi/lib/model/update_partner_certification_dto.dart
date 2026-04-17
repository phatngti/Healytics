//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdatePartnerCertificationDto {
  /// Returns a new [UpdatePartnerCertificationDto] instance.
  UpdatePartnerCertificationDto({
    this.id,
    this.title,
    this.subtitle,
    this.iconName,
    this.sortOrder,
  });


  /// Existing certification id. Omit to create a new one.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  /// Certification title displayed on the public clinic profile
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  /// Optional certification subtitle
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? subtitle;

  /// Material icon slug used by the public clinic UI
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? iconName;

  /// Sort order for certifications on the clinic profile
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdatePartnerCertificationDto &&
    other.id == id &&
    other.title == title &&
    other.subtitle == subtitle &&
    other.iconName == iconName &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (subtitle == null ? 0 : subtitle!.hashCode) +
    (iconName == null ? 0 : iconName!.hashCode) +
    (sortOrder == null ? 0 : sortOrder!.hashCode);

  @override
  String toString() => 'UpdatePartnerCertificationDto[id=$id, title=$title, subtitle=$subtitle, iconName=$iconName, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.subtitle != null) {
      json[r'subtitle'] = this.subtitle;
    } else {
      json[r'subtitle'] = null;
    }
    if (this.iconName != null) {
      json[r'iconName'] = this.iconName;
    } else {
      json[r'iconName'] = null;
    }
    if (this.sortOrder != null) {
      json[r'sortOrder'] = this.sortOrder;
    } else {
      json[r'sortOrder'] = null;
    }
    return json;
  }

  /// Returns a new [UpdatePartnerCertificationDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdatePartnerCertificationDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdatePartnerCertificationDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdatePartnerCertificationDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdatePartnerCertificationDto(
        id: mapValueOfType<String>(json, r'id'),
        title: mapValueOfType<String>(json, r'title'),
        subtitle: mapValueOfType<Object>(json, r'subtitle'),
        iconName: mapValueOfType<String>(json, r'iconName'),
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<UpdatePartnerCertificationDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerCertificationDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerCertificationDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdatePartnerCertificationDto> mapFromJson(dynamic json) {
    final map = <String, UpdatePartnerCertificationDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdatePartnerCertificationDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdatePartnerCertificationDto-objects as value to a dart map
  static Map<String, List<UpdatePartnerCertificationDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdatePartnerCertificationDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdatePartnerCertificationDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

