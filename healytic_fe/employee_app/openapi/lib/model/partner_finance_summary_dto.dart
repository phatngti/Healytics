//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerFinanceSummaryDto {
  /// Returns a new [PartnerFinanceSummaryDto] instance.
  PartnerFinanceSummaryDto({
    required this.grossVolume,
    required this.netSettled,
    required this.pendingPayout,
    required this.refundExposure,
    required this.availableBalance,
    required this.pendingBalance,
    required this.currency,
    this.nextPayoutAt,
    this.payoutMethod,
    this.payoutStatus,
  });


  num grossVolume;

  num netSettled;

  num pendingPayout;

  num refundExposure;

  num availableBalance;

  num pendingBalance;

  String currency;

  String? nextPayoutAt;

  String? payoutMethod;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PartnerPayoutStatus? payoutStatus;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerFinanceSummaryDto &&
    other.grossVolume == grossVolume &&
    other.netSettled == netSettled &&
    other.pendingPayout == pendingPayout &&
    other.refundExposure == refundExposure &&
    other.availableBalance == availableBalance &&
    other.pendingBalance == pendingBalance &&
    other.currency == currency &&
    other.nextPayoutAt == nextPayoutAt &&
    other.payoutMethod == payoutMethod &&
    other.payoutStatus == payoutStatus;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (grossVolume.hashCode) +
    (netSettled.hashCode) +
    (pendingPayout.hashCode) +
    (refundExposure.hashCode) +
    (availableBalance.hashCode) +
    (pendingBalance.hashCode) +
    (currency.hashCode) +
    (nextPayoutAt == null ? 0 : nextPayoutAt!.hashCode) +
    (payoutMethod == null ? 0 : payoutMethod!.hashCode) +
    (payoutStatus == null ? 0 : payoutStatus!.hashCode);

  @override
  String toString() => 'PartnerFinanceSummaryDto[grossVolume=$grossVolume, netSettled=$netSettled, pendingPayout=$pendingPayout, refundExposure=$refundExposure, availableBalance=$availableBalance, pendingBalance=$pendingBalance, currency=$currency, nextPayoutAt=$nextPayoutAt, payoutMethod=$payoutMethod, payoutStatus=$payoutStatus]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'grossVolume'] = this.grossVolume;
      json[r'netSettled'] = this.netSettled;
      json[r'pendingPayout'] = this.pendingPayout;
      json[r'refundExposure'] = this.refundExposure;
      json[r'availableBalance'] = this.availableBalance;
      json[r'pendingBalance'] = this.pendingBalance;
      json[r'currency'] = this.currency;
    if (this.nextPayoutAt != null) {
      json[r'nextPayoutAt'] = this.nextPayoutAt;
    } else {
      json[r'nextPayoutAt'] = null;
    }
    if (this.payoutMethod != null) {
      json[r'payoutMethod'] = this.payoutMethod;
    } else {
      json[r'payoutMethod'] = null;
    }
    if (this.payoutStatus != null) {
      json[r'payoutStatus'] = this.payoutStatus;
    } else {
      json[r'payoutStatus'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerFinanceSummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerFinanceSummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerFinanceSummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerFinanceSummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerFinanceSummaryDto(
        grossVolume: num.parse('${json[r'grossVolume']}'),
        netSettled: num.parse('${json[r'netSettled']}'),
        pendingPayout: num.parse('${json[r'pendingPayout']}'),
        refundExposure: num.parse('${json[r'refundExposure']}'),
        availableBalance: num.parse('${json[r'availableBalance']}'),
        pendingBalance: num.parse('${json[r'pendingBalance']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        nextPayoutAt: mapValueOfType<String>(json, r'nextPayoutAt'),
        payoutMethod: mapValueOfType<String>(json, r'payoutMethod'),
        payoutStatus: PartnerPayoutStatus.fromJson(json[r'payoutStatus']),
      );
    }
    return null;
  }

  static List<PartnerFinanceSummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerFinanceSummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerFinanceSummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerFinanceSummaryDto> mapFromJson(dynamic json) {
    final map = <String, PartnerFinanceSummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerFinanceSummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerFinanceSummaryDto-objects as value to a dart map
  static Map<String, List<PartnerFinanceSummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerFinanceSummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerFinanceSummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'grossVolume',
    'netSettled',
    'pendingPayout',
    'refundExposure',
    'availableBalance',
    'pendingBalance',
    'currency',
  };
}

