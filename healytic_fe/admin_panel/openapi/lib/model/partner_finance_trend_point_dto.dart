//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerFinanceTrendPointDto {
  /// Returns a new [PartnerFinanceTrendPointDto] instance.
  PartnerFinanceTrendPointDto({
    required this.date,
    required this.grossAmount,
    required this.netAmount,
    required this.refundAmount,
  });


  String date;

  num grossAmount;

  num netAmount;

  num refundAmount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerFinanceTrendPointDto &&
    other.date == date &&
    other.grossAmount == grossAmount &&
    other.netAmount == netAmount &&
    other.refundAmount == refundAmount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (grossAmount.hashCode) +
    (netAmount.hashCode) +
    (refundAmount.hashCode);

  @override
  String toString() => 'PartnerFinanceTrendPointDto[date=$date, grossAmount=$grossAmount, netAmount=$netAmount, refundAmount=$refundAmount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = this.date;
      json[r'grossAmount'] = this.grossAmount;
      json[r'netAmount'] = this.netAmount;
      json[r'refundAmount'] = this.refundAmount;
    return json;
  }

  /// Returns a new [PartnerFinanceTrendPointDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerFinanceTrendPointDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerFinanceTrendPointDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerFinanceTrendPointDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerFinanceTrendPointDto(
        date: mapValueOfType<String>(json, r'date')!,
        grossAmount: num.parse('${json[r'grossAmount']}'),
        netAmount: num.parse('${json[r'netAmount']}'),
        refundAmount: num.parse('${json[r'refundAmount']}'),
      );
    }
    return null;
  }

  static List<PartnerFinanceTrendPointDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerFinanceTrendPointDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerFinanceTrendPointDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerFinanceTrendPointDto> mapFromJson(dynamic json) {
    final map = <String, PartnerFinanceTrendPointDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerFinanceTrendPointDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerFinanceTrendPointDto-objects as value to a dart map
  static Map<String, List<PartnerFinanceTrendPointDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerFinanceTrendPointDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerFinanceTrendPointDto.listFromJson(entry.value, growable: growable,);
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
  };
}

