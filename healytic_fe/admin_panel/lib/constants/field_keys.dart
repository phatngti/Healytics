/// Centralized field key constants for partner verification forms.
///
/// These keys correspond to [VerifiedField.fieldKey] values from the API.
/// Use these constants when building DTOs or accessing form values.
abstract final class FieldKeys {
  // ══════════════════════════════════════════════════════════════
  // Address Fields
  // ══════════════════════════════════════════════════════════════

  /// Street address field key.
  static const streetAddress = 'streetAddress';

  /// Ward/commune field key.
  static const ward = 'ward';

  /// District field key.
  static const district = 'district';

  /// City/province field key.
  static const city = 'city';

  // ══════════════════════════════════════════════════════════════
  // Business Info Fields
  // ══════════════════════════════════════════════════════════════
  /// Business Type field key.
  static const businessType = 'businessType';

  /// Brand name field key.
  static const brandName = 'brandName';

  /// Tax registration code field key.
  static const taxCode = 'taxCode';

  /// Phone number field key.
  static const phoneNumber = 'phoneNumber';

  /// Username field key.
  static const username = 'username';

  /// Email field key.
  static const email = 'email';

  // ══════════════════════════════════════════════════════════════
  // Legal Representative Fields
  // ══════════════════════════════════════════════════════════════

  /// Full name field key.
  static const fullName = 'fullName';

  /// Position field key.
  static const position = 'position';

  /// ID type field key (ID Card, Passport, etc.).
  static const idType = 'idType';

  /// ID number field key.
  static const idNumber = 'idNumber';

  /// ID issue date field key.
  static const idIssueDate = 'idIssueDate';
}
