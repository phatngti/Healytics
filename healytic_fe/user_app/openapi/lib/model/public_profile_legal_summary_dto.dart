//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicProfileLegalSummaryDto {
  /// Returns a new [PublicProfileLegalSummaryDto] instance.
  PublicProfileLegalSummaryDto({
    required this.fullName,
    required this.position,
    required this.idType,
    required this.idNumber,
  });


  String fullName;

  String position;

  String idType;

  String idNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicProfileLegalSummaryDto &&
    other.fullName == fullName &&
    other.position == position &&
    other.idType == idType &&
    other.idNumber == idNumber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fullName.hashCode) +
    (position.hashCode) +
    (idType.hashCode) +
    (idNumber.hashCode);

  @override
  String toString() => 'PublicProfileLegalSummaryDto[fullName=$fullName, position=$position, idType=$idType, idNumber=$idNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fullName'] = this.fullName;
      json[r'position'] = this.position;
      json[r'idType'] = this.idType;
      json[r'idNumber'] = this.idNumber;
    return json;
  }

  /// Returns a new [PublicProfileLegalSummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicProfileLegalSummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicProfileLegalSummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicProfileLegalSummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicProfileLegalSummaryDto(
        fullName: mapValueOfType<String>(json, r'fullName')!,
        position: mapValueOfType<String>(json, r'position')!,
        idType: mapValueOfType<String>(json, r'idType')!,
        idNumber: mapValueOfType<String>(json, r'idNumber')!,
      );
    }
    return null;
  }

  static List<PublicProfileLegalSummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicProfileLegalSummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicProfileLegalSummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicProfileLegalSummaryDto> mapFromJson(dynamic json) {
    final map = <String, PublicProfileLegalSummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicProfileLegalSummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicProfileLegalSummaryDto-objects as value to a dart map
  static Map<String, List<PublicProfileLegalSummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicProfileLegalSummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicProfileLegalSummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fullName',
    'position',
    'idType',
    'idNumber',
  };
}

