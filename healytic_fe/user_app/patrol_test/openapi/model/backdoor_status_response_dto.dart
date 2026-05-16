//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;

class BackdoorStatusResponseDto {
  /// Returns a new [BackdoorStatusResponseDto] instance.
  BackdoorStatusResponseDto({
    required this.ok,
    required this.database,
    required this.nodeEnv,
  });


  bool ok;

  String database;

  String nodeEnv;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BackdoorStatusResponseDto &&
    other.ok == ok &&
    other.database == database &&
    other.nodeEnv == nodeEnv;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode) +
    (database.hashCode) +
    (nodeEnv.hashCode);

  @override
  String toString() => 'BackdoorStatusResponseDto[ok=$ok, database=$database, nodeEnv=$nodeEnv]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = this.ok;
      json[r'database'] = this.database;
      json[r'nodeEnv'] = this.nodeEnv;
    return json;
  }

  /// Returns a new [BackdoorStatusResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BackdoorStatusResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BackdoorStatusResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BackdoorStatusResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BackdoorStatusResponseDto(
        ok: mapValueOfType<bool>(json, r'ok')!,
        database: mapValueOfType<String>(json, r'database')!,
        nodeEnv: mapValueOfType<String>(json, r'nodeEnv')!,
      );
    }
    return null;
  }

  static List<BackdoorStatusResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BackdoorStatusResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BackdoorStatusResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BackdoorStatusResponseDto> mapFromJson(dynamic json) {
    final map = <String, BackdoorStatusResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BackdoorStatusResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BackdoorStatusResponseDto-objects as value to a dart map
  static Map<String, List<BackdoorStatusResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BackdoorStatusResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BackdoorStatusResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'ok',
    'database',
    'nodeEnv',
  };
}

