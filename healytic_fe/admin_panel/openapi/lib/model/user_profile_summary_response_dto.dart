//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserProfileSummaryResponseDto {
  /// Returns a new [UserProfileSummaryResponseDto] instance.
  UserProfileSummaryResponseDto({
    required this.ordersCount,
    required this.wishlistCount,
    required this.points,
    required this.pointsLabel,
  });


  num ordersCount;

  num wishlistCount;

  num points;

  String pointsLabel;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserProfileSummaryResponseDto &&
    other.ordersCount == ordersCount &&
    other.wishlistCount == wishlistCount &&
    other.points == points &&
    other.pointsLabel == pointsLabel;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ordersCount.hashCode) +
    (wishlistCount.hashCode) +
    (points.hashCode) +
    (pointsLabel.hashCode);

  @override
  String toString() => 'UserProfileSummaryResponseDto[ordersCount=$ordersCount, wishlistCount=$wishlistCount, points=$points, pointsLabel=$pointsLabel]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ordersCount'] = this.ordersCount;
      json[r'wishlistCount'] = this.wishlistCount;
      json[r'points'] = this.points;
      json[r'pointsLabel'] = this.pointsLabel;
    return json;
  }

  /// Returns a new [UserProfileSummaryResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserProfileSummaryResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserProfileSummaryResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserProfileSummaryResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserProfileSummaryResponseDto(
        ordersCount: num.parse('${json[r'ordersCount']}'),
        wishlistCount: num.parse('${json[r'wishlistCount']}'),
        points: num.parse('${json[r'points']}'),
        pointsLabel: mapValueOfType<String>(json, r'pointsLabel')!,
      );
    }
    return null;
  }

  static List<UserProfileSummaryResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileSummaryResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileSummaryResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserProfileSummaryResponseDto> mapFromJson(dynamic json) {
    final map = <String, UserProfileSummaryResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserProfileSummaryResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserProfileSummaryResponseDto-objects as value to a dart map
  static Map<String, List<UserProfileSummaryResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserProfileSummaryResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserProfileSummaryResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'ordersCount',
    'wishlistCount',
    'points',
    'pointsLabel',
  };
}

