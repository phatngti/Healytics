//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceRefundCaseRecordDto {
  /// Returns a new [AdminFinanceRefundCaseRecordDto] instance.
  AdminFinanceRefundCaseRecordDto({
    required this.id,
    required this.requestedAt,
    required this.transactionId,
    required this.partnerName,
    required this.customerName,
    required this.caseType,
    required this.amount,
    required this.currency,
    required this.reason,
    required this.owner,
    required this.status,
    required this.slaHours,
    required this.slaBreached,
    required this.riskTone,
  });


  String id;

  String requestedAt;

  String transactionId;

  String partnerName;

  String customerName;

  PartnerRefundCaseType caseType;

  num amount;

  String currency;

  String reason;

  String owner;

  PartnerRefundCaseStatus status;

  num slaHours;

  bool slaBreached;

  AdminFinanceRiskTone riskTone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceRefundCaseRecordDto &&
    other.id == id &&
    other.requestedAt == requestedAt &&
    other.transactionId == transactionId &&
    other.partnerName == partnerName &&
    other.customerName == customerName &&
    other.caseType == caseType &&
    other.amount == amount &&
    other.currency == currency &&
    other.reason == reason &&
    other.owner == owner &&
    other.status == status &&
    other.slaHours == slaHours &&
    other.slaBreached == slaBreached &&
    other.riskTone == riskTone;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (requestedAt.hashCode) +
    (transactionId.hashCode) +
    (partnerName.hashCode) +
    (customerName.hashCode) +
    (caseType.hashCode) +
    (amount.hashCode) +
    (currency.hashCode) +
    (reason.hashCode) +
    (owner.hashCode) +
    (status.hashCode) +
    (slaHours.hashCode) +
    (slaBreached.hashCode) +
    (riskTone.hashCode);

  @override
  String toString() => 'AdminFinanceRefundCaseRecordDto[id=$id, requestedAt=$requestedAt, transactionId=$transactionId, partnerName=$partnerName, customerName=$customerName, caseType=$caseType, amount=$amount, currency=$currency, reason=$reason, owner=$owner, status=$status, slaHours=$slaHours, slaBreached=$slaBreached, riskTone=$riskTone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'requestedAt'] = this.requestedAt;
      json[r'transactionId'] = this.transactionId;
      json[r'partnerName'] = this.partnerName;
      json[r'customerName'] = this.customerName;
      json[r'caseType'] = this.caseType;
      json[r'amount'] = this.amount;
      json[r'currency'] = this.currency;
      json[r'reason'] = this.reason;
      json[r'owner'] = this.owner;
      json[r'status'] = this.status;
      json[r'slaHours'] = this.slaHours;
      json[r'slaBreached'] = this.slaBreached;
      json[r'riskTone'] = this.riskTone;
    return json;
  }

  /// Returns a new [AdminFinanceRefundCaseRecordDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceRefundCaseRecordDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceRefundCaseRecordDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceRefundCaseRecordDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceRefundCaseRecordDto(
        id: mapValueOfType<String>(json, r'id')!,
        requestedAt: mapValueOfType<String>(json, r'requestedAt')!,
        transactionId: mapValueOfType<String>(json, r'transactionId')!,
        partnerName: mapValueOfType<String>(json, r'partnerName')!,
        customerName: mapValueOfType<String>(json, r'customerName')!,
        caseType: PartnerRefundCaseType.fromJson(json[r'caseType'])!,
        amount: num.parse('${json[r'amount']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        owner: mapValueOfType<String>(json, r'owner')!,
        status: PartnerRefundCaseStatus.fromJson(json[r'status'])!,
        slaHours: num.parse('${json[r'slaHours']}'),
        slaBreached: mapValueOfType<bool>(json, r'slaBreached')!,
        riskTone: AdminFinanceRiskTone.fromJson(json[r'riskTone'])!,
      );
    }
    return null;
  }

  static List<AdminFinanceRefundCaseRecordDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceRefundCaseRecordDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceRefundCaseRecordDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceRefundCaseRecordDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceRefundCaseRecordDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceRefundCaseRecordDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceRefundCaseRecordDto-objects as value to a dart map
  static Map<String, List<AdminFinanceRefundCaseRecordDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceRefundCaseRecordDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceRefundCaseRecordDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'requestedAt',
    'transactionId',
    'partnerName',
    'customerName',
    'caseType',
    'amount',
    'currency',
    'reason',
    'owner',
    'status',
    'slaHours',
    'slaBreached',
    'riskTone',
  };
}

