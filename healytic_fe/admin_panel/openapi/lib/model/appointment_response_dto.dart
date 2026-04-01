//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AppointmentResponseDto {
  /// Returns a new [AppointmentResponseDto] instance.
  AppointmentResponseDto({
    required this.id,
    required this.serviceName,
    required this.healthPartnerName,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.specialistName,
    required this.specialistId,
    required this.address,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    required this.isReviewed,
    required this.distanceKm,
    required this.healthPartnerId,
    required this.serviceId,
  });

  String id;

  String serviceName;

  String healthPartnerName;

  String imageUrl;

  AppointmentResponseDtoStatusEnum status;

  String category;

  String specialistName;

  String specialistId;

  String address;

  String date;

  String checkInTime;

  String checkOutTime;

  String duration;

  /// Whether the user has reviewed this appointment
  bool isReviewed;

  /// Distance from user to clinic in kilometers (null if coordinates not provided)
  num? distanceKm;

  /// Account ID of the health partner (vendor). Used for chat.
  Object? healthPartnerId;

  /// Product/service ID for navigation to service details.
  Object? serviceId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppointmentResponseDto &&
    other.id == id &&
    other.serviceName == serviceName &&
    other.healthPartnerName == healthPartnerName &&
    other.imageUrl == imageUrl &&
    other.status == status &&
    other.category == category &&
    other.specialistName == specialistName &&
    other.specialistId == specialistId &&
    other.address == address &&
    other.date == date &&
    other.checkInTime == checkInTime &&
    other.checkOutTime == checkOutTime &&
    other.duration == duration &&
    other.isReviewed == isReviewed &&
    other.distanceKm == distanceKm &&
    other.healthPartnerId == healthPartnerId &&
    other.serviceId == serviceId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (serviceName.hashCode) +
    (healthPartnerName.hashCode) +
    (imageUrl.hashCode) +
    (status.hashCode) +
    (category.hashCode) +
    (specialistName.hashCode) +
    (specialistId.hashCode) +
    (address.hashCode) +
    (date.hashCode) +
    (checkInTime.hashCode) +
    (checkOutTime.hashCode) +
    (duration.hashCode) +
    (isReviewed.hashCode) +
    (distanceKm == null ? 0 : distanceKm!.hashCode) +
    (healthPartnerId == null ? 0 : healthPartnerId!.hashCode) +
    (serviceId == null ? 0 : serviceId!.hashCode);

  @override
  String toString() => 'AppointmentResponseDto[id=$id, serviceName=$serviceName, healthPartnerName=$healthPartnerName, imageUrl=$imageUrl, status=$status, category=$category, specialistName=$specialistName, specialistId=$specialistId, address=$address, date=$date, checkInTime=$checkInTime, checkOutTime=$checkOutTime, duration=$duration, isReviewed=$isReviewed, distanceKm=$distanceKm, healthPartnerId=$healthPartnerId, serviceId=$serviceId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'serviceName'] = this.serviceName;
      json[r'healthPartnerName'] = this.healthPartnerName;
      json[r'imageUrl'] = this.imageUrl;
      json[r'status'] = this.status;
      json[r'category'] = this.category;
      json[r'specialistName'] = this.specialistName;
      json[r'specialistId'] = this.specialistId;
      json[r'address'] = this.address;
      json[r'date'] = this.date;
      json[r'checkInTime'] = this.checkInTime;
      json[r'checkOutTime'] = this.checkOutTime;
      json[r'duration'] = this.duration;
      json[r'isReviewed'] = this.isReviewed;
    if (this.distanceKm != null) {
      json[r'distanceKm'] = this.distanceKm;
    } else {
      json[r'distanceKm'] = null;
    }
    if (this.healthPartnerId != null) {
      json[r'healthPartnerId'] = this.healthPartnerId;
    } else {
      json[r'healthPartnerId'] = null;
    }
    if (this.serviceId != null) {
      json[r'serviceId'] = this.serviceId;
    } else {
      json[r'serviceId'] = null;
    }
    return json;
  }

  /// Returns a new [AppointmentResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AppointmentResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AppointmentResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AppointmentResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AppointmentResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        healthPartnerName: mapValueOfType<String>(json, r'healthPartnerName')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl')!,
        status: AppointmentResponseDtoStatusEnum.fromJson(json[r'status'])!,
        category: mapValueOfType<String>(json, r'category')!,
        specialistName: mapValueOfType<String>(json, r'specialistName')!,
        specialistId: mapValueOfType<String>(json, r'specialistId')!,
        address: mapValueOfType<String>(json, r'address')!,
        date: mapValueOfType<String>(json, r'date')!,
        checkInTime: mapValueOfType<String>(json, r'checkInTime')!,
        checkOutTime: mapValueOfType<String>(json, r'checkOutTime')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        isReviewed: mapValueOfType<bool>(json, r'isReviewed')!,
        distanceKm: json[r'distanceKm'] == null
            ? null
            : num.parse('${json[r'distanceKm']}'),
        healthPartnerId: mapValueOfType<Object>(json, r'healthPartnerId'),
        serviceId: mapValueOfType<Object>(json, r'serviceId'),
      );
    }
    return null;
  }

  static List<AppointmentResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AppointmentResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppointmentResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AppointmentResponseDto> mapFromJson(dynamic json) {
    final map = <String, AppointmentResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AppointmentResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AppointmentResponseDto-objects as value to a dart map
  static Map<String, List<AppointmentResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AppointmentResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AppointmentResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'serviceName',
    'healthPartnerName',
    'imageUrl',
    'status',
    'category',
    'specialistName',
    'specialistId',
    'address',
    'date',
    'checkInTime',
    'checkOutTime',
    'duration',
    'isReviewed',
    'distanceKm',
    'healthPartnerId',
    'serviceId',
  };
}


class AppointmentResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const AppointmentResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const upcoming = AppointmentResponseDtoStatusEnum._(r'upcoming');
  static const completed = AppointmentResponseDtoStatusEnum._(r'completed');
  static const canceled = AppointmentResponseDtoStatusEnum._(r'canceled');

  /// List of all possible values in this [enum][AppointmentResponseDtoStatusEnum].
  static const values = <AppointmentResponseDtoStatusEnum>[
    upcoming,
    completed,
    canceled,
  ];

  static AppointmentResponseDtoStatusEnum? fromJson(dynamic value) => AppointmentResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<AppointmentResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AppointmentResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppointmentResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AppointmentResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [AppointmentResponseDtoStatusEnum].
class AppointmentResponseDtoStatusEnumTypeTransformer {
  factory AppointmentResponseDtoStatusEnumTypeTransformer() => _instance ??= const AppointmentResponseDtoStatusEnumTypeTransformer._();

  const AppointmentResponseDtoStatusEnumTypeTransformer._();

  String encode(AppointmentResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AppointmentResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AppointmentResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'upcoming': return AppointmentResponseDtoStatusEnum.upcoming;
        case r'completed': return AppointmentResponseDtoStatusEnum.completed;
        case r'canceled': return AppointmentResponseDtoStatusEnum.canceled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AppointmentResponseDtoStatusEnumTypeTransformer] instance.
  static AppointmentResponseDtoStatusEnumTypeTransformer? _instance;
}


