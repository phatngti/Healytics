//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SeedServiceDto {
  /// Returns a new [SeedServiceDto] instance.
  SeedServiceDto({
    this.key,
    this.partnerKey,
    this.partnerBrandName,
    this.employeeKeys = const [],
    this.categoryKey,
    this.categoryName,
    required this.name,
    this.slug,
    this.description,
    this.price,
    this.durationMinutes,
    this.vendorName,
  });


  /// Unique lookup key
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? key;

  /// Key of a previously seeded partner
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerKey;

  /// Brand name to look up the partner
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerBrandName;

  /// Keys of previously seeded employees
  List<String> employeeKeys;

  /// Key of a previously seeded category
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? categoryKey;

  /// Category name (auto-created if missing)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? categoryName;

  String name;

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

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? price;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? durationMinutes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? vendorName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedServiceDto &&
    other.key == key &&
    other.partnerKey == partnerKey &&
    other.partnerBrandName == partnerBrandName &&
    _deepEquality.equals(other.employeeKeys, employeeKeys) &&
    other.categoryKey == categoryKey &&
    other.categoryName == categoryName &&
    other.name == name &&
    other.slug == slug &&
    other.description == description &&
    other.price == price &&
    other.durationMinutes == durationMinutes &&
    other.vendorName == vendorName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key == null ? 0 : key!.hashCode) +
    (partnerKey == null ? 0 : partnerKey!.hashCode) +
    (partnerBrandName == null ? 0 : partnerBrandName!.hashCode) +
    (employeeKeys.hashCode) +
    (categoryKey == null ? 0 : categoryKey!.hashCode) +
    (categoryName == null ? 0 : categoryName!.hashCode) +
    (name.hashCode) +
    (slug == null ? 0 : slug!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (price == null ? 0 : price!.hashCode) +
    (durationMinutes == null ? 0 : durationMinutes!.hashCode) +
    (vendorName == null ? 0 : vendorName!.hashCode);

  @override
  String toString() => 'SeedServiceDto[key=$key, partnerKey=$partnerKey, partnerBrandName=$partnerBrandName, employeeKeys=$employeeKeys, categoryKey=$categoryKey, categoryName=$categoryName, name=$name, slug=$slug, description=$description, price=$price, durationMinutes=$durationMinutes, vendorName=$vendorName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
    if (this.partnerKey != null) {
      json[r'partnerKey'] = this.partnerKey;
    } else {
      json[r'partnerKey'] = null;
    }
    if (this.partnerBrandName != null) {
      json[r'partnerBrandName'] = this.partnerBrandName;
    } else {
      json[r'partnerBrandName'] = null;
    }
      json[r'employeeKeys'] = this.employeeKeys;
    if (this.categoryKey != null) {
      json[r'categoryKey'] = this.categoryKey;
    } else {
      json[r'categoryKey'] = null;
    }
    if (this.categoryName != null) {
      json[r'categoryName'] = this.categoryName;
    } else {
      json[r'categoryName'] = null;
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
    if (this.price != null) {
      json[r'price'] = this.price;
    } else {
      json[r'price'] = null;
    }
    if (this.durationMinutes != null) {
      json[r'durationMinutes'] = this.durationMinutes;
    } else {
      json[r'durationMinutes'] = null;
    }
    if (this.vendorName != null) {
      json[r'vendorName'] = this.vendorName;
    } else {
      json[r'vendorName'] = null;
    }
    return json;
  }

  /// Returns a new [SeedServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedServiceDto(
        key: mapValueOfType<String>(json, r'key'),
        partnerKey: mapValueOfType<String>(json, r'partnerKey'),
        partnerBrandName: mapValueOfType<String>(json, r'partnerBrandName'),
        employeeKeys: json[r'employeeKeys'] is Iterable
            ? (json[r'employeeKeys'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        categoryKey: mapValueOfType<String>(json, r'categoryKey'),
        categoryName: mapValueOfType<String>(json, r'categoryName'),
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug'),
        description: mapValueOfType<String>(json, r'description'),
        price: num.parse('${json[r'price']}'),
        durationMinutes: num.parse('${json[r'durationMinutes']}'),
        vendorName: mapValueOfType<String>(json, r'vendorName'),
      );
    }
    return null;
  }

  static List<SeedServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedServiceDto> mapFromJson(dynamic json) {
    final map = <String, SeedServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedServiceDto-objects as value to a dart map
  static Map<String, List<SeedServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

