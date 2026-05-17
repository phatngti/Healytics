//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinancePayoutDetailDto {
  /// Returns a new [AdminFinancePayoutDetailDto] instance.
  AdminFinancePayoutDetailDto({
    required this.record,
    this.includedTransactions = const [],
    this.attempts = const [],
    required this.maskedDestination,
    this.auditTrail = const [],
    this.notes = const [],
  });


  AdminFinancePayoutRecordDto record;

  List<AdminFinanceTransactionRecordDto> includedTransactions;

  List<AdminFinancePayoutAttemptDto> attempts;

  String maskedDestination;

  List<AdminFinanceAuditEventDto> auditTrail;

  List<AdminFinanceNoteDto> notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinancePayoutDetailDto &&
    other.record == record &&
    _deepEquality.equals(other.includedTransactions, includedTransactions) &&
    _deepEquality.equals(other.attempts, attempts) &&
    other.maskedDestination == maskedDestination &&
    _deepEquality.equals(other.auditTrail, auditTrail) &&
    _deepEquality.equals(other.notes, notes);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (record.hashCode) +
    (includedTransactions.hashCode) +
    (attempts.hashCode) +
    (maskedDestination.hashCode) +
    (auditTrail.hashCode) +
    (notes.hashCode);

  @override
  String toString() => 'AdminFinancePayoutDetailDto[record=$record, includedTransactions=$includedTransactions, attempts=$attempts, maskedDestination=$maskedDestination, auditTrail=$auditTrail, notes=$notes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'record'] = this.record;
      json[r'includedTransactions'] = this.includedTransactions;
      json[r'attempts'] = this.attempts;
      json[r'maskedDestination'] = this.maskedDestination;
      json[r'auditTrail'] = this.auditTrail;
      json[r'notes'] = this.notes;
    return json;
  }

  /// Returns a new [AdminFinancePayoutDetailDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinancePayoutDetailDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinancePayoutDetailDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinancePayoutDetailDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinancePayoutDetailDto(
        record: AdminFinancePayoutRecordDto.fromJson(json[r'record'])!,
        includedTransactions: AdminFinanceTransactionRecordDto.listFromJson(json[r'includedTransactions']),
        attempts: AdminFinancePayoutAttemptDto.listFromJson(json[r'attempts']),
        maskedDestination: mapValueOfType<String>(json, r'maskedDestination')!,
        auditTrail: AdminFinanceAuditEventDto.listFromJson(json[r'auditTrail']),
        notes: AdminFinanceNoteDto.listFromJson(json[r'notes']),
      );
    }
    return null;
  }

  static List<AdminFinancePayoutDetailDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinancePayoutDetailDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinancePayoutDetailDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinancePayoutDetailDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinancePayoutDetailDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinancePayoutDetailDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinancePayoutDetailDto-objects as value to a dart map
  static Map<String, List<AdminFinancePayoutDetailDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinancePayoutDetailDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinancePayoutDetailDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'record',
    'includedTransactions',
    'attempts',
    'maskedDestination',
    'auditTrail',
    'notes',
  };
}

