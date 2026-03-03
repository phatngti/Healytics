//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerProductDefinitionDto {
  /// Returns a new [PartnerProductDefinitionDto] instance.
  PartnerProductDefinitionDto({
    required this.productId,
    required this.durationMinutes,
    this.bufferMinutes,
    this.maxCapacity,
    this.minLeadTimeHours,
    this.staffAssignmentType,
  });

  /// Product ID (primary key)
  String productId;

  /// Service duration in minutes
  num durationMinutes;

  /// Buffer time between appointments
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? bufferMinutes;

  /// Maximum capacity per slot
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? maxCapacity;

  /// Minimum lead time for booking (hours)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? minLeadTimeHours;

  /// Staff assignment type
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? staffAssignmentType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerProductDefinitionDto &&
    other.productId == productId &&
    other.durationMinutes == durationMinutes &&
    other.bufferMinutes == bufferMinutes &&
    other.maxCapacity == maxCapacity &&
    other.minLeadTimeHours == minLeadTimeHours &&
    other.staffAssignmentType == staffAssignmentType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (productId.hashCode) +
    (durationMinutes.hashCode) +
    (bufferMinutes == null ? 0 : bufferMinutes!.hashCode) +
    (maxCapacity == null ? 0 : maxCapacity!.hashCode) +
    (minLeadTimeHours == null ? 0 : minLeadTimeHours!.hashCode) +
    (staffAssignmentType == null ? 0 : staffAssignmentType!.hashCode);

  @override
  String toString() => 'PartnerProductDefinitionDto[productId=$productId, durationMinutes=$durationMinutes, bufferMinutes=$bufferMinutes, maxCapacity=$maxCapacity, minLeadTimeHours=$minLeadTimeHours, staffAssignmentType=$staffAssignmentType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'productId'] = this.productId;
      json[r'durationMinutes'] = this.durationMinutes;
    if (this.bufferMinutes != null) {
      json[r'bufferMinutes'] = this.bufferMinutes;
    } else {
      json[r'bufferMinutes'] = null;
    }
    if (this.maxCapacity != null) {
      json[r'maxCapacity'] = this.maxCapacity;
    } else {
      json[r'maxCapacity'] = null;
    }
    if (this.minLeadTimeHours != null) {
      json[r'minLeadTimeHours'] = this.minLeadTimeHours;
    } else {
      json[r'minLeadTimeHours'] = null;
    }
    if (this.staffAssignmentType != null) {
      json[r'staffAssignmentType'] = this.staffAssignmentType;
    } else {
      json[r'staffAssignmentType'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerProductDefinitionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerProductDefinitionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerProductDefinitionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerProductDefinitionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerProductDefinitionDto(
        productId: mapValueOfType<String>(json, r'productId')!,
        durationMinutes: num.parse('${json[r'durationMinutes']}'),
        bufferMinutes: num.parse('${json[r'bufferMinutes']}'),
        maxCapacity: num.parse('${json[r'maxCapacity']}'),
        minLeadTimeHours: num.parse('${json[r'minLeadTimeHours']}'),
        staffAssignmentType: mapValueOfType<String>(json, r'staffAssignmentType'),
      );
    }
    return null;
  }

  static List<PartnerProductDefinitionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerProductDefinitionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerProductDefinitionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerProductDefinitionDto> mapFromJson(dynamic json) {
    final map = <String, PartnerProductDefinitionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerProductDefinitionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerProductDefinitionDto-objects as value to a dart map
  static Map<String, List<PartnerProductDefinitionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerProductDefinitionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerProductDefinitionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'productId',
    'durationMinutes',
  };
}

