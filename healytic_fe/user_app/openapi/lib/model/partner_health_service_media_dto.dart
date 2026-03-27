//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerHealthServiceMediaDto {
  /// Returns a new [PartnerHealthServiceMediaDto] instance.
  PartnerHealthServiceMediaDto({
    required this.id,
    required this.url,
    this.mediaType,
    this.isThumbnail,
    required this.sortOrder,
  });

  /// Unique media identifier
  String id;

  /// Media URL
  String url;

  /// Media type (image, video, etc.)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? mediaType;

  /// Whether this is the thumbnail
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isThumbnail;

  /// Sort order for display
  num sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerHealthServiceMediaDto &&
    other.id == id &&
    other.url == url &&
    other.mediaType == mediaType &&
    other.isThumbnail == isThumbnail &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (url.hashCode) +
    (mediaType == null ? 0 : mediaType!.hashCode) +
    (isThumbnail == null ? 0 : isThumbnail!.hashCode) +
    (sortOrder.hashCode);

  @override
  String toString() => 'PartnerHealthServiceMediaDto[id=$id, url=$url, mediaType=$mediaType, isThumbnail=$isThumbnail, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'url'] = this.url;
    if (this.mediaType != null) {
      json[r'mediaType'] = this.mediaType;
    } else {
      json[r'mediaType'] = null;
    }
    if (this.isThumbnail != null) {
      json[r'isThumbnail'] = this.isThumbnail;
    } else {
      json[r'isThumbnail'] = null;
    }
      json[r'sortOrder'] = this.sortOrder;
    return json;
  }

  /// Returns a new [PartnerHealthServiceMediaDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerHealthServiceMediaDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerHealthServiceMediaDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerHealthServiceMediaDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerHealthServiceMediaDto(
        id: mapValueOfType<String>(json, r'id')!,
        url: mapValueOfType<String>(json, r'url')!,
        mediaType: mapValueOfType<String>(json, r'mediaType'),
        isThumbnail: mapValueOfType<bool>(json, r'isThumbnail'),
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<PartnerHealthServiceMediaDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerHealthServiceMediaDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerHealthServiceMediaDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerHealthServiceMediaDto> mapFromJson(dynamic json) {
    final map = <String, PartnerHealthServiceMediaDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerHealthServiceMediaDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerHealthServiceMediaDto-objects as value to a dart map
  static Map<String, List<PartnerHealthServiceMediaDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerHealthServiceMediaDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerHealthServiceMediaDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'url',
    'sortOrder',
  };
}

