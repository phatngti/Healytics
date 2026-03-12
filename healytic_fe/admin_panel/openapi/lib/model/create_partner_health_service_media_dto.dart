//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreatePartnerHealthServiceMediaDto {
  /// Returns a new [CreatePartnerHealthServiceMediaDto] instance.
  CreatePartnerHealthServiceMediaDto({
    required this.url,
    this.mediaType,
    this.isThumbnail,
    this.sortOrder,
  });

  String url;

  CreatePartnerHealthServiceMediaDtoMediaTypeEnum? mediaType;

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
  bool operator ==(Object other) => identical(this, other) || other is CreatePartnerHealthServiceMediaDto &&
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
  String toString() => 'CreatePartnerHealthServiceMediaDto[url=$url, mediaType=$mediaType, isThumbnail=$isThumbnail, sortOrder=$sortOrder]';

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

  /// Returns a new [CreatePartnerHealthServiceMediaDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreatePartnerHealthServiceMediaDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreatePartnerHealthServiceMediaDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreatePartnerHealthServiceMediaDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreatePartnerHealthServiceMediaDto(
        url: mapValueOfType<String>(json, r'url')!,
        mediaType: CreatePartnerHealthServiceMediaDtoMediaTypeEnum.fromJson(json[r'mediaType']),
        isThumbnail: mapValueOfType<bool>(json, r'isThumbnail'),
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<CreatePartnerHealthServiceMediaDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerHealthServiceMediaDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerHealthServiceMediaDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatePartnerHealthServiceMediaDto> mapFromJson(dynamic json) {
    final map = <String, CreatePartnerHealthServiceMediaDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreatePartnerHealthServiceMediaDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatePartnerHealthServiceMediaDto-objects as value to a dart map
  static Map<String, List<CreatePartnerHealthServiceMediaDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatePartnerHealthServiceMediaDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatePartnerHealthServiceMediaDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'url',
  };
}


class CreatePartnerHealthServiceMediaDtoMediaTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const CreatePartnerHealthServiceMediaDtoMediaTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const image = CreatePartnerHealthServiceMediaDtoMediaTypeEnum._(r'image');
  static const video = CreatePartnerHealthServiceMediaDtoMediaTypeEnum._(r'video');

  /// List of all possible values in this [enum][CreatePartnerHealthServiceMediaDtoMediaTypeEnum].
  static const values = <CreatePartnerHealthServiceMediaDtoMediaTypeEnum>[
    image,
    video,
  ];

  static CreatePartnerHealthServiceMediaDtoMediaTypeEnum? fromJson(dynamic value) => CreatePartnerHealthServiceMediaDtoMediaTypeEnumTypeTransformer().decode(value);

  static List<CreatePartnerHealthServiceMediaDtoMediaTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePartnerHealthServiceMediaDtoMediaTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePartnerHealthServiceMediaDtoMediaTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreatePartnerHealthServiceMediaDtoMediaTypeEnum] to String,
/// and [decode] dynamic data back to [CreatePartnerHealthServiceMediaDtoMediaTypeEnum].
class CreatePartnerHealthServiceMediaDtoMediaTypeEnumTypeTransformer {
  factory CreatePartnerHealthServiceMediaDtoMediaTypeEnumTypeTransformer() => _instance ??= const CreatePartnerHealthServiceMediaDtoMediaTypeEnumTypeTransformer._();

  const CreatePartnerHealthServiceMediaDtoMediaTypeEnumTypeTransformer._();

  String encode(CreatePartnerHealthServiceMediaDtoMediaTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreatePartnerHealthServiceMediaDtoMediaTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreatePartnerHealthServiceMediaDtoMediaTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'image': return CreatePartnerHealthServiceMediaDtoMediaTypeEnum.image;
        case r'video': return CreatePartnerHealthServiceMediaDtoMediaTypeEnum.video;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreatePartnerHealthServiceMediaDtoMediaTypeEnumTypeTransformer] instance.
  static CreatePartnerHealthServiceMediaDtoMediaTypeEnumTypeTransformer? _instance;
}


