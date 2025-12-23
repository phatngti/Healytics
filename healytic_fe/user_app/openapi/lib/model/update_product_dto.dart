//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateProductDto {
  /// Returns a new [UpdateProductDto] instance.
  UpdateProductDto({
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
    this.vendorName,
    this.employeeIds = const [],
    this.media = const [],
    this.physicalDetails,
    this.serviceDefinition,
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

  UpdateProductDtoTypeEnum? type;

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

  UpdateProductDtoStatusEnum? status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVisibleOnline;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? vendorName;

  List<String> employeeIds;

  /// Product media (images/videos)
  List<CreateProductMediaDto> media;

  /// Physical product details (required if type is physical)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CreatePhysicalDetailsDto? physicalDetails;

  /// Service definition (required if type is service)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CreateServiceDefinitionDto? serviceDefinition;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateProductDto &&
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
    other.vendorName == vendorName &&
    _deepEquality.equals(other.employeeIds, employeeIds) &&
    _deepEquality.equals(other.media, media) &&
    other.physicalDetails == physicalDetails &&
    other.serviceDefinition == serviceDefinition;

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
    (vendorName == null ? 0 : vendorName!.hashCode) +
    (employeeIds.hashCode) +
    (media.hashCode) +
    (physicalDetails == null ? 0 : physicalDetails!.hashCode) +
    (serviceDefinition == null ? 0 : serviceDefinition!.hashCode);

  @override
  String toString() => 'UpdateProductDto[categoryId=$categoryId, name=$name, slug=$slug, description=$description, type=$type, basePrice=$basePrice, salePrice=$salePrice, currency=$currency, status=$status, isVisibleOnline=$isVisibleOnline, vendorName=$vendorName, employeeIds=$employeeIds, media=$media, physicalDetails=$physicalDetails, serviceDefinition=$serviceDefinition]';

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
    if (this.vendorName != null) {
      json[r'vendorName'] = this.vendorName;
    } else {
      json[r'vendorName'] = null;
    }
      json[r'employeeIds'] = this.employeeIds;
      json[r'media'] = this.media;
    if (this.physicalDetails != null) {
      json[r'physicalDetails'] = this.physicalDetails;
    } else {
      json[r'physicalDetails'] = null;
    }
    if (this.serviceDefinition != null) {
      json[r'serviceDefinition'] = this.serviceDefinition;
    } else {
      json[r'serviceDefinition'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateProductDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateProductDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateProductDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateProductDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateProductDto(
        categoryId: mapValueOfType<String>(json, r'categoryId'),
        name: mapValueOfType<String>(json, r'name'),
        slug: mapValueOfType<String>(json, r'slug'),
        description: mapValueOfType<String>(json, r'description'),
        type: UpdateProductDtoTypeEnum.fromJson(json[r'type']),
        basePrice: num.parse('${json[r'basePrice']}'),
        salePrice: num.parse('${json[r'salePrice']}'),
        currency: mapValueOfType<String>(json, r'currency'),
        status: UpdateProductDtoStatusEnum.fromJson(json[r'status']),
        isVisibleOnline: mapValueOfType<bool>(json, r'isVisibleOnline'),
        vendorName: mapValueOfType<String>(json, r'vendorName'),
        employeeIds: json[r'employeeIds'] is Iterable
            ? (json[r'employeeIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        media: CreateProductMediaDto.listFromJson(json[r'media']),
        physicalDetails: CreatePhysicalDetailsDto.fromJson(json[r'physicalDetails']),
        serviceDefinition: CreateServiceDefinitionDto.fromJson(json[r'serviceDefinition']),
      );
    }
    return null;
  }

  static List<UpdateProductDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateProductDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateProductDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateProductDto> mapFromJson(dynamic json) {
    final map = <String, UpdateProductDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateProductDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateProductDto-objects as value to a dart map
  static Map<String, List<UpdateProductDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateProductDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateProductDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class UpdateProductDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateProductDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const physical = UpdateProductDtoTypeEnum._(r'physical');
  static const service = UpdateProductDtoTypeEnum._(r'service');

  /// List of all possible values in this [enum][UpdateProductDtoTypeEnum].
  static const values = <UpdateProductDtoTypeEnum>[
    physical,
    service,
  ];

  static UpdateProductDtoTypeEnum? fromJson(dynamic value) => UpdateProductDtoTypeEnumTypeTransformer().decode(value);

  static List<UpdateProductDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateProductDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateProductDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateProductDtoTypeEnum] to String,
/// and [decode] dynamic data back to [UpdateProductDtoTypeEnum].
class UpdateProductDtoTypeEnumTypeTransformer {
  factory UpdateProductDtoTypeEnumTypeTransformer() => _instance ??= const UpdateProductDtoTypeEnumTypeTransformer._();

  const UpdateProductDtoTypeEnumTypeTransformer._();

  String encode(UpdateProductDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdateProductDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateProductDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'physical': return UpdateProductDtoTypeEnum.physical;
        case r'service': return UpdateProductDtoTypeEnum.service;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateProductDtoTypeEnumTypeTransformer] instance.
  static UpdateProductDtoTypeEnumTypeTransformer? _instance;
}



class UpdateProductDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateProductDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const draft = UpdateProductDtoStatusEnum._(r'draft');
  static const active = UpdateProductDtoStatusEnum._(r'active');
  static const archived = UpdateProductDtoStatusEnum._(r'archived');

  /// List of all possible values in this [enum][UpdateProductDtoStatusEnum].
  static const values = <UpdateProductDtoStatusEnum>[
    draft,
    active,
    archived,
  ];

  static UpdateProductDtoStatusEnum? fromJson(dynamic value) => UpdateProductDtoStatusEnumTypeTransformer().decode(value);

  static List<UpdateProductDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateProductDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateProductDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateProductDtoStatusEnum] to String,
/// and [decode] dynamic data back to [UpdateProductDtoStatusEnum].
class UpdateProductDtoStatusEnumTypeTransformer {
  factory UpdateProductDtoStatusEnumTypeTransformer() => _instance ??= const UpdateProductDtoStatusEnumTypeTransformer._();

  const UpdateProductDtoStatusEnumTypeTransformer._();

  String encode(UpdateProductDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdateProductDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateProductDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'draft': return UpdateProductDtoStatusEnum.draft;
        case r'active': return UpdateProductDtoStatusEnum.active;
        case r'archived': return UpdateProductDtoStatusEnum.archived;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateProductDtoStatusEnumTypeTransformer] instance.
  static UpdateProductDtoStatusEnumTypeTransformer? _instance;
}


