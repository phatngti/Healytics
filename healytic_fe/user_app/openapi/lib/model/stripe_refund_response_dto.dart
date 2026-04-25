//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StripeRefundResponseDto {
  /// Returns a new [StripeRefundResponseDto] instance.
  StripeRefundResponseDto({
    required this.refundId,
    required this.amount,
    required this.currency,
    required this.status,
    this.paymentIntentId,
  });


  /// Stripe Refund ID
  String refundId;

  /// Refunded amount (VND)
  num amount;

  /// ISO currency code
  String currency;

  /// Refund status
  String status;

  /// Stripe PaymentIntent ID that was refunded
  String? paymentIntentId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StripeRefundResponseDto &&
    other.refundId == refundId &&
    other.amount == amount &&
    other.currency == currency &&
    other.status == status &&
    other.paymentIntentId == paymentIntentId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (refundId.hashCode) +
    (amount.hashCode) +
    (currency.hashCode) +
    (status.hashCode) +
    (paymentIntentId == null ? 0 : paymentIntentId!.hashCode);

  @override
  String toString() => 'StripeRefundResponseDto[refundId=$refundId, amount=$amount, currency=$currency, status=$status, paymentIntentId=$paymentIntentId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'refundId'] = this.refundId;
      json[r'amount'] = this.amount;
      json[r'currency'] = this.currency;
      json[r'status'] = this.status;
    if (this.paymentIntentId != null) {
      json[r'paymentIntentId'] = this.paymentIntentId;
    } else {
      json[r'paymentIntentId'] = null;
    }
    return json;
  }

  /// Returns a new [StripeRefundResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StripeRefundResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StripeRefundResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StripeRefundResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StripeRefundResponseDto(
        refundId: mapValueOfType<String>(json, r'refundId')!,
        amount: num.parse('${json[r'amount']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        status: mapValueOfType<String>(json, r'status')!,
        paymentIntentId: mapValueOfType<String>(json, r'paymentIntentId'),
      );
    }
    return null;
  }

  static List<StripeRefundResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StripeRefundResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StripeRefundResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StripeRefundResponseDto> mapFromJson(dynamic json) {
    final map = <String, StripeRefundResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StripeRefundResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StripeRefundResponseDto-objects as value to a dart map
  static Map<String, List<StripeRefundResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StripeRefundResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StripeRefundResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'refundId',
    'amount',
    'currency',
    'status',
  };
}

