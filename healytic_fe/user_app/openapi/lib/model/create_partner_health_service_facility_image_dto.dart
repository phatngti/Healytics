//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreatePartnerHealthServiceFacilityImageDto {
  /// Returns a new [CreatePartnerHealthServiceFacilityImageDto] instance.
  CreatePartnerHealthServiceFacilityImageDto({
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
  bool operator ==(Object other) => identical(this, other) || other is CreatePartnerHealthServiceFacilityImageDto &&
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
  String toString() => 'CreatePartnerHealthServiceFacilityImageDto[imageUrl=$imageUrl, label=$label, sortOrder=$sortOrder]';

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

  /// Returns a new [CreatePartnerHealthServiceFacilityImageDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreatePartnerHealthServiceFacilityImageDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreatePartnerHealthServiceFacilityImageDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreatePartnerHealthServiceFacilityImageDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreatePartnerHealthServiceFacilityImageDto(
        imageUrl: mapValueOfType<String>(json, r'imageUrl')!,
        label: mapValueOfType<String>(json, r'label')!,
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<CreatePartnerHealthServiceFacilityImageDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerHealthServiceFacilityImageDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerHealthServiceFacilityImageDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatePartnerHealthServiceFacilityImageDto> mapFromJson(dynamic json) {
    final map = <String, CreatePartnerHealthServiceFacilityImageDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreatePartnerHealthServiceFacilityImageDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatePartnerHealthServiceFacilityImageDto-objects as value to a dart map
  static Map<String, List<CreatePartnerHealthServiceFacilityImageDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatePartnerHealthServiceFacilityImageDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatePartnerHealthServiceFacilityImageDto.listFromJson(entry.value, growable: growable,);
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

