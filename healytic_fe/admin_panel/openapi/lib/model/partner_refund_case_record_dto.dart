//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerRefundCaseRecordDto {
  /// Returns a new [PartnerRefundCaseRecordDto] instance.
  PartnerRefundCaseRecordDto({
    required this.id,
    required this.transactionId,
    required this.caseType,
    required this.requestedAt,
    required this.amount,
    required this.currency,
    required this.reason,
    required this.owner,
    required this.status,
    required this.slaHours,
  });


  String id;

  String transactionId;

  PartnerRefundCaseType caseType;

  String requestedAt;

  num amount;

  String currency;

  String reason;

  String owner;

  PartnerRefundCaseStatus status;

  /// Remaining SLA hours (0 for resolved cases)
  num slaHours;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerRefundCaseRecordDto &&
    other.id == id &&
    other.transactionId == transactionId &&
    other.caseType == caseType &&
    other.requestedAt == requestedAt &&
    other.amount == amount &&
    other.currency == currency &&
    other.reason == reason &&
    other.owner == owner &&
    other.status == status &&
    other.slaHours == slaHours;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (transactionId.hashCode) +
    (caseType.hashCode) +
    (requestedAt.hashCode) +
    (amount.hashCode) +
    (currency.hashCode) +
    (reason.hashCode) +
    (owner.hashCode) +
    (status.hashCode) +
    (slaHours.hashCode);

  @override
  String toString() => 'PartnerRefundCaseRecordDto[id=$id, transactionId=$transactionId, caseType=$caseType, requestedAt=$requestedAt, amount=$amount, currency=$currency, reason=$reason, owner=$owner, status=$status, slaHours=$slaHours]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'transactionId'] = this.transactionId;
      json[r'caseType'] = this.caseType;
      json[r'requestedAt'] = this.requestedAt;
      json[r'amount'] = this.amount;
      json[r'currency'] = this.currency;
      json[r'reason'] = this.reason;
      json[r'owner'] = this.owner;
      json[r'status'] = this.status;
      json[r'slaHours'] = this.slaHours;
    return json;
  }

  /// Returns a new [PartnerRefundCaseRecordDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerRefundCaseRecordDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerRefundCaseRecordDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerRefundCaseRecordDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerRefundCaseRecordDto(
        id: mapValueOfType<String>(json, r'id')!,
        transactionId: mapValueOfType<String>(json, r'transactionId')!,
        caseType: PartnerRefundCaseType.fromJson(json[r'caseType'])!,
        requestedAt: mapValueOfType<String>(json, r'requestedAt')!,
        amount: num.parse('${json[r'amount']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        owner: mapValueOfType<String>(json, r'owner')!,
        status: PartnerRefundCaseStatus.fromJson(json[r'status'])!,
        slaHours: num.parse('${json[r'slaHours']}'),
      );
    }
    return null;
  }

  static List<PartnerRefundCaseRecordDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerRefundCaseRecordDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerRefundCaseRecordDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerRefundCaseRecordDto> mapFromJson(dynamic json) {
    final map = <String, PartnerRefundCaseRecordDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerRefundCaseRecordDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerRefundCaseRecordDto-objects as value to a dart map
  static Map<String, List<PartnerRefundCaseRecordDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerRefundCaseRecordDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerRefundCaseRecordDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'transactionId',
    'caseType',
    'requestedAt',
    'amount',
    'currency',
    'reason',
    'owner',
    'status',
    'slaHours',
  };
}

