//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaginatedEmployeeAppointmentsResponseDto {
  /// Returns a new [PaginatedEmployeeAppointmentsResponseDto] instance.
  PaginatedEmployeeAppointmentsResponseDto({
    this.data = const [],
    required this.meta,
  });


  /// List of appointments
  List<EmployeeAppointmentResponseDto> data;

  /// Pagination metadata
  PaginationMetaResponseDto meta;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaginatedEmployeeAppointmentsResponseDto &&
    _deepEquality.equals(other.data, data) &&
    other.meta == meta;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (data.hashCode) +
    (meta.hashCode);

  @override
  String toString() => 'PaginatedEmployeeAppointmentsResponseDto[data=$data, meta=$meta]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'data'] = this.data;
      json[r'meta'] = this.meta;
    return json;
  }

  /// Returns a new [PaginatedEmployeeAppointmentsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaginatedEmployeeAppointmentsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PaginatedEmployeeAppointmentsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PaginatedEmployeeAppointmentsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PaginatedEmployeeAppointmentsResponseDto(
        data: EmployeeAppointmentResponseDto.listFromJson(json[r'data']),
        meta: PaginationMetaResponseDto.fromJson(json[r'meta'])!,
      );
    }
    return null;
  }

  static List<PaginatedEmployeeAppointmentsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaginatedEmployeeAppointmentsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaginatedEmployeeAppointmentsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaginatedEmployeeAppointmentsResponseDto> mapFromJson(dynamic json) {
    final map = <String, PaginatedEmployeeAppointmentsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaginatedEmployeeAppointmentsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaginatedEmployeeAppointmentsResponseDto-objects as value to a dart map
  static Map<String, List<PaginatedEmployeeAppointmentsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaginatedEmployeeAppointmentsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaginatedEmployeeAppointmentsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'data',
    'meta',
  };
}

