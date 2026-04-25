//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BookingStatusBreakdownDto {
  /// Returns a new [BookingStatusBreakdownDto] instance.
  BookingStatusBreakdownDto({
    required this.statusKey,
    required this.label,
    required this.count,
  });


  /// Machine-readable status key: confirmed, cancelled, no_show
  String statusKey;

  /// Human-readable label
  String label;

  num count;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingStatusBreakdownDto &&
    other.statusKey == statusKey &&
    other.label == label &&
    other.count == count;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (statusKey.hashCode) +
    (label.hashCode) +
    (count.hashCode);

  @override
  String toString() => 'BookingStatusBreakdownDto[statusKey=$statusKey, label=$label, count=$count]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'statusKey'] = this.statusKey;
      json[r'label'] = this.label;
      json[r'count'] = this.count;
    return json;
  }

  /// Returns a new [BookingStatusBreakdownDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingStatusBreakdownDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BookingStatusBreakdownDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BookingStatusBreakdownDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BookingStatusBreakdownDto(
        statusKey: mapValueOfType<String>(json, r'statusKey')!,
        label: mapValueOfType<String>(json, r'label')!,
        count: num.parse('${json[r'count']}'),
      );
    }
    return null;
  }

  static List<BookingStatusBreakdownDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingStatusBreakdownDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingStatusBreakdownDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingStatusBreakdownDto> mapFromJson(dynamic json) {
    final map = <String, BookingStatusBreakdownDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingStatusBreakdownDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingStatusBreakdownDto-objects as value to a dart map
  static Map<String, List<BookingStatusBreakdownDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingStatusBreakdownDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingStatusBreakdownDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'statusKey',
    'label',
    'count',
  };
}

