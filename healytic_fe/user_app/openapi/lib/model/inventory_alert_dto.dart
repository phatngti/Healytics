//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class InventoryAlertDto {
  /// Returns a new [InventoryAlertDto] instance.
  InventoryAlertDto({
    required this.id,
    required this.productName,
    required this.alertType,
    required this.message,
    required this.createdAt,
    this.severity = const InventoryAlertDtoSeverityEnum._('warning'),
  });


  String id;

  String productName;

  InventoryAlertDtoAlertTypeEnum alertType;

  String message;

  String createdAt;

  InventoryAlertDtoSeverityEnum severity;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InventoryAlertDto &&
    other.id == id &&
    other.productName == productName &&
    other.alertType == alertType &&
    other.message == message &&
    other.createdAt == createdAt &&
    other.severity == severity;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (productName.hashCode) +
    (alertType.hashCode) +
    (message.hashCode) +
    (createdAt.hashCode) +
    (severity.hashCode);

  @override
  String toString() => 'InventoryAlertDto[id=$id, productName=$productName, alertType=$alertType, message=$message, createdAt=$createdAt, severity=$severity]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'productName'] = this.productName;
      json[r'alertType'] = this.alertType;
      json[r'message'] = this.message;
      json[r'createdAt'] = this.createdAt;
      json[r'severity'] = this.severity;
    return json;
  }

  /// Returns a new [InventoryAlertDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InventoryAlertDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "InventoryAlertDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "InventoryAlertDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return InventoryAlertDto(
        id: mapValueOfType<String>(json, r'id')!,
        productName: mapValueOfType<String>(json, r'productName')!,
        alertType: InventoryAlertDtoAlertTypeEnum.fromJson(json[r'alertType'])!,
        message: mapValueOfType<String>(json, r'message')!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
        severity: InventoryAlertDtoSeverityEnum.fromJson(json[r'severity'])!,
      );
    }
    return null;
  }

  static List<InventoryAlertDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InventoryAlertDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InventoryAlertDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InventoryAlertDto> mapFromJson(dynamic json) {
    final map = <String, InventoryAlertDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InventoryAlertDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InventoryAlertDto-objects as value to a dart map
  static Map<String, List<InventoryAlertDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InventoryAlertDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InventoryAlertDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'productName',
    'alertType',
    'message',
    'createdAt',
    'severity',
  };
}


class InventoryAlertDtoAlertTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const InventoryAlertDtoAlertTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const lowStock = InventoryAlertDtoAlertTypeEnum._(r'low_stock');
  static const expiring = InventoryAlertDtoAlertTypeEnum._(r'expiring');
  static const outOfStock = InventoryAlertDtoAlertTypeEnum._(r'out_of_stock');

  /// List of all possible values in this [enum][InventoryAlertDtoAlertTypeEnum].
  static const values = <InventoryAlertDtoAlertTypeEnum>[
    lowStock,
    expiring,
    outOfStock,
  ];

  static InventoryAlertDtoAlertTypeEnum? fromJson(dynamic value) => InventoryAlertDtoAlertTypeEnumTypeTransformer().decode(value);

  static List<InventoryAlertDtoAlertTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InventoryAlertDtoAlertTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InventoryAlertDtoAlertTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [InventoryAlertDtoAlertTypeEnum] to String,
/// and [decode] dynamic data back to [InventoryAlertDtoAlertTypeEnum].
class InventoryAlertDtoAlertTypeEnumTypeTransformer {
  factory InventoryAlertDtoAlertTypeEnumTypeTransformer() => _instance ??= const InventoryAlertDtoAlertTypeEnumTypeTransformer._();

  const InventoryAlertDtoAlertTypeEnumTypeTransformer._();

  String encode(InventoryAlertDtoAlertTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a InventoryAlertDtoAlertTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  InventoryAlertDtoAlertTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'low_stock': return InventoryAlertDtoAlertTypeEnum.lowStock;
        case r'expiring': return InventoryAlertDtoAlertTypeEnum.expiring;
        case r'out_of_stock': return InventoryAlertDtoAlertTypeEnum.outOfStock;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [InventoryAlertDtoAlertTypeEnumTypeTransformer] instance.
  static InventoryAlertDtoAlertTypeEnumTypeTransformer? _instance;
}



class InventoryAlertDtoSeverityEnum {
  /// Instantiate a new enum with the provided [value].
  const InventoryAlertDtoSeverityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const info = InventoryAlertDtoSeverityEnum._(r'info');
  static const warning = InventoryAlertDtoSeverityEnum._(r'warning');
  static const critical = InventoryAlertDtoSeverityEnum._(r'critical');

  /// List of all possible values in this [enum][InventoryAlertDtoSeverityEnum].
  static const values = <InventoryAlertDtoSeverityEnum>[
    info,
    warning,
    critical,
  ];

  static InventoryAlertDtoSeverityEnum? fromJson(dynamic value) => InventoryAlertDtoSeverityEnumTypeTransformer().decode(value);

  static List<InventoryAlertDtoSeverityEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InventoryAlertDtoSeverityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InventoryAlertDtoSeverityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [InventoryAlertDtoSeverityEnum] to String,
/// and [decode] dynamic data back to [InventoryAlertDtoSeverityEnum].
class InventoryAlertDtoSeverityEnumTypeTransformer {
  factory InventoryAlertDtoSeverityEnumTypeTransformer() => _instance ??= const InventoryAlertDtoSeverityEnumTypeTransformer._();

  const InventoryAlertDtoSeverityEnumTypeTransformer._();

  String encode(InventoryAlertDtoSeverityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a InventoryAlertDtoSeverityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  InventoryAlertDtoSeverityEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'info': return InventoryAlertDtoSeverityEnum.info;
        case r'warning': return InventoryAlertDtoSeverityEnum.warning;
        case r'critical': return InventoryAlertDtoSeverityEnum.critical;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [InventoryAlertDtoSeverityEnumTypeTransformer] instance.
  static InventoryAlertDtoSeverityEnumTypeTransformer? _instance;
}


