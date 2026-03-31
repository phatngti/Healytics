//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WsNewMessageEventDto {
  /// Returns a new [WsNewMessageEventDto] instance.
  WsNewMessageEventDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    required this.messageType,
    this.clientMessageId,
    required this.createdAt,
  });

  String id;

  String conversationId;

  String senderId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? senderName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? senderAvatar;

  String content;

  WsNewMessageEventDtoMessageTypeEnum messageType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? clientMessageId;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WsNewMessageEventDto &&
    other.id == id &&
    other.conversationId == conversationId &&
    other.senderId == senderId &&
    other.senderName == senderName &&
    other.senderAvatar == senderAvatar &&
    other.content == content &&
    other.messageType == messageType &&
    other.clientMessageId == clientMessageId &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (conversationId.hashCode) +
    (senderId.hashCode) +
    (senderName == null ? 0 : senderName!.hashCode) +
    (senderAvatar == null ? 0 : senderAvatar!.hashCode) +
    (content.hashCode) +
    (messageType.hashCode) +
    (clientMessageId == null ? 0 : clientMessageId!.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'WsNewMessageEventDto[id=$id, conversationId=$conversationId, senderId=$senderId, senderName=$senderName, senderAvatar=$senderAvatar, content=$content, messageType=$messageType, clientMessageId=$clientMessageId, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'conversationId'] = this.conversationId;
      json[r'senderId'] = this.senderId;
    if (this.senderName != null) {
      json[r'senderName'] = this.senderName;
    } else {
      json[r'senderName'] = null;
    }
    if (this.senderAvatar != null) {
      json[r'senderAvatar'] = this.senderAvatar;
    } else {
      json[r'senderAvatar'] = null;
    }
      json[r'content'] = this.content;
      json[r'messageType'] = this.messageType;
    if (this.clientMessageId != null) {
      json[r'clientMessageId'] = this.clientMessageId;
    } else {
      json[r'clientMessageId'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [WsNewMessageEventDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WsNewMessageEventDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WsNewMessageEventDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WsNewMessageEventDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WsNewMessageEventDto(
        id: mapValueOfType<String>(json, r'id')!,
        conversationId: mapValueOfType<String>(json, r'conversationId')!,
        senderId: mapValueOfType<String>(json, r'senderId')!,
        senderName: mapValueOfType<String>(json, r'senderName'),
        senderAvatar: mapValueOfType<String>(json, r'senderAvatar'),
        content: mapValueOfType<String>(json, r'content')!,
        messageType: WsNewMessageEventDtoMessageTypeEnum.fromJson(json[r'messageType'])!,
        clientMessageId: mapValueOfType<String>(json, r'clientMessageId'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<WsNewMessageEventDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WsNewMessageEventDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WsNewMessageEventDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WsNewMessageEventDto> mapFromJson(dynamic json) {
    final map = <String, WsNewMessageEventDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WsNewMessageEventDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WsNewMessageEventDto-objects as value to a dart map
  static Map<String, List<WsNewMessageEventDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WsNewMessageEventDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WsNewMessageEventDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'conversationId',
    'senderId',
    'content',
    'messageType',
    'createdAt',
  };
}


class WsNewMessageEventDtoMessageTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const WsNewMessageEventDtoMessageTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const text = WsNewMessageEventDtoMessageTypeEnum._(r'text');
  static const image = WsNewMessageEventDtoMessageTypeEnum._(r'image');
  static const file = WsNewMessageEventDtoMessageTypeEnum._(r'file');
  static const system = WsNewMessageEventDtoMessageTypeEnum._(r'system');

  /// List of all possible values in this [enum][WsNewMessageEventDtoMessageTypeEnum].
  static const values = <WsNewMessageEventDtoMessageTypeEnum>[
    text,
    image,
    file,
    system,
  ];

  static WsNewMessageEventDtoMessageTypeEnum? fromJson(dynamic value) => WsNewMessageEventDtoMessageTypeEnumTypeTransformer().decode(value);

  static List<WsNewMessageEventDtoMessageTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WsNewMessageEventDtoMessageTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WsNewMessageEventDtoMessageTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [WsNewMessageEventDtoMessageTypeEnum] to String,
/// and [decode] dynamic data back to [WsNewMessageEventDtoMessageTypeEnum].
class WsNewMessageEventDtoMessageTypeEnumTypeTransformer {
  factory WsNewMessageEventDtoMessageTypeEnumTypeTransformer() => _instance ??= const WsNewMessageEventDtoMessageTypeEnumTypeTransformer._();

  const WsNewMessageEventDtoMessageTypeEnumTypeTransformer._();

  String encode(WsNewMessageEventDtoMessageTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a WsNewMessageEventDtoMessageTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  WsNewMessageEventDtoMessageTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'text': return WsNewMessageEventDtoMessageTypeEnum.text;
        case r'image': return WsNewMessageEventDtoMessageTypeEnum.image;
        case r'file': return WsNewMessageEventDtoMessageTypeEnum.file;
        case r'system': return WsNewMessageEventDtoMessageTypeEnum.system;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [WsNewMessageEventDtoMessageTypeEnumTypeTransformer] instance.
  static WsNewMessageEventDtoMessageTypeEnumTypeTransformer? _instance;
}


