//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChatMessageResponseDto {
  /// Returns a new [ChatMessageResponseDto] instance.
  ChatMessageResponseDto({
    required this.type,
    required this.content,
    required this.conversationId,
    required this.timestamp,
  });

  /// The type of SSE event
  ChatMessageResponseDtoTypeEnum type;

  /// The content payload — a single token for \"token\" events, full message for \"end\"
  String content;

  /// The conversation identifier
  String conversationId;

  /// ISO 8601 timestamp of the event
  String timestamp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatMessageResponseDto &&
    other.type == type &&
    other.content == content &&
    other.conversationId == conversationId &&
    other.timestamp == timestamp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (type.hashCode) +
    (content.hashCode) +
    (conversationId.hashCode) +
    (timestamp.hashCode);

  @override
  String toString() => 'ChatMessageResponseDto[type=$type, content=$content, conversationId=$conversationId, timestamp=$timestamp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'type'] = this.type;
      json[r'content'] = this.content;
      json[r'conversationId'] = this.conversationId;
      json[r'timestamp'] = this.timestamp;
    return json;
  }

  /// Returns a new [ChatMessageResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatMessageResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChatMessageResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChatMessageResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChatMessageResponseDto(
        type: ChatMessageResponseDtoTypeEnum.fromJson(json[r'type'])!,
        content: mapValueOfType<String>(json, r'content')!,
        conversationId: mapValueOfType<String>(json, r'conversationId')!,
        timestamp: mapValueOfType<String>(json, r'timestamp')!,
      );
    }
    return null;
  }

  static List<ChatMessageResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatMessageResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatMessageResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatMessageResponseDto> mapFromJson(dynamic json) {
    final map = <String, ChatMessageResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatMessageResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatMessageResponseDto-objects as value to a dart map
  static Map<String, List<ChatMessageResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChatMessageResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatMessageResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'type',
    'content',
    'conversationId',
    'timestamp',
  };
}

/// The type of SSE event
class ChatMessageResponseDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const ChatMessageResponseDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const start = ChatMessageResponseDtoTypeEnum._(r'start');
  static const token = ChatMessageResponseDtoTypeEnum._(r'token');
  static const end = ChatMessageResponseDtoTypeEnum._(r'end');
  static const error = ChatMessageResponseDtoTypeEnum._(r'error');

  /// List of all possible values in this [enum][ChatMessageResponseDtoTypeEnum].
  static const values = <ChatMessageResponseDtoTypeEnum>[
    start,
    token,
    end,
    error,
  ];

  static ChatMessageResponseDtoTypeEnum? fromJson(dynamic value) => ChatMessageResponseDtoTypeEnumTypeTransformer().decode(value);

  static List<ChatMessageResponseDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatMessageResponseDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatMessageResponseDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChatMessageResponseDtoTypeEnum] to String,
/// and [decode] dynamic data back to [ChatMessageResponseDtoTypeEnum].
class ChatMessageResponseDtoTypeEnumTypeTransformer {
  factory ChatMessageResponseDtoTypeEnumTypeTransformer() => _instance ??= const ChatMessageResponseDtoTypeEnumTypeTransformer._();

  const ChatMessageResponseDtoTypeEnumTypeTransformer._();

  String encode(ChatMessageResponseDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ChatMessageResponseDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChatMessageResponseDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'start': return ChatMessageResponseDtoTypeEnum.start;
        case r'token': return ChatMessageResponseDtoTypeEnum.token;
        case r'end': return ChatMessageResponseDtoTypeEnum.end;
        case r'error': return ChatMessageResponseDtoTypeEnum.error;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChatMessageResponseDtoTypeEnumTypeTransformer] instance.
  static ChatMessageResponseDtoTypeEnumTypeTransformer? _instance;
}


