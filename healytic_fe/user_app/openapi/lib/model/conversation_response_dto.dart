//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConversationResponseDto {
  /// Returns a new [ConversationResponseDto] instance.
  ConversationResponseDto({
    required this.id,
    required this.status,
    this.bookingId,
    required this.otherParticipant,
    required this.lastMessage,
    required this.unreadCount,
    required this.createdAt,
  });


  String id;

  ConversationStatus status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? bookingId;

  ParticipantInfoDto otherParticipant;

  LastMessageDto lastMessage;

  num unreadCount;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConversationResponseDto &&
    other.id == id &&
    other.status == status &&
    other.bookingId == bookingId &&
    other.otherParticipant == otherParticipant &&
    other.lastMessage == lastMessage &&
    other.unreadCount == unreadCount &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (status.hashCode) +
    (bookingId == null ? 0 : bookingId!.hashCode) +
    (otherParticipant.hashCode) +
    (lastMessage.hashCode) +
    (unreadCount.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'ConversationResponseDto[id=$id, status=$status, bookingId=$bookingId, otherParticipant=$otherParticipant, lastMessage=$lastMessage, unreadCount=$unreadCount, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'status'] = this.status;
    if (this.bookingId != null) {
      json[r'bookingId'] = this.bookingId;
    } else {
      json[r'bookingId'] = null;
    }
      json[r'otherParticipant'] = this.otherParticipant;
      json[r'lastMessage'] = this.lastMessage;
      json[r'unreadCount'] = this.unreadCount;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ConversationResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConversationResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConversationResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConversationResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConversationResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        status: ConversationStatus.fromJson(json[r'status'])!,
        bookingId: mapValueOfType<String>(json, r'bookingId'),
        otherParticipant: ParticipantInfoDto.fromJson(json[r'otherParticipant'])!,
        lastMessage: LastMessageDto.fromJson(json[r'lastMessage'])!,
        unreadCount: num.parse('${json[r'unreadCount']}'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<ConversationResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConversationResponseDto> mapFromJson(dynamic json) {
    final map = <String, ConversationResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConversationResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConversationResponseDto-objects as value to a dart map
  static Map<String, List<ConversationResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConversationResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConversationResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'status',
    'otherParticipant',
    'lastMessage',
    'unreadCount',
    'createdAt',
  };
}

