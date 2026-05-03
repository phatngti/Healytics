//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerPayoutRecordDto {
  /// Returns a new [PartnerPayoutRecordDto] instance.
  PartnerPayoutRecordDto({
    required this.id,
    required this.periodLabel,
    required this.includedVolume,
    required this.feesAdjustments,
    required this.netPayout,
    required this.scheduledDate,
    required this.method,
    required this.status,
    required this.currency,
    this.includedTransactionIds = const [],
  });


  String id;

  String periodLabel;

  num includedVolume;

  num feesAdjustments;

  num netPayout;

  String scheduledDate;

  String method;

  PartnerPayoutStatus status;

  String currency;

  List<String> includedTransactionIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerPayoutRecordDto &&
    other.id == id &&
    other.periodLabel == periodLabel &&
    other.includedVolume == includedVolume &&
    other.feesAdjustments == feesAdjustments &&
    other.netPayout == netPayout &&
    other.scheduledDate == scheduledDate &&
    other.method == method &&
    other.status == status &&
    other.currency == currency &&
    _deepEquality.equals(other.includedTransactionIds, includedTransactionIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (periodLabel.hashCode) +
    (includedVolume.hashCode) +
    (feesAdjustments.hashCode) +
    (netPayout.hashCode) +
    (scheduledDate.hashCode) +
    (method.hashCode) +
    (status.hashCode) +
    (currency.hashCode) +
    (includedTransactionIds.hashCode);

  @override
  String toString() => 'PartnerPayoutRecordDto[id=$id, periodLabel=$periodLabel, includedVolume=$includedVolume, feesAdjustments=$feesAdjustments, netPayout=$netPayout, scheduledDate=$scheduledDate, method=$method, status=$status, currency=$currency, includedTransactionIds=$includedTransactionIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'periodLabel'] = this.periodLabel;
      json[r'includedVolume'] = this.includedVolume;
      json[r'feesAdjustments'] = this.feesAdjustments;
      json[r'netPayout'] = this.netPayout;
      json[r'scheduledDate'] = this.scheduledDate;
      json[r'method'] = this.method;
      json[r'status'] = this.status;
      json[r'currency'] = this.currency;
      json[r'includedTransactionIds'] = this.includedTransactionIds;
    return json;
  }

  /// Returns a new [PartnerPayoutRecordDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerPayoutRecordDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerPayoutRecordDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerPayoutRecordDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerPayoutRecordDto(
        id: mapValueOfType<String>(json, r'id')!,
        periodLabel: mapValueOfType<String>(json, r'periodLabel')!,
        includedVolume: num.parse('${json[r'includedVolume']}'),
        feesAdjustments: num.parse('${json[r'feesAdjustments']}'),
        netPayout: num.parse('${json[r'netPayout']}'),
        scheduledDate: mapValueOfType<String>(json, r'scheduledDate')!,
        method: mapValueOfType<String>(json, r'method')!,
        status: PartnerPayoutStatus.fromJson(json[r'status'])!,
        currency: mapValueOfType<String>(json, r'currency')!,
        includedTransactionIds: json[r'includedTransactionIds'] is Iterable
            ? (json[r'includedTransactionIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<PartnerPayoutRecordDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerPayoutRecordDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerPayoutRecordDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerPayoutRecordDto> mapFromJson(dynamic json) {
    final map = <String, PartnerPayoutRecordDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerPayoutRecordDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerPayoutRecordDto-objects as value to a dart map
  static Map<String, List<PartnerPayoutRecordDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerPayoutRecordDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerPayoutRecordDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'periodLabel',
    'includedVolume',
    'feesAdjustments',
    'netPayout',
    'scheduledDate',
    'method',
    'status',
    'currency',
    'includedTransactionIds',
  };
}

