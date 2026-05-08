//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeAppointmentResponseDto {
  /// Returns a new [EmployeeAppointmentResponseDto] instance.
  EmployeeAppointmentResponseDto({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.customerId,
    this.imageUrl,
    required this.status,
    required this.category,
    required this.clinicName,
    required this.address,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    this.price,
    this.notes,
  });


  String id;

  String serviceName;

  String customerName;

  String customerId;

  String? imageUrl;

  EmployeeBookingStatusFilter status;

  String category;

  String clinicName;

  String address;

  DateTime date;

  String checkInTime;

  String checkOutTime;

  String duration;

  num? price;

  String? notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeAppointmentResponseDto &&
    other.id == id &&
    other.serviceName == serviceName &&
    other.customerName == customerName &&
    other.customerId == customerId &&
    other.imageUrl == imageUrl &&
    other.status == status &&
    other.category == category &&
    other.clinicName == clinicName &&
    other.address == address &&
    other.date == date &&
    other.checkInTime == checkInTime &&
    other.checkOutTime == checkOutTime &&
    other.duration == duration &&
    other.price == price &&
    other.notes == notes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (serviceName.hashCode) +
    (customerName.hashCode) +
    (customerId.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (status.hashCode) +
    (category.hashCode) +
    (clinicName.hashCode) +
    (address.hashCode) +
    (date.hashCode) +
    (checkInTime.hashCode) +
    (checkOutTime.hashCode) +
    (duration.hashCode) +
    (price == null ? 0 : price!.hashCode) +
    (notes == null ? 0 : notes!.hashCode);

  @override
  String toString() => 'EmployeeAppointmentResponseDto[id=$id, serviceName=$serviceName, customerName=$customerName, customerId=$customerId, imageUrl=$imageUrl, status=$status, category=$category, clinicName=$clinicName, address=$address, date=$date, checkInTime=$checkInTime, checkOutTime=$checkOutTime, duration=$duration, price=$price, notes=$notes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'serviceName'] = this.serviceName;
      json[r'customerName'] = this.customerName;
      json[r'customerId'] = this.customerId;
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
      json[r'status'] = this.status;
      json[r'category'] = this.category;
      json[r'clinicName'] = this.clinicName;
      json[r'address'] = this.address;
      json[r'date'] = this.date.toUtc().toIso8601String();
      json[r'checkInTime'] = this.checkInTime;
      json[r'checkOutTime'] = this.checkOutTime;
      json[r'duration'] = this.duration;
    if (this.price != null) {
      json[r'price'] = this.price;
    } else {
      json[r'price'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    return json;
  }

  /// Returns a new [EmployeeAppointmentResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeAppointmentResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeAppointmentResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeAppointmentResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeAppointmentResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        customerName: mapValueOfType<String>(json, r'customerName')!,
        customerId: mapValueOfType<String>(json, r'customerId')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        status: EmployeeBookingStatusFilter.fromJson(json[r'status'])!,
        category: mapValueOfType<String>(json, r'category')!,
        clinicName: mapValueOfType<String>(json, r'clinicName')!,
        address: mapValueOfType<String>(json, r'address')!,
        date: mapDateTime(json, r'date', r'')!,
        checkInTime: mapValueOfType<String>(json, r'checkInTime')!,
        checkOutTime: mapValueOfType<String>(json, r'checkOutTime')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        price: json[r'price'] == null
            ? null
            : num.parse('${json[r'price']}'),
        notes: mapValueOfType<String>(json, r'notes'),
      );
    }
    return null;
  }

  static List<EmployeeAppointmentResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeAppointmentResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeAppointmentResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeAppointmentResponseDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeAppointmentResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeAppointmentResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeAppointmentResponseDto-objects as value to a dart map
  static Map<String, List<EmployeeAppointmentResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeAppointmentResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeAppointmentResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'serviceName',
    'customerName',
    'customerId',
    'status',
    'category',
    'clinicName',
    'address',
    'date',
    'checkInTime',
    'checkOutTime',
    'duration',
  };
}

