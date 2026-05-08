//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeRevenueSummaryResponseDto {
  /// Returns a new [EmployeeRevenueSummaryResponseDto] instance.
  EmployeeRevenueSummaryResponseDto({
    required this.totalRevenue,
    required this.totalCommission,
    required this.netEarnings,
    required this.completedAppointments,
    required this.canceledAppointments,
    required this.period,
    required this.periodStart,
    required this.periodEnd,
  });


  /// Total revenue from completed appointments
  num totalRevenue;

  /// Total commission deducted
  num totalCommission;

  /// Net earnings after commission
  num netEarnings;

  /// Number of completed appointments
  num completedAppointments;

  /// Number of canceled appointments
  num canceledAppointments;

  EmployeeRevenuePeriod period;

  /// Start of the aggregation period
  DateTime periodStart;

  /// End of the aggregation period
  DateTime periodEnd;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeRevenueSummaryResponseDto &&
    other.totalRevenue == totalRevenue &&
    other.totalCommission == totalCommission &&
    other.netEarnings == netEarnings &&
    other.completedAppointments == completedAppointments &&
    other.canceledAppointments == canceledAppointments &&
    other.period == period &&
    other.periodStart == periodStart &&
    other.periodEnd == periodEnd;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalRevenue.hashCode) +
    (totalCommission.hashCode) +
    (netEarnings.hashCode) +
    (completedAppointments.hashCode) +
    (canceledAppointments.hashCode) +
    (period.hashCode) +
    (periodStart.hashCode) +
    (periodEnd.hashCode);

  @override
  String toString() => 'EmployeeRevenueSummaryResponseDto[totalRevenue=$totalRevenue, totalCommission=$totalCommission, netEarnings=$netEarnings, completedAppointments=$completedAppointments, canceledAppointments=$canceledAppointments, period=$period, periodStart=$periodStart, periodEnd=$periodEnd]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalRevenue'] = this.totalRevenue;
      json[r'totalCommission'] = this.totalCommission;
      json[r'netEarnings'] = this.netEarnings;
      json[r'completedAppointments'] = this.completedAppointments;
      json[r'canceledAppointments'] = this.canceledAppointments;
      json[r'period'] = this.period;
      json[r'periodStart'] = this.periodStart.toUtc().toIso8601String();
      json[r'periodEnd'] = this.periodEnd.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [EmployeeRevenueSummaryResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeRevenueSummaryResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeRevenueSummaryResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeRevenueSummaryResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeRevenueSummaryResponseDto(
        totalRevenue: num.parse('${json[r'totalRevenue']}'),
        totalCommission: num.parse('${json[r'totalCommission']}'),
        netEarnings: num.parse('${json[r'netEarnings']}'),
        completedAppointments: num.parse('${json[r'completedAppointments']}'),
        canceledAppointments: num.parse('${json[r'canceledAppointments']}'),
        period: EmployeeRevenuePeriod.fromJson(json[r'period'])!,
        periodStart: mapDateTime(json, r'periodStart', r'')!,
        periodEnd: mapDateTime(json, r'periodEnd', r'')!,
      );
    }
    return null;
  }

  static List<EmployeeRevenueSummaryResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeRevenueSummaryResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeRevenueSummaryResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeRevenueSummaryResponseDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeRevenueSummaryResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeRevenueSummaryResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeRevenueSummaryResponseDto-objects as value to a dart map
  static Map<String, List<EmployeeRevenueSummaryResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeRevenueSummaryResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeRevenueSummaryResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalRevenue',
    'totalCommission',
    'netEarnings',
    'completedAppointments',
    'canceledAppointments',
    'period',
    'periodStart',
    'periodEnd',
  };
}

