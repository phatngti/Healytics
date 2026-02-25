//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SendMessageDto {
  /// Returns a new [SendMessageDto] instance.
  SendMessageDto({
    required this.message,
    this.conversationId,
  });

  /// The message content to send to the chatbot
  String message;

  /// Existing conversation ID to continue a conversation
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? conversationId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendMessageDto &&
    other.message == message &&
    other.conversationId == conversationId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (message.hashCode) +
    (conversationId == null ? 0 : conversationId!.hashCode);

  @override
  String toString() => 'SendMessageDto[message=$message, conversationId=$conversationId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'message'] = this.message;
    if (this.conversationId != null) {
      json[r'conversationId'] = this.conversationId;
    } else {
      json[r'conversationId'] = null;
    }
    return json;
  }

  /// Returns a new [SendMessageDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendMessageDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SendMessageDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SendMessageDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SendMessageDto(
        message: mapValueOfType<String>(json, r'message')!,
        conversationId: mapValueOfType<String>(json, r'conversationId'),
      );
    }
    return null;
  }

  static List<SendMessageDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendMessageDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendMessageDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendMessageDto> mapFromJson(dynamic json) {
    final map = <String, SendMessageDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendMessageDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendMessageDto-objects as value to a dart map
  static Map<String, List<SendMessageDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendMessageDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendMessageDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'message',
  };
}

