//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceTrendPointDto {
  /// Returns a new [AdminFinanceTrendPointDto] instance.
  AdminFinanceTrendPointDto({
    required this.date,
    required this.grossAmount,
    required this.netAmount,
    required this.refundAmount,
    required this.payoutAmount,
  });


  String date;

  num grossAmount;

  num netAmount;

  num refundAmount;

  num payoutAmount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceTrendPointDto &&
    other.date == date &&
    other.grossAmount == grossAmount &&
    other.netAmount == netAmount &&
    other.refundAmount == refundAmount &&
    other.payoutAmount == payoutAmount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (grossAmount.hashCode) +
    (netAmount.hashCode) +
    (refundAmount.hashCode) +
    (payoutAmount.hashCode);

  @override
  String toString() => 'AdminFinanceTrendPointDto[date=$date, grossAmount=$grossAmount, netAmount=$netAmount, refundAmount=$refundAmount, payoutAmount=$payoutAmount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = this.date;
      json[r'grossAmount'] = this.grossAmount;
      json[r'netAmount'] = this.netAmount;
      json[r'refundAmount'] = this.refundAmount;
      json[r'payoutAmount'] = this.payoutAmount;
    return json;
  }

  /// Returns a new [AdminFinanceTrendPointDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceTrendPointDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceTrendPointDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceTrendPointDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceTrendPointDto(
        date: mapValueOfType<String>(json, r'date')!,
        grossAmount: num.parse('${json[r'grossAmount']}'),
        netAmount: num.parse('${json[r'netAmount']}'),
        refundAmount: num.parse('${json[r'refundAmount']}'),
        payoutAmount: num.parse('${json[r'payoutAmount']}'),
      );
    }
    return null;
  }

  static List<AdminFinanceTrendPointDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceTrendPointDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceTrendPointDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceTrendPointDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceTrendPointDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceTrendPointDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceTrendPointDto-objects as value to a dart map
  static Map<String, List<AdminFinanceTrendPointDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceTrendPointDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceTrendPointDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'grossAmount',
    'netAmount',
    'refundAmount',
    'payoutAmount',
  };
}

