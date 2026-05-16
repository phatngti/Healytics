//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceSettlementActionDto {
  /// Returns a new [AdminFinanceSettlementActionDto] instance.
  AdminFinanceSettlementActionDto({
    required this.settlementStatus,
    required this.note,
  });


  PartnerSettlementStatus settlementStatus;

  String note;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceSettlementActionDto &&
    other.settlementStatus == settlementStatus &&
    other.note == note;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (settlementStatus.hashCode) +
    (note.hashCode);

  @override
  String toString() => 'AdminFinanceSettlementActionDto[settlementStatus=$settlementStatus, note=$note]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'settlementStatus'] = this.settlementStatus;
      json[r'note'] = this.note;
    return json;
  }

  /// Returns a new [AdminFinanceSettlementActionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceSettlementActionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceSettlementActionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceSettlementActionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceSettlementActionDto(
        settlementStatus: PartnerSettlementStatus.fromJson(json[r'settlementStatus'])!,
        note: mapValueOfType<String>(json, r'note')!,
      );
    }
    return null;
  }

  static List<AdminFinanceSettlementActionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceSettlementActionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceSettlementActionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceSettlementActionDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceSettlementActionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceSettlementActionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceSettlementActionDto-objects as value to a dart map
  static Map<String, List<AdminFinanceSettlementActionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceSettlementActionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceSettlementActionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'settlementStatus',
    'note',
  };
}

