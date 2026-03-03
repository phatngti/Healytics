//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreatePartnerProductDto {
  /// Returns a new [CreatePartnerProductDto] instance.
  CreatePartnerProductDto({
    this.categoryId,
    required this.name,
    required this.slug,
    this.description,
    required this.type,
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

  String name;

  String slug;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  CreatePartnerProductDtoTypeEnum type;

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

  CreatePartnerProductDtoStatusEnum? status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVisibleOnline;

  List<String> employeeIds;

  /// Product media (images/videos)
  List<CreatePartnerProductMediaDto> media;

  /// Product definition (required if type is service)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CreatePartnerProductDefinitionDto? productDefinition;

  /// Facility/clinic images
  List<CreatePartnerProductFacilityImageDto> facilityImages;

  /// Product reviews
  List<CreatePartnerProductReviewDto> reviews;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreatePartnerProductDto &&
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
    (name.hashCode) +
    (slug.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (type.hashCode) +
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
  String toString() => 'CreatePartnerProductDto[categoryId=$categoryId, name=$name, slug=$slug, description=$description, type=$type, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, status=$status, isVisibleOnline=$isVisibleOnline, employeeIds=$employeeIds, media=$media, productDefinition=$productDefinition, facilityImages=$facilityImages, reviews=$reviews]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.categoryId != null) {
      json[r'categoryId'] = this.categoryId;
    } else {
      json[r'categoryId'] = null;
    }
      json[r'name'] = this.name;
      json[r'slug'] = this.slug;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'type'] = this.type;
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

  /// Returns a new [CreatePartnerProductDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreatePartnerProductDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreatePartnerProductDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreatePartnerProductDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreatePartnerProductDto(
        categoryId: mapValueOfType<String>(json, r'categoryId'),
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug')!,
        description: mapValueOfType<String>(json, r'description'),
        type: CreatePartnerProductDtoTypeEnum.fromJson(json[r'type'])!,
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: num.parse('${json[r'salePrice']}'),
        currency: mapValueOfType<String>(json, r'currency'),
        status: CreatePartnerProductDtoStatusEnum.fromJson(json[r'status']),
        isVisibleOnline: mapValueOfType<bool>(json, r'isVisibleOnline'),
        employeeIds: json[r'employeeIds'] is Iterable
            ? (json[r'employeeIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        media: CreatePartnerProductMediaDto.listFromJson(json[r'media']),
        productDefinition: CreatePartnerProductDefinitionDto.fromJson(json[r'productDefinition']),
        facilityImages: CreatePartnerProductFacilityImageDto.listFromJson(json[r'facilityImages']),
        reviews: CreatePartnerProductReviewDto.listFromJson(json[r'reviews']),
      );
    }
    return null;
  }

  static List<CreatePartnerProductDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerProductDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerProductDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatePartnerProductDto> mapFromJson(dynamic json) {
    final map = <String, CreatePartnerProductDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreatePartnerProductDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatePartnerProductDto-objects as value to a dart map
  static Map<String, List<CreatePartnerProductDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatePartnerProductDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatePartnerProductDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'slug',
    'type',
  };
}


class CreatePartnerProductDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const CreatePartnerProductDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const physical = CreatePartnerProductDtoTypeEnum._(r'physical');
  static const service = CreatePartnerProductDtoTypeEnum._(r'service');

  /// List of all possible values in this [enum][CreatePartnerProductDtoTypeEnum].
  static const values = <CreatePartnerProductDtoTypeEnum>[
    physical,
    service,
  ];

  static CreatePartnerProductDtoTypeEnum? fromJson(dynamic value) => CreatePartnerProductDtoTypeEnumTypeTransformer().decode(value);

  static List<CreatePartnerProductDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerProductDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerProductDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreatePartnerProductDtoTypeEnum] to String,
/// and [decode] dynamic data back to [CreatePartnerProductDtoTypeEnum].
class CreatePartnerProductDtoTypeEnumTypeTransformer {
  factory CreatePartnerProductDtoTypeEnumTypeTransformer() => _instance ??= const CreatePartnerProductDtoTypeEnumTypeTransformer._();

  const CreatePartnerProductDtoTypeEnumTypeTransformer._();

  String encode(CreatePartnerProductDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreatePartnerProductDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreatePartnerProductDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'physical': return CreatePartnerProductDtoTypeEnum.physical;
        case r'service': return CreatePartnerProductDtoTypeEnum.service;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreatePartnerProductDtoTypeEnumTypeTransformer] instance.
  static CreatePartnerProductDtoTypeEnumTypeTransformer? _instance;
}



class CreatePartnerProductDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CreatePartnerProductDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const draft = CreatePartnerProductDtoStatusEnum._(r'draft');
  static const active = CreatePartnerProductDtoStatusEnum._(r'active');
  static const archived = CreatePartnerProductDtoStatusEnum._(r'archived');

  /// List of all possible values in this [enum][CreatePartnerProductDtoStatusEnum].
  static const values = <CreatePartnerProductDtoStatusEnum>[
    draft,
    active,
    archived,
  ];

  static CreatePartnerProductDtoStatusEnum? fromJson(dynamic value) => CreatePartnerProductDtoStatusEnumTypeTransformer().decode(value);

  static List<CreatePartnerProductDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerProductDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerProductDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreatePartnerProductDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CreatePartnerProductDtoStatusEnum].
class CreatePartnerProductDtoStatusEnumTypeTransformer {
  factory CreatePartnerProductDtoStatusEnumTypeTransformer() => _instance ??= const CreatePartnerProductDtoStatusEnumTypeTransformer._();

  const CreatePartnerProductDtoStatusEnumTypeTransformer._();

  String encode(CreatePartnerProductDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreatePartnerProductDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreatePartnerProductDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'draft': return CreatePartnerProductDtoStatusEnum.draft;
        case r'active': return CreatePartnerProductDtoStatusEnum.active;
        case r'archived': return CreatePartnerProductDtoStatusEnum.archived;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreatePartnerProductDtoStatusEnumTypeTransformer] instance.
  static CreatePartnerProductDtoStatusEnumTypeTransformer? _instance;
}


