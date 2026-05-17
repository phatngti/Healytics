//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminDashboardBookingOutcomeSummaryDto {
  /// Returns a new [AdminDashboardBookingOutcomeSummaryDto] instance.
  AdminDashboardBookingOutcomeSummaryDto({
    required this.totalBookings,
    required this.success,
    required this.failed,
    required this.canceled,
  });


  num totalBookings;

  AdminOutcomeMetricDto success;

  AdminOutcomeMetricDto failed;

  AdminOutcomeMetricDto canceled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboardBookingOutcomeSummaryDto &&
    other.totalBookings == totalBookings &&
    other.success == success &&
    other.failed == failed &&
    other.canceled == canceled;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalBookings.hashCode) +
    (success.hashCode) +
    (failed.hashCode) +
    (canceled.hashCode);

  @override
  String toString() => 'AdminDashboardBookingOutcomeSummaryDto[totalBookings=$totalBookings, success=$success, failed=$failed, canceled=$canceled]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalBookings'] = this.totalBookings;
      json[r'success'] = this.success;
      json[r'failed'] = this.failed;
      json[r'canceled'] = this.canceled;
    return json;
  }

  /// Returns a new [AdminDashboardBookingOutcomeSummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboardBookingOutcomeSummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminDashboardBookingOutcomeSummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminDashboardBookingOutcomeSummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminDashboardBookingOutcomeSummaryDto(
        totalBookings: num.parse('${json[r'totalBookings']}'),
        success: AdminOutcomeMetricDto.fromJson(json[r'success'])!,
        failed: AdminOutcomeMetricDto.fromJson(json[r'failed'])!,
        canceled: AdminOutcomeMetricDto.fromJson(json[r'canceled'])!,
      );
    }
    return null;
  }

  static List<AdminDashboardBookingOutcomeSummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboardBookingOutcomeSummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboardBookingOutcomeSummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboardBookingOutcomeSummaryDto> mapFromJson(dynamic json) {
    final map = <String, AdminDashboardBookingOutcomeSummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboardBookingOutcomeSummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboardBookingOutcomeSummaryDto-objects as value to a dart map
  static Map<String, List<AdminDashboardBookingOutcomeSummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboardBookingOutcomeSummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboardBookingOutcomeSummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalBookings',
    'success',
    'failed',
    'canceled',
  };
}

