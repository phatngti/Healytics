//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinancePayoutRecordDto {
  /// Returns a new [AdminFinancePayoutRecordDto] instance.
  AdminFinancePayoutRecordDto({
    required this.id,
    required this.scheduledDate,
    required this.partnerName,
    required this.periodLabel,
    required this.includedVolume,
    required this.feesAndAdjustments,
    required this.netPayout,
    required this.currency,
    required this.method,
    required this.status,
    required this.attemptCount,
    required this.notesCount,
    this.failureReason,
    this.holdReason,
  });


  String id;

  String scheduledDate;

  String partnerName;

  String periodLabel;

  num includedVolume;

  num feesAndAdjustments;

  num netPayout;

  String currency;

  String method;

  PartnerPayoutStatus status;

  num attemptCount;

  num notesCount;

  String? failureReason;

  String? holdReason;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinancePayoutRecordDto &&
    other.id == id &&
    other.scheduledDate == scheduledDate &&
    other.partnerName == partnerName &&
    other.periodLabel == periodLabel &&
    other.includedVolume == includedVolume &&
    other.feesAndAdjustments == feesAndAdjustments &&
    other.netPayout == netPayout &&
    other.currency == currency &&
    other.method == method &&
    other.status == status &&
    other.attemptCount == attemptCount &&
    other.notesCount == notesCount &&
    other.failureReason == failureReason &&
    other.holdReason == holdReason;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (scheduledDate.hashCode) +
    (partnerName.hashCode) +
    (periodLabel.hashCode) +
    (includedVolume.hashCode) +
    (feesAndAdjustments.hashCode) +
    (netPayout.hashCode) +
    (currency.hashCode) +
    (method.hashCode) +
    (status.hashCode) +
    (attemptCount.hashCode) +
    (notesCount.hashCode) +
    (failureReason == null ? 0 : failureReason!.hashCode) +
    (holdReason == null ? 0 : holdReason!.hashCode);

  @override
  String toString() => 'AdminFinancePayoutRecordDto[id=$id, scheduledDate=$scheduledDate, partnerName=$partnerName, periodLabel=$periodLabel, includedVolume=$includedVolume, feesAndAdjustments=$feesAndAdjustments, netPayout=$netPayout, currency=$currency, method=$method, status=$status, attemptCount=$attemptCount, notesCount=$notesCount, failureReason=$failureReason, holdReason=$holdReason]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'scheduledDate'] = this.scheduledDate;
      json[r'partnerName'] = this.partnerName;
      json[r'periodLabel'] = this.periodLabel;
      json[r'includedVolume'] = this.includedVolume;
      json[r'feesAndAdjustments'] = this.feesAndAdjustments;
      json[r'netPayout'] = this.netPayout;
      json[r'currency'] = this.currency;
      json[r'method'] = this.method;
      json[r'status'] = this.status;
      json[r'attemptCount'] = this.attemptCount;
      json[r'notesCount'] = this.notesCount;
    if (this.failureReason != null) {
      json[r'failureReason'] = this.failureReason;
    } else {
      json[r'failureReason'] = null;
    }
    if (this.holdReason != null) {
      json[r'holdReason'] = this.holdReason;
    } else {
      json[r'holdReason'] = null;
    }
    return json;
  }

  /// Returns a new [AdminFinancePayoutRecordDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinancePayoutRecordDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinancePayoutRecordDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinancePayoutRecordDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinancePayoutRecordDto(
        id: mapValueOfType<String>(json, r'id')!,
        scheduledDate: mapValueOfType<String>(json, r'scheduledDate')!,
        partnerName: mapValueOfType<String>(json, r'partnerName')!,
        periodLabel: mapValueOfType<String>(json, r'periodLabel')!,
        includedVolume: num.parse('${json[r'includedVolume']}'),
        feesAndAdjustments: num.parse('${json[r'feesAndAdjustments']}'),
        netPayout: num.parse('${json[r'netPayout']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        method: mapValueOfType<String>(json, r'method')!,
        status: PartnerPayoutStatus.fromJson(json[r'status'])!,
        attemptCount: num.parse('${json[r'attemptCount']}'),
        notesCount: num.parse('${json[r'notesCount']}'),
        failureReason: mapValueOfType<String>(json, r'failureReason'),
        holdReason: mapValueOfType<String>(json, r'holdReason'),
      );
    }
    return null;
  }

  static List<AdminFinancePayoutRecordDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinancePayoutRecordDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinancePayoutRecordDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinancePayoutRecordDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinancePayoutRecordDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinancePayoutRecordDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinancePayoutRecordDto-objects as value to a dart map
  static Map<String, List<AdminFinancePayoutRecordDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinancePayoutRecordDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinancePayoutRecordDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'scheduledDate',
    'partnerName',
    'periodLabel',
    'includedVolume',
    'feesAndAdjustments',
    'netPayout',
    'currency',
    'method',
    'status',
    'attemptCount',
    'notesCount',
  };
}

