//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;

class SeedNotificationDto {
  /// Returns a new [SeedNotificationDto] instance.
  SeedNotificationDto({
    this.key,
    this.userKey,
    this.userEmail,
    this.senderKey,
    this.senderEmail,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    this.isBroadcast = false,
  });


  /// Unique lookup key
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? key;

  /// Key of a previously seeded user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userKey;

  /// Email to look up the recipient user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userEmail;

  /// Key of a previously seeded sender account
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? senderKey;

  /// Email to look up the sender account
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? senderEmail;

  SeedNotificationDtoTypeEnum type;

  String title;

  String body;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? data;

  bool isRead;

  bool isBroadcast;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedNotificationDto &&
    other.key == key &&
    other.userKey == userKey &&
    other.userEmail == userEmail &&
    other.senderKey == senderKey &&
    other.senderEmail == senderEmail &&
    other.type == type &&
    other.title == title &&
    other.body == body &&
    other.data == data &&
    other.isRead == isRead &&
    other.isBroadcast == isBroadcast;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key == null ? 0 : key!.hashCode) +
    (userKey == null ? 0 : userKey!.hashCode) +
    (userEmail == null ? 0 : userEmail!.hashCode) +
    (senderKey == null ? 0 : senderKey!.hashCode) +
    (senderEmail == null ? 0 : senderEmail!.hashCode) +
    (type.hashCode) +
    (title.hashCode) +
    (body.hashCode) +
    (data == null ? 0 : data!.hashCode) +
    (isRead.hashCode) +
    (isBroadcast.hashCode);

  @override
  String toString() => 'SeedNotificationDto[key=$key, userKey=$userKey, userEmail=$userEmail, senderKey=$senderKey, senderEmail=$senderEmail, type=$type, title=$title, body=$body, data=$data, isRead=$isRead, isBroadcast=$isBroadcast]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
    if (this.userKey != null) {
      json[r'userKey'] = this.userKey;
    } else {
      json[r'userKey'] = null;
    }
    if (this.userEmail != null) {
      json[r'userEmail'] = this.userEmail;
    } else {
      json[r'userEmail'] = null;
    }
    if (this.senderKey != null) {
      json[r'senderKey'] = this.senderKey;
    } else {
      json[r'senderKey'] = null;
    }
    if (this.senderEmail != null) {
      json[r'senderEmail'] = this.senderEmail;
    } else {
      json[r'senderEmail'] = null;
    }
      json[r'type'] = this.type;
      json[r'title'] = this.title;
      json[r'body'] = this.body;
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
      json[r'isRead'] = this.isRead;
      json[r'isBroadcast'] = this.isBroadcast;
    return json;
  }

  /// Returns a new [SeedNotificationDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedNotificationDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedNotificationDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedNotificationDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedNotificationDto(
        key: mapValueOfType<String>(json, r'key'),
        userKey: mapValueOfType<String>(json, r'userKey'),
        userEmail: mapValueOfType<String>(json, r'userEmail'),
        senderKey: mapValueOfType<String>(json, r'senderKey'),
        senderEmail: mapValueOfType<String>(json, r'senderEmail'),
        type: SeedNotificationDtoTypeEnum.fromJson(json[r'type'])!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        data: mapValueOfType<Object>(json, r'data'),
        isRead: mapValueOfType<bool>(json, r'isRead') ?? false,
        isBroadcast: mapValueOfType<bool>(json, r'isBroadcast') ?? false,
      );
    }
    return null;
  }

  static List<SeedNotificationDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedNotificationDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedNotificationDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedNotificationDto> mapFromJson(dynamic json) {
    final map = <String, SeedNotificationDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedNotificationDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedNotificationDto-objects as value to a dart map
  static Map<String, List<SeedNotificationDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedNotificationDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedNotificationDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'type',
    'title',
    'body',
  };
}


class SeedNotificationDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const SeedNotificationDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const bookingConfirmed = SeedNotificationDtoTypeEnum._(r'booking_confirmed');
  static const bookingCancelled = SeedNotificationDtoTypeEnum._(r'booking_cancelled');
  static const bookingCompleted = SeedNotificationDtoTypeEnum._(r'booking_completed');
  static const appointmentReminder = SeedNotificationDtoTypeEnum._(r'appointment_reminder');
  static const appointmentUpdated = SeedNotificationDtoTypeEnum._(r'appointment_updated');
  static const newChatMessage = SeedNotificationDtoTypeEnum._(r'new_chat_message');
  static const paymentSuccess = SeedNotificationDtoTypeEnum._(r'payment_success');
  static const paymentFailed = SeedNotificationDtoTypeEnum._(r'payment_failed');
  static const systemBroadcast = SeedNotificationDtoTypeEnum._(r'system_broadcast');
  static const systemMaintenance = SeedNotificationDtoTypeEnum._(r'system_maintenance');
  static const partnerVerified = SeedNotificationDtoTypeEnum._(r'partner_verified');
  static const partnerRejected = SeedNotificationDtoTypeEnum._(r'partner_rejected');

  /// List of all possible values in this [enum][SeedNotificationDtoTypeEnum].
  static const values = <SeedNotificationDtoTypeEnum>[
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

  static SeedNotificationDtoTypeEnum? fromJson(dynamic value) => SeedNotificationDtoTypeEnumTypeTransformer().decode(value);

  static List<SeedNotificationDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedNotificationDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedNotificationDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SeedNotificationDtoTypeEnum] to String,
/// and [decode] dynamic data back to [SeedNotificationDtoTypeEnum].
class SeedNotificationDtoTypeEnumTypeTransformer {
  factory SeedNotificationDtoTypeEnumTypeTransformer() => _instance ??= const SeedNotificationDtoTypeEnumTypeTransformer._();

  const SeedNotificationDtoTypeEnumTypeTransformer._();

  String encode(SeedNotificationDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a SeedNotificationDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SeedNotificationDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'booking_confirmed': return SeedNotificationDtoTypeEnum.bookingConfirmed;
        case r'booking_cancelled': return SeedNotificationDtoTypeEnum.bookingCancelled;
        case r'booking_completed': return SeedNotificationDtoTypeEnum.bookingCompleted;
        case r'appointment_reminder': return SeedNotificationDtoTypeEnum.appointmentReminder;
        case r'appointment_updated': return SeedNotificationDtoTypeEnum.appointmentUpdated;
        case r'new_chat_message': return SeedNotificationDtoTypeEnum.newChatMessage;
        case r'payment_success': return SeedNotificationDtoTypeEnum.paymentSuccess;
        case r'payment_failed': return SeedNotificationDtoTypeEnum.paymentFailed;
        case r'system_broadcast': return SeedNotificationDtoTypeEnum.systemBroadcast;
        case r'system_maintenance': return SeedNotificationDtoTypeEnum.systemMaintenance;
        case r'partner_verified': return SeedNotificationDtoTypeEnum.partnerVerified;
        case r'partner_rejected': return SeedNotificationDtoTypeEnum.partnerRejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [SeedNotificationDtoTypeEnumTypeTransformer] instance.
  static SeedNotificationDtoTypeEnumTypeTransformer? _instance;
}


