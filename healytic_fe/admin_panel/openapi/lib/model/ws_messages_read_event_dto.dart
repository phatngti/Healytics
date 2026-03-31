//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WsMessagesReadEventDto {
  /// Returns a new [WsMessagesReadEventDto] instance.
  WsMessagesReadEventDto({
    required this.conversationId,
    required this.readerId,
    required this.readAt,
  });

  String conversationId;

  /// Account ID of the reader
  String readerId;

  DateTime readAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WsMessagesReadEventDto &&
    other.conversationId == conversationId &&
    other.readerId == readerId &&
    other.readAt == readAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conversationId.hashCode) +
    (readerId.hashCode) +
    (readAt.hashCode);

  @override
  String toString() => 'WsMessagesReadEventDto[conversationId=$conversationId, readerId=$readerId, readAt=$readAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conversationId'] = this.conversationId;
      json[r'readerId'] = this.readerId;
      json[r'readAt'] = this.readAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [WsMessagesReadEventDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WsMessagesReadEventDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WsMessagesReadEventDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WsMessagesReadEventDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WsMessagesReadEventDto(
        conversationId: mapValueOfType<String>(json, r'conversationId')!,
        readerId: mapValueOfType<String>(json, r'readerId')!,
        readAt: mapDateTime(json, r'readAt', r'')!,
      );
    }
    return null;
  }

  static List<WsMessagesReadEventDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WsMessagesReadEventDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WsMessagesReadEventDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WsMessagesReadEventDto> mapFromJson(dynamic json) {
    final map = <String, WsMessagesReadEventDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WsMessagesReadEventDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WsMessagesReadEventDto-objects as value to a dart map
  static Map<String, List<WsMessagesReadEventDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WsMessagesReadEventDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WsMessagesReadEventDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversationId',
    'readerId',
    'readAt',
  };
}

