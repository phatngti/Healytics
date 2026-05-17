//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceReconciliationDetailDto {
  /// Returns a new [AdminFinanceReconciliationDetailDto] instance.
  AdminFinanceReconciliationDetailDto({
    required this.exception,
    required this.providerEventContext,
    required this.ledgerContext,
    required this.resolutionNotes,
    this.auditTrail = const [],
    this.notes = const [],
  });


  AdminFinanceReconciliationExceptionDto exception;

  String providerEventContext;

  String ledgerContext;

  String resolutionNotes;

  List<AdminFinanceAuditEventDto> auditTrail;

  List<AdminFinanceNoteDto> notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceReconciliationDetailDto &&
    other.exception == exception &&
    other.providerEventContext == providerEventContext &&
    other.ledgerContext == ledgerContext &&
    other.resolutionNotes == resolutionNotes &&
    _deepEquality.equals(other.auditTrail, auditTrail) &&
    _deepEquality.equals(other.notes, notes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (exception.hashCode) +
    (providerEventContext.hashCode) +
    (ledgerContext.hashCode) +
    (resolutionNotes.hashCode) +
    (auditTrail.hashCode) +
    (notes.hashCode);

  @override
  String toString() => 'AdminFinanceReconciliationDetailDto[exception=$exception, providerEventContext=$providerEventContext, ledgerContext=$ledgerContext, resolutionNotes=$resolutionNotes, auditTrail=$auditTrail, notes=$notes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'exception'] = this.exception;
      json[r'providerEventContext'] = this.providerEventContext;
      json[r'ledgerContext'] = this.ledgerContext;
      json[r'resolutionNotes'] = this.resolutionNotes;
      json[r'auditTrail'] = this.auditTrail;
      json[r'notes'] = this.notes;
    return json;
  }

  /// Returns a new [AdminFinanceReconciliationDetailDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceReconciliationDetailDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceReconciliationDetailDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceReconciliationDetailDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceReconciliationDetailDto(
        exception: AdminFinanceReconciliationExceptionDto.fromJson(json[r'exception'])!,
        providerEventContext: mapValueOfType<String>(json, r'providerEventContext')!,
        ledgerContext: mapValueOfType<String>(json, r'ledgerContext')!,
        resolutionNotes: mapValueOfType<String>(json, r'resolutionNotes')!,
        auditTrail: AdminFinanceAuditEventDto.listFromJson(json[r'auditTrail']),
        notes: AdminFinanceNoteDto.listFromJson(json[r'notes']),
      );
    }
    return null;
  }

  static List<AdminFinanceReconciliationDetailDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceReconciliationDetailDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceReconciliationDetailDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceReconciliationDetailDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceReconciliationDetailDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceReconciliationDetailDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceReconciliationDetailDto-objects as value to a dart map
  static Map<String, List<AdminFinanceReconciliationDetailDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceReconciliationDetailDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceReconciliationDetailDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'exception',
    'providerEventContext',
    'ledgerContext',
    'resolutionNotes',
    'auditTrail',
    'notes',
  };
}

