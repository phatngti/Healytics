//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicReviewFilterDto {
  /// Returns a new [ClinicReviewFilterDto] instance.
  ClinicReviewFilterDto({
    required this.id,
    required this.label,
    this.starCount,
    required this.requiresMedia,
  });


  String id;

  String label;

  num? starCount;

  bool requiresMedia;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicReviewFilterDto &&
    other.id == id &&
    other.label == label &&
    other.starCount == starCount &&
    other.requiresMedia == requiresMedia;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (label.hashCode) +
    (starCount == null ? 0 : starCount!.hashCode) +
    (requiresMedia.hashCode);

  @override
  String toString() => 'ClinicReviewFilterDto[id=$id, label=$label, starCount=$starCount, requiresMedia=$requiresMedia]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'label'] = this.label;
    if (this.starCount != null) {
      json[r'starCount'] = this.starCount;
    } else {
      json[r'starCount'] = null;
    }
      json[r'requiresMedia'] = this.requiresMedia;
    return json;
  }

  /// Returns a new [ClinicReviewFilterDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicReviewFilterDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicReviewFilterDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicReviewFilterDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicReviewFilterDto(
        id: mapValueOfType<String>(json, r'id')!,
        label: mapValueOfType<String>(json, r'label')!,
        starCount: json[r'starCount'] == null
            ? null
            : num.parse('${json[r'starCount']}'),
        requiresMedia: mapValueOfType<bool>(json, r'requiresMedia')!,
      );
    }
    return null;
  }

  static List<ClinicReviewFilterDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicReviewFilterDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicReviewFilterDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicReviewFilterDto> mapFromJson(dynamic json) {
    final map = <String, ClinicReviewFilterDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicReviewFilterDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicReviewFilterDto-objects as value to a dart map
  static Map<String, List<ClinicReviewFilterDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicReviewFilterDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicReviewFilterDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'label',
    'requiresMedia',
  };
}

