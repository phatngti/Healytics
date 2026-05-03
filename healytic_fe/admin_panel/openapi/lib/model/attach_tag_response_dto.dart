//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AttachTagResponseDto {
  /// Returns a new [AttachTagResponseDto] instance.
  AttachTagResponseDto({
    required this.tagId,
    required this.productId,
    required this.createdAt,
  });


  /// Service tag ID
  String tagId;

  /// Product ID
  String productId;

  /// Creation timestamp of the relationship
  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AttachTagResponseDto &&
    other.tagId == tagId &&
    other.productId == productId &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (tagId.hashCode) +
    (productId.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'AttachTagResponseDto[tagId=$tagId, productId=$productId, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tagId'] = this.tagId;
      json[r'productId'] = this.productId;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [AttachTagResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AttachTagResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AttachTagResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AttachTagResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AttachTagResponseDto(
        tagId: mapValueOfType<String>(json, r'tagId')!,
        productId: mapValueOfType<String>(json, r'productId')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<AttachTagResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AttachTagResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AttachTagResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AttachTagResponseDto> mapFromJson(dynamic json) {
    final map = <String, AttachTagResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AttachTagResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AttachTagResponseDto-objects as value to a dart map
  static Map<String, List<AttachTagResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AttachTagResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AttachTagResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tagId',
    'productId',
    'createdAt',
  };
}

