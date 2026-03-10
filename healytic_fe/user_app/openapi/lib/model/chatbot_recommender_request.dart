//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChatbotRecommenderRequest {
  /// Returns a new [ChatbotRecommenderRequest] instance.
  ChatbotRecommenderRequest({
    required this.conversationId,
    required this.query,
    this.topK = 3,
  });

  String conversationId;

  String query;

  /// Minimum value: 1
  /// Maximum value: 20
  int topK;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatbotRecommenderRequest &&
    other.conversationId == conversationId &&
    other.query == query &&
    other.topK == topK;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conversationId.hashCode) +
    (query.hashCode) +
    (topK.hashCode);

  @override
  String toString() => 'ChatbotRecommenderRequest[conversationId=$conversationId, query=$query, topK=$topK]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conversation_id'] = this.conversationId;
      json[r'query'] = this.query;
      json[r'top_k'] = this.topK;
    return json;
  }

  /// Returns a new [ChatbotRecommenderRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatbotRecommenderRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChatbotRecommenderRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChatbotRecommenderRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChatbotRecommenderRequest(
        conversationId: mapValueOfType<String>(json, r'conversation_id')!,
        query: mapValueOfType<String>(json, r'query')!,
        topK: mapValueOfType<int>(json, r'top_k') ?? 3,
      );
    }
    return null;
  }

  static List<ChatbotRecommenderRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChatbotRecommenderRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatbotRecommenderRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatbotRecommenderRequest> mapFromJson(dynamic json) {
    final map = <String, ChatbotRecommenderRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatbotRecommenderRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatbotRecommenderRequest-objects as value to a dart map
  static Map<String, List<ChatbotRecommenderRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChatbotRecommenderRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatbotRecommenderRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversation_id',
    'query',
  };
}

