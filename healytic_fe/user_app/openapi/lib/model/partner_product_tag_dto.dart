//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerProductTagDto {
  /// Returns a new [PartnerProductTagDto] instance.
  PartnerProductTagDto({
    required this.tagId,
    this.tag,
  });


  /// Tag ID
  String tagId;

  /// Tag detail
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PartnerProductTagDetailDto? tag;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerProductTagDto &&
    other.tagId == tagId &&
    other.tag == tag;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (tagId.hashCode) +
    (tag == null ? 0 : tag!.hashCode);

  @override
  String toString() => 'PartnerProductTagDto[tagId=$tagId, tag=$tag]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tagId'] = this.tagId;
    if (this.tag != null) {
      json[r'tag'] = this.tag;
    } else {
      json[r'tag'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerProductTagDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerProductTagDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerProductTagDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerProductTagDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerProductTagDto(
        tagId: mapValueOfType<String>(json, r'tagId')!,
        tag: PartnerProductTagDetailDto.fromJson(json[r'tag']),
      );
    }
    return null;
  }

  static List<PartnerProductTagDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerProductTagDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerProductTagDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerProductTagDto> mapFromJson(dynamic json) {
    final map = <String, PartnerProductTagDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerProductTagDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerProductTagDto-objects as value to a dart map
  static Map<String, List<PartnerProductTagDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerProductTagDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerProductTagDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tagId',
  };
}

