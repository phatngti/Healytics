//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeRevenueBreakdownItemDto {
  /// Returns a new [EmployeeRevenueBreakdownItemDto] instance.
  EmployeeRevenueBreakdownItemDto({
    required this.serviceName,
    required this.count,
    required this.totalAmount,
  });


  String serviceName;

  num count;

  num totalAmount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeRevenueBreakdownItemDto &&
    other.serviceName == serviceName &&
    other.count == count &&
    other.totalAmount == totalAmount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (serviceName.hashCode) +
    (count.hashCode) +
    (totalAmount.hashCode);

  @override
  String toString() => 'EmployeeRevenueBreakdownItemDto[serviceName=$serviceName, count=$count, totalAmount=$totalAmount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'serviceName'] = this.serviceName;
      json[r'count'] = this.count;
      json[r'totalAmount'] = this.totalAmount;
    return json;
  }

  /// Returns a new [EmployeeRevenueBreakdownItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeRevenueBreakdownItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeRevenueBreakdownItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeRevenueBreakdownItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeRevenueBreakdownItemDto(
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        count: num.parse('${json[r'count']}'),
        totalAmount: num.parse('${json[r'totalAmount']}'),
      );
    }
    return null;
  }

  static List<EmployeeRevenueBreakdownItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeRevenueBreakdownItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeRevenueBreakdownItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeRevenueBreakdownItemDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeRevenueBreakdownItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeRevenueBreakdownItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeRevenueBreakdownItemDto-objects as value to a dart map
  static Map<String, List<EmployeeRevenueBreakdownItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeRevenueBreakdownItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeRevenueBreakdownItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'serviceName',
    'count',
    'totalAmount',
  };
}

