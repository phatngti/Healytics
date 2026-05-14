//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminDashboardRevenueTrendPointDto {
  /// Returns a new [AdminDashboardRevenueTrendPointDto] instance.
  AdminDashboardRevenueTrendPointDto({
    required this.date,
    required this.grossRevenue,
    required this.netRevenue,
    required this.refundAmount,
    required this.transactionCount,
    required this.successfulBookingCount,
  });


  String date;

  num grossRevenue;

  num netRevenue;

  num refundAmount;

  num transactionCount;

  num successfulBookingCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboardRevenueTrendPointDto &&
    other.date == date &&
    other.grossRevenue == grossRevenue &&
    other.netRevenue == netRevenue &&
    other.refundAmount == refundAmount &&
    other.transactionCount == transactionCount &&
    other.successfulBookingCount == successfulBookingCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (grossRevenue.hashCode) +
    (netRevenue.hashCode) +
    (refundAmount.hashCode) +
    (transactionCount.hashCode) +
    (successfulBookingCount.hashCode);

  @override
  String toString() => 'AdminDashboardRevenueTrendPointDto[date=$date, grossRevenue=$grossRevenue, netRevenue=$netRevenue, refundAmount=$refundAmount, transactionCount=$transactionCount, successfulBookingCount=$successfulBookingCount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = this.date;
      json[r'grossRevenue'] = this.grossRevenue;
      json[r'netRevenue'] = this.netRevenue;
      json[r'refundAmount'] = this.refundAmount;
      json[r'transactionCount'] = this.transactionCount;
      json[r'successfulBookingCount'] = this.successfulBookingCount;
    return json;
  }

  /// Returns a new [AdminDashboardRevenueTrendPointDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboardRevenueTrendPointDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminDashboardRevenueTrendPointDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminDashboardRevenueTrendPointDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminDashboardRevenueTrendPointDto(
        date: mapValueOfType<String>(json, r'date')!,
        grossRevenue: num.parse('${json[r'grossRevenue']}'),
        netRevenue: num.parse('${json[r'netRevenue']}'),
        refundAmount: num.parse('${json[r'refundAmount']}'),
        transactionCount: num.parse('${json[r'transactionCount']}'),
        successfulBookingCount: num.parse('${json[r'successfulBookingCount']}'),
      );
    }
    return null;
  }

  static List<AdminDashboardRevenueTrendPointDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboardRevenueTrendPointDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboardRevenueTrendPointDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboardRevenueTrendPointDto> mapFromJson(dynamic json) {
    final map = <String, AdminDashboardRevenueTrendPointDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboardRevenueTrendPointDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboardRevenueTrendPointDto-objects as value to a dart map
  static Map<String, List<AdminDashboardRevenueTrendPointDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboardRevenueTrendPointDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboardRevenueTrendPointDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'grossRevenue',
    'netRevenue',
    'refundAmount',
    'transactionCount',
    'successfulBookingCount',
  };
}

