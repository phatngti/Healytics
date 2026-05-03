//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class HealthServiceOverviewAnalyticsResponseDto {
  /// Returns a new [HealthServiceOverviewAnalyticsResponseDto] instance.
  HealthServiceOverviewAnalyticsResponseDto({
    required this.totalProducts,
    required this.activeProducts,
    required this.bookings,
    required this.bookingsDelta,
    required this.revenue,
    required this.revenueDelta,
    required this.averageRating,
    required this.ratingDelta,
    required this.reviewCount,
    required this.bookingMetrics,
    this.trendPoints = const [],
    this.categoryPerformance = const [],
    this.topServices = const [],
  });


  num totalProducts;

  num activeProducts;

  /// Completed bookings in the selected period
  num bookings;

  /// % change vs previous period
  num bookingsDelta;

  /// Revenue in VND
  num revenue;

  num revenueDelta;

  num averageRating;

  num ratingDelta;

  num reviewCount;

  AnalyticsBookingMetricsDto bookingMetrics;

  List<AnalyticsTrendPointDto> trendPoints;

  List<AnalyticsCategoryPerformanceDto> categoryPerformance;

  List<AnalyticsServicePerformanceDto> topServices;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HealthServiceOverviewAnalyticsResponseDto &&
    other.totalProducts == totalProducts &&
    other.activeProducts == activeProducts &&
    other.bookings == bookings &&
    other.bookingsDelta == bookingsDelta &&
    other.revenue == revenue &&
    other.revenueDelta == revenueDelta &&
    other.averageRating == averageRating &&
    other.ratingDelta == ratingDelta &&
    other.reviewCount == reviewCount &&
    other.bookingMetrics == bookingMetrics &&
    _deepEquality.equals(other.trendPoints, trendPoints) &&
    _deepEquality.equals(other.categoryPerformance, categoryPerformance) &&
    _deepEquality.equals(other.topServices, topServices);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalProducts.hashCode) +
    (activeProducts.hashCode) +
    (bookings.hashCode) +
    (bookingsDelta.hashCode) +
    (revenue.hashCode) +
    (revenueDelta.hashCode) +
    (averageRating.hashCode) +
    (ratingDelta.hashCode) +
    (reviewCount.hashCode) +
    (bookingMetrics.hashCode) +
    (trendPoints.hashCode) +
    (categoryPerformance.hashCode) +
    (topServices.hashCode);

  @override
  String toString() => 'HealthServiceOverviewAnalyticsResponseDto[totalProducts=$totalProducts, activeProducts=$activeProducts, bookings=$bookings, bookingsDelta=$bookingsDelta, revenue=$revenue, revenueDelta=$revenueDelta, averageRating=$averageRating, ratingDelta=$ratingDelta, reviewCount=$reviewCount, bookingMetrics=$bookingMetrics, trendPoints=$trendPoints, categoryPerformance=$categoryPerformance, topServices=$topServices]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalProducts'] = this.totalProducts;
      json[r'activeProducts'] = this.activeProducts;
      json[r'bookings'] = this.bookings;
      json[r'bookingsDelta'] = this.bookingsDelta;
      json[r'revenue'] = this.revenue;
      json[r'revenueDelta'] = this.revenueDelta;
      json[r'averageRating'] = this.averageRating;
      json[r'ratingDelta'] = this.ratingDelta;
      json[r'reviewCount'] = this.reviewCount;
      json[r'bookingMetrics'] = this.bookingMetrics;
      json[r'trendPoints'] = this.trendPoints;
      json[r'categoryPerformance'] = this.categoryPerformance;
      json[r'topServices'] = this.topServices;
    return json;
  }

  /// Returns a new [HealthServiceOverviewAnalyticsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HealthServiceOverviewAnalyticsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "HealthServiceOverviewAnalyticsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "HealthServiceOverviewAnalyticsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return HealthServiceOverviewAnalyticsResponseDto(
        totalProducts: num.parse('${json[r'totalProducts']}'),
        activeProducts: num.parse('${json[r'activeProducts']}'),
        bookings: num.parse('${json[r'bookings']}'),
        bookingsDelta: num.parse('${json[r'bookingsDelta']}'),
        revenue: num.parse('${json[r'revenue']}'),
        revenueDelta: num.parse('${json[r'revenueDelta']}'),
        averageRating: num.parse('${json[r'averageRating']}'),
        ratingDelta: num.parse('${json[r'ratingDelta']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        bookingMetrics: AnalyticsBookingMetricsDto.fromJson(json[r'bookingMetrics'])!,
        trendPoints: AnalyticsTrendPointDto.listFromJson(json[r'trendPoints']),
        categoryPerformance: AnalyticsCategoryPerformanceDto.listFromJson(json[r'categoryPerformance']),
        topServices: AnalyticsServicePerformanceDto.listFromJson(json[r'topServices']),
      );
    }
    return null;
  }

  static List<HealthServiceOverviewAnalyticsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HealthServiceOverviewAnalyticsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HealthServiceOverviewAnalyticsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HealthServiceOverviewAnalyticsResponseDto> mapFromJson(dynamic json) {
    final map = <String, HealthServiceOverviewAnalyticsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HealthServiceOverviewAnalyticsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HealthServiceOverviewAnalyticsResponseDto-objects as value to a dart map
  static Map<String, List<HealthServiceOverviewAnalyticsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<HealthServiceOverviewAnalyticsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HealthServiceOverviewAnalyticsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalProducts',
    'activeProducts',
    'bookings',
    'bookingsDelta',
    'revenue',
    'revenueDelta',
    'averageRating',
    'ratingDelta',
    'reviewCount',
    'bookingMetrics',
    'trendPoints',
    'categoryPerformance',
    'topServices',
  };
}

