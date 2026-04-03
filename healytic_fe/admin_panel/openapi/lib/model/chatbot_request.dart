//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChatbotRequest {
  /// Returns a new [ChatbotRequest] instance.
  ChatbotRequest({
    this.conversationId,
    required this.userId,
    required this.message,
    this.topK = 3,
  });

  String? conversationId;

  String userId;

  String message;

  /// Minimum value: 1
  /// Maximum value: 20
  int topK;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatbotRequest &&
    other.conversationId == conversationId &&
    other.userId == userId &&
    other.message == message &&
    other.topK == topK;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conversationId == null ? 0 : conversationId!.hashCode) +
    (userId.hashCode) +
    (message.hashCode) +
    (topK.hashCode);

  @override
  String toString() => 'ChatbotRequest[conversationId=$conversationId, userId=$userId, message=$message, topK=$topK]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.conversationId != null) {
      json[r'conversation_id'] = this.conversationId;
    } else {
      json[r'conversation_id'] = null;
    }
      json[r'user_id'] = this.userId;
      json[r'message'] = this.message;
      json[r'top_k'] = this.topK;
    return json;
  }

  /// Returns a new [ChatbotRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatbotRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChatbotRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChatbotRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChatbotRequest(
        conversationId: mapValueOfType<String>(json, r'conversation_id'),
        userId: mapValueOfType<String>(json, r'user_id')!,
        message: mapValueOfType<String>(json, r'message')!,
        topK: mapValueOfType<int>(json, r'top_k') ?? 3,
      );
    }
    return null;
  }

  static List<ChatbotRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatbotRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatbotRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatbotRequest> mapFromJson(dynamic json) {
    final map = <String, ChatbotRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatbotRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatbotRequest-objects as value to a dart map
  static Map<String, List<ChatbotRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChatbotRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatbotRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user_id',
    'message',
  };
}

