//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DashboardStatsResponseDto {
  /// Returns a new [DashboardStatsResponseDto] instance.
  DashboardStatsResponseDto({
    required this.totalAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.pendingAppointments,
    required this.totalRevenue,
    required this.revenueGrowthPercent,
    required this.totalServices,
    required this.activeServices,
    required this.totalEmployees,
    required this.activeEmployees,
    required this.averageRating,
    required this.totalReviews,
  });

  num totalAppointments;

  num completedAppointments;

  num cancelledAppointments;

  num pendingAppointments;

  /// Total revenue in VND
  num totalRevenue;

  /// Revenue growth % vs previous period
  num revenueGrowthPercent;

  num totalServices;

  num activeServices;

  num totalEmployees;

  num activeEmployees;

  /// Weighted average rating
  num averageRating;

  num totalReviews;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DashboardStatsResponseDto &&
    other.totalAppointments == totalAppointments &&
    other.completedAppointments == completedAppointments &&
    other.cancelledAppointments == cancelledAppointments &&
    other.pendingAppointments == pendingAppointments &&
    other.totalRevenue == totalRevenue &&
    other.revenueGrowthPercent == revenueGrowthPercent &&
    other.totalServices == totalServices &&
    other.activeServices == activeServices &&
    other.totalEmployees == totalEmployees &&
    other.activeEmployees == activeEmployees &&
    other.averageRating == averageRating &&
    other.totalReviews == totalReviews;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalAppointments.hashCode) +
    (completedAppointments.hashCode) +
    (cancelledAppointments.hashCode) +
    (pendingAppointments.hashCode) +
    (totalRevenue.hashCode) +
    (revenueGrowthPercent.hashCode) +
    (totalServices.hashCode) +
    (activeServices.hashCode) +
    (totalEmployees.hashCode) +
    (activeEmployees.hashCode) +
    (averageRating.hashCode) +
    (totalReviews.hashCode);

  @override
  String toString() => 'DashboardStatsResponseDto[totalAppointments=$totalAppointments, completedAppointments=$completedAppointments, cancelledAppointments=$cancelledAppointments, pendingAppointments=$pendingAppointments, totalRevenue=$totalRevenue, revenueGrowthPercent=$revenueGrowthPercent, totalServices=$totalServices, activeServices=$activeServices, totalEmployees=$totalEmployees, activeEmployees=$activeEmployees, averageRating=$averageRating, totalReviews=$totalReviews]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalAppointments'] = this.totalAppointments;
      json[r'completedAppointments'] = this.completedAppointments;
      json[r'cancelledAppointments'] = this.cancelledAppointments;
      json[r'pendingAppointments'] = this.pendingAppointments;
      json[r'totalRevenue'] = this.totalRevenue;
      json[r'revenueGrowthPercent'] = this.revenueGrowthPercent;
      json[r'totalServices'] = this.totalServices;
      json[r'activeServices'] = this.activeServices;
      json[r'totalEmployees'] = this.totalEmployees;
      json[r'activeEmployees'] = this.activeEmployees;
      json[r'averageRating'] = this.averageRating;
      json[r'totalReviews'] = this.totalReviews;
    return json;
  }

  /// Returns a new [DashboardStatsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DashboardStatsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DashboardStatsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DashboardStatsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DashboardStatsResponseDto(
        totalAppointments: num.parse('${json[r'totalAppointments']}'),
        completedAppointments: num.parse('${json[r'completedAppointments']}'),
        cancelledAppointments: num.parse('${json[r'cancelledAppointments']}'),
        pendingAppointments: num.parse('${json[r'pendingAppointments']}'),
        totalRevenue: num.parse('${json[r'totalRevenue']}'),
        revenueGrowthPercent: num.parse('${json[r'revenueGrowthPercent']}'),
        totalServices: num.parse('${json[r'totalServices']}'),
        activeServices: num.parse('${json[r'activeServices']}'),
        totalEmployees: num.parse('${json[r'totalEmployees']}'),
        activeEmployees: num.parse('${json[r'activeEmployees']}'),
        averageRating: num.parse('${json[r'averageRating']}'),
        totalReviews: num.parse('${json[r'totalReviews']}'),
      );
    }
    return null;
  }

  static List<DashboardStatsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardStatsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardStatsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DashboardStatsResponseDto> mapFromJson(dynamic json) {
    final map = <String, DashboardStatsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DashboardStatsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DashboardStatsResponseDto-objects as value to a dart map
  static Map<String, List<DashboardStatsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DashboardStatsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DashboardStatsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalAppointments',
    'completedAppointments',
    'cancelledAppointments',
    'pendingAppointments',
    'totalRevenue',
    'revenueGrowthPercent',
    'totalServices',
    'activeServices',
    'totalEmployees',
    'activeEmployees',
    'averageRating',
    'totalReviews',
  };
}

