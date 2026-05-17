//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceAuditEventDto {
  /// Returns a new [AdminFinanceAuditEventDto] instance.
  AdminFinanceAuditEventDto({
    required this.id,
    required this.label,
    required this.detail,
    required this.performedBy,
    required this.occurredAt,
    required this.isError,
  });


  String id;

  String label;

  String detail;

  String performedBy;

  String occurredAt;

  bool isError;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceAuditEventDto &&
    other.id == id &&
    other.label == label &&
    other.detail == detail &&
    other.performedBy == performedBy &&
    other.occurredAt == occurredAt &&
    other.isError == isError;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (label.hashCode) +
    (detail.hashCode) +
    (performedBy.hashCode) +
    (occurredAt.hashCode) +
    (isError.hashCode);

  @override
  String toString() => 'AdminFinanceAuditEventDto[id=$id, label=$label, detail=$detail, performedBy=$performedBy, occurredAt=$occurredAt, isError=$isError]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'label'] = this.label;
      json[r'detail'] = this.detail;
      json[r'performedBy'] = this.performedBy;
      json[r'occurredAt'] = this.occurredAt;
      json[r'isError'] = this.isError;
    return json;
  }

  /// Returns a new [AdminFinanceAuditEventDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceAuditEventDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceAuditEventDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceAuditEventDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceAuditEventDto(
        id: mapValueOfType<String>(json, r'id')!,
        label: mapValueOfType<String>(json, r'label')!,
        detail: mapValueOfType<String>(json, r'detail')!,
        performedBy: mapValueOfType<String>(json, r'performedBy')!,
        occurredAt: mapValueOfType<String>(json, r'occurredAt')!,
        isError: mapValueOfType<bool>(json, r'isError')!,
      );
    }
    return null;
  }

  static List<AdminFinanceAuditEventDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceAuditEventDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceAuditEventDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceAuditEventDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceAuditEventDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceAuditEventDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceAuditEventDto-objects as value to a dart map
  static Map<String, List<AdminFinanceAuditEventDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceAuditEventDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceAuditEventDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'label',
    'detail',
    'performedBy',
    'occurredAt',
    'isError',
  };
}

