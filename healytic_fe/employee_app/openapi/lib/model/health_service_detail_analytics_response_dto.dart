//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class HealthServiceDetailAnalyticsResponseDto {
  /// Returns a new [HealthServiceDetailAnalyticsResponseDto] instance.
  HealthServiceDetailAnalyticsResponseDto({
    required this.productId,
    required this.bookings,
    required this.bookingsDelta,
    required this.revenue,
    required this.revenueDelta,
    required this.completionRate,
    required this.completionRateDelta,
    required this.averageRating,
    required this.reviewCount,
    this.trendPoints = const [],
    this.reviewDistribution = const [],
    this.operationalMetrics = const [],
    this.peerRanking = const [],
    this.alerts = const [],
  });


  String productId;

  num bookings;

  num bookingsDelta;

  /// Revenue in VND
  num revenue;

  num revenueDelta;

  /// % of bookings that completed
  num completionRate;

  num completionRateDelta;

  num averageRating;

  num reviewCount;

  List<AnalyticsTrendPointDto> trendPoints;

  List<AnalyticsReviewBucketDto> reviewDistribution;

  List<AnalyticsOperationalMetricDto> operationalMetrics;

  List<AnalyticsServicePerformanceDto> peerRanking;

  List<AnalyticsAlertDto> alerts;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HealthServiceDetailAnalyticsResponseDto &&
    other.productId == productId &&
    other.bookings == bookings &&
    other.bookingsDelta == bookingsDelta &&
    other.revenue == revenue &&
    other.revenueDelta == revenueDelta &&
    other.completionRate == completionRate &&
    other.completionRateDelta == completionRateDelta &&
    other.averageRating == averageRating &&
    other.reviewCount == reviewCount &&
    _deepEquality.equals(other.trendPoints, trendPoints) &&
    _deepEquality.equals(other.reviewDistribution, reviewDistribution) &&
    _deepEquality.equals(other.operationalMetrics, operationalMetrics) &&
    _deepEquality.equals(other.peerRanking, peerRanking) &&
    _deepEquality.equals(other.alerts, alerts);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (productId.hashCode) +
    (bookings.hashCode) +
    (bookingsDelta.hashCode) +
    (revenue.hashCode) +
    (revenueDelta.hashCode) +
    (completionRate.hashCode) +
    (completionRateDelta.hashCode) +
    (averageRating.hashCode) +
    (reviewCount.hashCode) +
    (trendPoints.hashCode) +
    (reviewDistribution.hashCode) +
    (operationalMetrics.hashCode) +
    (peerRanking.hashCode) +
    (alerts.hashCode);

  @override
  String toString() => 'HealthServiceDetailAnalyticsResponseDto[productId=$productId, bookings=$bookings, bookingsDelta=$bookingsDelta, revenue=$revenue, revenueDelta=$revenueDelta, completionRate=$completionRate, completionRateDelta=$completionRateDelta, averageRating=$averageRating, reviewCount=$reviewCount, trendPoints=$trendPoints, reviewDistribution=$reviewDistribution, operationalMetrics=$operationalMetrics, peerRanking=$peerRanking, alerts=$alerts]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'productId'] = this.productId;
      json[r'bookings'] = this.bookings;
      json[r'bookingsDelta'] = this.bookingsDelta;
      json[r'revenue'] = this.revenue;
      json[r'revenueDelta'] = this.revenueDelta;
      json[r'completionRate'] = this.completionRate;
      json[r'completionRateDelta'] = this.completionRateDelta;
      json[r'averageRating'] = this.averageRating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'trendPoints'] = this.trendPoints;
      json[r'reviewDistribution'] = this.reviewDistribution;
      json[r'operationalMetrics'] = this.operationalMetrics;
      json[r'peerRanking'] = this.peerRanking;
      json[r'alerts'] = this.alerts;
    return json;
  }

  /// Returns a new [HealthServiceDetailAnalyticsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HealthServiceDetailAnalyticsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "HealthServiceDetailAnalyticsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "HealthServiceDetailAnalyticsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return HealthServiceDetailAnalyticsResponseDto(
        productId: mapValueOfType<String>(json, r'productId')!,
        bookings: num.parse('${json[r'bookings']}'),
        bookingsDelta: num.parse('${json[r'bookingsDelta']}'),
        revenue: num.parse('${json[r'revenue']}'),
        revenueDelta: num.parse('${json[r'revenueDelta']}'),
        completionRate: num.parse('${json[r'completionRate']}'),
        completionRateDelta: num.parse('${json[r'completionRateDelta']}'),
        averageRating: num.parse('${json[r'averageRating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        trendPoints: AnalyticsTrendPointDto.listFromJson(json[r'trendPoints']),
        reviewDistribution: AnalyticsReviewBucketDto.listFromJson(json[r'reviewDistribution']),
        operationalMetrics: AnalyticsOperationalMetricDto.listFromJson(json[r'operationalMetrics']),
        peerRanking: AnalyticsServicePerformanceDto.listFromJson(json[r'peerRanking']),
        alerts: AnalyticsAlertDto.listFromJson(json[r'alerts']),
      );
    }
    return null;
  }

  static List<HealthServiceDetailAnalyticsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HealthServiceDetailAnalyticsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HealthServiceDetailAnalyticsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HealthServiceDetailAnalyticsResponseDto> mapFromJson(dynamic json) {
    final map = <String, HealthServiceDetailAnalyticsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HealthServiceDetailAnalyticsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HealthServiceDetailAnalyticsResponseDto-objects as value to a dart map
  static Map<String, List<HealthServiceDetailAnalyticsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<HealthServiceDetailAnalyticsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HealthServiceDetailAnalyticsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'productId',
    'bookings',
    'bookingsDelta',
    'revenue',
    'revenueDelta',
    'completionRate',
    'completionRateDelta',
    'averageRating',
    'reviewCount',
    'trendPoints',
    'reviewDistribution',
    'operationalMetrics',
    'peerRanking',
    'alerts',
  };
}

