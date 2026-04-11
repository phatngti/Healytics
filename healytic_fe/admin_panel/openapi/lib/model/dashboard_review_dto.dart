//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DashboardReviewDto {
  /// Returns a new [DashboardReviewDto] instance.
  DashboardReviewDto({
    required this.reviewerName,
    this.avatarUrl,
    required this.rating,
    required this.status,
    required this.date,
    required this.text,
    this.imageUrls = const [],
  });

  String reviewerName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatarUrl;

  num rating;

  DashboardReviewDtoStatusEnum status;

  String date;

  String text;

  List<String> imageUrls;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DashboardReviewDto &&
    other.reviewerName == reviewerName &&
    other.avatarUrl == avatarUrl &&
    other.rating == rating &&
    other.status == status &&
    other.date == date &&
    other.text == text &&
    _deepEquality.equals(other.imageUrls, imageUrls);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (reviewerName.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (rating.hashCode) +
    (status.hashCode) +
    (date.hashCode) +
    (text.hashCode) +
    (imageUrls.hashCode);

  @override
  String toString() => 'DashboardReviewDto[reviewerName=$reviewerName, avatarUrl=$avatarUrl, rating=$rating, status=$status, date=$date, text=$text, imageUrls=$imageUrls]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reviewerName'] = this.reviewerName;
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
      json[r'rating'] = this.rating;
      json[r'status'] = this.status;
      json[r'date'] = this.date;
      json[r'text'] = this.text;
      json[r'imageUrls'] = this.imageUrls;
    return json;
  }

  /// Returns a new [DashboardReviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DashboardReviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DashboardReviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DashboardReviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DashboardReviewDto(
        reviewerName: mapValueOfType<String>(json, r'reviewerName')!,
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        rating: num.parse('${json[r'rating']}'),
        status: DashboardReviewDtoStatusEnum.fromJson(json[r'status'])!,
        date: mapValueOfType<String>(json, r'date')!,
        text: mapValueOfType<String>(json, r'text')!,
        imageUrls: json[r'imageUrls'] is Iterable
            ? (json[r'imageUrls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<DashboardReviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardReviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardReviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DashboardReviewDto> mapFromJson(dynamic json) {
    final map = <String, DashboardReviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DashboardReviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DashboardReviewDto-objects as value to a dart map
  static Map<String, List<DashboardReviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DashboardReviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DashboardReviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reviewerName',
    'rating',
    'status',
    'date',
    'text',
    'imageUrls',
  };
}


class DashboardReviewDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const DashboardReviewDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const published = DashboardReviewDtoStatusEnum._(r'published');
  static const hidden = DashboardReviewDtoStatusEnum._(r'hidden');

  /// List of all possible values in this [enum][DashboardReviewDtoStatusEnum].
  static const values = <DashboardReviewDtoStatusEnum>[
    published,
    hidden,
  ];

  static DashboardReviewDtoStatusEnum? fromJson(dynamic value) => DashboardReviewDtoStatusEnumTypeTransformer().decode(value);

  static List<DashboardReviewDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardReviewDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardReviewDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DashboardReviewDtoStatusEnum] to String,
/// and [decode] dynamic data back to [DashboardReviewDtoStatusEnum].
class DashboardReviewDtoStatusEnumTypeTransformer {
  factory DashboardReviewDtoStatusEnumTypeTransformer() => _instance ??= const DashboardReviewDtoStatusEnumTypeTransformer._();

  const DashboardReviewDtoStatusEnumTypeTransformer._();

  String encode(DashboardReviewDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a DashboardReviewDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DashboardReviewDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'published': return DashboardReviewDtoStatusEnum.published;
        case r'hidden': return DashboardReviewDtoStatusEnum.hidden;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [DashboardReviewDtoStatusEnumTypeTransformer] instance.
  static DashboardReviewDtoStatusEnumTypeTransformer? _instance;
}


