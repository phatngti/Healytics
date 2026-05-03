//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateMoMoRefundDto {
  /// Returns a new [CreateMoMoRefundDto] instance.
  CreateMoMoRefundDto({
    required this.transId,
  });


  /// MoMo transaction ID from the original payment (required for refund)
  num transId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateMoMoRefundDto &&
    other.transId == transId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (transId.hashCode);

  @override
  String toString() => 'CreateMoMoRefundDto[transId=$transId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'transId'] = this.transId;
    return json;
  }

  /// Returns a new [CreateMoMoRefundDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateMoMoRefundDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateMoMoRefundDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateMoMoRefundDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateMoMoRefundDto(
        transId: num.parse('${json[r'transId']}'),
      );
    }
    return null;
  }

  static List<CreateMoMoRefundDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateMoMoRefundDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateMoMoRefundDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateMoMoRefundDto> mapFromJson(dynamic json) {
    final map = <String, CreateMoMoRefundDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateMoMoRefundDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateMoMoRefundDto-objects as value to a dart map
  static Map<String, List<CreateMoMoRefundDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateMoMoRefundDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateMoMoRefundDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'transId',
  };
}

