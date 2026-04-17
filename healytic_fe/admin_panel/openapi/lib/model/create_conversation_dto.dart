//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateConversationDto {
  /// Returns a new [CreateConversationDto] instance.
  CreateConversationDto({
    required this.healthPartnerId,
    this.bookingId,
    this.initialMessage,
  });


  /// Account ID of the health partner
  String healthPartnerId;

  /// Optional booking context for the conversation
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? bookingId;

  /// Optional first message to start the conversation
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? initialMessage;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateConversationDto &&
    other.healthPartnerId == healthPartnerId &&
    other.bookingId == bookingId &&
    other.initialMessage == initialMessage;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (healthPartnerId.hashCode) +
    (bookingId == null ? 0 : bookingId!.hashCode) +
    (initialMessage == null ? 0 : initialMessage!.hashCode);

  @override
  String toString() => 'CreateConversationDto[healthPartnerId=$healthPartnerId, bookingId=$bookingId, initialMessage=$initialMessage]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'healthPartnerId'] = this.healthPartnerId;
    if (this.bookingId != null) {
      json[r'bookingId'] = this.bookingId;
    } else {
      json[r'bookingId'] = null;
    }
    if (this.initialMessage != null) {
      json[r'initialMessage'] = this.initialMessage;
    } else {
      json[r'initialMessage'] = null;
    }
    return json;
  }

  /// Returns a new [CreateConversationDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateConversationDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateConversationDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateConversationDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateConversationDto(
        healthPartnerId: mapValueOfType<String>(json, r'healthPartnerId')!,
        bookingId: mapValueOfType<String>(json, r'bookingId'),
        initialMessage: mapValueOfType<String>(json, r'initialMessage'),
      );
    }
    return null;
  }

  static List<CreateConversationDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateConversationDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateConversationDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateConversationDto> mapFromJson(dynamic json) {
    final map = <String, CreateConversationDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateConversationDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateConversationDto-objects as value to a dart map
  static Map<String, List<CreateConversationDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateConversationDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateConversationDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'healthPartnerId',
  };
}

