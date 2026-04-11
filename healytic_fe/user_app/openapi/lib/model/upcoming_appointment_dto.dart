//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpcomingAppointmentDto {
  /// Returns a new [UpcomingAppointmentDto] instance.
  UpcomingAppointmentDto({
    required this.id,
    required this.patientName,
    required this.serviceName,
    required this.employeeName,
    required this.scheduledAt,
    required this.status,
  });

  String id;

  String patientName;

  String serviceName;

  String employeeName;

  String scheduledAt;

  /// Mapped from BookingStatus
  UpcomingAppointmentDtoStatusEnum status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpcomingAppointmentDto &&
    other.id == id &&
    other.patientName == patientName &&
    other.serviceName == serviceName &&
    other.employeeName == employeeName &&
    other.scheduledAt == scheduledAt &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (patientName.hashCode) +
    (serviceName.hashCode) +
    (employeeName.hashCode) +
    (scheduledAt.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'UpcomingAppointmentDto[id=$id, patientName=$patientName, serviceName=$serviceName, employeeName=$employeeName, scheduledAt=$scheduledAt, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'patientName'] = this.patientName;
      json[r'serviceName'] = this.serviceName;
      json[r'employeeName'] = this.employeeName;
      json[r'scheduledAt'] = this.scheduledAt;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [UpcomingAppointmentDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpcomingAppointmentDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpcomingAppointmentDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpcomingAppointmentDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpcomingAppointmentDto(
        id: mapValueOfType<String>(json, r'id')!,
        patientName: mapValueOfType<String>(json, r'patientName')!,
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        employeeName: mapValueOfType<String>(json, r'employeeName')!,
        scheduledAt: mapValueOfType<String>(json, r'scheduledAt')!,
        status: UpcomingAppointmentDtoStatusEnum.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<UpcomingAppointmentDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpcomingAppointmentDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpcomingAppointmentDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpcomingAppointmentDto> mapFromJson(dynamic json) {
    final map = <String, UpcomingAppointmentDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpcomingAppointmentDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpcomingAppointmentDto-objects as value to a dart map
  static Map<String, List<UpcomingAppointmentDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpcomingAppointmentDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpcomingAppointmentDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'patientName',
    'serviceName',
    'employeeName',
    'scheduledAt',
    'status',
  };
}

/// Mapped from BookingStatus
class UpcomingAppointmentDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const UpcomingAppointmentDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const confirmed = UpcomingAppointmentDtoStatusEnum._(r'confirmed');
  static const pending = UpcomingAppointmentDtoStatusEnum._(r'pending');

  /// List of all possible values in this [enum][UpcomingAppointmentDtoStatusEnum].
  static const values = <UpcomingAppointmentDtoStatusEnum>[
    confirmed,
    pending,
  ];

  static UpcomingAppointmentDtoStatusEnum? fromJson(dynamic value) => UpcomingAppointmentDtoStatusEnumTypeTransformer().decode(value);

  static List<UpcomingAppointmentDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpcomingAppointmentDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpcomingAppointmentDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpcomingAppointmentDtoStatusEnum] to String,
/// and [decode] dynamic data back to [UpcomingAppointmentDtoStatusEnum].
class UpcomingAppointmentDtoStatusEnumTypeTransformer {
  factory UpcomingAppointmentDtoStatusEnumTypeTransformer() => _instance ??= const UpcomingAppointmentDtoStatusEnumTypeTransformer._();

  const UpcomingAppointmentDtoStatusEnumTypeTransformer._();

  String encode(UpcomingAppointmentDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpcomingAppointmentDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpcomingAppointmentDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'confirmed': return UpcomingAppointmentDtoStatusEnum.confirmed;
        case r'pending': return UpcomingAppointmentDtoStatusEnum.pending;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpcomingAppointmentDtoStatusEnumTypeTransformer] instance.
  static UpcomingAppointmentDtoStatusEnumTypeTransformer? _instance;
}


