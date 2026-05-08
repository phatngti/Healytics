//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MicroLockDto {
  /// Returns a new [MicroLockDto] instance.
  MicroLockDto({
    required this.staffId,
    required this.startTime,
    this.productId,
  });


  /// Staff/employee UUID
  String staffId;

  /// Desired slot start time (ISO 8601)
  String startTime;

  /// Product/service UUID
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? productId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MicroLockDto &&
    other.staffId == staffId &&
    other.startTime == startTime &&
    other.productId == productId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (staffId.hashCode) +
    (startTime.hashCode) +
    (productId == null ? 0 : productId!.hashCode);

  @override
  String toString() => 'MicroLockDto[staffId=$staffId, startTime=$startTime, productId=$productId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'staffId'] = this.staffId;
      json[r'startTime'] = this.startTime;
    if (this.productId != null) {
      json[r'productId'] = this.productId;
    } else {
      json[r'productId'] = null;
    }
    return json;
  }

  /// Returns a new [MicroLockDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MicroLockDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MicroLockDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MicroLockDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MicroLockDto(
        staffId: mapValueOfType<String>(json, r'staffId')!,
        startTime: mapValueOfType<String>(json, r'startTime')!,
        productId: mapValueOfType<String>(json, r'productId'),
      );
    }
    return null;
  }

  static List<MicroLockDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MicroLockDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MicroLockDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MicroLockDto> mapFromJson(dynamic json) {
    final map = <String, MicroLockDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MicroLockDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MicroLockDto-objects as value to a dart map
  static Map<String, List<MicroLockDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MicroLockDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MicroLockDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'staffId',
    'startTime',
  };
}

