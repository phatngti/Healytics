//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerTransactionTimelineEventDto {
  /// Returns a new [PartnerTransactionTimelineEventDto] instance.
  PartnerTransactionTimelineEventDto({
    required this.title,
    required this.description,
    required this.occurredAt,
  });


  String title;

  String description;

  String occurredAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerTransactionTimelineEventDto &&
    other.title == title &&
    other.description == description &&
    other.occurredAt == occurredAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (description.hashCode) +
    (occurredAt.hashCode);

  @override
  String toString() => 'PartnerTransactionTimelineEventDto[title=$title, description=$description, occurredAt=$occurredAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'description'] = this.description;
      json[r'occurredAt'] = this.occurredAt;
    return json;
  }

  /// Returns a new [PartnerTransactionTimelineEventDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerTransactionTimelineEventDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerTransactionTimelineEventDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerTransactionTimelineEventDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerTransactionTimelineEventDto(
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description')!,
        occurredAt: mapValueOfType<String>(json, r'occurredAt')!,
      );
    }
    return null;
  }

  static List<PartnerTransactionTimelineEventDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerTransactionTimelineEventDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerTransactionTimelineEventDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerTransactionTimelineEventDto> mapFromJson(dynamic json) {
    final map = <String, PartnerTransactionTimelineEventDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerTransactionTimelineEventDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerTransactionTimelineEventDto-objects as value to a dart map
  static Map<String, List<PartnerTransactionTimelineEventDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerTransactionTimelineEventDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerTransactionTimelineEventDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'description',
    'occurredAt',
  };
}

