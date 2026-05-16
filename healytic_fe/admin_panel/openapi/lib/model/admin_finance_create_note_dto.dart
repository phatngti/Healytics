//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceCreateNoteDto {
  /// Returns a new [AdminFinanceCreateNoteDto] instance.
  AdminFinanceCreateNoteDto({
    required this.entityType,
    required this.entityId,
    required this.content,
  });


  AdminFinanceNoteEntityType entityType;

  String entityId;

  String content;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceCreateNoteDto &&
    other.entityType == entityType &&
    other.entityId == entityId &&
    other.content == content;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (entityType.hashCode) +
    (entityId.hashCode) +
    (content.hashCode);

  @override
  String toString() => 'AdminFinanceCreateNoteDto[entityType=$entityType, entityId=$entityId, content=$content]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'entityType'] = this.entityType;
      json[r'entityId'] = this.entityId;
      json[r'content'] = this.content;
    return json;
  }

  /// Returns a new [AdminFinanceCreateNoteDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceCreateNoteDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceCreateNoteDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceCreateNoteDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceCreateNoteDto(
        entityType: AdminFinanceNoteEntityType.fromJson(json[r'entityType'])!,
        entityId: mapValueOfType<String>(json, r'entityId')!,
        content: mapValueOfType<String>(json, r'content')!,
      );
    }
    return null;
  }

  static List<AdminFinanceCreateNoteDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceCreateNoteDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceCreateNoteDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceCreateNoteDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceCreateNoteDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceCreateNoteDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceCreateNoteDto-objects as value to a dart map
  static Map<String, List<AdminFinanceCreateNoteDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceCreateNoteDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceCreateNoteDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'entityType',
    'entityId',
    'content',
  };
}

