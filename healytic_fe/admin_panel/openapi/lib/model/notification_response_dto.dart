//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NotificationResponseDto {
  /// Returns a new [NotificationResponseDto] instance.
  NotificationResponseDto({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    this.readAt,
    required this.isBroadcast,
    required this.createdAt,
  });


  /// Notification UUID
  String id;

  /// The type of notification
  NotificationResponseDtoTypeEnum type;

  /// Notification title
  String title;

  /// Notification body text
  String body;

  /// Deep-link data for frontend routing
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? data;

  /// Whether the notification has been read
  bool isRead;

  /// When the notification was read
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? readAt;

  /// Whether this is a system-wide broadcast
  bool isBroadcast;

  /// When the notification was created
  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationResponseDto &&
    other.id == id &&
    other.type == type &&
    other.title == title &&
    other.body == body &&
    other.data == data &&
    other.isRead == isRead &&
    other.readAt == readAt &&
    other.isBroadcast == isBroadcast &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (type.hashCode) +
    (title.hashCode) +
    (body.hashCode) +
    (data == null ? 0 : data!.hashCode) +
    (isRead.hashCode) +
    (readAt == null ? 0 : readAt!.hashCode) +
    (isBroadcast.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'NotificationResponseDto[id=$id, type=$type, title=$title, body=$body, data=$data, isRead=$isRead, readAt=$readAt, isBroadcast=$isBroadcast, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'type'] = this.type;
      json[r'title'] = this.title;
      json[r'body'] = this.body;
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
      json[r'isRead'] = this.isRead;
    if (this.readAt != null) {
      json[r'readAt'] = this.readAt;
    } else {
      json[r'readAt'] = null;
    }
      json[r'isBroadcast'] = this.isBroadcast;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [NotificationResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "NotificationResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "NotificationResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return NotificationResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        type: NotificationResponseDtoTypeEnum.fromJson(json[r'type'])!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        data: mapValueOfType<Object>(json, r'data'),
        isRead: mapValueOfType<bool>(json, r'isRead')!,
        readAt: mapValueOfType<Object>(json, r'readAt'),
        isBroadcast: mapValueOfType<bool>(json, r'isBroadcast')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<NotificationResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationResponseDto> mapFromJson(dynamic json) {
    final map = <String, NotificationResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationResponseDto-objects as value to a dart map
  static Map<String, List<NotificationResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotificationResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotificationResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'type',
    'title',
    'body',
    'isRead',
    'isBroadcast',
    'createdAt',
  };
}

/// The type of notification
class NotificationResponseDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const NotificationResponseDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const bookingConfirmed = NotificationResponseDtoTypeEnum._(r'booking_confirmed');
  static const bookingCancelled = NotificationResponseDtoTypeEnum._(r'booking_cancelled');
  static const bookingCompleted = NotificationResponseDtoTypeEnum._(r'booking_completed');
  static const appointmentReminder = NotificationResponseDtoTypeEnum._(r'appointment_reminder');
  static const appointmentUpdated = NotificationResponseDtoTypeEnum._(r'appointment_updated');
  static const newChatMessage = NotificationResponseDtoTypeEnum._(r'new_chat_message');
  static const paymentSuccess = NotificationResponseDtoTypeEnum._(r'payment_success');
  static const paymentFailed = NotificationResponseDtoTypeEnum._(r'payment_failed');
  static const systemBroadcast = NotificationResponseDtoTypeEnum._(r'system_broadcast');
  static const systemMaintenance = NotificationResponseDtoTypeEnum._(r'system_maintenance');
  static const partnerVerified = NotificationResponseDtoTypeEnum._(r'partner_verified');
  static const partnerRejected = NotificationResponseDtoTypeEnum._(r'partner_rejected');

  /// List of all possible values in this [enum][NotificationResponseDtoTypeEnum].
  static const values = <NotificationResponseDtoTypeEnum>[
    bookingConfirmed,
    bookingCancelled,
    bookingCompleted,
    appointmentReminder,
    appointmentUpdated,
    newChatMessage,
    paymentSuccess,
    paymentFailed,
    systemBroadcast,
    systemMaintenance,
    partnerVerified,
    partnerRejected,
  ];

  static NotificationResponseDtoTypeEnum? fromJson(dynamic value) => NotificationResponseDtoTypeEnumTypeTransformer().decode(value);

  static List<NotificationResponseDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationResponseDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationResponseDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [NotificationResponseDtoTypeEnum] to String,
/// and [decode] dynamic data back to [NotificationResponseDtoTypeEnum].
class NotificationResponseDtoTypeEnumTypeTransformer {
  factory NotificationResponseDtoTypeEnumTypeTransformer() => _instance ??= const NotificationResponseDtoTypeEnumTypeTransformer._();

  const NotificationResponseDtoTypeEnumTypeTransformer._();

  String encode(NotificationResponseDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a NotificationResponseDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  NotificationResponseDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'booking_confirmed': return NotificationResponseDtoTypeEnum.bookingConfirmed;
        case r'booking_cancelled': return NotificationResponseDtoTypeEnum.bookingCancelled;
        case r'booking_completed': return NotificationResponseDtoTypeEnum.bookingCompleted;
        case r'appointment_reminder': return NotificationResponseDtoTypeEnum.appointmentReminder;
        case r'appointment_updated': return NotificationResponseDtoTypeEnum.appointmentUpdated;
        case r'new_chat_message': return NotificationResponseDtoTypeEnum.newChatMessage;
        case r'payment_success': return NotificationResponseDtoTypeEnum.paymentSuccess;
        case r'payment_failed': return NotificationResponseDtoTypeEnum.paymentFailed;
        case r'system_broadcast': return NotificationResponseDtoTypeEnum.systemBroadcast;
        case r'system_maintenance': return NotificationResponseDtoTypeEnum.systemMaintenance;
        case r'partner_verified': return NotificationResponseDtoTypeEnum.partnerVerified;
        case r'partner_rejected': return NotificationResponseDtoTypeEnum.partnerRejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [NotificationResponseDtoTypeEnumTypeTransformer] instance.
  static NotificationResponseDtoTypeEnumTypeTransformer? _instance;
}


