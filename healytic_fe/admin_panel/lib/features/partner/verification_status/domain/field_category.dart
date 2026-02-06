import 'package:admin_panel/constants/field_keys.dart';

/// Categories for partner update fields.
///
/// Used to categorize field keys from the API response for DTO building.
enum FieldCategory {
  /// Business entity information fields (brand, tax code, phone).
  businessInfo,

  /// Address/location fields (street, ward, district, city).
  address,

  /// Legal representative fields (name, position, ID info).
  legalRepresentative,

  /// KYC document fields (identity, licenses, certificates).
  kycDocument,
}

/// Utility to categorize field keys from the API.
///
/// Field keys come from [VerifiedField.fieldKey] in the API response.
/// This utility provides a centralized way to determine which DTO section
/// each field belongs to when building [UpdatePartnerDto].
abstract final class FieldCategoryLookup {
  /// Address field keys (nested under businessInfo in DTO structure).
  static const _addressKeys = {
    FieldKeys.streetAddress,
    FieldKeys.ward,
    FieldKeys.district,
    FieldKeys.city,
  };

  /// Business info field keys.
  static const _businessInfoKeys = {
    FieldKeys.brandName,
    FieldKeys.taxCode,
    FieldKeys.phoneNumber,
    FieldKeys.businessType,
  };

  /// Legal representative field keys.
  static const _legalRepKeys = {
    FieldKeys.fullName,
    FieldKeys.position,
    FieldKeys.idType,
    FieldKeys.idNumber,
    FieldKeys.idIssueDate,
  };

  /// Get the category for a field key.
  ///
  /// Returns `null` if the key is not recognized (likely a KYC document).
  static FieldCategory? categoryOf(String fieldKey) {
    if (_addressKeys.contains(fieldKey)) return FieldCategory.address;
    if (_businessInfoKeys.contains(fieldKey)) return FieldCategory.businessInfo;
    if (_legalRepKeys.contains(fieldKey)) {
      return FieldCategory.legalRepresentative;
    }
    return null; // Unknown or KYC document
  }

  /// Check if edits contain any keys for a category.
  static bool hasEditsInCategory(
    Map<String, String> edits,
    FieldCategory category,
  ) {
    return edits.keys.any((key) => categoryOf(key) == category);
  }

  /// Get all edit entries for a specific category.
  static Map<String, String> editsForCategory(
    Map<String, String> edits,
    FieldCategory category,
  ) {
    return Map.fromEntries(
      edits.entries.where((e) => categoryOf(e.key) == category),
    );
  }

  /// Get the value for a specific field key from edits, or null if not present.
  static String? getValue(Map<String, String> edits, String fieldKey) {
    return edits[fieldKey];
  }
}
