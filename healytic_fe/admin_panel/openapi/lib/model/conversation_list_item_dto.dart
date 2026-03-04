//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConversationListItemDto {
  /// Returns a new [ConversationListItemDto] instance.
  ConversationListItemDto({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
  });

  /// Conversation identifier
  String id;

  /// Auto-generated conversation title
  String title;

  /// Last message text in the conversation
  String lastMessage;

  /// ISO 8601 timestamp of the last message
  String timestamp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversationListItemDto &&
    other.id == id &&
    other.title == title &&
    other.lastMessage == lastMessage &&
    other.timestamp == timestamp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (lastMessage.hashCode) +
    (timestamp.hashCode);

  @override
  String toString() => 'ConversationListItemDto[id=$id, title=$title, lastMessage=$lastMessage, timestamp=$timestamp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'lastMessage'] = this.lastMessage;
      json[r'timestamp'] = this.timestamp;
    return json;
  }

  /// Returns a new [ConversationListItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConversationListItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConversationListItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConversationListItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConversationListItemDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        lastMessage: mapValueOfType<String>(json, r'lastMessage')!,
        timestamp: mapValueOfType<String>(json, r'timestamp')!,
      );
    }
    return null;
  }

  static List<ConversationListItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationListItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationListItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversationListItemDto> mapFromJson(dynamic json) {
    final map = <String, ConversationListItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConversationListItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversationListItemDto-objects as value to a dart map
  static Map<String, List<ConversationListItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversationListItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversationListItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'lastMessage',
    'timestamp',
  };
}

