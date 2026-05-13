//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceRequiredNoteActionDto {
  /// Returns a new [AdminFinanceRequiredNoteActionDto] instance.
  AdminFinanceRequiredNoteActionDto({
    required this.note,
  });


  String note;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceRequiredNoteActionDto &&
    other.note == note;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (note.hashCode);

  @override
  String toString() => 'AdminFinanceRequiredNoteActionDto[note=$note]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'note'] = this.note;
    return json;
  }

  /// Returns a new [AdminFinanceRequiredNoteActionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceRequiredNoteActionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceRequiredNoteActionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceRequiredNoteActionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceRequiredNoteActionDto(
        note: mapValueOfType<String>(json, r'note')!,
      );
    }
    return null;
  }

  static List<AdminFinanceRequiredNoteActionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceRequiredNoteActionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceRequiredNoteActionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceRequiredNoteActionDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceRequiredNoteActionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceRequiredNoteActionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceRequiredNoteActionDto-objects as value to a dart map
  static Map<String, List<AdminFinanceRequiredNoteActionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceRequiredNoteActionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceRequiredNoteActionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'note',
  };
}

