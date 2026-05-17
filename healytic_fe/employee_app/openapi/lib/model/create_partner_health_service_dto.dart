//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreatePartnerHealthServiceDto {
  /// Returns a new [CreatePartnerHealthServiceDto] instance.
  CreatePartnerHealthServiceDto({
    this.categoryId,
    required this.name,
    this.slug,
    this.description,
    required this.type,
    this.basePrice,
    this.salePrice,
    this.currency,
    this.status,
    this.isVisibleOnline,
    this.employeeIds = const [],
    this.tagIds = const [],
    this.media = const [],
    this.productDefinition,
    this.facilityImages = const [],
    this.serviceManual,
  });


  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? categoryId;

  String name;

  /// Ignored — slug is auto-generated as {partner_brand}_{product_name}_{random}.
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

  HealthServiceType type;

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

  CreatePartnerHealthServiceDtoStatusEnum? status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVisibleOnline;

  List<String> employeeIds;

  /// Feature tag IDs to associate with this service
  List<String> tagIds;

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

  /// Service manual (guidelines, rules, procedure steps)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ServiceManualInputDto? serviceManual;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreatePartnerHealthServiceDto &&
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
    _deepEquality.equals(other.tagIds, tagIds) &&
    _deepEquality.equals(other.media, media) &&
    other.productDefinition == productDefinition &&
    _deepEquality.equals(other.facilityImages, facilityImages) &&
    other.serviceManual == serviceManual;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (name.hashCode) +
    (slug == null ? 0 : slug!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (type.hashCode) +
    (basePrice == null ? 0 : basePrice!.hashCode) +
    (salePrice == null ? 0 : salePrice!.hashCode) +
    (currency == null ? 0 : currency!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (isVisibleOnline == null ? 0 : isVisibleOnline!.hashCode) +
    (employeeIds.hashCode) +
    (tagIds.hashCode) +
    (media.hashCode) +
    (productDefinition == null ? 0 : productDefinition!.hashCode) +
    (facilityImages.hashCode) +
    (serviceManual == null ? 0 : serviceManual!.hashCode);

  @override
  String toString() => 'CreatePartnerHealthServiceDto[categoryId=$categoryId, name=$name, slug=$slug, description=$description, type=$type, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, status=$status, isVisibleOnline=$isVisibleOnline, employeeIds=$employeeIds, tagIds=$tagIds, media=$media, productDefinition=$productDefinition, facilityImages=$facilityImages, serviceManual=$serviceManual]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.categoryId != null) {
      json[r'categoryId'] = this.categoryId;
    } else {
      json[r'categoryId'] = null;
    }
      json[r'name'] = this.name;
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
      json[r'tagIds'] = this.tagIds;
      json[r'media'] = this.media;
    if (this.productDefinition != null) {
      json[r'productDefinition'] = this.productDefinition;
    } else {
      json[r'productDefinition'] = null;
    }
      json[r'facilityImages'] = this.facilityImages;
    if (this.serviceManual != null) {
      json[r'serviceManual'] = this.serviceManual;
    } else {
      json[r'serviceManual'] = null;
    }
    return json;
  }

  /// Returns a new [CreatePartnerHealthServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreatePartnerHealthServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreatePartnerHealthServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreatePartnerHealthServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreatePartnerHealthServiceDto(
        categoryId: mapValueOfType<String>(json, r'categoryId'),
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug'),
        description: mapValueOfType<String>(json, r'description'),
        type: HealthServiceType.fromJson(json[r'type'])!,
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: num.parse('${json[r'salePrice']}'),
        currency: mapValueOfType<String>(json, r'currency'),
        status: CreatePartnerHealthServiceDtoStatusEnum.fromJson(json[r'status']),
        isVisibleOnline: mapValueOfType<bool>(json, r'isVisibleOnline'),
        employeeIds: json[r'employeeIds'] is Iterable
            ? (json[r'employeeIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        tagIds: json[r'tagIds'] is Iterable
            ? (json[r'tagIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        media: CreatePartnerHealthServiceMediaDto.listFromJson(json[r'media']),
        productDefinition: CreatePartnerHealthServiceDefinitionDto.fromJson(json[r'productDefinition']),
        facilityImages: CreatePartnerHealthServiceFacilityImageDto.listFromJson(json[r'facilityImages']),
        serviceManual: ServiceManualInputDto.fromJson(json[r'serviceManual']),
      );
    }
    return null;
  }

  static List<CreatePartnerHealthServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerHealthServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerHealthServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatePartnerHealthServiceDto> mapFromJson(dynamic json) {
    final map = <String, CreatePartnerHealthServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreatePartnerHealthServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatePartnerHealthServiceDto-objects as value to a dart map
  static Map<String, List<CreatePartnerHealthServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatePartnerHealthServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatePartnerHealthServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'type',
  };
}


class CreatePartnerHealthServiceDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CreatePartnerHealthServiceDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const draft = CreatePartnerHealthServiceDtoStatusEnum._(r'draft');
  static const active = CreatePartnerHealthServiceDtoStatusEnum._(r'active');
  static const archived = CreatePartnerHealthServiceDtoStatusEnum._(r'archived');

  /// List of all possible values in this [enum][CreatePartnerHealthServiceDtoStatusEnum].
  static const values = <CreatePartnerHealthServiceDtoStatusEnum>[
    draft,
    active,
    archived,
  ];

  static CreatePartnerHealthServiceDtoStatusEnum? fromJson(dynamic value) => CreatePartnerHealthServiceDtoStatusEnumTypeTransformer().decode(value);

  static List<CreatePartnerHealthServiceDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerHealthServiceDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerHealthServiceDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreatePartnerHealthServiceDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CreatePartnerHealthServiceDtoStatusEnum].
class CreatePartnerHealthServiceDtoStatusEnumTypeTransformer {
  factory CreatePartnerHealthServiceDtoStatusEnumTypeTransformer() => _instance ??= const CreatePartnerHealthServiceDtoStatusEnumTypeTransformer._();

  const CreatePartnerHealthServiceDtoStatusEnumTypeTransformer._();

  String encode(CreatePartnerHealthServiceDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreatePartnerHealthServiceDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreatePartnerHealthServiceDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'draft': return CreatePartnerHealthServiceDtoStatusEnum.draft;
        case r'active': return CreatePartnerHealthServiceDtoStatusEnum.active;
        case r'archived': return CreatePartnerHealthServiceDtoStatusEnum.archived;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreatePartnerHealthServiceDtoStatusEnumTypeTransformer] instance.
  static CreatePartnerHealthServiceDtoStatusEnumTypeTransformer? _instance;
}


