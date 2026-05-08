//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CartItemResponseDto {
  /// Returns a new [CartItemResponseDto] instance.
  CartItemResponseDto({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImageUrl,
    required this.price,
    required this.priceAmount,
    required this.clinicId,
    required this.clinicName,
    required this.clinicAddress,
    this.clinicImageUrl,
    required this.employeeId,
    required this.employeeName,
    required this.employeeRole,
    this.employeeAvatarUrl,
    required this.timeSlot,
    required this.isTimeSlotAvailable,
    required this.status,
    required this.createdAt,
  });


  String id;

  String serviceId;

  String serviceName;

  String serviceImageUrl;

  String price;

  num priceAmount;

  String clinicId;

  String clinicName;

  String clinicAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? clinicImageUrl;

  String employeeId;

  String employeeName;

  CartItemResponseDtoEmployeeRoleEnum employeeRole;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? employeeAvatarUrl;

  /// Selected time slot for the appointment
  DateTime timeSlot;

  /// Whether the selected time slot is still available in the employee schedule.
  bool isTimeSlotAvailable;

  /// Cart item status: ACTIVE, BOOKED, or DELETED
  CartItemResponseDtoStatusEnum status;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CartItemResponseDto &&
    other.id == id &&
    other.serviceId == serviceId &&
    other.serviceName == serviceName &&
    other.serviceImageUrl == serviceImageUrl &&
    other.price == price &&
    other.priceAmount == priceAmount &&
    other.clinicId == clinicId &&
    other.clinicName == clinicName &&
    other.clinicAddress == clinicAddress &&
    other.clinicImageUrl == clinicImageUrl &&
    other.employeeId == employeeId &&
    other.employeeName == employeeName &&
    other.employeeRole == employeeRole &&
    other.employeeAvatarUrl == employeeAvatarUrl &&
    other.timeSlot == timeSlot &&
    other.isTimeSlotAvailable == isTimeSlotAvailable &&
    other.status == status &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (serviceId.hashCode) +
    (serviceName.hashCode) +
    (serviceImageUrl.hashCode) +
    (price.hashCode) +
    (priceAmount.hashCode) +
    (clinicId.hashCode) +
    (clinicName.hashCode) +
    (clinicAddress.hashCode) +
    (clinicImageUrl == null ? 0 : clinicImageUrl!.hashCode) +
    (employeeId.hashCode) +
    (employeeName.hashCode) +
    (employeeRole.hashCode) +
    (employeeAvatarUrl == null ? 0 : employeeAvatarUrl!.hashCode) +
    (timeSlot.hashCode) +
    (isTimeSlotAvailable.hashCode) +
    (status.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'CartItemResponseDto[id=$id, serviceId=$serviceId, serviceName=$serviceName, serviceImageUrl=$serviceImageUrl, price=$price, priceAmount=$priceAmount, clinicId=$clinicId, clinicName=$clinicName, clinicAddress=$clinicAddress, clinicImageUrl=$clinicImageUrl, employeeId=$employeeId, employeeName=$employeeName, employeeRole=$employeeRole, employeeAvatarUrl=$employeeAvatarUrl, timeSlot=$timeSlot, isTimeSlotAvailable=$isTimeSlotAvailable, status=$status, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'serviceId'] = this.serviceId;
      json[r'serviceName'] = this.serviceName;
      json[r'serviceImageUrl'] = this.serviceImageUrl;
      json[r'price'] = this.price;
      json[r'priceAmount'] = this.priceAmount;
      json[r'clinicId'] = this.clinicId;
      json[r'clinicName'] = this.clinicName;
      json[r'clinicAddress'] = this.clinicAddress;
    if (this.clinicImageUrl != null) {
      json[r'clinicImageUrl'] = this.clinicImageUrl;
    } else {
      json[r'clinicImageUrl'] = null;
    }
      json[r'employeeId'] = this.employeeId;
      json[r'employeeName'] = this.employeeName;
      json[r'employeeRole'] = this.employeeRole;
    if (this.employeeAvatarUrl != null) {
      json[r'employeeAvatarUrl'] = this.employeeAvatarUrl;
    } else {
      json[r'employeeAvatarUrl'] = null;
    }
      json[r'timeSlot'] = this.timeSlot.toUtc().toIso8601String();
      json[r'isTimeSlotAvailable'] = this.isTimeSlotAvailable;
      json[r'status'] = this.status;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CartItemResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CartItemResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CartItemResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CartItemResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CartItemResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        serviceId: mapValueOfType<String>(json, r'serviceId')!,
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        serviceImageUrl: mapValueOfType<String>(json, r'serviceImageUrl')!,
        price: mapValueOfType<String>(json, r'price')!,
        priceAmount: num.parse('${json[r'priceAmount']}'),
        clinicId: mapValueOfType<String>(json, r'clinicId')!,
        clinicName: mapValueOfType<String>(json, r'clinicName')!,
        clinicAddress: mapValueOfType<String>(json, r'clinicAddress')!,
        clinicImageUrl: mapValueOfType<Object>(json, r'clinicImageUrl'),
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        employeeName: mapValueOfType<String>(json, r'employeeName')!,
        employeeRole: CartItemResponseDtoEmployeeRoleEnum.fromJson(json[r'employeeRole'])!,
        employeeAvatarUrl: mapValueOfType<Object>(json, r'employeeAvatarUrl'),
        timeSlot: mapDateTime(json, r'timeSlot', r'')!,
        isTimeSlotAvailable: mapValueOfType<bool>(json, r'isTimeSlotAvailable')!,
        status: CartItemResponseDtoStatusEnum.fromJson(json[r'status'])!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<CartItemResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CartItemResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CartItemResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CartItemResponseDto> mapFromJson(dynamic json) {
    final map = <String, CartItemResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CartItemResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CartItemResponseDto-objects as value to a dart map
  static Map<String, List<CartItemResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CartItemResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CartItemResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'serviceId',
    'serviceName',
    'serviceImageUrl',
    'price',
    'priceAmount',
    'clinicId',
    'clinicName',
    'clinicAddress',
    'employeeId',
    'employeeName',
    'employeeRole',
    'timeSlot',
    'isTimeSlotAvailable',
    'status',
    'createdAt',
  };
}


class CartItemResponseDtoEmployeeRoleEnum {
  /// Instantiate a new enum with the provided [value].
  const CartItemResponseDtoEmployeeRoleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const DOCTOR = CartItemResponseDtoEmployeeRoleEnum._(r'DOCTOR');
  static const THERAPIST = CartItemResponseDtoEmployeeRoleEnum._(r'THERAPIST');

  /// List of all possible values in this [enum][CartItemResponseDtoEmployeeRoleEnum].
  static const values = <CartItemResponseDtoEmployeeRoleEnum>[
    DOCTOR,
    THERAPIST,
  ];

  static CartItemResponseDtoEmployeeRoleEnum? fromJson(dynamic value) => CartItemResponseDtoEmployeeRoleEnumTypeTransformer().decode(value);

  static List<CartItemResponseDtoEmployeeRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CartItemResponseDtoEmployeeRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CartItemResponseDtoEmployeeRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CartItemResponseDtoEmployeeRoleEnum] to String,
/// and [decode] dynamic data back to [CartItemResponseDtoEmployeeRoleEnum].
class CartItemResponseDtoEmployeeRoleEnumTypeTransformer {
  factory CartItemResponseDtoEmployeeRoleEnumTypeTransformer() => _instance ??= const CartItemResponseDtoEmployeeRoleEnumTypeTransformer._();

  const CartItemResponseDtoEmployeeRoleEnumTypeTransformer._();

  String encode(CartItemResponseDtoEmployeeRoleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CartItemResponseDtoEmployeeRoleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CartItemResponseDtoEmployeeRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'DOCTOR': return CartItemResponseDtoEmployeeRoleEnum.DOCTOR;
        case r'THERAPIST': return CartItemResponseDtoEmployeeRoleEnum.THERAPIST;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CartItemResponseDtoEmployeeRoleEnumTypeTransformer] instance.
  static CartItemResponseDtoEmployeeRoleEnumTypeTransformer? _instance;
}


/// Cart item status: ACTIVE, BOOKED, or DELETED
class CartItemResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CartItemResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = CartItemResponseDtoStatusEnum._(r'ACTIVE');
  static const BOOKED = CartItemResponseDtoStatusEnum._(r'BOOKED');
  static const DELETED = CartItemResponseDtoStatusEnum._(r'DELETED');

  /// List of all possible values in this [enum][CartItemResponseDtoStatusEnum].
  static const values = <CartItemResponseDtoStatusEnum>[
    ACTIVE,
    BOOKED,
    DELETED,
  ];

  static CartItemResponseDtoStatusEnum? fromJson(dynamic value) => CartItemResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<CartItemResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CartItemResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CartItemResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CartItemResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CartItemResponseDtoStatusEnum].
class CartItemResponseDtoStatusEnumTypeTransformer {
  factory CartItemResponseDtoStatusEnumTypeTransformer() => _instance ??= const CartItemResponseDtoStatusEnumTypeTransformer._();

  const CartItemResponseDtoStatusEnumTypeTransformer._();

  String encode(CartItemResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CartItemResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CartItemResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return CartItemResponseDtoStatusEnum.ACTIVE;
        case r'BOOKED': return CartItemResponseDtoStatusEnum.BOOKED;
        case r'DELETED': return CartItemResponseDtoStatusEnum.DELETED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CartItemResponseDtoStatusEnumTypeTransformer] instance.
  static CartItemResponseDtoStatusEnumTypeTransformer? _instance;
}


