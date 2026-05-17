//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminServiceRankingItemDto {
  /// Returns a new [AdminServiceRankingItemDto] instance.
  AdminServiceRankingItemDto({
    required this.serviceId,
    required this.serviceName,
    required this.categoryName,
    required this.partnerName,
    required this.rank,
    required this.grossRevenue,
    required this.bookingCount,
  });


  String serviceId;

  String serviceName;

  String categoryName;

  String partnerName;

  num rank;

  num grossRevenue;

  num bookingCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminServiceRankingItemDto &&
    other.serviceId == serviceId &&
    other.serviceName == serviceName &&
    other.categoryName == categoryName &&
    other.partnerName == partnerName &&
    other.rank == rank &&
    other.grossRevenue == grossRevenue &&
    other.bookingCount == bookingCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (serviceId.hashCode) +
    (serviceName.hashCode) +
    (categoryName.hashCode) +
    (partnerName.hashCode) +
    (rank.hashCode) +
    (grossRevenue.hashCode) +
    (bookingCount.hashCode);

  @override
  String toString() => 'AdminServiceRankingItemDto[serviceId=$serviceId, serviceName=$serviceName, categoryName=$categoryName, partnerName=$partnerName, rank=$rank, grossRevenue=$grossRevenue, bookingCount=$bookingCount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'serviceId'] = this.serviceId;
      json[r'serviceName'] = this.serviceName;
      json[r'categoryName'] = this.categoryName;
      json[r'partnerName'] = this.partnerName;
      json[r'rank'] = this.rank;
      json[r'grossRevenue'] = this.grossRevenue;
      json[r'bookingCount'] = this.bookingCount;
    return json;
  }

  /// Returns a new [AdminServiceRankingItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminServiceRankingItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminServiceRankingItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminServiceRankingItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminServiceRankingItemDto(
        serviceId: mapValueOfType<String>(json, r'serviceId')!,
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        categoryName: mapValueOfType<String>(json, r'categoryName')!,
        partnerName: mapValueOfType<String>(json, r'partnerName')!,
        rank: num.parse('${json[r'rank']}'),
        grossRevenue: num.parse('${json[r'grossRevenue']}'),
        bookingCount: num.parse('${json[r'bookingCount']}'),
      );
    }
    return null;
  }

  static List<AdminServiceRankingItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminServiceRankingItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminServiceRankingItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminServiceRankingItemDto> mapFromJson(dynamic json) {
    final map = <String, AdminServiceRankingItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminServiceRankingItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminServiceRankingItemDto-objects as value to a dart map
  static Map<String, List<AdminServiceRankingItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminServiceRankingItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminServiceRankingItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'serviceId',
    'serviceName',
    'categoryName',
    'partnerName',
    'rank',
    'grossRevenue',
    'bookingCount',
  };
}

