//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdatePartnerHealthServiceDto {
  /// Returns a new [UpdatePartnerHealthServiceDto] instance.
  UpdatePartnerHealthServiceDto({
    this.categoryId,
    this.name,
    this.slug,
    this.description,
    this.type,
    this.basePrice,
    this.salePrice,
    this.currency,
    this.status,
    this.isVisibleOnline,
    this.employeeIds = const [],
    this.media = const [],
    this.productDefinition,
    this.facilityImages = const [],
    this.reviews = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? categoryId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? slug;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  UpdatePartnerHealthServiceDtoTypeEnum? type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? basePrice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? salePrice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currency;

  UpdatePartnerHealthServiceDtoStatusEnum? status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVisibleOnline;

  List<String> employeeIds;

  /// Product media (images/videos)
  List<CreatePartnerHealthServiceMediaDto> media;

  /// Product definition (required if type is service)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CreatePartnerHealthServiceDefinitionDto? productDefinition;

  /// Facility/clinic images
  List<CreatePartnerHealthServiceFacilityImageDto> facilityImages;

  /// Product reviews
  List<CreatePartnerHealthServiceReviewDto> reviews;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdatePartnerHealthServiceDto &&
    other.categoryId == categoryId &&
    other.name == name &&
    other.slug == slug &&
    other.description == description &&
    other.type == type &&
    other.basePrice == basePrice &&
    other.salePrice == salePrice &&
    other.currency == currency &&
    other.status == status &&
    other.isVisibleOnline == isVisibleOnline &&
    _deepEquality.equals(other.employeeIds, employeeIds) &&
    _deepEquality.equals(other.media, media) &&
    other.productDefinition == productDefinition &&
    _deepEquality.equals(other.facilityImages, facilityImages) &&
    _deepEquality.equals(other.reviews, reviews);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (slug == null ? 0 : slug!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (basePrice == null ? 0 : basePrice!.hashCode) +
    (salePrice == null ? 0 : salePrice!.hashCode) +
    (currency == null ? 0 : currency!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (isVisibleOnline == null ? 0 : isVisibleOnline!.hashCode) +
    (employeeIds.hashCode) +
    (media.hashCode) +
    (productDefinition == null ? 0 : productDefinition!.hashCode) +
    (facilityImages.hashCode) +
    (reviews.hashCode);

  @override
  String toString() => 'UpdatePartnerHealthServiceDto[categoryId=$categoryId, name=$name, slug=$slug, description=$description, type=$type, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, status=$status, isVisibleOnline=$isVisibleOnline, employeeIds=$employeeIds, media=$media, productDefinition=$productDefinition, facilityImages=$facilityImages, reviews=$reviews]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.categoryId != null) {
      json[r'categoryId'] = this.categoryId;
    } else {
      json[r'categoryId'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.slug != null) {
      json[r'slug'] = this.slug;
    } else {
      json[r'slug'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.basePrice != null) {
      json[r'basePrice'] = this.basePrice;
    } else {
      json[r'basePrice'] = null;
    }
    if (this.salePrice != null) {
      json[r'salePrice'] = this.salePrice;
    } else {
      json[r'salePrice'] = null;
    }
    if (this.currency != null) {
      json[r'currency'] = this.currency;
    } else {
      json[r'currency'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.isVisibleOnline != null) {
      json[r'isVisibleOnline'] = this.isVisibleOnline;
    } else {
      json[r'isVisibleOnline'] = null;
    }
      json[r'employeeIds'] = this.employeeIds;
      json[r'media'] = this.media;
    if (this.productDefinition != null) {
      json[r'productDefinition'] = this.productDefinition;
    } else {
      json[r'productDefinition'] = null;
    }
      json[r'facilityImages'] = this.facilityImages;
      json[r'reviews'] = this.reviews;
    return json;
  }

  /// Returns a new [UpdatePartnerHealthServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdatePartnerHealthServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdatePartnerHealthServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdatePartnerHealthServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdatePartnerHealthServiceDto(
        categoryId: mapValueOfType<String>(json, r'categoryId'),
        name: mapValueOfType<String>(json, r'name'),
        slug: mapValueOfType<String>(json, r'slug'),
        description: mapValueOfType<String>(json, r'description'),
        type: UpdatePartnerHealthServiceDtoTypeEnum.fromJson(json[r'type']),
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: num.parse('${json[r'salePrice']}'),
        currency: mapValueOfType<String>(json, r'currency'),
        status: UpdatePartnerHealthServiceDtoStatusEnum.fromJson(json[r'status']),
        isVisibleOnline: mapValueOfType<bool>(json, r'isVisibleOnline'),
        employeeIds: json[r'employeeIds'] is Iterable
            ? (json[r'employeeIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        media: CreatePartnerHealthServiceMediaDto.listFromJson(json[r'media']),
        productDefinition: CreatePartnerHealthServiceDefinitionDto.fromJson(json[r'productDefinition']),
        facilityImages: CreatePartnerHealthServiceFacilityImageDto.listFromJson(json[r'facilityImages']),
        reviews: CreatePartnerHealthServiceReviewDto.listFromJson(json[r'reviews']),
      );
    }
    return null;
  }

  static List<UpdatePartnerHealthServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerHealthServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerHealthServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdatePartnerHealthServiceDto> mapFromJson(dynamic json) {
    final map = <String, UpdatePartnerHealthServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdatePartnerHealthServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdatePartnerHealthServiceDto-objects as value to a dart map
  static Map<String, List<UpdatePartnerHealthServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdatePartnerHealthServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdatePartnerHealthServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class UpdatePartnerHealthServiceDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdatePartnerHealthServiceDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const physical = UpdatePartnerHealthServiceDtoTypeEnum._(r'physical');
  static const service = UpdatePartnerHealthServiceDtoTypeEnum._(r'service');

  /// List of all possible values in this [enum][UpdatePartnerHealthServiceDtoTypeEnum].
  static const values = <UpdatePartnerHealthServiceDtoTypeEnum>[
    physical,
    service,
  ];

  static UpdatePartnerHealthServiceDtoTypeEnum? fromJson(dynamic value) => UpdatePartnerHealthServiceDtoTypeEnumTypeTransformer().decode(value);

  static List<UpdatePartnerHealthServiceDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerHealthServiceDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerHealthServiceDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdatePartnerHealthServiceDtoTypeEnum] to String,
/// and [decode] dynamic data back to [UpdatePartnerHealthServiceDtoTypeEnum].
class UpdatePartnerHealthServiceDtoTypeEnumTypeTransformer {
  factory UpdatePartnerHealthServiceDtoTypeEnumTypeTransformer() => _instance ??= const UpdatePartnerHealthServiceDtoTypeEnumTypeTransformer._();

  const UpdatePartnerHealthServiceDtoTypeEnumTypeTransformer._();

  String encode(UpdatePartnerHealthServiceDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdatePartnerHealthServiceDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdatePartnerHealthServiceDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'physical': return UpdatePartnerHealthServiceDtoTypeEnum.physical;
        case r'service': return UpdatePartnerHealthServiceDtoTypeEnum.service;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdatePartnerHealthServiceDtoTypeEnumTypeTransformer] instance.
  static UpdatePartnerHealthServiceDtoTypeEnumTypeTransformer? _instance;
}



class UpdatePartnerHealthServiceDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdatePartnerHealthServiceDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const draft = UpdatePartnerHealthServiceDtoStatusEnum._(r'draft');
  static const active = UpdatePartnerHealthServiceDtoStatusEnum._(r'active');
  static const archived = UpdatePartnerHealthServiceDtoStatusEnum._(r'archived');

  /// List of all possible values in this [enum][UpdatePartnerHealthServiceDtoStatusEnum].
  static const values = <UpdatePartnerHealthServiceDtoStatusEnum>[
    draft,
    active,
    archived,
  ];

  static UpdatePartnerHealthServiceDtoStatusEnum? fromJson(dynamic value) => UpdatePartnerHealthServiceDtoStatusEnumTypeTransformer().decode(value);

  static List<UpdatePartnerHealthServiceDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerHealthServiceDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerHealthServiceDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdatePartnerHealthServiceDtoStatusEnum] to String,
/// and [decode] dynamic data back to [UpdatePartnerHealthServiceDtoStatusEnum].
class UpdatePartnerHealthServiceDtoStatusEnumTypeTransformer {
  factory UpdatePartnerHealthServiceDtoStatusEnumTypeTransformer() => _instance ??= const UpdatePartnerHealthServiceDtoStatusEnumTypeTransformer._();

  const UpdatePartnerHealthServiceDtoStatusEnumTypeTransformer._();

  String encode(UpdatePartnerHealthServiceDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdatePartnerHealthServiceDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdatePartnerHealthServiceDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'draft': return UpdatePartnerHealthServiceDtoStatusEnum.draft;
        case r'active': return UpdatePartnerHealthServiceDtoStatusEnum.active;
        case r'archived': return UpdatePartnerHealthServiceDtoStatusEnum.archived;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdatePartnerHealthServiceDtoStatusEnumTypeTransformer] instance.
  static UpdatePartnerHealthServiceDtoStatusEnumTypeTransformer? _instance;
}


