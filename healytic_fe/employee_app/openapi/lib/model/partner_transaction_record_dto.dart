//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerTransactionRecordDto {
  /// Returns a new [PartnerTransactionRecordDto] instance.
  PartnerTransactionRecordDto({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.sourceType,
    required this.reference,
    required this.customerName,
    required this.grossAmount,
    required this.feeAmount,
    required this.netAmount,
    required this.currency,
    required this.status,
    required this.settlementStatus,
    required this.payoutStatus,
    required this.paymentMethod,
    required this.sourceTitle,
    required this.sourceSubtitle,
    this.timeline = const [],
    required this.flaggedForReview,
    this.notes,
    this.payoutId,
  });


  String id;

  String createdAt;

  PartnerTransactionType type;

  PartnerCommerceSourceType sourceType;

  String reference;

  String customerName;

  num grossAmount;

  num feeAmount;

  num netAmount;

  String currency;

  PartnerTransactionStatus status;

  PartnerSettlementStatus settlementStatus;

  PartnerPayoutStatus payoutStatus;

  String paymentMethod;

  String sourceTitle;

  String sourceSubtitle;

  List<PartnerTransactionTimelineEventDto> timeline;

  bool flaggedForReview;

  String? notes;

  String? payoutId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerTransactionRecordDto &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.type == type &&
    other.sourceType == sourceType &&
    other.reference == reference &&
    other.customerName == customerName &&
    other.grossAmount == grossAmount &&
    other.feeAmount == feeAmount &&
    other.netAmount == netAmount &&
    other.currency == currency &&
    other.status == status &&
    other.settlementStatus == settlementStatus &&
    other.payoutStatus == payoutStatus &&
    other.paymentMethod == paymentMethod &&
    other.sourceTitle == sourceTitle &&
    other.sourceSubtitle == sourceSubtitle &&
    _deepEquality.equals(other.timeline, timeline) &&
    other.flaggedForReview == flaggedForReview &&
    other.notes == notes &&
    other.payoutId == payoutId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (sourceType.hashCode) +
    (reference.hashCode) +
    (customerName.hashCode) +
    (grossAmount.hashCode) +
    (feeAmount.hashCode) +
    (netAmount.hashCode) +
    (currency.hashCode) +
    (status.hashCode) +
    (settlementStatus.hashCode) +
    (payoutStatus.hashCode) +
    (paymentMethod.hashCode) +
    (sourceTitle.hashCode) +
    (sourceSubtitle.hashCode) +
    (timeline.hashCode) +
    (flaggedForReview.hashCode) +
    (notes == null ? 0 : notes!.hashCode) +
    (payoutId == null ? 0 : payoutId!.hashCode);

  @override
  String toString() => 'PartnerTransactionRecordDto[id=$id, createdAt=$createdAt, type=$type, sourceType=$sourceType, reference=$reference, customerName=$customerName, grossAmount=$grossAmount, feeAmount=$feeAmount, netAmount=$netAmount, currency=$currency, status=$status, settlementStatus=$settlementStatus, payoutStatus=$payoutStatus, paymentMethod=$paymentMethod, sourceTitle=$sourceTitle, sourceSubtitle=$sourceSubtitle, timeline=$timeline, flaggedForReview=$flaggedForReview, notes=$notes, payoutId=$payoutId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt;
      json[r'type'] = this.type;
      json[r'sourceType'] = this.sourceType;
      json[r'reference'] = this.reference;
      json[r'customerName'] = this.customerName;
      json[r'grossAmount'] = this.grossAmount;
      json[r'feeAmount'] = this.feeAmount;
      json[r'netAmount'] = this.netAmount;
      json[r'currency'] = this.currency;
      json[r'status'] = this.status;
      json[r'settlementStatus'] = this.settlementStatus;
      json[r'payoutStatus'] = this.payoutStatus;
      json[r'paymentMethod'] = this.paymentMethod;
      json[r'sourceTitle'] = this.sourceTitle;
      json[r'sourceSubtitle'] = this.sourceSubtitle;
      json[r'timeline'] = this.timeline;
      json[r'flaggedForReview'] = this.flaggedForReview;
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    if (this.payoutId != null) {
      json[r'payoutId'] = this.payoutId;
    } else {
      json[r'payoutId'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerTransactionRecordDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerTransactionRecordDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerTransactionRecordDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerTransactionRecordDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerTransactionRecordDto(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
        type: PartnerTransactionType.fromJson(json[r'type'])!,
        sourceType: PartnerCommerceSourceType.fromJson(json[r'sourceType'])!,
        reference: mapValueOfType<String>(json, r'reference')!,
        customerName: mapValueOfType<String>(json, r'customerName')!,
        grossAmount: num.parse('${json[r'grossAmount']}'),
        feeAmount: num.parse('${json[r'feeAmount']}'),
        netAmount: num.parse('${json[r'netAmount']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        status: PartnerTransactionStatus.fromJson(json[r'status'])!,
        settlementStatus: PartnerSettlementStatus.fromJson(json[r'settlementStatus'])!,
        payoutStatus: PartnerPayoutStatus.fromJson(json[r'payoutStatus'])!,
        paymentMethod: mapValueOfType<String>(json, r'paymentMethod')!,
        sourceTitle: mapValueOfType<String>(json, r'sourceTitle')!,
        sourceSubtitle: mapValueOfType<String>(json, r'sourceSubtitle')!,
        timeline: PartnerTransactionTimelineEventDto.listFromJson(json[r'timeline']),
        flaggedForReview: mapValueOfType<bool>(json, r'flaggedForReview')!,
        notes: mapValueOfType<String>(json, r'notes'),
        payoutId: mapValueOfType<String>(json, r'payoutId'),
      );
    }
    return null;
  }

  static List<PartnerTransactionRecordDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerTransactionRecordDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerTransactionRecordDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerTransactionRecordDto> mapFromJson(dynamic json) {
    final map = <String, PartnerTransactionRecordDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerTransactionRecordDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerTransactionRecordDto-objects as value to a dart map
  static Map<String, List<PartnerTransactionRecordDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerTransactionRecordDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerTransactionRecordDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'type',
    'sourceType',
    'reference',
    'customerName',
    'grossAmount',
    'feeAmount',
    'netAmount',
    'currency',
    'status',
    'settlementStatus',
    'payoutStatus',
    'paymentMethod',
    'sourceTitle',
    'sourceSubtitle',
    'timeline',
    'flaggedForReview',
  };
}

