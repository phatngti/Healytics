//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CheckDuplicateSlotResponseDto {
  /// Returns a new [CheckDuplicateSlotResponseDto] instance.
  CheckDuplicateSlotResponseDto({
    required this.isDuplicate,
    this.conflictingServiceName,
    this.conflictingBookingId,
  });


  /// Whether a conflicting booking exists at this datetime
  bool isDuplicate;

  /// Name of the conflicting service/product (if duplicate found)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? conflictingServiceName;

  /// ID of the conflicting booking (if duplicate found)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? conflictingBookingId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CheckDuplicateSlotResponseDto &&
    other.isDuplicate == isDuplicate &&
    other.conflictingServiceName == conflictingServiceName &&
    other.conflictingBookingId == conflictingBookingId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (isDuplicate.hashCode) +
    (conflictingServiceName == null ? 0 : conflictingServiceName!.hashCode) +
    (conflictingBookingId == null ? 0 : conflictingBookingId!.hashCode);

  @override
  String toString() => 'CheckDuplicateSlotResponseDto[isDuplicate=$isDuplicate, conflictingServiceName=$conflictingServiceName, conflictingBookingId=$conflictingBookingId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'isDuplicate'] = this.isDuplicate;
    if (this.conflictingServiceName != null) {
      json[r'conflictingServiceName'] = this.conflictingServiceName;
    } else {
      json[r'conflictingServiceName'] = null;
    }
    if (this.conflictingBookingId != null) {
      json[r'conflictingBookingId'] = this.conflictingBookingId;
    } else {
      json[r'conflictingBookingId'] = null;
    }
    return json;
  }

  /// Returns a new [CheckDuplicateSlotResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CheckDuplicateSlotResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CheckDuplicateSlotResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CheckDuplicateSlotResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CheckDuplicateSlotResponseDto(
        isDuplicate: mapValueOfType<bool>(json, r'isDuplicate')!,
        conflictingServiceName: mapValueOfType<String>(json, r'conflictingServiceName'),
        conflictingBookingId: mapValueOfType<String>(json, r'conflictingBookingId'),
      );
    }
    return null;
  }

  static List<CheckDuplicateSlotResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckDuplicateSlotResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckDuplicateSlotResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CheckDuplicateSlotResponseDto> mapFromJson(dynamic json) {
    final map = <String, CheckDuplicateSlotResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CheckDuplicateSlotResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CheckDuplicateSlotResponseDto-objects as value to a dart map
  static Map<String, List<CheckDuplicateSlotResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CheckDuplicateSlotResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CheckDuplicateSlotResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'isDuplicate',
  };
}

