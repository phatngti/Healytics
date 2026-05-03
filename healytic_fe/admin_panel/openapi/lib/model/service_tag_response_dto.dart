//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ServiceTagResponseDto {
  /// Returns a new [ServiceTagResponseDto] instance.
  ServiceTagResponseDto({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.colorValue,
    required this.usage,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });


  String id;

  String userId;

  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? description;

  String colorValue;

  num usage;

  bool isActive;

  num sortOrder;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ServiceTagResponseDto &&
    other.id == id &&
    other.userId == userId &&
    other.name == name &&
    other.description == description &&
    other.colorValue == colorValue &&
    other.usage == usage &&
    other.isActive == isActive &&
    other.sortOrder == sortOrder &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (userId.hashCode) +
    (name.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (colorValue.hashCode) +
    (usage.hashCode) +
    (isActive.hashCode) +
    (sortOrder.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'ServiceTagResponseDto[id=$id, userId=$userId, name=$name, description=$description, colorValue=$colorValue, usage=$usage, isActive=$isActive, sortOrder=$sortOrder, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'userId'] = this.userId;
      json[r'name'] = this.name;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'colorValue'] = this.colorValue;
      json[r'usage'] = this.usage;
      json[r'isActive'] = this.isActive;
      json[r'sortOrder'] = this.sortOrder;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'updatedAt'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ServiceTagResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ServiceTagResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ServiceTagResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ServiceTagResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ServiceTagResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        userId: mapValueOfType<String>(json, r'userId')!,
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<Object>(json, r'description'),
        colorValue: mapValueOfType<String>(json, r'colorValue')!,
        usage: num.parse('${json[r'usage']}'),
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        sortOrder: num.parse('${json[r'sortOrder']}'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
      );
    }
    return null;
  }

  static List<ServiceTagResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ServiceTagResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ServiceTagResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ServiceTagResponseDto> mapFromJson(dynamic json) {
    final map = <String, ServiceTagResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ServiceTagResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ServiceTagResponseDto-objects as value to a dart map
  static Map<String, List<ServiceTagResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ServiceTagResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ServiceTagResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'userId',
    'name',
    'colorValue',
    'usage',
    'isActive',
    'sortOrder',
    'createdAt',
    'updatedAt',
  };
}

