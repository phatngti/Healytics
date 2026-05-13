//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceNoteDto {
  /// Returns a new [AdminFinanceNoteDto] instance.
  AdminFinanceNoteDto({
    required this.id,
    required this.content,
    required this.createdBy,
    required this.createdAt,
  });


  String id;

  String content;

  String createdBy;

  String createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceNoteDto &&
    other.id == id &&
    other.content == content &&
    other.createdBy == createdBy &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (content.hashCode) +
    (createdBy.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'AdminFinanceNoteDto[id=$id, content=$content, createdBy=$createdBy, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'content'] = this.content;
      json[r'createdBy'] = this.createdBy;
      json[r'createdAt'] = this.createdAt;
    return json;
  }

  /// Returns a new [AdminFinanceNoteDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceNoteDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceNoteDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceNoteDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceNoteDto(
        id: mapValueOfType<String>(json, r'id')!,
        content: mapValueOfType<String>(json, r'content')!,
        createdBy: mapValueOfType<String>(json, r'createdBy')!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
      );
    }
    return null;
  }

  static List<AdminFinanceNoteDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceNoteDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceNoteDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceNoteDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceNoteDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceNoteDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceNoteDto-objects as value to a dart map
  static Map<String, List<AdminFinanceNoteDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceNoteDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceNoteDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'content',
    'createdBy',
    'createdAt',
  };
}

