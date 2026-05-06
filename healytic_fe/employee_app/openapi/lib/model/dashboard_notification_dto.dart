//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DashboardNotificationDto {
  /// Returns a new [DashboardNotificationDto] instance.
  DashboardNotificationDto({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });


  String id;

  String title;

  String message;

  DashboardNotificationDtoTypeEnum type;

  String createdAt;

  bool isRead;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DashboardNotificationDto &&
    other.id == id &&
    other.title == title &&
    other.message == message &&
    other.type == type &&
    other.createdAt == createdAt &&
    other.isRead == isRead;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (message.hashCode) +
    (type.hashCode) +
    (createdAt.hashCode) +
    (isRead.hashCode);

  @override
  String toString() => 'DashboardNotificationDto[id=$id, title=$title, message=$message, type=$type, createdAt=$createdAt, isRead=$isRead]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'message'] = this.message;
      json[r'type'] = this.type;
      json[r'createdAt'] = this.createdAt;
      json[r'isRead'] = this.isRead;
    return json;
  }

  /// Returns a new [DashboardNotificationDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DashboardNotificationDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DashboardNotificationDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DashboardNotificationDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DashboardNotificationDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        message: mapValueOfType<String>(json, r'message')!,
        type: DashboardNotificationDtoTypeEnum.fromJson(json[r'type'])!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
        isRead: mapValueOfType<bool>(json, r'isRead')!,
      );
    }
    return null;
  }

  static List<DashboardNotificationDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardNotificationDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardNotificationDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DashboardNotificationDto> mapFromJson(dynamic json) {
    final map = <String, DashboardNotificationDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DashboardNotificationDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DashboardNotificationDto-objects as value to a dart map
  static Map<String, List<DashboardNotificationDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DashboardNotificationDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DashboardNotificationDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'message',
    'type',
    'createdAt',
    'isRead',
  };
}


class DashboardNotificationDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const DashboardNotificationDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const appointment = DashboardNotificationDtoTypeEnum._(r'appointment');
  static const review = DashboardNotificationDtoTypeEnum._(r'review');
  static const system = DashboardNotificationDtoTypeEnum._(r'system');
  static const alert = DashboardNotificationDtoTypeEnum._(r'alert');

  /// List of all possible values in this [enum][DashboardNotificationDtoTypeEnum].
  static const values = <DashboardNotificationDtoTypeEnum>[
    appointment,
    review,
    system,
    alert,
  ];

  static DashboardNotificationDtoTypeEnum? fromJson(dynamic value) => DashboardNotificationDtoTypeEnumTypeTransformer().decode(value);

  static List<DashboardNotificationDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardNotificationDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardNotificationDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DashboardNotificationDtoTypeEnum] to String,
/// and [decode] dynamic data back to [DashboardNotificationDtoTypeEnum].
class DashboardNotificationDtoTypeEnumTypeTransformer {
  factory DashboardNotificationDtoTypeEnumTypeTransformer() => _instance ??= const DashboardNotificationDtoTypeEnumTypeTransformer._();

  const DashboardNotificationDtoTypeEnumTypeTransformer._();

  String encode(DashboardNotificationDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a DashboardNotificationDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DashboardNotificationDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'appointment': return DashboardNotificationDtoTypeEnum.appointment;
        case r'review': return DashboardNotificationDtoTypeEnum.review;
        case r'system': return DashboardNotificationDtoTypeEnum.system;
        case r'alert': return DashboardNotificationDtoTypeEnum.alert;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [DashboardNotificationDtoTypeEnumTypeTransformer] instance.
  static DashboardNotificationDtoTypeEnumTypeTransformer? _instance;
}


