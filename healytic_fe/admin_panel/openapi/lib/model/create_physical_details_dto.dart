//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreatePhysicalDetailsDto {
  /// Returns a new [CreatePhysicalDetailsDto] instance.
  CreatePhysicalDetailsDto({
    this.sku,
    this.barcode,
    this.stockQuantity,
    this.costPerItem,
    this.weightGram,
    this.dimensions,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sku;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? barcode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? stockQuantity;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? costPerItem;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? weightGram;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dimensions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreatePhysicalDetailsDto &&
    other.sku == sku &&
    other.barcode == barcode &&
    other.stockQuantity == stockQuantity &&
    other.costPerItem == costPerItem &&
    other.weightGram == weightGram &&
    other.dimensions == dimensions;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (sku == null ? 0 : sku!.hashCode) +
    (barcode == null ? 0 : barcode!.hashCode) +
    (stockQuantity == null ? 0 : stockQuantity!.hashCode) +
    (costPerItem == null ? 0 : costPerItem!.hashCode) +
    (weightGram == null ? 0 : weightGram!.hashCode) +
    (dimensions == null ? 0 : dimensions!.hashCode);

  @override
  String toString() => 'CreatePhysicalDetailsDto[sku=$sku, barcode=$barcode, stockQuantity=$stockQuantity, costPerItem=$costPerItem, weightGram=$weightGram, dimensions=$dimensions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.sku != null) {
      json[r'sku'] = this.sku;
    } else {
      json[r'sku'] = null;
    }
    if (this.barcode != null) {
      json[r'barcode'] = this.barcode;
    } else {
      json[r'barcode'] = null;
    }
    if (this.stockQuantity != null) {
      json[r'stockQuantity'] = this.stockQuantity;
    } else {
      json[r'stockQuantity'] = null;
    }
    if (this.costPerItem != null) {
      json[r'costPerItem'] = this.costPerItem;
    } else {
      json[r'costPerItem'] = null;
    }
    if (this.weightGram != null) {
      json[r'weightGram'] = this.weightGram;
    } else {
      json[r'weightGram'] = null;
    }
    if (this.dimensions != null) {
      json[r'dimensions'] = this.dimensions;
    } else {
      json[r'dimensions'] = null;
    }
    return json;
  }

  /// Returns a new [CreatePhysicalDetailsDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreatePhysicalDetailsDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreatePhysicalDetailsDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreatePhysicalDetailsDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreatePhysicalDetailsDto(
        sku: mapValueOfType<String>(json, r'sku'),
        barcode: mapValueOfType<String>(json, r'barcode'),
        stockQuantity: num.parse('${json[r'stockQuantity']}'),
        costPerItem: num.parse('${json[r'costPerItem']}'),
        weightGram: num.parse('${json[r'weightGram']}'),
        dimensions: mapValueOfType<String>(json, r'dimensions'),
      );
    }
    return null;
  }

  static List<CreatePhysicalDetailsDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreatePhysicalDetailsDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreatePhysicalDetailsDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreatePhysicalDetailsDto> mapFromJson(dynamic json) {
    final map = <String, CreatePhysicalDetailsDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreatePhysicalDetailsDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreatePhysicalDetailsDto-objects as value to a dart map
  static Map<String, List<CreatePhysicalDetailsDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreatePhysicalDetailsDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreatePhysicalDetailsDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

