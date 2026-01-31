import 'package:admin_panel/constants/document_types.dart';
import 'package:admin_panel/constants/file_type.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';

/// Helper function to create a verified string field
VerifiedFieldEntity<String> _vf(
  String key,
  String value, {
  bool isVerified = false,
  String? feedback,
}) => VerifiedFieldEntity(
  fieldKey: key,
  value: value,
  isVerified: isVerified,
  feedback: feedback,
);

/// Helper function to create a verified location field
VerifiedFieldEntity<AddressLocation> _vfLocation(
  String key,
  String id,
  String name, {
  bool isVerified = false,
  String? feedback,
}) => VerifiedFieldEntity(
  fieldKey: key,
  value: AddressLocation(id: id, name: name),
  isVerified: isVerified,
  feedback: feedback,
);

/// Mock data for partner verification detail matching the review application UI.
///
/// Each entry should have:
/// - Complete address information (streetAddress, ward, district, city, country)
/// - Paired ID cards (front + back) for 2-column grid display
/// - Optional authorization letter documents
/// - Fields wrapped in [VerifiedFieldEntity] with isVerified and feedback
final Map<String, PartnerVerificationDetailEntity>
partnerVerificationDetailMockData = {
  'SP-2023-001': PartnerVerificationDetailEntity(
    id: const PartnerVerificationId('SP-2023-001'),
    brandName: const VerifiedFieldEntity(
      fieldKey: 'brandName',
      value: 'Hanoi Spa & Wellness',
      isVerified: true,
    ),
    taxRegistrationCode: const VerifiedFieldEntity(
      fieldKey: 'taxRegistrationCode',
      value: '0101234567-HN',
      isVerified: true,
    ),
    isTaxCodeValid: true,
    serviceTags: const VerifiedFieldEntity(
      fieldKey: 'serviceTags',
      value: [
        'Spa Treatment',
        'Massage Therapy',
        'Sauna',
        'Facial Care',
        'Body Wrap',
      ],
      isVerified: true,
    ),
    address: AddressInfo(
      streetAddress: _vf(
        'streetAddress',
        '18 Âu Triệu Street',
        isVerified: true,
      ),
      ward: _vfLocation('ward', 'w001', 'Hàng Trống', isVerified: true),
      district: _vfLocation('district', 'd001', 'Hoàn Kiếm', isVerified: true),
      city: _vfLocation('city', 'c001', 'Hà Nội', isVerified: true),
      country: 'Vietnam',
    ),
    username: const VerifiedFieldEntity(
      fieldKey: 'username',
      value: 'hanoispa_admin',
      isVerified: true,
    ),
    email: const VerifiedFieldEntity(
      fieldKey: 'email',
      value: 'contact@hanoispa.vn',
      isVerified: true,
    ),
    isEmailVerified: true,
    phoneNumber: const VerifiedFieldEntity(
      fieldKey: 'phoneNumber',
      value: '+84 90 123 4567',
      isVerified: true,
    ),
    legalRepresentative: LegalRepresentative(
      fullName: _vf('fullName', 'Nguyễn Văn An', isVerified: true),
      position: _vf('position', 'General Director', isVerified: true),
      idType: _vf('idType', 'Citizen ID Card', isVerified: true),
      idNumber: _vf('idNumber', '001088000XXX', isVerified: true),
      idIssueDate: _vf('idIssueDate', '2020-05-15', isVerified: true),
    ),
    kycDocuments: [
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardFront.documentKey,
        value: KycDocument(
          id: 'doc1',
          documentKey: DocumentTypes.idCardFront.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Front_NVA.jpg',
          fileUrl: 'https://picsum.photos/seed/idfront1/800/500',
          uploadedAt: DateTime(2023, 10, 24),
        ),
        isVerified: true,
      ),
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardBack.documentKey,
        value: KycDocument(
          id: 'doc2',
          documentKey: DocumentTypes.idCardBack.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Back_NVA.jpg',
          fileUrl: 'https://picsum.photos/seed/idback1/800/500',
          uploadedAt: DateTime(2023, 10, 24),
        ),
        isVerified: true,
      ),
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.authorizationLetter.documentKey,
        value: KycDocument(
          id: 'doc3',
          documentKey: DocumentTypes.authorizationLetter.documentKey,
          fileType: FileTypeDisplay.pdf.toString(),
          fileName: 'Authorization_Letter_Signed.pdf',
          fileUrl: 'https://picsum.photos/seed/auth1/800/1100',
          fileSize: '2.4 MB',
          uploadedAt: DateTime(2023, 10, 24),
        ),
        isVerified: true,
      ),
    ],
    status: PartnerVerificationStatus.pending,
    priority: PartnerPriority.high,
    submittedAt: DateTime(2023, 10, 24),
  ),
  'GYM-2023-042': PartnerVerificationDetailEntity(
    id: const PartnerVerificationId('GYM-2023-042'),
    brandName: const VerifiedFieldEntity(
      fieldKey: 'brandName',
      value: 'Elite Fitness Center',
      isVerified: false,
      feedback: 'Brand name requires verification with business license.',
    ),
    taxRegistrationCode: const VerifiedFieldEntity(
      fieldKey: 'taxRegistrationCode',
      value: '0102345678-HN',
      isVerified: true,
    ),
    isTaxCodeValid: true,
    serviceTags: const VerifiedFieldEntity(
      fieldKey: 'serviceTags',
      value: ['Gym', 'Yoga', 'Personal Training', 'Group Classes'],
      isVerified: true,
    ),
    address: AddressInfo(
      streetAddress: _vf(
        'streetAddress',
        '45 Trần Hưng Đạo Street',
        isVerified: true,
      ),
      ward: _vfLocation('ward', 'w002', 'Phan Chu Trinh', isVerified: true),
      district: _vfLocation('district', 'd001', 'Hoàn Kiếm', isVerified: true),
      city: _vfLocation('city', 'c001', 'Hà Nội', isVerified: true),
      country: 'Vietnam',
    ),
    username: const VerifiedFieldEntity(
      fieldKey: 'username',
      value: 'elitefitness_mgr',
      isVerified: true,
    ),
    email: const VerifiedFieldEntity(
      fieldKey: 'email',
      value: 'info@elitefitness.vn',
      isVerified: false,
      feedback: 'Email has not been verified by the partner.',
    ),
    isEmailVerified: false,
    phoneNumber: const VerifiedFieldEntity(
      fieldKey: 'phoneNumber',
      value: '+84 91 234 5678',
      isVerified: true,
    ),
    legalRepresentative: LegalRepresentative(
      fullName: _vf('fullName', 'Trần Minh Đức', isVerified: true),
      position: _vf('position', 'CEO', isVerified: true),
      idType: _vf('idType', 'Citizen ID Card', isVerified: true),
      idNumber: _vf('idNumber', '001089000YYY', isVerified: true),
      idIssueDate: _vf('idIssueDate', '2019-08-22', isVerified: true),
    ),
    kycDocuments: [
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardFront.documentKey,
        value: KycDocument(
          id: 'doc4',
          documentKey: DocumentTypes.idCardFront.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Front_TMD.jpg',
          fileUrl: 'https://picsum.photos/seed/idfront2/800/500',
          uploadedAt: DateTime(2023, 10, 22),
        ),
        isVerified: true,
      ),
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardBack.documentKey,
        value: KycDocument(
          id: 'doc5',
          documentKey: DocumentTypes.idCardBack.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Back_TMD.jpg',
          fileUrl: 'https://picsum.photos/seed/idback2/800/500',
          uploadedAt: DateTime(2023, 10, 22),
        ),
        isVerified: true,
      ),
    ],
    status: PartnerVerificationStatus.pending,
    priority: PartnerPriority.normal,
    submittedAt: DateTime(2023, 10, 22),
  ),
  'SP-2023-003': PartnerVerificationDetailEntity(
    id: const PartnerVerificationId('SP-2023-003'),
    brandName: const VerifiedFieldEntity(
      fieldKey: 'brandName',
      value: 'Lotus Massage',
      isVerified: true,
    ),
    taxRegistrationCode: const VerifiedFieldEntity(
      fieldKey: 'taxRegistrationCode',
      value: '0103456789-HN',
      isVerified: false,
      feedback: 'Tax registration code is invalid. Please verify.',
    ),
    isTaxCodeValid: false,
    serviceTags: const VerifiedFieldEntity(
      fieldKey: 'serviceTags',
      value: ['Massage', 'Aromatherapy', 'Hot Stone'],
      isVerified: true,
    ),
    address: AddressInfo(
      streetAddress: _vf(
        'streetAddress',
        '123 Hàng Bông Street',
        isVerified: true,
      ),
      ward: _vfLocation('ward', 'w003', 'Hàng Gai', isVerified: true),
      district: _vfLocation('district', 'd001', 'Hoàn Kiếm', isVerified: true),
      city: _vfLocation('city', 'c001', 'Hà Nội', isVerified: true),
      country: 'Vietnam',
    ),
    username: const VerifiedFieldEntity(
      fieldKey: 'username',
      value: 'lotus_massage',
      isVerified: true,
    ),
    email: const VerifiedFieldEntity(
      fieldKey: 'email',
      value: 'lotus.massage@gmail.com',
      isVerified: false,
    ),
    isEmailVerified: false,
    phoneNumber: const VerifiedFieldEntity(
      fieldKey: 'phoneNumber',
      value: '+84 92 345 6789',
      isVerified: true,
    ),
    legalRepresentative: LegalRepresentative(
      fullName: _vf('fullName', 'Lê Thị Hoa', isVerified: true),
      position: _vf('position', 'Owner', isVerified: true),
      idNumber: _vf('idNumber', '001090000ZZZ', isVerified: true),
    ),
    kycDocuments: [
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardFront.documentKey,
        value: KycDocument(
          id: 'doc6',
          documentKey: DocumentTypes.idCardFront.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Front_LTH.jpg',
          fileUrl: 'https://picsum.photos/seed/idfront3/800/500',
          uploadedAt: DateTime(2023, 10, 21),
        ),
        isVerified: true,
      ),
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardBack.documentKey,
        value: KycDocument(
          id: 'doc6b',
          documentKey: DocumentTypes.idCardBack.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Back_LTH.jpg',
          fileUrl: 'https://picsum.photos/seed/idback3/800/500',
          uploadedAt: DateTime(2023, 10, 21),
        ),
        isVerified: true,
      ),
    ],
    status: PartnerVerificationStatus.pending,
    priority: PartnerPriority.normal,
    submittedAt: DateTime(2023, 10, 21),
  ),
  'SP-2023-019': PartnerVerificationDetailEntity(
    id: const PartnerVerificationId('SP-2023-019'),
    brandName: const VerifiedFieldEntity(
      fieldKey: 'brandName',
      value: 'Royal Sauna & Bath',
      isVerified: true,
    ),
    taxRegistrationCode: const VerifiedFieldEntity(
      fieldKey: 'taxRegistrationCode',
      value: '0104567890-HN',
      isVerified: true,
    ),
    isTaxCodeValid: true,
    serviceTags: const VerifiedFieldEntity(
      fieldKey: 'serviceTags',
      value: ['Sauna', 'Steam Bath', 'Therapy', 'Relaxation', 'Premium'],
      isVerified: true,
    ),
    address: AddressInfo(
      streetAddress: _vf(
        'streetAddress',
        '78 Lý Thường Kiệt Street',
        isVerified: true,
      ),
      ward: _vfLocation('ward', 'w004', 'Trần Hưng Đạo', isVerified: true),
      district: _vfLocation('district', 'd001', 'Hoàn Kiếm', isVerified: true),
      city: _vfLocation('city', 'c001', 'Hà Nội', isVerified: true),
      country: 'Vietnam',
    ),
    username: const VerifiedFieldEntity(
      fieldKey: 'username',
      value: 'royalsauna_vn',
      isVerified: true,
    ),
    email: const VerifiedFieldEntity(
      fieldKey: 'email',
      value: 'contact@royalsauna.vn',
      isVerified: true,
    ),
    isEmailVerified: true,
    phoneNumber: const VerifiedFieldEntity(
      fieldKey: 'phoneNumber',
      value: '+84 93 456 7890',
      isVerified: true,
    ),
    legalRepresentative: LegalRepresentative(
      fullName: _vf('fullName', 'Phạm Quốc Bảo', isVerified: true),
      position: _vf('position', 'Managing Director', isVerified: true),
      idNumber: _vf('idNumber', '001091000AAA', isVerified: true),
    ),
    kycDocuments: [
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardFront.documentKey,
        value: KycDocument(
          id: 'doc7',
          documentKey: DocumentTypes.idCardFront.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Front_PQB.jpg',
          fileUrl: 'https://picsum.photos/seed/idfront4/800/500',
          uploadedAt: DateTime(2023, 10, 20),
        ),
        isVerified: true,
      ),
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardBack.documentKey,
        value: KycDocument(
          id: 'doc8',
          documentKey: DocumentTypes.idCardBack.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Back_PQB.jpg',
          fileUrl: 'https://picsum.photos/seed/idback4/800/500',
          uploadedAt: DateTime(2023, 10, 20),
        ),
        isVerified: true,
      ),
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.authorizationLetter.documentKey,
        value: KycDocument(
          id: 'doc9',
          documentKey: DocumentTypes.authorizationLetter.documentKey,
          fileType: FileTypeDisplay.pdf.toString(),
          fileName: 'Authorization_Letter.pdf',
          fileUrl: 'https://picsum.photos/seed/auth2/800/1100',
          fileSize: '1.8 MB',
          uploadedAt: DateTime(2023, 10, 20),
        ),
        isVerified: true,
      ),
    ],
    status: PartnerVerificationStatus.pending,
    priority: PartnerPriority.high,
    submittedAt: DateTime(2023, 10, 20),
  ),
  'GYM-2023-011': PartnerVerificationDetailEntity(
    id: const PartnerVerificationId('GYM-2023-011'),
    brandName: const VerifiedFieldEntity(
      fieldKey: 'brandName',
      value: 'Ozone Gym',
      isVerified: true,
    ),
    taxRegistrationCode: const VerifiedFieldEntity(
      fieldKey: 'taxRegistrationCode',
      value: '0105678901-HN',
      isVerified: true,
    ),
    isTaxCodeValid: true,
    serviceTags: const VerifiedFieldEntity(
      fieldKey: 'serviceTags',
      value: ['Gym', 'Weight Training', 'Cardio', 'CrossFit'],
      isVerified: true,
    ),
    address: AddressInfo(
      streetAddress: _vf(
        'streetAddress',
        '56 Nguyễn Du Street',
        isVerified: true,
      ),
      ward: _vfLocation('ward', 'w005', 'Nguyễn Du', isVerified: true),
      district: _vfLocation(
        'district',
        'd002',
        'Hai Bà Trưng',
        isVerified: true,
      ),
      city: _vfLocation('city', 'c001', 'Hà Nội', isVerified: true),
      country: 'Vietnam',
    ),
    username: const VerifiedFieldEntity(
      fieldKey: 'username',
      value: 'ozone_gym',
      isVerified: true,
    ),
    email: const VerifiedFieldEntity(
      fieldKey: 'email',
      value: 'ozone.gym@email.com',
      isVerified: false,
    ),
    isEmailVerified: false,
    phoneNumber: const VerifiedFieldEntity(
      fieldKey: 'phoneNumber',
      value: '+84 94 567 8901',
      isVerified: true,
    ),
    legalRepresentative: LegalRepresentative(
      fullName: _vf('fullName', 'Hoàng Văn Cường', isVerified: true),
      position: _vf('position', 'Founder', isVerified: true),
      idNumber: _vf('idNumber', '001092000BBB', isVerified: true),
    ),
    kycDocuments: [
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardFront.documentKey,
        value: KycDocument(
          id: 'doc10',
          documentKey: DocumentTypes.idCardFront.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Front_HVC.jpg',
          fileUrl: 'https://picsum.photos/seed/idfront5/800/500',
          uploadedAt: DateTime(2023, 10, 18),
        ),
        isVerified: true,
      ),
      VerifiedFieldEntity(
        fieldKey: DocumentTypes.idCardBack.documentKey,
        value: KycDocument(
          id: 'doc11',
          documentKey: DocumentTypes.idCardBack.documentKey,
          fileType: FileTypeDisplay.image.toString(),
          fileName: 'CCCD_Back_HVC.jpg',
          fileUrl: 'https://picsum.photos/seed/idback5/800/500',
          uploadedAt: DateTime(2023, 10, 18),
        ),
        isVerified: true,
      ),
    ],
    status: PartnerVerificationStatus.approved,
    priority: PartnerPriority.normal,
    submittedAt: DateTime(2023, 10, 18),
    reviewNote: 'All documents verified. Partner approved.',
  ),
  'SP-2023-000': PartnerVerificationDetailEntity(
    id: const PartnerVerificationId('SP-2023-000'),
    brandName: const VerifiedFieldEntity(
      fieldKey: 'brandName',
      value: 'Fake Clinic',
      isVerified: false,
      feedback: 'Brand name does not match business registration.',
    ),
    taxRegistrationCode: const VerifiedFieldEntity(
      fieldKey: 'taxRegistrationCode',
      value: '0000000000-XX',
      isVerified: false,
      feedback: 'Invalid tax registration code.',
    ),
    isTaxCodeValid: false,
    serviceTags: const VerifiedFieldEntity(
      fieldKey: 'serviceTags',
      value: ['Clinic'],
      isVerified: false,
      feedback: 'Service type not verified.',
    ),
    address: AddressInfo(
      streetAddress: _vf(
        'streetAddress',
        'Unknown Address',
        isVerified: false,
        feedback: 'Address could not be verified.',
      ),
      city: _vfLocation('city', '', 'Unknown', isVerified: false),
      country: 'Vietnam',
    ),
    username: const VerifiedFieldEntity(
      fieldKey: 'username',
      value: 'fake_clinic',
      isVerified: false,
    ),
    email: const VerifiedFieldEntity(
      fieldKey: 'email',
      value: 'fake@clinic.com',
      isVerified: false,
      feedback: 'Email domain appears suspicious.',
    ),
    isEmailVerified: false,
    phoneNumber: const VerifiedFieldEntity(
      fieldKey: 'phoneNumber',
      value: '+84 00 000 0000',
      isVerified: false,
      feedback: 'Phone number is invalid.',
    ),
    legalRepresentative: LegalRepresentative(
      fullName: _vf(
        'fullName',
        'Unknown Person',
        isVerified: false,
        feedback: 'Identity could not be verified.',
      ),
      position: _vf('position', 'Unknown', isVerified: false),
      idNumber: _vf('idNumber', '000000000XXX', isVerified: false),
    ),
    kycDocuments: [],
    status: PartnerVerificationStatus.rejected,
    priority: PartnerPriority.normal,
    submittedAt: DateTime(2023, 10, 15),
    reviewNote:
        'Rejected due to invalid tax registration and missing KYC documents.',
  ),
};
