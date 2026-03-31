//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WsSendMessagePayloadDto {
  /// Returns a new [WsSendMessagePayloadDto] instance.
  WsSendMessagePayloadDto({
    required this.conversationId,
    required this.content,
    this.messageType = const WsSendMessagePayloadDtoMessageTypeEnum._('text'),
    this.clientMessageId,
  });

  /// Target conversation UUID
  String conversationId;

  /// Message text content (max 5000 chars)
  String content;

  /// Message type
  WsSendMessagePayloadDtoMessageTypeEnum messageType;

  /// Client-generated UUID for idempotent delivery (prevents duplicates on retry)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? clientMessageId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WsSendMessagePayloadDto &&
    other.conversationId == conversationId &&
    other.content == content &&
    other.messageType == messageType &&
    other.clientMessageId == clientMessageId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conversationId.hashCode) +
    (content.hashCode) +
    (messageType.hashCode) +
    (clientMessageId == null ? 0 : clientMessageId!.hashCode);

  @override
  String toString() => 'WsSendMessagePayloadDto[conversationId=$conversationId, content=$content, messageType=$messageType, clientMessageId=$clientMessageId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conversationId'] = this.conversationId;
      json[r'content'] = this.content;
      json[r'messageType'] = this.messageType;
    if (this.clientMessageId != null) {
      json[r'clientMessageId'] = this.clientMessageId;
    } else {
      json[r'clientMessageId'] = null;
    }
    return json;
  }

  /// Returns a new [WsSendMessagePayloadDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WsSendMessagePayloadDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WsSendMessagePayloadDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WsSendMessagePayloadDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WsSendMessagePayloadDto(
        conversationId: mapValueOfType<String>(json, r'conversationId')!,
        content: mapValueOfType<String>(json, r'content')!,
        messageType: WsSendMessagePayloadDtoMessageTypeEnum.fromJson(json[r'messageType']) ?? const WsSendMessagePayloadDtoMessageTypeEnum._('text'),
        clientMessageId: mapValueOfType<String>(json, r'clientMessageId'),
      );
    }
    return null;
  }

  static List<WsSendMessagePayloadDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WsSendMessagePayloadDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WsSendMessagePayloadDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WsSendMessagePayloadDto> mapFromJson(dynamic json) {
    final map = <String, WsSendMessagePayloadDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WsSendMessagePayloadDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WsSendMessagePayloadDto-objects as value to a dart map
  static Map<String, List<WsSendMessagePayloadDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WsSendMessagePayloadDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WsSendMessagePayloadDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversationId',
    'content',
  };
}

/// Message type
class WsSendMessagePayloadDtoMessageTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const WsSendMessagePayloadDtoMessageTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const text = WsSendMessagePayloadDtoMessageTypeEnum._(r'text');
  static const image = WsSendMessagePayloadDtoMessageTypeEnum._(r'image');
  static const file = WsSendMessagePayloadDtoMessageTypeEnum._(r'file');
  static const system = WsSendMessagePayloadDtoMessageTypeEnum._(r'system');

  /// List of all possible values in this [enum][WsSendMessagePayloadDtoMessageTypeEnum].
  static const values = <WsSendMessagePayloadDtoMessageTypeEnum>[
    text,
    image,
    file,
    system,
  ];

  static WsSendMessagePayloadDtoMessageTypeEnum? fromJson(dynamic value) => WsSendMessagePayloadDtoMessageTypeEnumTypeTransformer().decode(value);

  static List<WsSendMessagePayloadDtoMessageTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WsSendMessagePayloadDtoMessageTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WsSendMessagePayloadDtoMessageTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [WsSendMessagePayloadDtoMessageTypeEnum] to String,
/// and [decode] dynamic data back to [WsSendMessagePayloadDtoMessageTypeEnum].
class WsSendMessagePayloadDtoMessageTypeEnumTypeTransformer {
  factory WsSendMessagePayloadDtoMessageTypeEnumTypeTransformer() => _instance ??= const WsSendMessagePayloadDtoMessageTypeEnumTypeTransformer._();

  const WsSendMessagePayloadDtoMessageTypeEnumTypeTransformer._();

  String encode(WsSendMessagePayloadDtoMessageTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a WsSendMessagePayloadDtoMessageTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  WsSendMessagePayloadDtoMessageTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'text': return WsSendMessagePayloadDtoMessageTypeEnum.text;
        case r'image': return WsSendMessagePayloadDtoMessageTypeEnum.image;
        case r'file': return WsSendMessagePayloadDtoMessageTypeEnum.file;
        case r'system': return WsSendMessagePayloadDtoMessageTypeEnum.system;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [WsSendMessagePayloadDtoMessageTypeEnumTypeTransformer] instance.
  static WsSendMessagePayloadDtoMessageTypeEnumTypeTransformer? _instance;
}


