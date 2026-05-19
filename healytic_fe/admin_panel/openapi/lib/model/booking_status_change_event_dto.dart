//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BookingStatusChangeEventDto {
  /// Returns a new [BookingStatusChangeEventDto] instance.
  BookingStatusChangeEventDto({
    required this.eventId,
    required this.bookingId,
    required this.status,
    required this.persistedStatus,
    required this.previousStatus,
    required this.userId,
    this.partnerId,
    required this.specialistId,
    required this.changedBy,
    required this.occurredAt,
  });


  String eventId;

  String bookingId;

  PublicBookingStatus status;

  BookingStatus persistedStatus;

  BookingStatus previousStatus;

  String userId;

  String? partnerId;

  String specialistId;

  BookingStatusChangedByDto changedBy;

  DateTime occurredAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingStatusChangeEventDto &&
    other.eventId == eventId &&
    other.bookingId == bookingId &&
    other.status == status &&
    other.persistedStatus == persistedStatus &&
    other.previousStatus == previousStatus &&
    other.userId == userId &&
    other.partnerId == partnerId &&
    other.specialistId == specialistId &&
    other.changedBy == changedBy &&
    other.occurredAt == occurredAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (eventId.hashCode) +
    (bookingId.hashCode) +
    (status.hashCode) +
    (persistedStatus.hashCode) +
    (previousStatus.hashCode) +
    (userId.hashCode) +
    (partnerId == null ? 0 : partnerId!.hashCode) +
    (specialistId.hashCode) +
    (changedBy.hashCode) +
    (occurredAt.hashCode);

  @override
  String toString() => 'BookingStatusChangeEventDto[eventId=$eventId, bookingId=$bookingId, status=$status, persistedStatus=$persistedStatus, previousStatus=$previousStatus, userId=$userId, partnerId=$partnerId, specialistId=$specialistId, changedBy=$changedBy, occurredAt=$occurredAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'eventId'] = this.eventId;
      json[r'bookingId'] = this.bookingId;
      json[r'status'] = this.status;
      json[r'persistedStatus'] = this.persistedStatus;
      json[r'previousStatus'] = this.previousStatus;
      json[r'userId'] = this.userId;
    if (this.partnerId != null) {
      json[r'partnerId'] = this.partnerId;
    } else {
      json[r'partnerId'] = null;
    }
      json[r'specialistId'] = this.specialistId;
      json[r'changedBy'] = this.changedBy;
      json[r'occurredAt'] = this.occurredAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [BookingStatusChangeEventDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingStatusChangeEventDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BookingStatusChangeEventDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BookingStatusChangeEventDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BookingStatusChangeEventDto(
        eventId: mapValueOfType<String>(json, r'eventId')!,
        bookingId: mapValueOfType<String>(json, r'bookingId')!,
        status: PublicBookingStatus.fromJson(json[r'status'])!,
        persistedStatus: BookingStatus.fromJson(json[r'persistedStatus'])!,
        previousStatus: BookingStatus.fromJson(json[r'previousStatus'])!,
        userId: mapValueOfType<String>(json, r'userId')!,
        partnerId: mapValueOfType<String>(json, r'partnerId'),
        specialistId: mapValueOfType<String>(json, r'specialistId')!,
        changedBy: BookingStatusChangedByDto.fromJson(json[r'changedBy'])!,
        occurredAt: mapDateTime(json, r'occurredAt', r'')!,
      );
    }
    return null;
  }

  static List<BookingStatusChangeEventDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingStatusChangeEventDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingStatusChangeEventDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingStatusChangeEventDto> mapFromJson(dynamic json) {
    final map = <String, BookingStatusChangeEventDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingStatusChangeEventDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingStatusChangeEventDto-objects as value to a dart map
  static Map<String, List<BookingStatusChangeEventDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingStatusChangeEventDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingStatusChangeEventDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventId',
    'bookingId',
    'status',
    'persistedStatus',
    'previousStatus',
    'userId',
    'specialistId',
    'changedBy',
    'occurredAt',
  };
}

