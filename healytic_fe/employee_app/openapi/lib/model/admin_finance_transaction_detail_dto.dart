//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceTransactionDetailDto {
  /// Returns a new [AdminFinanceTransactionDetailDto] instance.
  AdminFinanceTransactionDetailDto({
    required this.record,
    this.providerEvents = const [],
    this.auditTrail = const [],
    this.notes = const [],
    this.relatedRefundCases = const [],
  });


  AdminFinanceTransactionRecordDto record;

  List<AdminFinanceProviderEventDto> providerEvents;

  List<AdminFinanceAuditEventDto> auditTrail;

  List<AdminFinanceNoteDto> notes;

  List<AdminFinanceRefundCaseRecordDto> relatedRefundCases;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceTransactionDetailDto &&
    other.record == record &&
    _deepEquality.equals(other.providerEvents, providerEvents) &&
    _deepEquality.equals(other.auditTrail, auditTrail) &&
    _deepEquality.equals(other.notes, notes) &&
    _deepEquality.equals(other.relatedRefundCases, relatedRefundCases);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (record.hashCode) +
    (providerEvents.hashCode) +
    (auditTrail.hashCode) +
    (notes.hashCode) +
    (relatedRefundCases.hashCode);

  @override
  String toString() => 'AdminFinanceTransactionDetailDto[record=$record, providerEvents=$providerEvents, auditTrail=$auditTrail, notes=$notes, relatedRefundCases=$relatedRefundCases]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'record'] = this.record;
      json[r'providerEvents'] = this.providerEvents;
      json[r'auditTrail'] = this.auditTrail;
      json[r'notes'] = this.notes;
      json[r'relatedRefundCases'] = this.relatedRefundCases;
    return json;
  }

  /// Returns a new [AdminFinanceTransactionDetailDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceTransactionDetailDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceTransactionDetailDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceTransactionDetailDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceTransactionDetailDto(
        record: AdminFinanceTransactionRecordDto.fromJson(json[r'record'])!,
        providerEvents: AdminFinanceProviderEventDto.listFromJson(json[r'providerEvents']),
        auditTrail: AdminFinanceAuditEventDto.listFromJson(json[r'auditTrail']),
        notes: AdminFinanceNoteDto.listFromJson(json[r'notes']),
        relatedRefundCases: AdminFinanceRefundCaseRecordDto.listFromJson(json[r'relatedRefundCases']),
      );
    }
    return null;
  }

  static List<AdminFinanceTransactionDetailDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceTransactionDetailDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceTransactionDetailDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceTransactionDetailDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceTransactionDetailDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceTransactionDetailDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceTransactionDetailDto-objects as value to a dart map
  static Map<String, List<AdminFinanceTransactionDetailDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceTransactionDetailDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceTransactionDetailDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'record',
    'providerEvents',
    'auditTrail',
    'notes',
    'relatedRefundCases',
  };
}

