//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StripePaymentResponseDto {
  /// Returns a new [StripePaymentResponseDto] instance.
  StripePaymentResponseDto({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
  });


  /// Stripe PaymentIntent ID
  String paymentIntentId;

  /// Client secret for on-device payment confirmation
  String clientSecret;

  /// Payment amount in smallest currency unit (VND)
  num amount;

  /// ISO currency code (e.g., vnd)
  String currency;

  /// Stripe PaymentIntent status
  String status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StripePaymentResponseDto &&
    other.paymentIntentId == paymentIntentId &&
    other.clientSecret == clientSecret &&
    other.amount == amount &&
    other.currency == currency &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (paymentIntentId.hashCode) +
    (clientSecret.hashCode) +
    (amount.hashCode) +
    (currency.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'StripePaymentResponseDto[paymentIntentId=$paymentIntentId, clientSecret=$clientSecret, amount=$amount, currency=$currency, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'paymentIntentId'] = this.paymentIntentId;
      json[r'clientSecret'] = this.clientSecret;
      json[r'amount'] = this.amount;
      json[r'currency'] = this.currency;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [StripePaymentResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StripePaymentResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StripePaymentResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StripePaymentResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StripePaymentResponseDto(
        paymentIntentId: mapValueOfType<String>(json, r'paymentIntentId')!,
        clientSecret: mapValueOfType<String>(json, r'clientSecret')!,
        amount: num.parse('${json[r'amount']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        status: mapValueOfType<String>(json, r'status')!,
      );
    }
    return null;
  }

  static List<StripePaymentResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StripePaymentResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StripePaymentResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StripePaymentResponseDto> mapFromJson(dynamic json) {
    final map = <String, StripePaymentResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StripePaymentResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StripePaymentResponseDto-objects as value to a dart map
  static Map<String, List<StripePaymentResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StripePaymentResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StripePaymentResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'paymentIntentId',
    'clientSecret',
    'amount',
    'currency',
    'status',
  };
}

