//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerHealthServiceResponseDto {
  /// Returns a new [PartnerHealthServiceResponseDto] instance.
  PartnerHealthServiceResponseDto({
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
    this.serviceManual,
  });


  /// Unique identifier
  String id;

  /// Name
  String name;

  /// URL-friendly slug
  String slug;

  /// Description
  String? description;

  HealthServiceType type;

  /// Base price in specified currency
  num basePrice;

  /// Sale price if on discount
  num? salePrice;

  /// Currency code (ISO 4217)
  String currency;

  HealthServiceStatus status;

  /// Whether visible online
  bool isVisibleOnline;

  /// Vendor name
  String? vendorName;

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
  PartnerCategorySummaryDto? category;

  /// Media assets
  List<PartnerHealthServiceMediaDto> media;

  /// Definition for service type
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PartnerHealthServiceDefinitionDto? productDefinition;

  /// Eligible employees for service
  List<PartnerHealthServiceEmployeeEligibilityDto> productEmployeeEligibilities;

  /// Service manual (guidelines, rules, procedure steps)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PartnerServiceManualDto? serviceManual;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerHealthServiceResponseDto &&
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
    _deepEquality.equals(other.productEmployeeEligibilities, productEmployeeEligibilities) &&
    other.serviceManual == serviceManual;

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
    (productEmployeeEligibilities.hashCode) +
    (serviceManual == null ? 0 : serviceManual!.hashCode);

  @override
  String toString() => 'PartnerHealthServiceResponseDto[id=$id, name=$name, slug=$slug, description=$description, type=$type, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, status=$status, isVisibleOnline=$isVisibleOnline, vendorName=$vendorName, createdAt=$createdAt, updatedAt=$updatedAt, category=$category, media=$media, productDefinition=$productDefinition, productEmployeeEligibilities=$productEmployeeEligibilities, serviceManual=$serviceManual]';

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
    if (this.serviceManual != null) {
      json[r'serviceManual'] = this.serviceManual;
    } else {
      json[r'serviceManual'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerHealthServiceResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerHealthServiceResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerHealthServiceResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerHealthServiceResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerHealthServiceResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug')!,
        description: mapValueOfType<String>(json, r'description'),
        type: HealthServiceType.fromJson(json[r'type'])!,
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: json[r'salePrice'] == null
            ? null
            : num.parse('${json[r'salePrice']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        status: HealthServiceStatus.fromJson(json[r'status'])!,
        isVisibleOnline: mapValueOfType<bool>(json, r'isVisibleOnline')!,
        vendorName: mapValueOfType<String>(json, r'vendorName'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
        category: PartnerCategorySummaryDto.fromJson(json[r'category']),
        media: PartnerHealthServiceMediaDto.listFromJson(json[r'media']),
        productDefinition: PartnerHealthServiceDefinitionDto.fromJson(json[r'productDefinition']),
        productEmployeeEligibilities: PartnerHealthServiceEmployeeEligibilityDto.listFromJson(json[r'productEmployeeEligibilities']),
        serviceManual: PartnerServiceManualDto.fromJson(json[r'serviceManual']),
      );
    }
    return null;
  }

  static List<PartnerHealthServiceResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerHealthServiceResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerHealthServiceResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerHealthServiceResponseDto> mapFromJson(dynamic json) {
    final map = <String, PartnerHealthServiceResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerHealthServiceResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerHealthServiceResponseDto-objects as value to a dart map
  static Map<String, List<PartnerHealthServiceResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerHealthServiceResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerHealthServiceResponseDto.listFromJson(entry.value, growable: growable,);
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

