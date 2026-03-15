//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BookingResponseDto {
  /// Returns a new [BookingResponseDto] instance.
  BookingResponseDto({
    required this.id,
    required this.userId,
    required this.staffId,
    this.productId,
    required this.startTime,
    this.endTime,
    required this.status,
    this.paymentUrl,
    this.paymentExpiresAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;

  String userId;

  String staffId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? productId;

  DateTime startTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? endTime;

  BookingResponseDtoStatusEnum status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? paymentUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? paymentExpiresAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? notes;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingResponseDto &&
    other.id == id &&
    other.userId == userId &&
    other.staffId == staffId &&
    other.productId == productId &&
    other.startTime == startTime &&
    other.endTime == endTime &&
    other.status == status &&
    other.paymentUrl == paymentUrl &&
    other.paymentExpiresAt == paymentExpiresAt &&
    other.notes == notes &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (userId.hashCode) +
    (staffId.hashCode) +
    (productId == null ? 0 : productId!.hashCode) +
    (startTime.hashCode) +
    (endTime == null ? 0 : endTime!.hashCode) +
    (status.hashCode) +
    (paymentUrl == null ? 0 : paymentUrl!.hashCode) +
    (paymentExpiresAt == null ? 0 : paymentExpiresAt!.hashCode) +
    (notes == null ? 0 : notes!.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'BookingResponseDto[id=$id, userId=$userId, staffId=$staffId, productId=$productId, startTime=$startTime, endTime=$endTime, status=$status, paymentUrl=$paymentUrl, paymentExpiresAt=$paymentExpiresAt, notes=$notes, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'userId'] = this.userId;
      json[r'staffId'] = this.staffId;
    if (this.productId != null) {
      json[r'productId'] = this.productId;
    } else {
      json[r'productId'] = null;
    }
      json[r'startTime'] = this.startTime.toUtc().toIso8601String();
    if (this.endTime != null) {
      json[r'endTime'] = this.endTime;
    } else {
      json[r'endTime'] = null;
    }
      json[r'status'] = this.status;
    if (this.paymentUrl != null) {
      json[r'paymentUrl'] = this.paymentUrl;
    } else {
      json[r'paymentUrl'] = null;
    }
    if (this.paymentExpiresAt != null) {
      json[r'paymentExpiresAt'] = this.paymentExpiresAt;
    } else {
      json[r'paymentExpiresAt'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'updatedAt'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [BookingResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BookingResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BookingResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BookingResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        userId: mapValueOfType<String>(json, r'userId')!,
        staffId: mapValueOfType<String>(json, r'staffId')!,
        productId: mapValueOfType<Object>(json, r'productId'),
        startTime: mapDateTime(json, r'startTime', r'')!,
        endTime: mapValueOfType<Object>(json, r'endTime'),
        status: BookingResponseDtoStatusEnum.fromJson(json[r'status'])!,
        paymentUrl: mapValueOfType<Object>(json, r'paymentUrl'),
        paymentExpiresAt: mapValueOfType<Object>(json, r'paymentExpiresAt'),
        notes: mapValueOfType<Object>(json, r'notes'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
      );
    }
    return null;
  }

  static List<BookingResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingResponseDto> mapFromJson(dynamic json) {
    final map = <String, BookingResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingResponseDto-objects as value to a dart map
  static Map<String, List<BookingResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingResponseDto.listFromJson(entry.value, growable: growable,);
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
    'createdAt',
    'updatedAt',
  };
}


class BookingResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const BookingResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING_PAYMENT = BookingResponseDtoStatusEnum._(r'PENDING_PAYMENT');
  static const CONFIRMED = BookingResponseDtoStatusEnum._(r'CONFIRMED');
  static const CANCELLED = BookingResponseDtoStatusEnum._(r'CANCELLED');
  static const COMPLETED = BookingResponseDtoStatusEnum._(r'COMPLETED');
  static const NO_SHOW = BookingResponseDtoStatusEnum._(r'NO_SHOW');

  /// List of all possible values in this [enum][BookingResponseDtoStatusEnum].
  static const values = <BookingResponseDtoStatusEnum>[
    PENDING_PAYMENT,
    CONFIRMED,
    CANCELLED,
    COMPLETED,
    NO_SHOW,
  ];

  static BookingResponseDtoStatusEnum? fromJson(dynamic value) => BookingResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<BookingResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [BookingResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [BookingResponseDtoStatusEnum].
class BookingResponseDtoStatusEnumTypeTransformer {
  factory BookingResponseDtoStatusEnumTypeTransformer() => _instance ??= const BookingResponseDtoStatusEnumTypeTransformer._();

  const BookingResponseDtoStatusEnumTypeTransformer._();

  String encode(BookingResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a BookingResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  BookingResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING_PAYMENT': return BookingResponseDtoStatusEnum.PENDING_PAYMENT;
        case r'CONFIRMED': return BookingResponseDtoStatusEnum.CONFIRMED;
        case r'CANCELLED': return BookingResponseDtoStatusEnum.CANCELLED;
        case r'COMPLETED': return BookingResponseDtoStatusEnum.COMPLETED;
        case r'NO_SHOW': return BookingResponseDtoStatusEnum.NO_SHOW;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [BookingResponseDtoStatusEnumTypeTransformer] instance.
  static BookingResponseDtoStatusEnumTypeTransformer? _instance;
}


