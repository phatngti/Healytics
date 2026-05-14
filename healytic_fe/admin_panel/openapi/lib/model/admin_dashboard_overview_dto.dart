//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminDashboardOverviewDto {
  /// Returns a new [AdminDashboardOverviewDto] instance.
  AdminDashboardOverviewDto({
    required this.grossRevenue,
    required this.netRevenue,
    required this.refundAmount,
    required this.failedPaymentAmount,
    required this.averageBookingValue,
    required this.successfulTransactions,
    required this.pendingTransactions,
    required this.refundedTransactions,
    required this.failedTransactions,
    required this.canceledTransactions,
    required this.totalPartners,
    required this.pendingPartnerReviews,
    required this.bookingSuccessRate,
    required this.bookingFailedRate,
    required this.bookingCanceledRate,
    required this.notificationVolume,
  });


  num grossRevenue;

  num netRevenue;

  num refundAmount;

  num failedPaymentAmount;

  num averageBookingValue;

  num successfulTransactions;

  num pendingTransactions;

  num refundedTransactions;

  num failedTransactions;

  num canceledTransactions;

  num totalPartners;

  num pendingPartnerReviews;

  num bookingSuccessRate;

  num bookingFailedRate;

  num bookingCanceledRate;

  num notificationVolume;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboardOverviewDto &&
    other.grossRevenue == grossRevenue &&
    other.netRevenue == netRevenue &&
    other.refundAmount == refundAmount &&
    other.failedPaymentAmount == failedPaymentAmount &&
    other.averageBookingValue == averageBookingValue &&
    other.successfulTransactions == successfulTransactions &&
    other.pendingTransactions == pendingTransactions &&
    other.refundedTransactions == refundedTransactions &&
    other.failedTransactions == failedTransactions &&
    other.canceledTransactions == canceledTransactions &&
    other.totalPartners == totalPartners &&
    other.pendingPartnerReviews == pendingPartnerReviews &&
    other.bookingSuccessRate == bookingSuccessRate &&
    other.bookingFailedRate == bookingFailedRate &&
    other.bookingCanceledRate == bookingCanceledRate &&
    other.notificationVolume == notificationVolume;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (grossRevenue.hashCode) +
    (netRevenue.hashCode) +
    (refundAmount.hashCode) +
    (failedPaymentAmount.hashCode) +
    (averageBookingValue.hashCode) +
    (successfulTransactions.hashCode) +
    (pendingTransactions.hashCode) +
    (refundedTransactions.hashCode) +
    (failedTransactions.hashCode) +
    (canceledTransactions.hashCode) +
    (totalPartners.hashCode) +
    (pendingPartnerReviews.hashCode) +
    (bookingSuccessRate.hashCode) +
    (bookingFailedRate.hashCode) +
    (bookingCanceledRate.hashCode) +
    (notificationVolume.hashCode);

  @override
  String toString() => 'AdminDashboardOverviewDto[grossRevenue=$grossRevenue, netRevenue=$netRevenue, refundAmount=$refundAmount, failedPaymentAmount=$failedPaymentAmount, averageBookingValue=$averageBookingValue, successfulTransactions=$successfulTransactions, pendingTransactions=$pendingTransactions, refundedTransactions=$refundedTransactions, failedTransactions=$failedTransactions, canceledTransactions=$canceledTransactions, totalPartners=$totalPartners, pendingPartnerReviews=$pendingPartnerReviews, bookingSuccessRate=$bookingSuccessRate, bookingFailedRate=$bookingFailedRate, bookingCanceledRate=$bookingCanceledRate, notificationVolume=$notificationVolume]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'grossRevenue'] = this.grossRevenue;
      json[r'netRevenue'] = this.netRevenue;
      json[r'refundAmount'] = this.refundAmount;
      json[r'failedPaymentAmount'] = this.failedPaymentAmount;
      json[r'averageBookingValue'] = this.averageBookingValue;
      json[r'successfulTransactions'] = this.successfulTransactions;
      json[r'pendingTransactions'] = this.pendingTransactions;
      json[r'refundedTransactions'] = this.refundedTransactions;
      json[r'failedTransactions'] = this.failedTransactions;
      json[r'canceledTransactions'] = this.canceledTransactions;
      json[r'totalPartners'] = this.totalPartners;
      json[r'pendingPartnerReviews'] = this.pendingPartnerReviews;
      json[r'bookingSuccessRate'] = this.bookingSuccessRate;
      json[r'bookingFailedRate'] = this.bookingFailedRate;
      json[r'bookingCanceledRate'] = this.bookingCanceledRate;
      json[r'notificationVolume'] = this.notificationVolume;
    return json;
  }

  /// Returns a new [AdminDashboardOverviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboardOverviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminDashboardOverviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminDashboardOverviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminDashboardOverviewDto(
        grossRevenue: num.parse('${json[r'grossRevenue']}'),
        netRevenue: num.parse('${json[r'netRevenue']}'),
        refundAmount: num.parse('${json[r'refundAmount']}'),
        failedPaymentAmount: num.parse('${json[r'failedPaymentAmount']}'),
        averageBookingValue: num.parse('${json[r'averageBookingValue']}'),
        successfulTransactions: num.parse('${json[r'successfulTransactions']}'),
        pendingTransactions: num.parse('${json[r'pendingTransactions']}'),
        refundedTransactions: num.parse('${json[r'refundedTransactions']}'),
        failedTransactions: num.parse('${json[r'failedTransactions']}'),
        canceledTransactions: num.parse('${json[r'canceledTransactions']}'),
        totalPartners: num.parse('${json[r'totalPartners']}'),
        pendingPartnerReviews: num.parse('${json[r'pendingPartnerReviews']}'),
        bookingSuccessRate: num.parse('${json[r'bookingSuccessRate']}'),
        bookingFailedRate: num.parse('${json[r'bookingFailedRate']}'),
        bookingCanceledRate: num.parse('${json[r'bookingCanceledRate']}'),
        notificationVolume: num.parse('${json[r'notificationVolume']}'),
      );
    }
    return null;
  }

  static List<AdminDashboardOverviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboardOverviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboardOverviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboardOverviewDto> mapFromJson(dynamic json) {
    final map = <String, AdminDashboardOverviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboardOverviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboardOverviewDto-objects as value to a dart map
  static Map<String, List<AdminDashboardOverviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboardOverviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboardOverviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'grossRevenue',
    'netRevenue',
    'refundAmount',
    'failedPaymentAmount',
    'averageBookingValue',
    'successfulTransactions',
    'pendingTransactions',
    'refundedTransactions',
    'failedTransactions',
    'canceledTransactions',
    'totalPartners',
    'pendingPartnerReviews',
    'bookingSuccessRate',
    'bookingFailedRate',
    'bookingCanceledRate',
    'notificationVolume',
  };
}

