//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateMoMoPaymentDto {
  /// Returns a new [CreateMoMoPaymentDto] instance.
  CreateMoMoPaymentDto({
    this.requestType,
  });


  /// MoMo request type: captureWallet | payWithATM | payWithCC
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? requestType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateMoMoPaymentDto &&
    other.requestType == requestType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (requestType == null ? 0 : requestType!.hashCode);

  @override
  String toString() => 'CreateMoMoPaymentDto[requestType=$requestType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.requestType != null) {
      json[r'requestType'] = this.requestType;
    } else {
      json[r'requestType'] = null;
    }
    return json;
  }

  /// Returns a new [CreateMoMoPaymentDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateMoMoPaymentDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateMoMoPaymentDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateMoMoPaymentDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateMoMoPaymentDto(
        requestType: mapValueOfType<String>(json, r'requestType'),
      );
    }
    return null;
  }

  static List<CreateMoMoPaymentDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateMoMoPaymentDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateMoMoPaymentDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateMoMoPaymentDto> mapFromJson(dynamic json) {
    final map = <String, CreateMoMoPaymentDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateMoMoPaymentDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateMoMoPaymentDto-objects as value to a dart map
  static Map<String, List<CreateMoMoPaymentDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateMoMoPaymentDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateMoMoPaymentDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

