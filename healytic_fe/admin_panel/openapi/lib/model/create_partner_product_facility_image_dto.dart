//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreatePartnerProductFacilityImageDto {
  /// Returns a new [CreatePartnerProductFacilityImageDto] instance.
  CreatePartnerProductFacilityImageDto({
    required this.imageUrl,
    required this.label,
    this.sortOrder,
  });

  String imageUrl;

  String label;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreatePartnerProductFacilityImageDto &&
    other.imageUrl == imageUrl &&
    other.label == label &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (imageUrl.hashCode) +
    (label.hashCode) +
    (sortOrder == null ? 0 : sortOrder!.hashCode);

  @override
  String toString() => 'CreatePartnerProductFacilityImageDto[imageUrl=$imageUrl, label=$label, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'imageUrl'] = this.imageUrl;
      json[r'label'] = this.label;
    if (this.sortOrder != null) {
      json[r'sortOrder'] = this.sortOrder;
    } else {
      json[r'sortOrder'] = null;
    }
    return json;
  }

  /// Returns a new [CreatePartnerProductFacilityImageDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreatePartnerProductFacilityImageDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreatePartnerProductFacilityImageDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreatePartnerProductFacilityImageDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreatePartnerProductFacilityImageDto(
        imageUrl: mapValueOfType<String>(json, r'imageUrl')!,
        label: mapValueOfType<String>(json, r'label')!,
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<CreatePartnerProductFacilityImageDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerProductFacilityImageDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerProductFacilityImageDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatePartnerProductFacilityImageDto> mapFromJson(dynamic json) {
    final map = <String, CreatePartnerProductFacilityImageDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreatePartnerProductFacilityImageDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatePartnerProductFacilityImageDto-objects as value to a dart map
  static Map<String, List<CreatePartnerProductFacilityImageDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatePartnerProductFacilityImageDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatePartnerProductFacilityImageDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'imageUrl',
    'label',
  };
}

