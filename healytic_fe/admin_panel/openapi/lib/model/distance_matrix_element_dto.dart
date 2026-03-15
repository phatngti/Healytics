//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DistanceMatrixElementDto {
  /// Returns a new [DistanceMatrixElementDto] instance.
  DistanceMatrixElementDto({
    required this.distanceText,
    required this.distanceValue,
    required this.durationText,
    required this.durationValue,
    required this.status,
  });

  String distanceText;

  num distanceValue;

  String durationText;

  num durationValue;

  String status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DistanceMatrixElementDto &&
    other.distanceText == distanceText &&
    other.distanceValue == distanceValue &&
    other.durationText == durationText &&
    other.durationValue == durationValue &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (distanceText.hashCode) +
    (distanceValue.hashCode) +
    (durationText.hashCode) +
    (durationValue.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'DistanceMatrixElementDto[distanceText=$distanceText, distanceValue=$distanceValue, durationText=$durationText, durationValue=$durationValue, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'distanceText'] = this.distanceText;
      json[r'distanceValue'] = this.distanceValue;
      json[r'durationText'] = this.durationText;
      json[r'durationValue'] = this.durationValue;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [DistanceMatrixElementDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DistanceMatrixElementDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DistanceMatrixElementDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DistanceMatrixElementDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DistanceMatrixElementDto(
        distanceText: mapValueOfType<String>(json, r'distanceText')!,
        distanceValue: num.parse('${json[r'distanceValue']}'),
        durationText: mapValueOfType<String>(json, r'durationText')!,
        durationValue: num.parse('${json[r'durationValue']}'),
        status: mapValueOfType<String>(json, r'status')!,
      );
    }
    return null;
  }

  static List<DistanceMatrixElementDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DistanceMatrixElementDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DistanceMatrixElementDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DistanceMatrixElementDto> mapFromJson(dynamic json) {
    final map = <String, DistanceMatrixElementDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DistanceMatrixElementDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DistanceMatrixElementDto-objects as value to a dart map
  static Map<String, List<DistanceMatrixElementDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DistanceMatrixElementDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DistanceMatrixElementDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'distanceText',
    'distanceValue',
    'durationText',
    'durationValue',
    'status',
  };
}

