//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreatePartnerProductMediaDto {
  /// Returns a new [CreatePartnerProductMediaDto] instance.
  CreatePartnerProductMediaDto({
    required this.url,
    this.mediaType,
    this.isThumbnail,
    this.sortOrder,
  });

  String url;

  CreatePartnerProductMediaDtoMediaTypeEnum? mediaType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isThumbnail;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreatePartnerProductMediaDto &&
    other.url == url &&
    other.mediaType == mediaType &&
    other.isThumbnail == isThumbnail &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (url.hashCode) +
    (mediaType == null ? 0 : mediaType!.hashCode) +
    (isThumbnail == null ? 0 : isThumbnail!.hashCode) +
    (sortOrder == null ? 0 : sortOrder!.hashCode);

  @override
  String toString() => 'CreatePartnerProductMediaDto[url=$url, mediaType=$mediaType, isThumbnail=$isThumbnail, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'url'] = this.url;
    if (this.mediaType != null) {
      json[r'mediaType'] = this.mediaType;
    } else {
      json[r'mediaType'] = null;
    }
    if (this.isThumbnail != null) {
      json[r'isThumbnail'] = this.isThumbnail;
    } else {
      json[r'isThumbnail'] = null;
    }
    if (this.sortOrder != null) {
      json[r'sortOrder'] = this.sortOrder;
    } else {
      json[r'sortOrder'] = null;
    }
    return json;
  }

  /// Returns a new [CreatePartnerProductMediaDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreatePartnerProductMediaDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreatePartnerProductMediaDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreatePartnerProductMediaDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreatePartnerProductMediaDto(
        url: mapValueOfType<String>(json, r'url')!,
        mediaType: CreatePartnerProductMediaDtoMediaTypeEnum.fromJson(json[r'mediaType']),
        isThumbnail: mapValueOfType<bool>(json, r'isThumbnail'),
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<CreatePartnerProductMediaDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerProductMediaDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerProductMediaDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatePartnerProductMediaDto> mapFromJson(dynamic json) {
    final map = <String, CreatePartnerProductMediaDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreatePartnerProductMediaDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatePartnerProductMediaDto-objects as value to a dart map
  static Map<String, List<CreatePartnerProductMediaDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatePartnerProductMediaDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatePartnerProductMediaDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'url',
  };
}


class CreatePartnerProductMediaDtoMediaTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const CreatePartnerProductMediaDtoMediaTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const image = CreatePartnerProductMediaDtoMediaTypeEnum._(r'image');
  static const video = CreatePartnerProductMediaDtoMediaTypeEnum._(r'video');

  /// List of all possible values in this [enum][CreatePartnerProductMediaDtoMediaTypeEnum].
  static const values = <CreatePartnerProductMediaDtoMediaTypeEnum>[
    image,
    video,
  ];

  static CreatePartnerProductMediaDtoMediaTypeEnum? fromJson(dynamic value) => CreatePartnerProductMediaDtoMediaTypeEnumTypeTransformer().decode(value);

  static List<CreatePartnerProductMediaDtoMediaTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerProductMediaDtoMediaTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerProductMediaDtoMediaTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreatePartnerProductMediaDtoMediaTypeEnum] to String,
/// and [decode] dynamic data back to [CreatePartnerProductMediaDtoMediaTypeEnum].
class CreatePartnerProductMediaDtoMediaTypeEnumTypeTransformer {
  factory CreatePartnerProductMediaDtoMediaTypeEnumTypeTransformer() => _instance ??= const CreatePartnerProductMediaDtoMediaTypeEnumTypeTransformer._();

  const CreatePartnerProductMediaDtoMediaTypeEnumTypeTransformer._();

  String encode(CreatePartnerProductMediaDtoMediaTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreatePartnerProductMediaDtoMediaTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreatePartnerProductMediaDtoMediaTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'image': return CreatePartnerProductMediaDtoMediaTypeEnum.image;
        case r'video': return CreatePartnerProductMediaDtoMediaTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreatePartnerProductMediaDtoMediaTypeEnumTypeTransformer] instance.
  static CreatePartnerProductMediaDtoMediaTypeEnumTypeTransformer? _instance;
}


