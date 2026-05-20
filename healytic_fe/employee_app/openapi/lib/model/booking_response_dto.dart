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

  String? productId;

  DateTime startTime;

  DateTime? endTime;

  BookingStatus status;

  String? paymentUrl;

  DateTime? paymentExpiresAt;

  String? notes;

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
      json[r'endTime'] = this.endTime!.toUtc().toIso8601String();
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
      json[r'paymentExpiresAt'] = this.paymentExpiresAt!.toUtc().toIso8601String();
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
        productId: mapValueOfType<String>(json, r'productId'),
        startTime: mapDateTime(json, r'startTime', r'')!,
        endTime: mapDateTime(json, r'endTime', r''),
        status: BookingStatus.fromJson(json[r'status'])!,
        paymentUrl: mapValueOfType<String>(json, r'paymentUrl'),
        paymentExpiresAt: mapDateTime(json, r'paymentExpiresAt', r''),
        notes: mapValueOfType<String>(json, r'notes'),
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

