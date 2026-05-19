//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateStripeSetupIntentResponseDto {
  /// Returns a new [CreateStripeSetupIntentResponseDto] instance.
  CreateStripeSetupIntentResponseDto({
    required this.setupIntentId,
    required this.clientSecret,
  });


  /// Stripe SetupIntent ID
  String setupIntentId;

  /// Client secret used by Stripe PaymentSheet to add a card
  String clientSecret;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateStripeSetupIntentResponseDto &&
    other.setupIntentId == setupIntentId &&
    other.clientSecret == clientSecret;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (setupIntentId.hashCode) +
    (clientSecret.hashCode);

  @override
  String toString() => 'CreateStripeSetupIntentResponseDto[setupIntentId=$setupIntentId, clientSecret=$clientSecret]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'setupIntentId'] = this.setupIntentId;
      json[r'clientSecret'] = this.clientSecret;
    return json;
  }

  /// Returns a new [CreateStripeSetupIntentResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateStripeSetupIntentResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateStripeSetupIntentResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateStripeSetupIntentResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateStripeSetupIntentResponseDto(
        setupIntentId: mapValueOfType<String>(json, r'setupIntentId')!,
        clientSecret: mapValueOfType<String>(json, r'clientSecret')!,
      );
    }
    return null;
  }

  static List<CreateStripeSetupIntentResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateStripeSetupIntentResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateStripeSetupIntentResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateStripeSetupIntentResponseDto> mapFromJson(dynamic json) {
    final map = <String, CreateStripeSetupIntentResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateStripeSetupIntentResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateStripeSetupIntentResponseDto-objects as value to a dart map
  static Map<String, List<CreateStripeSetupIntentResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateStripeSetupIntentResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateStripeSetupIntentResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'setupIntentId',
    'clientSecret',
  };
}

