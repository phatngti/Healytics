//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceRefundCaseDetailDto {
  /// Returns a new [AdminFinanceRefundCaseDetailDto] instance.
  AdminFinanceRefundCaseDetailDto({
    required this.record,
    required this.customerRequest,
    required this.partnerResponse,
    this.evidenceLinks = const [],
    required this.decisionNote,
    this.auditTrail = const [],
    this.notes = const [],
  });


  AdminFinanceRefundCaseRecordDto record;

  String customerRequest;

  String partnerResponse;

  List<String> evidenceLinks;

  String decisionNote;

  List<AdminFinanceAuditEventDto> auditTrail;

  List<AdminFinanceNoteDto> notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceRefundCaseDetailDto &&
    other.record == record &&
    other.customerRequest == customerRequest &&
    other.partnerResponse == partnerResponse &&
    _deepEquality.equals(other.evidenceLinks, evidenceLinks) &&
    other.decisionNote == decisionNote &&
    _deepEquality.equals(other.auditTrail, auditTrail) &&
    _deepEquality.equals(other.notes, notes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (record.hashCode) +
    (customerRequest.hashCode) +
    (partnerResponse.hashCode) +
    (evidenceLinks.hashCode) +
    (decisionNote.hashCode) +
    (auditTrail.hashCode) +
    (notes.hashCode);

  @override
  String toString() => 'AdminFinanceRefundCaseDetailDto[record=$record, customerRequest=$customerRequest, partnerResponse=$partnerResponse, evidenceLinks=$evidenceLinks, decisionNote=$decisionNote, auditTrail=$auditTrail, notes=$notes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'record'] = this.record;
      json[r'customerRequest'] = this.customerRequest;
      json[r'partnerResponse'] = this.partnerResponse;
      json[r'evidenceLinks'] = this.evidenceLinks;
      json[r'decisionNote'] = this.decisionNote;
      json[r'auditTrail'] = this.auditTrail;
      json[r'notes'] = this.notes;
    return json;
  }

  /// Returns a new [AdminFinanceRefundCaseDetailDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceRefundCaseDetailDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceRefundCaseDetailDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceRefundCaseDetailDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceRefundCaseDetailDto(
        record: AdminFinanceRefundCaseRecordDto.fromJson(json[r'record'])!,
        customerRequest: mapValueOfType<String>(json, r'customerRequest')!,
        partnerResponse: mapValueOfType<String>(json, r'partnerResponse')!,
        evidenceLinks: json[r'evidenceLinks'] is Iterable
            ? (json[r'evidenceLinks'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        decisionNote: mapValueOfType<String>(json, r'decisionNote')!,
        auditTrail: AdminFinanceAuditEventDto.listFromJson(json[r'auditTrail']),
        notes: AdminFinanceNoteDto.listFromJson(json[r'notes']),
      );
    }
    return null;
  }

  static List<AdminFinanceRefundCaseDetailDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceRefundCaseDetailDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceRefundCaseDetailDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceRefundCaseDetailDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceRefundCaseDetailDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceRefundCaseDetailDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceRefundCaseDetailDto-objects as value to a dart map
  static Map<String, List<AdminFinanceRefundCaseDetailDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceRefundCaseDetailDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceRefundCaseDetailDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'record',
    'customerRequest',
    'partnerResponse',
    'evidenceLinks',
    'decisionNote',
    'auditTrail',
    'notes',
  };
}

