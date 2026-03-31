//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WsTypingEventDto {
  /// Returns a new [WsTypingEventDto] instance.
  WsTypingEventDto({
    required this.conversationId,
    required this.userId,
    required this.userName,
  });

  String conversationId;

  String userId;

  String userName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WsTypingEventDto &&
    other.conversationId == conversationId &&
    other.userId == userId &&
    other.userName == userName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conversationId.hashCode) +
    (userId.hashCode) +
    (userName.hashCode);

  @override
  String toString() => 'WsTypingEventDto[conversationId=$conversationId, userId=$userId, userName=$userName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conversationId'] = this.conversationId;
      json[r'userId'] = this.userId;
      json[r'userName'] = this.userName;
    return json;
  }

  /// Returns a new [WsTypingEventDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WsTypingEventDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WsTypingEventDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WsTypingEventDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WsTypingEventDto(
        conversationId: mapValueOfType<String>(json, r'conversationId')!,
        userId: mapValueOfType<String>(json, r'userId')!,
        userName: mapValueOfType<String>(json, r'userName')!,
      );
    }
    return null;
  }

  static List<WsTypingEventDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WsTypingEventDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WsTypingEventDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WsTypingEventDto> mapFromJson(dynamic json) {
    final map = <String, WsTypingEventDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WsTypingEventDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WsTypingEventDto-objects as value to a dart map
  static Map<String, List<WsTypingEventDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WsTypingEventDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WsTypingEventDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversationId',
    'userId',
    'userName',
  };
}

