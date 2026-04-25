//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnalyticsBookingMetricsDto {
  /// Returns a new [AnalyticsBookingMetricsDto] instance.
  AnalyticsBookingMetricsDto({
    required this.totalBookings,
    required this.delayedBookings,
    required this.delayThresholdMinutes,
    required this.pendingBookings,
    required this.completedBookings,
    this.statusBreakdown = const [],
    this.alerts = const [],
  });


  num totalBookings;

  /// Bookings exceeding delay threshold
  num delayedBookings;

  /// Delay threshold in minutes
  num delayThresholdMinutes;

  /// PENDING_PAYMENT + CONFIRMED bookings
  num pendingBookings;

  num completedBookings;

  /// Per-status counts
  List<BookingStatusBreakdownDto> statusBreakdown;

  /// Operational alerts for booking health
  List<AnalyticsAlertDto> alerts;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnalyticsBookingMetricsDto &&
    other.totalBookings == totalBookings &&
    other.delayedBookings == delayedBookings &&
    other.delayThresholdMinutes == delayThresholdMinutes &&
    other.pendingBookings == pendingBookings &&
    other.completedBookings == completedBookings &&
    _deepEquality.equals(other.statusBreakdown, statusBreakdown) &&
    _deepEquality.equals(other.alerts, alerts);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalBookings.hashCode) +
    (delayedBookings.hashCode) +
    (delayThresholdMinutes.hashCode) +
    (pendingBookings.hashCode) +
    (completedBookings.hashCode) +
    (statusBreakdown.hashCode) +
    (alerts.hashCode);

  @override
  String toString() => 'AnalyticsBookingMetricsDto[totalBookings=$totalBookings, delayedBookings=$delayedBookings, delayThresholdMinutes=$delayThresholdMinutes, pendingBookings=$pendingBookings, completedBookings=$completedBookings, statusBreakdown=$statusBreakdown, alerts=$alerts]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalBookings'] = this.totalBookings;
      json[r'delayedBookings'] = this.delayedBookings;
      json[r'delayThresholdMinutes'] = this.delayThresholdMinutes;
      json[r'pendingBookings'] = this.pendingBookings;
      json[r'completedBookings'] = this.completedBookings;
      json[r'statusBreakdown'] = this.statusBreakdown;
      json[r'alerts'] = this.alerts;
    return json;
  }

  /// Returns a new [AnalyticsBookingMetricsDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnalyticsBookingMetricsDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AnalyticsBookingMetricsDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AnalyticsBookingMetricsDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AnalyticsBookingMetricsDto(
        totalBookings: num.parse('${json[r'totalBookings']}'),
        delayedBookings: num.parse('${json[r'delayedBookings']}'),
        delayThresholdMinutes: num.parse('${json[r'delayThresholdMinutes']}'),
        pendingBookings: num.parse('${json[r'pendingBookings']}'),
        completedBookings: num.parse('${json[r'completedBookings']}'),
        statusBreakdown: BookingStatusBreakdownDto.listFromJson(json[r'statusBreakdown']),
        alerts: AnalyticsAlertDto.listFromJson(json[r'alerts']),
      );
    }
    return null;
  }

  static List<AnalyticsBookingMetricsDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsBookingMetricsDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsBookingMetricsDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnalyticsBookingMetricsDto> mapFromJson(dynamic json) {
    final map = <String, AnalyticsBookingMetricsDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnalyticsBookingMetricsDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnalyticsBookingMetricsDto-objects as value to a dart map
  static Map<String, List<AnalyticsBookingMetricsDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnalyticsBookingMetricsDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnalyticsBookingMetricsDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalBookings',
    'delayedBookings',
    'delayThresholdMinutes',
    'pendingBookings',
    'completedBookings',
    'statusBreakdown',
    'alerts',
  };
}

