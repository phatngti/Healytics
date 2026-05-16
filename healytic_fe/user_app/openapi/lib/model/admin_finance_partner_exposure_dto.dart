//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinancePartnerExposureDto {
  /// Returns a new [AdminFinancePartnerExposureDto] instance.
  AdminFinancePartnerExposureDto({
    required this.partnerId,
    required this.partnerName,
    required this.totalVolume,
    required this.pendingPayouts,
    required this.refundExposure,
    required this.failedPayments,
    required this.heldFunds,
    required this.currency,
    required this.riskTone,
  });


  String partnerId;

  String partnerName;

  num totalVolume;

  num pendingPayouts;

  num refundExposure;

  num failedPayments;

  num heldFunds;

  String currency;

  AdminFinanceRiskTone riskTone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinancePartnerExposureDto &&
    other.partnerId == partnerId &&
    other.partnerName == partnerName &&
    other.totalVolume == totalVolume &&
    other.pendingPayouts == pendingPayouts &&
    other.refundExposure == refundExposure &&
    other.failedPayments == failedPayments &&
    other.heldFunds == heldFunds &&
    other.currency == currency &&
    other.riskTone == riskTone;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (partnerId.hashCode) +
    (partnerName.hashCode) +
    (totalVolume.hashCode) +
    (pendingPayouts.hashCode) +
    (refundExposure.hashCode) +
    (failedPayments.hashCode) +
    (heldFunds.hashCode) +
    (currency.hashCode) +
    (riskTone.hashCode);

  @override
  String toString() => 'AdminFinancePartnerExposureDto[partnerId=$partnerId, partnerName=$partnerName, totalVolume=$totalVolume, pendingPayouts=$pendingPayouts, refundExposure=$refundExposure, failedPayments=$failedPayments, heldFunds=$heldFunds, currency=$currency, riskTone=$riskTone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'partnerId'] = this.partnerId;
      json[r'partnerName'] = this.partnerName;
      json[r'totalVolume'] = this.totalVolume;
      json[r'pendingPayouts'] = this.pendingPayouts;
      json[r'refundExposure'] = this.refundExposure;
      json[r'failedPayments'] = this.failedPayments;
      json[r'heldFunds'] = this.heldFunds;
      json[r'currency'] = this.currency;
      json[r'riskTone'] = this.riskTone;
    return json;
  }

  /// Returns a new [AdminFinancePartnerExposureDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinancePartnerExposureDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinancePartnerExposureDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinancePartnerExposureDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinancePartnerExposureDto(
        partnerId: mapValueOfType<String>(json, r'partnerId')!,
        partnerName: mapValueOfType<String>(json, r'partnerName')!,
        totalVolume: num.parse('${json[r'totalVolume']}'),
        pendingPayouts: num.parse('${json[r'pendingPayouts']}'),
        refundExposure: num.parse('${json[r'refundExposure']}'),
        failedPayments: num.parse('${json[r'failedPayments']}'),
        heldFunds: num.parse('${json[r'heldFunds']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        riskTone: AdminFinanceRiskTone.fromJson(json[r'riskTone'])!,
      );
    }
    return null;
  }

  static List<AdminFinancePartnerExposureDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinancePartnerExposureDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinancePartnerExposureDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinancePartnerExposureDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinancePartnerExposureDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinancePartnerExposureDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinancePartnerExposureDto-objects as value to a dart map
  static Map<String, List<AdminFinancePartnerExposureDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinancePartnerExposureDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinancePartnerExposureDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'partnerId',
    'partnerName',
    'totalVolume',
    'pendingPayouts',
    'refundExposure',
    'failedPayments',
    'heldFunds',
    'currency',
    'riskTone',
  };
}

