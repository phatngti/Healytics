//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProductResponseDto {
  /// Returns a new [ProductResponseDto] instance.
  ProductResponseDto({
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
    this.serviceDefinition,
    this.serviceEmployeeEligibilities = const [],
  });

  /// Unique product identifier
  String id;

  /// Product name
  String name;

  /// URL-friendly slug
  String slug;

  /// Product description
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? description;

  /// Product type
  ProductResponseDtoTypeEnum type;

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

  /// Product status
  ProductResponseDtoStatusEnum status;

  /// Whether product is visible online
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

  /// Product category
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CategorySummaryDto? category;

  /// Product media assets
  List<ProductMediaDto> media;

  /// Service definition for service products
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ServiceDefinitionDto? serviceDefinition;

  /// Eligible employees for service
  List<ServiceEmployeeEligibilityDto> serviceEmployeeEligibilities;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProductResponseDto &&
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
    other.serviceDefinition == serviceDefinition &&
    _deepEquality.equals(other.serviceEmployeeEligibilities, serviceEmployeeEligibilities);

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
    (serviceDefinition == null ? 0 : serviceDefinition!.hashCode) +
    (serviceEmployeeEligibilities.hashCode);

  @override
  String toString() => 'ProductResponseDto[id=$id, name=$name, slug=$slug, description=$description, type=$type, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, status=$status, isVisibleOnline=$isVisibleOnline, vendorName=$vendorName, createdAt=$createdAt, updatedAt=$updatedAt, category=$category, media=$media, serviceDefinition=$serviceDefinition, serviceEmployeeEligibilities=$serviceEmployeeEligibilities]';

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
    if (this.serviceDefinition != null) {
      json[r'serviceDefinition'] = this.serviceDefinition;
    } else {
      json[r'serviceDefinition'] = null;
    }
      json[r'serviceEmployeeEligibilities'] = this.serviceEmployeeEligibilities;
    return json;
  }

  /// Returns a new [ProductResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProductResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProductResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProductResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProductResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug')!,
        description: mapValueOfType<Object>(json, r'description'),
        type: ProductResponseDtoTypeEnum.fromJson(json[r'type'])!,
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: mapValueOfType<Object>(json, r'salePrice'),
        currency: mapValueOfType<String>(json, r'currency')!,
        status: ProductResponseDtoStatusEnum.fromJson(json[r'status'])!,
        isVisibleOnline: mapValueOfType<bool>(json, r'isVisibleOnline')!,
        vendorName: mapValueOfType<Object>(json, r'vendorName'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
        category: CategorySummaryDto.fromJson(json[r'category']),
        media: ProductMediaDto.listFromJson(json[r'media']),
        serviceDefinition: ServiceDefinitionDto.fromJson(json[r'serviceDefinition']),
        serviceEmployeeEligibilities: ServiceEmployeeEligibilityDto.listFromJson(json[r'serviceEmployeeEligibilities']),
      );
    }
    return null;
  }

  static List<ProductResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProductResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProductResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProductResponseDto> mapFromJson(dynamic json) {
    final map = <String, ProductResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProductResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProductResponseDto-objects as value to a dart map
  static Map<String, List<ProductResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProductResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProductResponseDto.listFromJson(entry.value, growable: growable,);
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

/// Product type
class ProductResponseDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const ProductResponseDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const physical = ProductResponseDtoTypeEnum._(r'physical');
  static const service = ProductResponseDtoTypeEnum._(r'service');

  /// List of all possible values in this [enum][ProductResponseDtoTypeEnum].
  static const values = <ProductResponseDtoTypeEnum>[
    physical,
    service,
  ];

  static ProductResponseDtoTypeEnum? fromJson(dynamic value) => ProductResponseDtoTypeEnumTypeTransformer().decode(value);

  static List<ProductResponseDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProductResponseDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProductResponseDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProductResponseDtoTypeEnum] to String,
/// and [decode] dynamic data back to [ProductResponseDtoTypeEnum].
class ProductResponseDtoTypeEnumTypeTransformer {
  factory ProductResponseDtoTypeEnumTypeTransformer() => _instance ??= const ProductResponseDtoTypeEnumTypeTransformer._();

  const ProductResponseDtoTypeEnumTypeTransformer._();

  String encode(ProductResponseDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProductResponseDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProductResponseDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'physical': return ProductResponseDtoTypeEnum.physical;
        case r'service': return ProductResponseDtoTypeEnum.service;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProductResponseDtoTypeEnumTypeTransformer] instance.
  static ProductResponseDtoTypeEnumTypeTransformer? _instance;
}


/// Product status
class ProductResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const ProductResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const draft = ProductResponseDtoStatusEnum._(r'draft');
  static const active = ProductResponseDtoStatusEnum._(r'active');
  static const archived = ProductResponseDtoStatusEnum._(r'archived');

  /// List of all possible values in this [enum][ProductResponseDtoStatusEnum].
  static const values = <ProductResponseDtoStatusEnum>[
    draft,
    active,
    archived,
  ];

  static ProductResponseDtoStatusEnum? fromJson(dynamic value) => ProductResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<ProductResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProductResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProductResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProductResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [ProductResponseDtoStatusEnum].
class ProductResponseDtoStatusEnumTypeTransformer {
  factory ProductResponseDtoStatusEnumTypeTransformer() => _instance ??= const ProductResponseDtoStatusEnumTypeTransformer._();

  const ProductResponseDtoStatusEnumTypeTransformer._();

  String encode(ProductResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProductResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProductResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'draft': return ProductResponseDtoStatusEnum.draft;
        case r'active': return ProductResponseDtoStatusEnum.active;
        case r'archived': return ProductResponseDtoStatusEnum.archived;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProductResponseDtoStatusEnumTypeTransformer] instance.
  static ProductResponseDtoStatusEnumTypeTransformer? _instance;
}


