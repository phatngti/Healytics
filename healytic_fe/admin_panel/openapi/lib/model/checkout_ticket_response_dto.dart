//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CheckoutTicketResponseDto {
  /// Returns a new [CheckoutTicketResponseDto] instance.
  CheckoutTicketResponseDto({
    required this.id,
    required this.userId,
    required this.staffId,
    required this.startTime,
    required this.status,
    required this.idempotencyKey,
    this.bookingId,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });


  /// Ticket ID (same as ticket_id in webhook)
  String id;

  String userId;

  String staffId;

  DateTime startTime;

  CheckoutTicketResponseDtoStatusEnum status;

  String idempotencyKey;

  /// Booking ID when checkout succeeds
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? bookingId;

  /// Error message when checkout fails
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? errorMessage;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CheckoutTicketResponseDto &&
    other.id == id &&
    other.userId == userId &&
    other.staffId == staffId &&
    other.startTime == startTime &&
    other.status == status &&
    other.idempotencyKey == idempotencyKey &&
    other.bookingId == bookingId &&
    other.errorMessage == errorMessage &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (userId.hashCode) +
    (staffId.hashCode) +
    (startTime.hashCode) +
    (status.hashCode) +
    (idempotencyKey.hashCode) +
    (bookingId == null ? 0 : bookingId!.hashCode) +
    (errorMessage == null ? 0 : errorMessage!.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'CheckoutTicketResponseDto[id=$id, userId=$userId, staffId=$staffId, startTime=$startTime, status=$status, idempotencyKey=$idempotencyKey, bookingId=$bookingId, errorMessage=$errorMessage, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'userId'] = this.userId;
      json[r'staffId'] = this.staffId;
      json[r'startTime'] = this.startTime.toUtc().toIso8601String();
      json[r'status'] = this.status;
      json[r'idempotencyKey'] = this.idempotencyKey;
    if (this.bookingId != null) {
      json[r'bookingId'] = this.bookingId;
    } else {
      json[r'bookingId'] = null;
    }
    if (this.errorMessage != null) {
      json[r'errorMessage'] = this.errorMessage;
    } else {
      json[r'errorMessage'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'updatedAt'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CheckoutTicketResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CheckoutTicketResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CheckoutTicketResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CheckoutTicketResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CheckoutTicketResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        userId: mapValueOfType<String>(json, r'userId')!,
        staffId: mapValueOfType<String>(json, r'staffId')!,
        startTime: mapDateTime(json, r'startTime', r'')!,
        status: CheckoutTicketResponseDtoStatusEnum.fromJson(json[r'status'])!,
        idempotencyKey: mapValueOfType<String>(json, r'idempotencyKey')!,
        bookingId: mapValueOfType<String>(json, r'bookingId'),
        errorMessage: mapValueOfType<String>(json, r'errorMessage'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
      );
    }
    return null;
  }

  static List<CheckoutTicketResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckoutTicketResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckoutTicketResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CheckoutTicketResponseDto> mapFromJson(dynamic json) {
    final map = <String, CheckoutTicketResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CheckoutTicketResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CheckoutTicketResponseDto-objects as value to a dart map
  static Map<String, List<CheckoutTicketResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CheckoutTicketResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CheckoutTicketResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'userId',
    'staffId',
    'startTime',
    'status',
    'idempotencyKey',
    'createdAt',
    'updatedAt',
  };
}


class CheckoutTicketResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CheckoutTicketResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const QUEUED = CheckoutTicketResponseDtoStatusEnum._(r'QUEUED');
  static const PROCESSING = CheckoutTicketResponseDtoStatusEnum._(r'PROCESSING');
  static const SUCCESS = CheckoutTicketResponseDtoStatusEnum._(r'SUCCESS');
  static const FAILED = CheckoutTicketResponseDtoStatusEnum._(r'FAILED');

  /// List of all possible values in this [enum][CheckoutTicketResponseDtoStatusEnum].
  static const values = <CheckoutTicketResponseDtoStatusEnum>[
    QUEUED,
    PROCESSING,
    SUCCESS,
    FAILED,
  ];

  static CheckoutTicketResponseDtoStatusEnum? fromJson(dynamic value) => CheckoutTicketResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<CheckoutTicketResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckoutTicketResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckoutTicketResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CheckoutTicketResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CheckoutTicketResponseDtoStatusEnum].
class CheckoutTicketResponseDtoStatusEnumTypeTransformer {
  factory CheckoutTicketResponseDtoStatusEnumTypeTransformer() => _instance ??= const CheckoutTicketResponseDtoStatusEnumTypeTransformer._();

  const CheckoutTicketResponseDtoStatusEnumTypeTransformer._();

  String encode(CheckoutTicketResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CheckoutTicketResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CheckoutTicketResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'QUEUED': return CheckoutTicketResponseDtoStatusEnum.QUEUED;
        case r'PROCESSING': return CheckoutTicketResponseDtoStatusEnum.PROCESSING;
        case r'SUCCESS': return CheckoutTicketResponseDtoStatusEnum.SUCCESS;
        case r'FAILED': return CheckoutTicketResponseDtoStatusEnum.FAILED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CheckoutTicketResponseDtoStatusEnumTypeTransformer] instance.
  static CheckoutTicketResponseDtoStatusEnumTypeTransformer? _instance;
}


