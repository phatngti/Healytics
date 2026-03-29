//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicHealthServiceResponseDto {
  /// Returns a new [PublicHealthServiceResponseDto] instance.
  PublicHealthServiceResponseDto({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.type,
    required this.basePrice,
    this.salePrice,
    required this.currency,
    required this.status,
    required this.isVisibleOnline,
    this.vendorName,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.media = const [],
    this.productDefinition,
    this.productEmployeeEligibilities = const [],
  });

  /// Unique identifier
  String id;

  /// Name
  String name;

  /// URL-friendly slug
  String slug;

  /// Description
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? description;

  /// Type
  PublicHealthServiceResponseDtoTypeEnum type;

  /// Base price in specified currency
  num basePrice;

  /// Sale price if on discount
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? salePrice;

  /// Currency code (ISO 4217)
  String currency;

  /// Status
  PublicHealthServiceResponseDtoStatusEnum status;

  /// Whether visible online
  bool isVisibleOnline;

  /// Vendor name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? vendorName;

  /// Creation timestamp
  DateTime createdAt;

  /// Last update timestamp
  DateTime updatedAt;

  /// Category
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PublicCategorySummaryDto? category;

  /// Media assets
  List<PublicHealthServiceMediaDto> media;

  /// Definition for service type
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PublicHealthServiceDefinitionDto? productDefinition;

  /// Eligible employees for service
  List<PublicHealthServiceEmployeeEligibilityDto> productEmployeeEligibilities;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicHealthServiceResponseDto &&
    other.id == id &&
    other.name == name &&
    other.slug == slug &&
    other.description == description &&
    other.type == type &&
    other.basePrice == basePrice &&
    other.salePrice == salePrice &&
    other.currency == currency &&
    other.status == status &&
    other.isVisibleOnline == isVisibleOnline &&
    other.vendorName == vendorName &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.category == category &&
    _deepEquality.equals(other.media, media) &&
    other.productDefinition == productDefinition &&
    _deepEquality.equals(other.productEmployeeEligibilities, productEmployeeEligibilities);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (slug.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (type.hashCode) +
    (basePrice.hashCode) +
    (salePrice == null ? 0 : salePrice!.hashCode) +
    (currency.hashCode) +
    (status.hashCode) +
    (isVisibleOnline.hashCode) +
    (vendorName == null ? 0 : vendorName!.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode) +
    (category == null ? 0 : category!.hashCode) +
    (media.hashCode) +
    (productDefinition == null ? 0 : productDefinition!.hashCode) +
    (productEmployeeEligibilities.hashCode);

  @override
  String toString() => 'PublicHealthServiceResponseDto[id=$id, name=$name, slug=$slug, description=$description, type=$type, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, status=$status, isVisibleOnline=$isVisibleOnline, vendorName=$vendorName, createdAt=$createdAt, updatedAt=$updatedAt, category=$category, media=$media, productDefinition=$productDefinition, productEmployeeEligibilities=$productEmployeeEligibilities]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'slug'] = this.slug;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'type'] = this.type;
      json[r'basePrice'] = this.basePrice;
    if (this.salePrice != null) {
      json[r'salePrice'] = this.salePrice;
    } else {
      json[r'salePrice'] = null;
    }
      json[r'currency'] = this.currency;
      json[r'status'] = this.status;
      json[r'isVisibleOnline'] = this.isVisibleOnline;
    if (this.vendorName != null) {
      json[r'vendorName'] = this.vendorName;
    } else {
      json[r'vendorName'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'updatedAt'] = this.updatedAt.toUtc().toIso8601String();
    if (this.category != null) {
      json[r'category'] = this.category;
    } else {
      json[r'category'] = null;
    }
      json[r'media'] = this.media;
    if (this.productDefinition != null) {
      json[r'productDefinition'] = this.productDefinition;
    } else {
      json[r'productDefinition'] = null;
    }
      json[r'productEmployeeEligibilities'] = this.productEmployeeEligibilities;
    return json;
  }

  /// Returns a new [PublicHealthServiceResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicHealthServiceResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicHealthServiceResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicHealthServiceResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicHealthServiceResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug')!,
        description: mapValueOfType<Object>(json, r'description'),
        type: PublicHealthServiceResponseDtoTypeEnum.fromJson(json[r'type'])!,
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: mapValueOfType<Object>(json, r'salePrice'),
        currency: mapValueOfType<String>(json, r'currency')!,
        status: PublicHealthServiceResponseDtoStatusEnum.fromJson(json[r'status'])!,
        isVisibleOnline: mapValueOfType<bool>(json, r'isVisibleOnline')!,
        vendorName: mapValueOfType<Object>(json, r'vendorName'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
        category: PublicCategorySummaryDto.fromJson(json[r'category']),
        media: PublicHealthServiceMediaDto.listFromJson(json[r'media']),
        productDefinition: PublicHealthServiceDefinitionDto.fromJson(json[r'productDefinition']),
        productEmployeeEligibilities: PublicHealthServiceEmployeeEligibilityDto.listFromJson(json[r'productEmployeeEligibilities']),
      );
    }
    return null;
  }

  static List<PublicHealthServiceResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicHealthServiceResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicHealthServiceResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicHealthServiceResponseDto> mapFromJson(dynamic json) {
    final map = <String, PublicHealthServiceResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicHealthServiceResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicHealthServiceResponseDto-objects as value to a dart map
  static Map<String, List<PublicHealthServiceResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicHealthServiceResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicHealthServiceResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'slug',
    'type',
    'basePrice',
    'currency',
    'status',
    'isVisibleOnline',
    'createdAt',
    'updatedAt',
  };
}

/// Type
class PublicHealthServiceResponseDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const PublicHealthServiceResponseDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const service = PublicHealthServiceResponseDtoTypeEnum._(r'service');

  /// List of all possible values in this [enum][PublicHealthServiceResponseDtoTypeEnum].
  static const values = <PublicHealthServiceResponseDtoTypeEnum>[
    service,
  ];

  static PublicHealthServiceResponseDtoTypeEnum? fromJson(dynamic value) => PublicHealthServiceResponseDtoTypeEnumTypeTransformer().decode(value);

  static List<PublicHealthServiceResponseDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicHealthServiceResponseDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicHealthServiceResponseDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PublicHealthServiceResponseDtoTypeEnum] to String,
/// and [decode] dynamic data back to [PublicHealthServiceResponseDtoTypeEnum].
class PublicHealthServiceResponseDtoTypeEnumTypeTransformer {
  factory PublicHealthServiceResponseDtoTypeEnumTypeTransformer() => _instance ??= const PublicHealthServiceResponseDtoTypeEnumTypeTransformer._();

  const PublicHealthServiceResponseDtoTypeEnumTypeTransformer._();

  String encode(PublicHealthServiceResponseDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PublicHealthServiceResponseDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PublicHealthServiceResponseDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'service': return PublicHealthServiceResponseDtoTypeEnum.service;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PublicHealthServiceResponseDtoTypeEnumTypeTransformer] instance.
  static PublicHealthServiceResponseDtoTypeEnumTypeTransformer? _instance;
}


/// Status
class PublicHealthServiceResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const PublicHealthServiceResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const draft = PublicHealthServiceResponseDtoStatusEnum._(r'draft');
  static const active = PublicHealthServiceResponseDtoStatusEnum._(r'active');
  static const archived = PublicHealthServiceResponseDtoStatusEnum._(r'archived');

  /// List of all possible values in this [enum][PublicHealthServiceResponseDtoStatusEnum].
  static const values = <PublicHealthServiceResponseDtoStatusEnum>[
    draft,
    active,
    archived,
  ];

  static PublicHealthServiceResponseDtoStatusEnum? fromJson(dynamic value) => PublicHealthServiceResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<PublicHealthServiceResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicHealthServiceResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicHealthServiceResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PublicHealthServiceResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [PublicHealthServiceResponseDtoStatusEnum].
class PublicHealthServiceResponseDtoStatusEnumTypeTransformer {
  factory PublicHealthServiceResponseDtoStatusEnumTypeTransformer() => _instance ??= const PublicHealthServiceResponseDtoStatusEnumTypeTransformer._();

  const PublicHealthServiceResponseDtoStatusEnumTypeTransformer._();

  String encode(PublicHealthServiceResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PublicHealthServiceResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PublicHealthServiceResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'draft': return PublicHealthServiceResponseDtoStatusEnum.draft;
        case r'active': return PublicHealthServiceResponseDtoStatusEnum.active;
        case r'archived': return PublicHealthServiceResponseDtoStatusEnum.archived;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PublicHealthServiceResponseDtoStatusEnumTypeTransformer] instance.
  static PublicHealthServiceResponseDtoStatusEnumTypeTransformer? _instance;
}


