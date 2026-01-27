//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReviewPartnerProfileDto {
  /// Returns a new [ReviewPartnerProfileDto] instance.
  ReviewPartnerProfileDto({
    required this.decision,
    this.generalComment,
    this.items = const [],
  });

  /// Overall decision on the partner profile
  ReviewPartnerProfileDtoDecisionEnum decision;

  /// General comment for the review
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? generalComment;

  /// List of specific items (fields or documents) with their validation status
  List<ReviewItemDto> items;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewPartnerProfileDto &&
    other.decision == decision &&
    other.generalComment == generalComment &&
    _deepEquality.equals(other.items, items);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (decision.hashCode) +
    (generalComment == null ? 0 : generalComment!.hashCode) +
    (items.hashCode);

  @override
  String toString() => 'ReviewPartnerProfileDto[decision=$decision, generalComment=$generalComment, items=$items]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'decision'] = this.decision;
    if (this.generalComment != null) {
      json[r'generalComment'] = this.generalComment;
    } else {
      json[r'generalComment'] = null;
    }
      json[r'items'] = this.items;
    return json;
  }

  /// Returns a new [ReviewPartnerProfileDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReviewPartnerProfileDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReviewPartnerProfileDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReviewPartnerProfileDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReviewPartnerProfileDto(
        decision: ReviewPartnerProfileDtoDecisionEnum.fromJson(json[r'decision'])!,
        generalComment: mapValueOfType<String>(json, r'generalComment'),
        items: ReviewItemDto.listFromJson(json[r'items']),
      );
    }
    return null;
  }

  static List<ReviewPartnerProfileDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewPartnerProfileDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewPartnerProfileDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewPartnerProfileDto> mapFromJson(dynamic json) {
    final map = <String, ReviewPartnerProfileDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReviewPartnerProfileDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewPartnerProfileDto-objects as value to a dart map
  static Map<String, List<ReviewPartnerProfileDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewPartnerProfileDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewPartnerProfileDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'decision',
  };
}

/// Overall decision on the partner profile
class ReviewPartnerProfileDtoDecisionEnum {
  /// Instantiate a new enum with the provided [value].
  const ReviewPartnerProfileDtoDecisionEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const APPROVED = ReviewPartnerProfileDtoDecisionEnum._(r'APPROVED');
  static const CHANGES_REQUIRED = ReviewPartnerProfileDtoDecisionEnum._(r'CHANGES_REQUIRED');
  static const REJECTED = ReviewPartnerProfileDtoDecisionEnum._(r'REJECTED');

  /// List of all possible values in this [enum][ReviewPartnerProfileDtoDecisionEnum].
  static const values = <ReviewPartnerProfileDtoDecisionEnum>[
    APPROVED,
    CHANGES_REQUIRED,
    REJECTED,
  ];

  static ReviewPartnerProfileDtoDecisionEnum? fromJson(dynamic value) => ReviewPartnerProfileDtoDecisionEnumTypeTransformer().decode(value);

  static List<ReviewPartnerProfileDtoDecisionEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewPartnerProfileDtoDecisionEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewPartnerProfileDtoDecisionEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ReviewPartnerProfileDtoDecisionEnum] to String,
/// and [decode] dynamic data back to [ReviewPartnerProfileDtoDecisionEnum].
class ReviewPartnerProfileDtoDecisionEnumTypeTransformer {
  factory ReviewPartnerProfileDtoDecisionEnumTypeTransformer() => _instance ??= const ReviewPartnerProfileDtoDecisionEnumTypeTransformer._();

  const ReviewPartnerProfileDtoDecisionEnumTypeTransformer._();

  String encode(ReviewPartnerProfileDtoDecisionEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ReviewPartnerProfileDtoDecisionEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ReviewPartnerProfileDtoDecisionEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'APPROVED': return ReviewPartnerProfileDtoDecisionEnum.APPROVED;
        case r'CHANGES_REQUIRED': return ReviewPartnerProfileDtoDecisionEnum.CHANGES_REQUIRED;
        case r'REJECTED': return ReviewPartnerProfileDtoDecisionEnum.REJECTED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ReviewPartnerProfileDtoDecisionEnumTypeTransformer] instance.
  static ReviewPartnerProfileDtoDecisionEnumTypeTransformer? _instance;
}


