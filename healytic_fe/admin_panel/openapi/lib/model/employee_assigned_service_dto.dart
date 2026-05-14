//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeAssignedServiceDto {
  /// Returns a new [EmployeeAssignedServiceDto] instance.
  EmployeeAssignedServiceDto({
    required this.id,
    required this.name,
    required this.status,
    required this.basePrice,
    this.salePrice,
    required this.currency,
    this.durationMinutes,
    this.categoryName,
    this.imageUrl,
    required this.isPrimary,
  });


  /// Assigned service/product ID
  String id;

  /// Service name
  String name;

  HealthServiceStatus status;

  /// Base price in service currency
  num basePrice;

  /// Sale price in service currency, when configured
  num? salePrice;

  /// Currency code
  String currency;

  /// Service duration in minutes
  num? durationMinutes;

  /// Service category name
  String? categoryName;

  /// Preferred service image URL
  String? imageUrl;

  /// Whether this employee is primary for this service
  bool isPrimary;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeAssignedServiceDto &&
    other.id == id &&
    other.name == name &&
    other.status == status &&
    other.basePrice == basePrice &&
    other.salePrice == salePrice &&
    other.currency == currency &&
    other.durationMinutes == durationMinutes &&
    other.categoryName == categoryName &&
    other.imageUrl == imageUrl &&
    other.isPrimary == isPrimary;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (status.hashCode) +
    (basePrice.hashCode) +
    (salePrice == null ? 0 : salePrice!.hashCode) +
    (currency.hashCode) +
    (durationMinutes == null ? 0 : durationMinutes!.hashCode) +
    (categoryName == null ? 0 : categoryName!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (isPrimary.hashCode);

  @override
  String toString() => 'EmployeeAssignedServiceDto[id=$id, name=$name, status=$status, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, durationMinutes=$durationMinutes, categoryName=$categoryName, imageUrl=$imageUrl, isPrimary=$isPrimary]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'status'] = this.status;
      json[r'basePrice'] = this.basePrice;
    if (this.salePrice != null) {
      json[r'salePrice'] = this.salePrice;
    } else {
      json[r'salePrice'] = null;
    }
      json[r'currency'] = this.currency;
    if (this.durationMinutes != null) {
      json[r'durationMinutes'] = this.durationMinutes;
    } else {
      json[r'durationMinutes'] = null;
    }
    if (this.categoryName != null) {
      json[r'categoryName'] = this.categoryName;
    } else {
      json[r'categoryName'] = null;
    }
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
      json[r'isPrimary'] = this.isPrimary;
    return json;
  }

  /// Returns a new [EmployeeAssignedServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeAssignedServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeAssignedServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeAssignedServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeAssignedServiceDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        status: HealthServiceStatus.fromJson(json[r'status'])!,
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: json[r'salePrice'] == null
            ? null
            : num.parse('${json[r'salePrice']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        durationMinutes: json[r'durationMinutes'] == null
            ? null
            : num.parse('${json[r'durationMinutes']}'),
        categoryName: mapValueOfType<String>(json, r'categoryName'),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        isPrimary: mapValueOfType<bool>(json, r'isPrimary')!,
      );
    }
    return null;
  }

  static List<EmployeeAssignedServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeAssignedServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeAssignedServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeAssignedServiceDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeAssignedServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeAssignedServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeAssignedServiceDto-objects as value to a dart map
  static Map<String, List<EmployeeAssignedServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeAssignedServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeAssignedServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'status',
    'basePrice',
    'currency',
    'isPrimary',
  };
}

