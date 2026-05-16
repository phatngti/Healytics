//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceTransactionRecordDto {
  /// Returns a new [AdminFinanceTransactionRecordDto] instance.
  AdminFinanceTransactionRecordDto({
    required this.id,
    required this.createdAt,
    required this.reference,
    required this.partnerName,
    required this.customerName,
    required this.sourceType,
    required this.type,
    required this.grossAmount,
    required this.feeAmount,
    required this.netAmount,
    required this.currency,
    required this.transactionStatus,
    required this.settlementStatus,
    required this.payoutStatus,
    required this.provider,
    required this.isFlagged,
    required this.notesCount,
    this.payoutId,
  });


  String id;

  String createdAt;

  String reference;

  String partnerName;

  String customerName;

  PartnerCommerceSourceType sourceType;

  PartnerTransactionType type;

  num grossAmount;

  num feeAmount;

  num netAmount;

  String currency;

  PartnerTransactionStatus transactionStatus;

  PartnerSettlementStatus settlementStatus;

  PartnerPayoutStatus payoutStatus;

  AdminFinanceProvider provider;

  bool isFlagged;

  num notesCount;

  String? payoutId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceTransactionRecordDto &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.reference == reference &&
    other.partnerName == partnerName &&
    other.customerName == customerName &&
    other.sourceType == sourceType &&
    other.type == type &&
    other.grossAmount == grossAmount &&
    other.feeAmount == feeAmount &&
    other.netAmount == netAmount &&
    other.currency == currency &&
    other.transactionStatus == transactionStatus &&
    other.settlementStatus == settlementStatus &&
    other.payoutStatus == payoutStatus &&
    other.provider == provider &&
    other.isFlagged == isFlagged &&
    other.notesCount == notesCount &&
    other.payoutId == payoutId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (reference.hashCode) +
    (partnerName.hashCode) +
    (customerName.hashCode) +
    (sourceType.hashCode) +
    (type.hashCode) +
    (grossAmount.hashCode) +
    (feeAmount.hashCode) +
    (netAmount.hashCode) +
    (currency.hashCode) +
    (transactionStatus.hashCode) +
    (settlementStatus.hashCode) +
    (payoutStatus.hashCode) +
    (provider.hashCode) +
    (isFlagged.hashCode) +
    (notesCount.hashCode) +
    (payoutId == null ? 0 : payoutId!.hashCode);

  @override
  String toString() => 'AdminFinanceTransactionRecordDto[id=$id, createdAt=$createdAt, reference=$reference, partnerName=$partnerName, customerName=$customerName, sourceType=$sourceType, type=$type, grossAmount=$grossAmount, feeAmount=$feeAmount, netAmount=$netAmount, currency=$currency, transactionStatus=$transactionStatus, settlementStatus=$settlementStatus, payoutStatus=$payoutStatus, provider=$provider, isFlagged=$isFlagged, notesCount=$notesCount, payoutId=$payoutId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt;
      json[r'reference'] = this.reference;
      json[r'partnerName'] = this.partnerName;
      json[r'customerName'] = this.customerName;
      json[r'sourceType'] = this.sourceType;
      json[r'type'] = this.type;
      json[r'grossAmount'] = this.grossAmount;
      json[r'feeAmount'] = this.feeAmount;
      json[r'netAmount'] = this.netAmount;
      json[r'currency'] = this.currency;
      json[r'transactionStatus'] = this.transactionStatus;
      json[r'settlementStatus'] = this.settlementStatus;
      json[r'payoutStatus'] = this.payoutStatus;
      json[r'provider'] = this.provider;
      json[r'isFlagged'] = this.isFlagged;
      json[r'notesCount'] = this.notesCount;
    if (this.payoutId != null) {
      json[r'payoutId'] = this.payoutId;
    } else {
      json[r'payoutId'] = null;
    }
    return json;
  }

  /// Returns a new [AdminFinanceTransactionRecordDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceTransactionRecordDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceTransactionRecordDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceTransactionRecordDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceTransactionRecordDto(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
        reference: mapValueOfType<String>(json, r'reference')!,
        partnerName: mapValueOfType<String>(json, r'partnerName')!,
        customerName: mapValueOfType<String>(json, r'customerName')!,
        sourceType: PartnerCommerceSourceType.fromJson(json[r'sourceType'])!,
        type: PartnerTransactionType.fromJson(json[r'type'])!,
        grossAmount: num.parse('${json[r'grossAmount']}'),
        feeAmount: num.parse('${json[r'feeAmount']}'),
        netAmount: num.parse('${json[r'netAmount']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        transactionStatus: PartnerTransactionStatus.fromJson(json[r'transactionStatus'])!,
        settlementStatus: PartnerSettlementStatus.fromJson(json[r'settlementStatus'])!,
        payoutStatus: PartnerPayoutStatus.fromJson(json[r'payoutStatus'])!,
        provider: AdminFinanceProvider.fromJson(json[r'provider'])!,
        isFlagged: mapValueOfType<bool>(json, r'isFlagged')!,
        notesCount: num.parse('${json[r'notesCount']}'),
        payoutId: mapValueOfType<String>(json, r'payoutId'),
      );
    }
    return null;
  }

  static List<AdminFinanceTransactionRecordDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceTransactionRecordDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceTransactionRecordDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceTransactionRecordDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceTransactionRecordDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceTransactionRecordDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceTransactionRecordDto-objects as value to a dart map
  static Map<String, List<AdminFinanceTransactionRecordDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceTransactionRecordDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceTransactionRecordDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'reference',
    'partnerName',
    'customerName',
    'sourceType',
    'type',
    'grossAmount',
    'feeAmount',
    'netAmount',
    'currency',
    'transactionStatus',
    'settlementStatus',
    'payoutStatus',
    'provider',
    'isFlagged',
    'notesCount',
  };
}

