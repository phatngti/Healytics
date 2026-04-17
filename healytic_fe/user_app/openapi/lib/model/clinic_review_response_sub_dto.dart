//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicReviewResponseSubDto {
  /// Returns a new [ClinicReviewResponseSubDto] instance.
  ClinicReviewResponseSubDto({
    this.responseText,
  });


  String? responseText;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicReviewResponseSubDto &&
    other.responseText == responseText;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (responseText == null ? 0 : responseText!.hashCode);

  @override
  String toString() => 'ClinicReviewResponseSubDto[responseText=$responseText]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.responseText != null) {
      json[r'responseText'] = this.responseText;
    } else {
      json[r'responseText'] = null;
    }
    return json;
  }

  /// Returns a new [ClinicReviewResponseSubDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicReviewResponseSubDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicReviewResponseSubDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicReviewResponseSubDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicReviewResponseSubDto(
        responseText: mapValueOfType<String>(json, r'responseText'),
      );
    }
    return null;
  }

  static List<ClinicReviewResponseSubDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicReviewResponseSubDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicReviewResponseSubDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicReviewResponseSubDto> mapFromJson(dynamic json) {
    final map = <String, ClinicReviewResponseSubDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicReviewResponseSubDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicReviewResponseSubDto-objects as value to a dart map
  static Map<String, List<ClinicReviewResponseSubDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicReviewResponseSubDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicReviewResponseSubDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

