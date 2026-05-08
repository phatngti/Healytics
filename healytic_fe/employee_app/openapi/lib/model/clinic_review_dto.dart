//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicReviewDto {
  /// Returns a new [ClinicReviewDto] instance.
  ClinicReviewDto({
    required this.id,
    required this.reviewerName,
    required this.reviewerInitial,
    required this.starCount,
    this.memberBadge,
    required this.dateLabel,
    this.serviceName,
    this.serviceIcon,
    required this.reviewText,
    this.mediaUrls = const [],
    this.clinicResponse,
  });


  String id;

  /// Masked name for privacy
  String reviewerName;

  String reviewerInitial;

  /// Minimum value: 1
  /// Maximum value: 5
  num starCount;

  /// null for MVP
  String? memberBadge;

  String dateLabel;

  String? serviceName;

  String? serviceIcon;

  String reviewText;

  List<String> mediaUrls;

  ClinicReviewResponseSubDto? clinicResponse;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicReviewDto &&
    other.id == id &&
    other.reviewerName == reviewerName &&
    other.reviewerInitial == reviewerInitial &&
    other.starCount == starCount &&
    other.memberBadge == memberBadge &&
    other.dateLabel == dateLabel &&
    other.serviceName == serviceName &&
    other.serviceIcon == serviceIcon &&
    other.reviewText == reviewText &&
    _deepEquality.equals(other.mediaUrls, mediaUrls) &&
    other.clinicResponse == clinicResponse;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (reviewerName.hashCode) +
    (reviewerInitial.hashCode) +
    (starCount.hashCode) +
    (memberBadge == null ? 0 : memberBadge!.hashCode) +
    (dateLabel.hashCode) +
    (serviceName == null ? 0 : serviceName!.hashCode) +
    (serviceIcon == null ? 0 : serviceIcon!.hashCode) +
    (reviewText.hashCode) +
    (mediaUrls.hashCode) +
    (clinicResponse == null ? 0 : clinicResponse!.hashCode);

  @override
  String toString() => 'ClinicReviewDto[id=$id, reviewerName=$reviewerName, reviewerInitial=$reviewerInitial, starCount=$starCount, memberBadge=$memberBadge, dateLabel=$dateLabel, serviceName=$serviceName, serviceIcon=$serviceIcon, reviewText=$reviewText, mediaUrls=$mediaUrls, clinicResponse=$clinicResponse]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'reviewerName'] = this.reviewerName;
      json[r'reviewerInitial'] = this.reviewerInitial;
      json[r'starCount'] = this.starCount;
    if (this.memberBadge != null) {
      json[r'memberBadge'] = this.memberBadge;
    } else {
      json[r'memberBadge'] = null;
    }
      json[r'dateLabel'] = this.dateLabel;
    if (this.serviceName != null) {
      json[r'serviceName'] = this.serviceName;
    } else {
      json[r'serviceName'] = null;
    }
    if (this.serviceIcon != null) {
      json[r'serviceIcon'] = this.serviceIcon;
    } else {
      json[r'serviceIcon'] = null;
    }
      json[r'reviewText'] = this.reviewText;
      json[r'mediaUrls'] = this.mediaUrls;
    if (this.clinicResponse != null) {
      json[r'clinicResponse'] = this.clinicResponse;
    } else {
      json[r'clinicResponse'] = null;
    }
    return json;
  }

  /// Returns a new [ClinicReviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicReviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicReviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicReviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicReviewDto(
        id: mapValueOfType<String>(json, r'id')!,
        reviewerName: mapValueOfType<String>(json, r'reviewerName')!,
        reviewerInitial: mapValueOfType<String>(json, r'reviewerInitial')!,
        starCount: num.parse('${json[r'starCount']}'),
        memberBadge: mapValueOfType<String>(json, r'memberBadge'),
        dateLabel: mapValueOfType<String>(json, r'dateLabel')!,
        serviceName: mapValueOfType<String>(json, r'serviceName'),
        serviceIcon: mapValueOfType<String>(json, r'serviceIcon'),
        reviewText: mapValueOfType<String>(json, r'reviewText')!,
        mediaUrls: json[r'mediaUrls'] is Iterable
            ? (json[r'mediaUrls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        clinicResponse: ClinicReviewResponseSubDto.fromJson(json[r'clinicResponse']),
      );
    }
    return null;
  }

  static List<ClinicReviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicReviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicReviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicReviewDto> mapFromJson(dynamic json) {
    final map = <String, ClinicReviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicReviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicReviewDto-objects as value to a dart map
  static Map<String, List<ClinicReviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicReviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicReviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'reviewerName',
    'reviewerInitial',
    'starCount',
    'dateLabel',
    'reviewText',
    'mediaUrls',
  };
}

