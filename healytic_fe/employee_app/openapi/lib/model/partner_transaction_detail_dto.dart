//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerTransactionDetailDto {
  /// Returns a new [PartnerTransactionDetailDto] instance.
  PartnerTransactionDetailDto({
    required this.record,
    this.payoutRecord,
    this.relatedRefundCases = const [],
    required this.sourceSummaryTitle,
    required this.sourceSummarySubtitle,
  });


  PartnerTransactionRecordDto record;

  PartnerPayoutRecordDto? payoutRecord;

  List<PartnerRefundCaseRecordDto> relatedRefundCases;

  String sourceSummaryTitle;

  String sourceSummarySubtitle;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerTransactionDetailDto &&
    other.record == record &&
    other.payoutRecord == payoutRecord &&
    _deepEquality.equals(other.relatedRefundCases, relatedRefundCases) &&
    other.sourceSummaryTitle == sourceSummaryTitle &&
    other.sourceSummarySubtitle == sourceSummarySubtitle;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (record.hashCode) +
    (payoutRecord == null ? 0 : payoutRecord!.hashCode) +
    (relatedRefundCases.hashCode) +
    (sourceSummaryTitle.hashCode) +
    (sourceSummarySubtitle.hashCode);

  @override
  String toString() => 'PartnerTransactionDetailDto[record=$record, payoutRecord=$payoutRecord, relatedRefundCases=$relatedRefundCases, sourceSummaryTitle=$sourceSummaryTitle, sourceSummarySubtitle=$sourceSummarySubtitle]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'record'] = this.record;
    if (this.payoutRecord != null) {
      json[r'payoutRecord'] = this.payoutRecord;
    } else {
      json[r'payoutRecord'] = null;
    }
      json[r'relatedRefundCases'] = this.relatedRefundCases;
      json[r'sourceSummaryTitle'] = this.sourceSummaryTitle;
      json[r'sourceSummarySubtitle'] = this.sourceSummarySubtitle;
    return json;
  }

  /// Returns a new [PartnerTransactionDetailDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerTransactionDetailDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerTransactionDetailDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerTransactionDetailDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerTransactionDetailDto(
        record: PartnerTransactionRecordDto.fromJson(json[r'record'])!,
        payoutRecord: PartnerPayoutRecordDto.fromJson(json[r'payoutRecord']),
        relatedRefundCases: PartnerRefundCaseRecordDto.listFromJson(json[r'relatedRefundCases']),
        sourceSummaryTitle: mapValueOfType<String>(json, r'sourceSummaryTitle')!,
        sourceSummarySubtitle: mapValueOfType<String>(json, r'sourceSummarySubtitle')!,
      );
    }
    return null;
  }

  static List<PartnerTransactionDetailDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerTransactionDetailDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerTransactionDetailDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerTransactionDetailDto> mapFromJson(dynamic json) {
    final map = <String, PartnerTransactionDetailDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerTransactionDetailDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerTransactionDetailDto-objects as value to a dart map
  static Map<String, List<PartnerTransactionDetailDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerTransactionDetailDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerTransactionDetailDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'record',
    'relatedRefundCases',
    'sourceSummaryTitle',
    'sourceSummarySubtitle',
  };
}

