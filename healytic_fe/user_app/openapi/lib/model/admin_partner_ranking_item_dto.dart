//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminPartnerRankingItemDto {
  /// Returns a new [AdminPartnerRankingItemDto] instance.
  AdminPartnerRankingItemDto({
    required this.partnerId,
    required this.partnerName,
    required this.rank,
    required this.grossRevenue,
    required this.bookingCount,
    required this.successfulBookingRate,
    required this.verificationStatus,
  });


  String partnerId;

  String partnerName;

  num rank;

  num grossRevenue;

  num bookingCount;

  num successfulBookingRate;

  AdminPartnerRankingVerificationStatus verificationStatus;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPartnerRankingItemDto &&
    other.partnerId == partnerId &&
    other.partnerName == partnerName &&
    other.rank == rank &&
    other.grossRevenue == grossRevenue &&
    other.bookingCount == bookingCount &&
    other.successfulBookingRate == successfulBookingRate &&
    other.verificationStatus == verificationStatus;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (partnerId.hashCode) +
    (partnerName.hashCode) +
    (rank.hashCode) +
    (grossRevenue.hashCode) +
    (bookingCount.hashCode) +
    (successfulBookingRate.hashCode) +
    (verificationStatus.hashCode);

  @override
  String toString() => 'AdminPartnerRankingItemDto[partnerId=$partnerId, partnerName=$partnerName, rank=$rank, grossRevenue=$grossRevenue, bookingCount=$bookingCount, successfulBookingRate=$successfulBookingRate, verificationStatus=$verificationStatus]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'partnerId'] = this.partnerId;
      json[r'partnerName'] = this.partnerName;
      json[r'rank'] = this.rank;
      json[r'grossRevenue'] = this.grossRevenue;
      json[r'bookingCount'] = this.bookingCount;
      json[r'successfulBookingRate'] = this.successfulBookingRate;
      json[r'verificationStatus'] = this.verificationStatus;
    return json;
  }

  /// Returns a new [AdminPartnerRankingItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPartnerRankingItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminPartnerRankingItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminPartnerRankingItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminPartnerRankingItemDto(
        partnerId: mapValueOfType<String>(json, r'partnerId')!,
        partnerName: mapValueOfType<String>(json, r'partnerName')!,
        rank: num.parse('${json[r'rank']}'),
        grossRevenue: num.parse('${json[r'grossRevenue']}'),
        bookingCount: num.parse('${json[r'bookingCount']}'),
        successfulBookingRate: num.parse('${json[r'successfulBookingRate']}'),
        verificationStatus: AdminPartnerRankingVerificationStatus.fromJson(json[r'verificationStatus'])!,
      );
    }
    return null;
  }

  static List<AdminPartnerRankingItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerRankingItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerRankingItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPartnerRankingItemDto> mapFromJson(dynamic json) {
    final map = <String, AdminPartnerRankingItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPartnerRankingItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPartnerRankingItemDto-objects as value to a dart map
  static Map<String, List<AdminPartnerRankingItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPartnerRankingItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPartnerRankingItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'partnerId',
    'partnerName',
    'rank',
    'grossRevenue',
    'bookingCount',
    'successfulBookingRate',
    'verificationStatus',
  };
}

