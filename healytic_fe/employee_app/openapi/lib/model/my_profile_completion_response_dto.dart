//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MyProfileCompletionResponseDto {
  /// Returns a new [MyProfileCompletionResponseDto] instance.
  MyProfileCompletionResponseDto({
    required this.id,
    required this.clinicIdentity,
    this.coverImageUrl,
    this.logoImageUrl,
    this.description,
    this.gallery = const [],
    this.certifications = const [],
    this.checklist = const [],
    required this.completionPercent,
    required this.isCompleted,
  });


  String id;

  PartnerProfileCompletionIdentityDto clinicIdentity;

  Object? coverImageUrl;

  Object? logoImageUrl;

  Object? description;

  List<String> gallery;

  List<PartnerProfileCompletionCertificationDto> certifications;

  List<CompletionChecklistItemDto> checklist;

  num completionPercent;

  /// Always true when returned from a successful profile-completion update, because the request DTO enforces all required checklist constraints.
  bool isCompleted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MyProfileCompletionResponseDto &&
    other.id == id &&
    other.clinicIdentity == clinicIdentity &&
    other.coverImageUrl == coverImageUrl &&
    other.logoImageUrl == logoImageUrl &&
    other.description == description &&
    _deepEquality.equals(other.gallery, gallery) &&
    _deepEquality.equals(other.certifications, certifications) &&
    _deepEquality.equals(other.checklist, checklist) &&
    other.completionPercent == completionPercent &&
    other.isCompleted == isCompleted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (clinicIdentity.hashCode) +
    (coverImageUrl == null ? 0 : coverImageUrl!.hashCode) +
    (logoImageUrl == null ? 0 : logoImageUrl!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (gallery.hashCode) +
    (certifications.hashCode) +
    (checklist.hashCode) +
    (completionPercent.hashCode) +
    (isCompleted.hashCode);

  @override
  String toString() => 'MyProfileCompletionResponseDto[id=$id, clinicIdentity=$clinicIdentity, coverImageUrl=$coverImageUrl, logoImageUrl=$logoImageUrl, description=$description, gallery=$gallery, certifications=$certifications, checklist=$checklist, completionPercent=$completionPercent, isCompleted=$isCompleted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'clinicIdentity'] = this.clinicIdentity;
    if (this.coverImageUrl != null) {
      json[r'coverImageUrl'] = this.coverImageUrl;
    } else {
      json[r'coverImageUrl'] = null;
    }
    if (this.logoImageUrl != null) {
      json[r'logoImageUrl'] = this.logoImageUrl;
    } else {
      json[r'logoImageUrl'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'gallery'] = this.gallery;
      json[r'certifications'] = this.certifications;
      json[r'checklist'] = this.checklist;
      json[r'completionPercent'] = this.completionPercent;
      json[r'isCompleted'] = this.isCompleted;
    return json;
  }

  /// Returns a new [MyProfileCompletionResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MyProfileCompletionResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MyProfileCompletionResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MyProfileCompletionResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MyProfileCompletionResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        clinicIdentity: PartnerProfileCompletionIdentityDto.fromJson(json[r'clinicIdentity'])!,
        coverImageUrl: mapValueOfType<Object>(json, r'coverImageUrl'),
        logoImageUrl: mapValueOfType<Object>(json, r'logoImageUrl'),
        description: mapValueOfType<Object>(json, r'description'),
        gallery: json[r'gallery'] is Iterable
            ? (json[r'gallery'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        certifications: PartnerProfileCompletionCertificationDto.listFromJson(json[r'certifications']),
        checklist: CompletionChecklistItemDto.listFromJson(json[r'checklist']),
        completionPercent: num.parse('${json[r'completionPercent']}'),
        isCompleted: mapValueOfType<bool>(json, r'isCompleted')!,
      );
    }
    return null;
  }

  static List<MyProfileCompletionResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyProfileCompletionResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyProfileCompletionResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MyProfileCompletionResponseDto> mapFromJson(dynamic json) {
    final map = <String, MyProfileCompletionResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MyProfileCompletionResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MyProfileCompletionResponseDto-objects as value to a dart map
  static Map<String, List<MyProfileCompletionResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MyProfileCompletionResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MyProfileCompletionResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'clinicIdentity',
    'gallery',
    'certifications',
    'checklist',
    'completionPercent',
    'isCompleted',
  };
}

