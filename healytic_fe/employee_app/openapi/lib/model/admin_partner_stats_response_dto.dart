//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminPartnerStatsResponseDto {
  /// Returns a new [AdminPartnerStatsResponseDto] instance.
  AdminPartnerStatsResponseDto({
    required this.pendingReview,
    required this.highPriority,
    required this.activeToday,
    required this.avgWaitSeconds,
    required this.avgWaitTime,
    required this.totalProviders,
    required this.requiredResubmit,
    required this.approved,
    required this.rejected,
  });


  /// Partners awaiting admin review
  num pendingReview;

  /// Review-queue partners with HIGH or URGENT priority
  num highPriority;

  /// Approved providers (active today v1)
  num activeToday;

  /// Average wait time in seconds
  num avgWaitSeconds;

  /// Formatted average wait time
  String avgWaitTime;

  /// Total providers across all statuses
  num totalProviders;

  /// Partners in REQUIRED_RESUBMIT status
  num requiredResubmit;

  /// Partners with APPROVED status
  num approved;

  /// Partners with REJECTED status
  num rejected;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPartnerStatsResponseDto &&
    other.pendingReview == pendingReview &&
    other.highPriority == highPriority &&
    other.activeToday == activeToday &&
    other.avgWaitSeconds == avgWaitSeconds &&
    other.avgWaitTime == avgWaitTime &&
    other.totalProviders == totalProviders &&
    other.requiredResubmit == requiredResubmit &&
    other.approved == approved &&
    other.rejected == rejected;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (pendingReview.hashCode) +
    (highPriority.hashCode) +
    (activeToday.hashCode) +
    (avgWaitSeconds.hashCode) +
    (avgWaitTime.hashCode) +
    (totalProviders.hashCode) +
    (requiredResubmit.hashCode) +
    (approved.hashCode) +
    (rejected.hashCode);

  @override
  String toString() => 'AdminPartnerStatsResponseDto[pendingReview=$pendingReview, highPriority=$highPriority, activeToday=$activeToday, avgWaitSeconds=$avgWaitSeconds, avgWaitTime=$avgWaitTime, totalProviders=$totalProviders, requiredResubmit=$requiredResubmit, approved=$approved, rejected=$rejected]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'pendingReview'] = this.pendingReview;
      json[r'highPriority'] = this.highPriority;
      json[r'activeToday'] = this.activeToday;
      json[r'avgWaitSeconds'] = this.avgWaitSeconds;
      json[r'avgWaitTime'] = this.avgWaitTime;
      json[r'totalProviders'] = this.totalProviders;
      json[r'requiredResubmit'] = this.requiredResubmit;
      json[r'approved'] = this.approved;
      json[r'rejected'] = this.rejected;
    return json;
  }

  /// Returns a new [AdminPartnerStatsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPartnerStatsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminPartnerStatsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminPartnerStatsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminPartnerStatsResponseDto(
        pendingReview: num.parse('${json[r'pendingReview']}'),
        highPriority: num.parse('${json[r'highPriority']}'),
        activeToday: num.parse('${json[r'activeToday']}'),
        avgWaitSeconds: num.parse('${json[r'avgWaitSeconds']}'),
        avgWaitTime: mapValueOfType<String>(json, r'avgWaitTime')!,
        totalProviders: num.parse('${json[r'totalProviders']}'),
        requiredResubmit: num.parse('${json[r'requiredResubmit']}'),
        approved: num.parse('${json[r'approved']}'),
        rejected: num.parse('${json[r'rejected']}'),
      );
    }
    return null;
  }

  static List<AdminPartnerStatsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerStatsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerStatsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPartnerStatsResponseDto> mapFromJson(dynamic json) {
    final map = <String, AdminPartnerStatsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPartnerStatsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPartnerStatsResponseDto-objects as value to a dart map
  static Map<String, List<AdminPartnerStatsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPartnerStatsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPartnerStatsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'pendingReview',
    'highPriority',
    'activeToday',
    'avgWaitSeconds',
    'avgWaitTime',
    'totalProviders',
    'requiredResubmit',
    'approved',
    'rejected',
  };
}

