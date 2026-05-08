//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AsyncCheckoutDto {
  /// Returns a new [AsyncCheckoutDto] instance.
  AsyncCheckoutDto({
    required this.userId,
    required this.staffId,
    required this.startTime,
    required this.productId,
    required this.idempotencyKey,
    this.webhookUrl,
  });


  /// User account UUID
  String userId;

  /// Staff/employee UUID
  String staffId;

  /// Desired slot start time (ISO 8601)
  String startTime;

  /// Product/service UUID
  String productId;

  /// Idempotency key to prevent duplicate requests from AI retry
  String idempotencyKey;

  /// Webhook URL to receive checkout result
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? webhookUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AsyncCheckoutDto &&
    other.userId == userId &&
    other.staffId == staffId &&
    other.startTime == startTime &&
    other.productId == productId &&
    other.idempotencyKey == idempotencyKey &&
    other.webhookUrl == webhookUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (staffId.hashCode) +
    (startTime.hashCode) +
    (productId.hashCode) +
    (idempotencyKey.hashCode) +
    (webhookUrl == null ? 0 : webhookUrl!.hashCode);

  @override
  String toString() => 'AsyncCheckoutDto[userId=$userId, staffId=$staffId, startTime=$startTime, productId=$productId, idempotencyKey=$idempotencyKey, webhookUrl=$webhookUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'userId'] = this.userId;
      json[r'staffId'] = this.staffId;
      json[r'startTime'] = this.startTime;
      json[r'productId'] = this.productId;
      json[r'idempotencyKey'] = this.idempotencyKey;
    if (this.webhookUrl != null) {
      json[r'webhookUrl'] = this.webhookUrl;
    } else {
      json[r'webhookUrl'] = null;
    }
    return json;
  }

  /// Returns a new [AsyncCheckoutDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AsyncCheckoutDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AsyncCheckoutDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AsyncCheckoutDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AsyncCheckoutDto(
        userId: mapValueOfType<String>(json, r'userId')!,
        staffId: mapValueOfType<String>(json, r'staffId')!,
        startTime: mapValueOfType<String>(json, r'startTime')!,
        productId: mapValueOfType<String>(json, r'productId')!,
        idempotencyKey: mapValueOfType<String>(json, r'idempotencyKey')!,
        webhookUrl: mapValueOfType<String>(json, r'webhookUrl'),
      );
    }
    return null;
  }

  static List<AsyncCheckoutDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AsyncCheckoutDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AsyncCheckoutDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AsyncCheckoutDto> mapFromJson(dynamic json) {
    final map = <String, AsyncCheckoutDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AsyncCheckoutDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AsyncCheckoutDto-objects as value to a dart map
  static Map<String, List<AsyncCheckoutDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AsyncCheckoutDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AsyncCheckoutDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'userId',
    'staffId',
    'startTime',
    'productId',
    'idempotencyKey',
  };
}

