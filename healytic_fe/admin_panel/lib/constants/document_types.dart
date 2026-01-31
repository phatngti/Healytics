/// Business constants for document types used in partner verification.
///
/// Each document type has:
/// - [type]: The document type identifier (e.g., 'BUSINESS_LICENSE')
/// - [label]: Human-readable label
/// - [documentKey]: Form field key for the document
class DocumentType {
  const DocumentType({
    required this.type,
    required this.label,
    required this.documentKey,
  });

  final String type;
  final String label;
  final String documentKey;
}

/// Registry of all document types used in partner verification.
abstract final class DocumentTypes {
  // ══════════════════════════════════════════════════════════════
  // Common Documents
  // ══════════════════════════════════════════════════════════════
  static const otherDocuments = DocumentType(
    type: 'OTHER_DOCUMENTS',
    label: 'Other Documents (Giấy tờ khác)',
    documentKey: 'other_documents',
  );
  static const businessLicense = DocumentType(
    type: 'BUSINESS_LICENSE',
    label: 'Business License (Giấy phép kinh doanh)',
    documentKey: 'business_license',
  );

  static const authorizationLetter = DocumentType(
    type: 'AUTHORIZATION_LETTER',
    label: 'Authorization Letter (Giấy ủy quyền)',
    documentKey: 'authorization_letter',
  );

  static const taxCertificate = DocumentType(
    type: 'TAX_CERTIFICATE',
    label: 'Tax Certificate (Giấy đăng ký thuế)',
    documentKey: 'tax_certificate',
  );

  // ══════════════════════════════════════════════════════════════
  // Medical & Healthcare Licenses
  // ══════════════════════════════════════════════════════════════

  static const kcbLicense = DocumentType(
    type: 'KCB_LICENSE',
    label: 'KCB License (Giấy phép hành nghề KCB)',
    documentKey: 'kcb_license',
  );

  static const rhmLicense = DocumentType(
    type: 'RHM_LICENSE',
    label: 'RHM License (Giấy phép hoạt động Răng Hàm Mặt)',
    documentKey: 'rhm_license',
  );

  static const dermatologyLicense = DocumentType(
    type: 'DERMATOLOGY_LICENSE',
    label: 'Dermatology License (Giấy phép hành nghề Da liễu)',
    documentKey: 'dermatology_license',
  );

  static const yhctLicense = DocumentType(
    type: 'YHCT_LICENSE',
    label: 'YHCT License (Giấy phép Y học cổ truyền)',
    documentKey: 'yhct_license',
  );

  static const psychologyLicense = DocumentType(
    type: 'PSYCHOLOGY_LICENSE',
    label: 'Psychology License (Giấy phép hành nghề Tâm lý)',
    documentKey: 'psychology_license',
  );

  static const psychiatryLicense = DocumentType(
    type: 'PSYCHIATRY_LICENSE',
    label: 'Psychiatry License (Giấy phép hành nghề Tâm thần)',
    documentKey: 'psychiatry_license',
  );

  static const nutritionLicense = DocumentType(
    type: 'NUTRITION_LICENSE',
    label: 'Nutrition License (Giấy phép hành nghề Dinh dưỡng)',
    documentKey: 'nutrition_license',
  );

  // ══════════════════════════════════════════════════════════════
  // Specialty Certificates
  // ══════════════════════════════════════════════════════════════

  static const antt = DocumentType(
    type: 'ANTT',
    label: 'ANTT (Giấy phép an toàn thực phẩm)',
    documentKey: 'antt',
  );

  static const gcnFitness = DocumentType(
    type: 'GCN_FITNESS',
    label: 'GCN Fitness (Giấy chứng nhận thể thao)',
    documentKey: 'gcn_fitness',
  );

  static const gpp = DocumentType(
    type: 'GPP',
    label: 'GPP Certificate (Giấy chứng nhận GPP)',
    documentKey: 'gpp',
  );

  static const technicalPortfolio = DocumentType(
    type: 'TECHNICAL_PORTFOLIO',
    label: 'Technical Portfolio (Hồ sơ kỹ thuật)',
    documentKey: 'technical_portfolio',
  );

  static const medicalWasteContract = DocumentType(
    type: 'MEDICAL_WASTE_CONTRACT',
    label: 'Medical Waste Contract (Hợp đồng xử lý chất thải y tế)',
    documentKey: 'medical_waste_contract',
  );

  // ══════════════════════════════════════════════════════════════
  // Identity Documents
  // ══════════════════════════════════════════════════════════════

  static const idCardFront = DocumentType(
    type: 'IDENTITY_FRONT',
    label: 'ID Card Front (CCCD mặt trước)',
    documentKey: 'identity_front',
  );

  static const idCardBack = DocumentType(
    type: 'IDENTITY_BACK',
    label: 'ID Card Back (CCCD mặt sau)',
    documentKey: 'identity_back',
  );

  // ══════════════════════════════════════════════════════════════
  // Lookup
  // ══════════════════════════════════════════════════════════════

  /// All available document types.
  static const List<DocumentType> values = [
    businessLicense,
    authorizationLetter,
    taxCertificate,
    kcbLicense,
    rhmLicense,
    dermatologyLicense,
    yhctLicense,
    psychologyLicense,
    psychiatryLicense,
    nutritionLicense,
    antt,
    gcnFitness,
    gpp,
    technicalPortfolio,
    medicalWasteContract,
    idCardFront,
    idCardBack,
    otherDocuments,
  ];

  /// Find document type by type string.
  static DocumentType? findByType(String type) {
    final upperType = type.toUpperCase();
    for (final doc in values) {
      if (doc.type == upperType) return doc;
    }
    return null;
  }

  /// Find document type by document key.
  static DocumentType? findByKey(String key) {
    final lowerKey = key.toLowerCase();
    for (final doc in values) {
      if (doc.documentKey == lowerKey) return doc;
    }
    return null;
  }
}
