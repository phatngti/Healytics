//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeOverviewAnalyticsResponseDto {
  /// Returns a new [EmployeeOverviewAnalyticsResponseDto] instance.
  EmployeeOverviewAnalyticsResponseDto({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.onLeaveEmployees,
    required this.inactiveEmployees,
    required this.utilizationRate,
    required this.utilizationDelta,
    required this.averageRating,
    required this.ratingDelta,
    required this.reviewCount,
    this.trendPoints = const [],
    this.roleDistribution = const [],
    this.topPerformers = const [],
    this.complianceItems = const [],
  });


  num totalEmployees;

  num activeEmployees;

  num onLeaveEmployees;

  num inactiveEmployees;

  /// Aggregate utilization rate percentage
  num utilizationRate;

  /// % change vs previous period
  num utilizationDelta;

  num averageRating;

  num ratingDelta;

  num reviewCount;

  List<EmployeeTrendPointDto> trendPoints;

  List<EmployeeRoleDistributionDto> roleDistribution;

  List<EmployeePerformanceSummaryDto> topPerformers;

  List<EmployeeComplianceItemDto> complianceItems;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeOverviewAnalyticsResponseDto &&
    other.totalEmployees == totalEmployees &&
    other.activeEmployees == activeEmployees &&
    other.onLeaveEmployees == onLeaveEmployees &&
    other.inactiveEmployees == inactiveEmployees &&
    other.utilizationRate == utilizationRate &&
    other.utilizationDelta == utilizationDelta &&
    other.averageRating == averageRating &&
    other.ratingDelta == ratingDelta &&
    other.reviewCount == reviewCount &&
    _deepEquality.equals(other.trendPoints, trendPoints) &&
    _deepEquality.equals(other.roleDistribution, roleDistribution) &&
    _deepEquality.equals(other.topPerformers, topPerformers) &&
    _deepEquality.equals(other.complianceItems, complianceItems);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalEmployees.hashCode) +
    (activeEmployees.hashCode) +
    (onLeaveEmployees.hashCode) +
    (inactiveEmployees.hashCode) +
    (utilizationRate.hashCode) +
    (utilizationDelta.hashCode) +
    (averageRating.hashCode) +
    (ratingDelta.hashCode) +
    (reviewCount.hashCode) +
    (trendPoints.hashCode) +
    (roleDistribution.hashCode) +
    (topPerformers.hashCode) +
    (complianceItems.hashCode);

  @override
  String toString() => 'EmployeeOverviewAnalyticsResponseDto[totalEmployees=$totalEmployees, activeEmployees=$activeEmployees, onLeaveEmployees=$onLeaveEmployees, inactiveEmployees=$inactiveEmployees, utilizationRate=$utilizationRate, utilizationDelta=$utilizationDelta, averageRating=$averageRating, ratingDelta=$ratingDelta, reviewCount=$reviewCount, trendPoints=$trendPoints, roleDistribution=$roleDistribution, topPerformers=$topPerformers, complianceItems=$complianceItems]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalEmployees'] = this.totalEmployees;
      json[r'activeEmployees'] = this.activeEmployees;
      json[r'onLeaveEmployees'] = this.onLeaveEmployees;
      json[r'inactiveEmployees'] = this.inactiveEmployees;
      json[r'utilizationRate'] = this.utilizationRate;
      json[r'utilizationDelta'] = this.utilizationDelta;
      json[r'averageRating'] = this.averageRating;
      json[r'ratingDelta'] = this.ratingDelta;
      json[r'reviewCount'] = this.reviewCount;
      json[r'trendPoints'] = this.trendPoints;
      json[r'roleDistribution'] = this.roleDistribution;
      json[r'topPerformers'] = this.topPerformers;
      json[r'complianceItems'] = this.complianceItems;
    return json;
  }

  /// Returns a new [EmployeeOverviewAnalyticsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeOverviewAnalyticsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeOverviewAnalyticsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeOverviewAnalyticsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeOverviewAnalyticsResponseDto(
        totalEmployees: num.parse('${json[r'totalEmployees']}'),
        activeEmployees: num.parse('${json[r'activeEmployees']}'),
        onLeaveEmployees: num.parse('${json[r'onLeaveEmployees']}'),
        inactiveEmployees: num.parse('${json[r'inactiveEmployees']}'),
        utilizationRate: num.parse('${json[r'utilizationRate']}'),
        utilizationDelta: num.parse('${json[r'utilizationDelta']}'),
        averageRating: num.parse('${json[r'averageRating']}'),
        ratingDelta: num.parse('${json[r'ratingDelta']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        trendPoints: EmployeeTrendPointDto.listFromJson(json[r'trendPoints']),
        roleDistribution: EmployeeRoleDistributionDto.listFromJson(json[r'roleDistribution']),
        topPerformers: EmployeePerformanceSummaryDto.listFromJson(json[r'topPerformers']),
        complianceItems: EmployeeComplianceItemDto.listFromJson(json[r'complianceItems']),
      );
    }
    return null;
  }

  static List<EmployeeOverviewAnalyticsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeOverviewAnalyticsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeOverviewAnalyticsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeOverviewAnalyticsResponseDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeOverviewAnalyticsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeOverviewAnalyticsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeOverviewAnalyticsResponseDto-objects as value to a dart map
  static Map<String, List<EmployeeOverviewAnalyticsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeOverviewAnalyticsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeOverviewAnalyticsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalEmployees',
    'activeEmployees',
    'onLeaveEmployees',
    'inactiveEmployees',
    'utilizationRate',
    'utilizationDelta',
    'averageRating',
    'ratingDelta',
    'reviewCount',
    'trendPoints',
    'roleDistribution',
    'topPerformers',
    'complianceItems',
  };
}

