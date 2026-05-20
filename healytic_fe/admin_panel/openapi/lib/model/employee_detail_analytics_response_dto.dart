//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeDetailAnalyticsResponseDto {
  /// Returns a new [EmployeeDetailAnalyticsResponseDto] instance.
  EmployeeDetailAnalyticsResponseDto({
    required this.employeeId,
    required this.completedSessions,
    required this.sessionsDelta,
    required this.contributionValue,
    required this.contributionDelta,
    required this.utilizationRate,
    required this.utilizationDelta,
    required this.averageRating,
    required this.reviewCount,
    this.trendPoints = const [],
    this.mixMetrics = const [],
    this.scheduleLoad = const [],
    this.qualityMetrics = const [],
    this.complianceItems = const [],
  });


  String employeeId;

  num completedSessions;

  /// % change vs previous period
  num sessionsDelta;

  /// Contribution value in VND
  num contributionValue;

  num contributionDelta;

  num utilizationRate;

  num utilizationDelta;

  num averageRating;

  num reviewCount;

  List<EmployeeTrendPointDto> trendPoints;

  List<EmployeeMixMetricDto> mixMetrics;

  List<EmployeeScheduleLoadDto> scheduleLoad;

  List<EmployeeQualityMetricDto> qualityMetrics;

  List<EmployeeComplianceItemDto> complianceItems;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeDetailAnalyticsResponseDto &&
    other.employeeId == employeeId &&
    other.completedSessions == completedSessions &&
    other.sessionsDelta == sessionsDelta &&
    other.contributionValue == contributionValue &&
    other.contributionDelta == contributionDelta &&
    other.utilizationRate == utilizationRate &&
    other.utilizationDelta == utilizationDelta &&
    other.averageRating == averageRating &&
    other.reviewCount == reviewCount &&
    _deepEquality.equals(other.trendPoints, trendPoints) &&
    _deepEquality.equals(other.mixMetrics, mixMetrics) &&
    _deepEquality.equals(other.scheduleLoad, scheduleLoad) &&
    _deepEquality.equals(other.qualityMetrics, qualityMetrics) &&
    _deepEquality.equals(other.complianceItems, complianceItems);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeId.hashCode) +
    (completedSessions.hashCode) +
    (sessionsDelta.hashCode) +
    (contributionValue.hashCode) +
    (contributionDelta.hashCode) +
    (utilizationRate.hashCode) +
    (utilizationDelta.hashCode) +
    (averageRating.hashCode) +
    (reviewCount.hashCode) +
    (trendPoints.hashCode) +
    (mixMetrics.hashCode) +
    (scheduleLoad.hashCode) +
    (qualityMetrics.hashCode) +
    (complianceItems.hashCode);

  @override
  String toString() => 'EmployeeDetailAnalyticsResponseDto[employeeId=$employeeId, completedSessions=$completedSessions, sessionsDelta=$sessionsDelta, contributionValue=$contributionValue, contributionDelta=$contributionDelta, utilizationRate=$utilizationRate, utilizationDelta=$utilizationDelta, averageRating=$averageRating, reviewCount=$reviewCount, trendPoints=$trendPoints, mixMetrics=$mixMetrics, scheduleLoad=$scheduleLoad, qualityMetrics=$qualityMetrics, complianceItems=$complianceItems]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'employeeId'] = this.employeeId;
      json[r'completedSessions'] = this.completedSessions;
      json[r'sessionsDelta'] = this.sessionsDelta;
      json[r'contributionValue'] = this.contributionValue;
      json[r'contributionDelta'] = this.contributionDelta;
      json[r'utilizationRate'] = this.utilizationRate;
      json[r'utilizationDelta'] = this.utilizationDelta;
      json[r'averageRating'] = this.averageRating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'trendPoints'] = this.trendPoints;
      json[r'mixMetrics'] = this.mixMetrics;
      json[r'scheduleLoad'] = this.scheduleLoad;
      json[r'qualityMetrics'] = this.qualityMetrics;
      json[r'complianceItems'] = this.complianceItems;
    return json;
  }

  /// Returns a new [EmployeeDetailAnalyticsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeDetailAnalyticsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeDetailAnalyticsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeDetailAnalyticsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeDetailAnalyticsResponseDto(
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        completedSessions: num.parse('${json[r'completedSessions']}'),
        sessionsDelta: num.parse('${json[r'sessionsDelta']}'),
        contributionValue: num.parse('${json[r'contributionValue']}'),
        contributionDelta: num.parse('${json[r'contributionDelta']}'),
        utilizationRate: num.parse('${json[r'utilizationRate']}'),
        utilizationDelta: num.parse('${json[r'utilizationDelta']}'),
        averageRating: num.parse('${json[r'averageRating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        trendPoints: EmployeeTrendPointDto.listFromJson(json[r'trendPoints']),
        mixMetrics: EmployeeMixMetricDto.listFromJson(json[r'mixMetrics']),
        scheduleLoad: EmployeeScheduleLoadDto.listFromJson(json[r'scheduleLoad']),
        qualityMetrics: EmployeeQualityMetricDto.listFromJson(json[r'qualityMetrics']),
        complianceItems: EmployeeComplianceItemDto.listFromJson(json[r'complianceItems']),
      );
    }
    return null;
  }

  static List<EmployeeDetailAnalyticsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeDetailAnalyticsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeDetailAnalyticsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeDetailAnalyticsResponseDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeDetailAnalyticsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeDetailAnalyticsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeDetailAnalyticsResponseDto-objects as value to a dart map
  static Map<String, List<EmployeeDetailAnalyticsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeDetailAnalyticsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeDetailAnalyticsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'employeeId',
    'completedSessions',
    'sessionsDelta',
    'contributionValue',
    'contributionDelta',
    'utilizationRate',
    'utilizationDelta',
    'averageRating',
    'reviewCount',
    'trendPoints',
    'mixMetrics',
    'scheduleLoad',
    'qualityMetrics',
    'complianceItems',
  };
}

