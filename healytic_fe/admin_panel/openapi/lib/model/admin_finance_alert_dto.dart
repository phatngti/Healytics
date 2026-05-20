//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceAlertDto {
  /// Returns a new [AdminFinanceAlertDto] instance.
  AdminFinanceAlertDto({
    required this.id,
    required this.title,
    required this.description,
    required this.tone,
    required this.createdAt,
  });


  String id;

  String title;

  String description;

  AdminFinanceRiskTone tone;

  String createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceAlertDto &&
    other.id == id &&
    other.title == title &&
    other.description == description &&
    other.tone == tone &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (description.hashCode) +
    (tone.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'AdminFinanceAlertDto[id=$id, title=$title, description=$description, tone=$tone, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'description'] = this.description;
      json[r'tone'] = this.tone;
      json[r'createdAt'] = this.createdAt;
    return json;
  }

  /// Returns a new [AdminFinanceAlertDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceAlertDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceAlertDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceAlertDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceAlertDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description')!,
        tone: AdminFinanceRiskTone.fromJson(json[r'tone'])!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
      );
    }
    return null;
  }

  static List<AdminFinanceAlertDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceAlertDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceAlertDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceAlertDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceAlertDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceAlertDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceAlertDto-objects as value to a dart map
  static Map<String, List<AdminFinanceAlertDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceAlertDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceAlertDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'description',
    'tone',
    'createdAt',
  };
}

