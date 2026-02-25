//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SendMessageResponseDto {
  /// Returns a new [SendMessageResponseDto] instance.
  SendMessageResponseDto({
    required this.conversationId,
    required this.streamUrl,
  });

  /// The conversation ID to use for the SSE stream
  String conversationId;

  /// SSE stream URL to connect to
  String streamUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendMessageResponseDto &&
    other.conversationId == conversationId &&
    other.streamUrl == streamUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (conversationId.hashCode) +
    (streamUrl.hashCode);

  @override
  String toString() => 'SendMessageResponseDto[conversationId=$conversationId, streamUrl=$streamUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'conversationId'] = this.conversationId;
      json[r'streamUrl'] = this.streamUrl;
    return json;
  }

  /// Returns a new [SendMessageResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendMessageResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SendMessageResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SendMessageResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SendMessageResponseDto(
        conversationId: mapValueOfType<String>(json, r'conversationId')!,
        streamUrl: mapValueOfType<String>(json, r'streamUrl')!,
      );
    }
    return null;
  }

  static List<SendMessageResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendMessageResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendMessageResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendMessageResponseDto> mapFromJson(dynamic json) {
    final map = <String, SendMessageResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendMessageResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendMessageResponseDto-objects as value to a dart map
  static Map<String, List<SendMessageResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendMessageResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendMessageResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'conversationId',
    'streamUrl',
  };
}

