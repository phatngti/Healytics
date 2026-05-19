//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerBookingResponseDto {
  /// Returns a new [PartnerBookingResponseDto] instance.
  PartnerBookingResponseDto({
    required this.id,
    required this.customer,
    required this.specialist,
    required this.service,
    required this.slot,
    required this.status,
  });


  String id;

  PartnerBookingCustomerDto customer;

  PartnerBookingSpecialistDto specialist;

  PartnerBookingServiceDto service;

  PartnerBookingSlotDto slot;

  PartnerBookingStatus status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerBookingResponseDto &&
    other.id == id &&
    other.customer == customer &&
    other.specialist == specialist &&
    other.service == service &&
    other.slot == slot &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (customer.hashCode) +
    (specialist.hashCode) +
    (service.hashCode) +
    (slot.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'PartnerBookingResponseDto[id=$id, customer=$customer, specialist=$specialist, service=$service, slot=$slot, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'customer'] = this.customer;
      json[r'specialist'] = this.specialist;
      json[r'service'] = this.service;
      json[r'slot'] = this.slot;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [PartnerBookingResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerBookingResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerBookingResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerBookingResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerBookingResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        customer: PartnerBookingCustomerDto.fromJson(json[r'customer'])!,
        specialist: PartnerBookingSpecialistDto.fromJson(json[r'specialist'])!,
        service: PartnerBookingServiceDto.fromJson(json[r'service'])!,
        slot: PartnerBookingSlotDto.fromJson(json[r'slot'])!,
        status: PartnerBookingStatus.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<PartnerBookingResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerBookingResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerBookingResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerBookingResponseDto> mapFromJson(dynamic json) {
    final map = <String, PartnerBookingResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerBookingResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerBookingResponseDto-objects as value to a dart map
  static Map<String, List<PartnerBookingResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerBookingResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerBookingResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'customer',
    'specialist',
    'service',
    'slot',
    'status',
  };
}

