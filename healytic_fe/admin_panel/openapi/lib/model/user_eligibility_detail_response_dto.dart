//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserEligibilityDetailResponseDto {
  /// Returns a new [UserEligibilityDetailResponseDto] instance.
  UserEligibilityDetailResponseDto({
    required this.isCompletedStep,
    this.bookingSchedule,
    required this.specialist,
    required this.service,
    required this.category,
    required this.location,
    required this.priceBreakdown,
  });

  bool isCompletedStep;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  BookingScheduleDto? bookingSchedule;

  SpecialistInfoDto specialist;

  ServiceInfoDto service;

  CategoryInfoDto category;

  LocationInfoDto location;

  PriceBreakdownDto priceBreakdown;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserEligibilityDetailResponseDto &&
    other.isCompletedStep == isCompletedStep &&
    other.bookingSchedule == bookingSchedule &&
    other.specialist == specialist &&
    other.service == service &&
    other.category == category &&
    other.location == location &&
    other.priceBreakdown == priceBreakdown;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (isCompletedStep.hashCode) +
    (bookingSchedule == null ? 0 : bookingSchedule!.hashCode) +
    (specialist.hashCode) +
    (service.hashCode) +
    (category.hashCode) +
    (location.hashCode) +
    (priceBreakdown.hashCode);

  @override
  String toString() => 'UserEligibilityDetailResponseDto[isCompletedStep=$isCompletedStep, bookingSchedule=$bookingSchedule, specialist=$specialist, service=$service, category=$category, location=$location, priceBreakdown=$priceBreakdown]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'isCompletedStep'] = this.isCompletedStep;
    if (this.bookingSchedule != null) {
      json[r'bookingSchedule'] = this.bookingSchedule;
    } else {
      json[r'bookingSchedule'] = null;
    }
      json[r'specialist'] = this.specialist;
      json[r'service'] = this.service;
      json[r'category'] = this.category;
      json[r'location'] = this.location;
      json[r'priceBreakdown'] = this.priceBreakdown;
    return json;
  }

  /// Returns a new [UserEligibilityDetailResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserEligibilityDetailResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserEligibilityDetailResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserEligibilityDetailResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserEligibilityDetailResponseDto(
        isCompletedStep: mapValueOfType<bool>(json, r'isCompletedStep')!,
        bookingSchedule: BookingScheduleDto.fromJson(json[r'bookingSchedule']),
        specialist: SpecialistInfoDto.fromJson(json[r'specialist'])!,
        service: ServiceInfoDto.fromJson(json[r'service'])!,
        category: CategoryInfoDto.fromJson(json[r'category'])!,
        location: LocationInfoDto.fromJson(json[r'location'])!,
        priceBreakdown: PriceBreakdownDto.fromJson(json[r'priceBreakdown'])!,
      );
    }
    return null;
  }

  static List<UserEligibilityDetailResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserEligibilityDetailResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserEligibilityDetailResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserEligibilityDetailResponseDto> mapFromJson(dynamic json) {
    final map = <String, UserEligibilityDetailResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserEligibilityDetailResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserEligibilityDetailResponseDto-objects as value to a dart map
  static Map<String, List<UserEligibilityDetailResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserEligibilityDetailResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserEligibilityDetailResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'isCompletedStep',
    'specialist',
    'service',
    'category',
    'location',
    'priceBreakdown',
  };
}

