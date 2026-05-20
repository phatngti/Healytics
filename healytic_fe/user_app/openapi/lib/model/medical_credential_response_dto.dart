//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MedicalCredentialResponseDto {
  /// Returns a new [MedicalCredentialResponseDto] instance.
  MedicalCredentialResponseDto({
    this.title,
    this.license,
  });


  /// Title
  String? title;

  /// License
  String? license;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MedicalCredentialResponseDto &&
    other.title == title &&
    other.license == license;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title == null ? 0 : title!.hashCode) +
    (license == null ? 0 : license!.hashCode);

  @override
  String toString() => 'MedicalCredentialResponseDto[title=$title, license=$license]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.license != null) {
      json[r'license'] = this.license;
    } else {
      json[r'license'] = null;
    }
    return json;
  }

  /// Returns a new [MedicalCredentialResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MedicalCredentialResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MedicalCredentialResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MedicalCredentialResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MedicalCredentialResponseDto(
        title: mapValueOfType<String>(json, r'title'),
        license: mapValueOfType<String>(json, r'license'),
      );
    }
    return null;
  }

  static List<MedicalCredentialResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MedicalCredentialResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MedicalCredentialResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MedicalCredentialResponseDto> mapFromJson(dynamic json) {
    final map = <String, MedicalCredentialResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MedicalCredentialResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MedicalCredentialResponseDto-objects as value to a dart map
  static Map<String, List<MedicalCredentialResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MedicalCredentialResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MedicalCredentialResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

