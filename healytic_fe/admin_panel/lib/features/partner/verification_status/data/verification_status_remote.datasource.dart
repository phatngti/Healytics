import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';

/// Abstract interface for verification status data source.
abstract class VerificationStatusRemoteDataSource {
  /// Fetches the verification status from the remote API.
  Future<ProviderVerificationStatusEntity> getVerificationStatus();

  /// Resubmits the application to the remote API.
  Future<bool> resubmitApplication();

  /// Uploads a document to the remote storage.
  Future<VerificationDocument> uploadDocument({
    required String documentId,
    required String filePath,
  });
}

/// Mock implementation of [VerificationStatusRemoteDataSource].
///
/// Returns sample data matching the HTML design for development
/// and testing purposes.
class VerificationStatusRemoteDataSourceMock
    implements VerificationStatusRemoteDataSource {
  @override
  Future<ProviderVerificationStatusEntity> getVerificationStatus() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Define partner info with requiresUpdate flags
    const partnerInfo = PartnerInfo(
      taxCode: VerificationStringField(
        value: 'XX-1234567-Y',
        displayValue: 'XX-1234567-Y',
        requiresUpdate: true,
        adminFeedback: 'Tax code mismatch with tax document.',
      ),
      legalName: VerificationStringField(
        value: 'Serenity Spa & Wellness LLC',
        displayValue: 'Serenity Spa & Wellness LLC',
        requiresUpdate: true,
        adminFeedback: 'Name mismatch with tax document.',
      ),
      brandName: VerificationStringField(
        value: 'Serenity Spa',
        displayValue: 'Serenity Spa',
        requiresUpdate: false,
      ),
      businessType: VerificationStringField(
        value: 'Individual Business',
        displayValue: 'Individual Business',
        requiresUpdate: false,
      ),
      phoneNumber: VerificationOptionalStringField(
        value: '+1 (555) 000-0000',
        displayValue: '+1 (555) 000-0000',
        requiresUpdate: true,
        adminFeedback: 'Phone number mismatch with tax document.',
      ),
    );

    // Define location details with requiresUpdate flags
    const locationDetails = LocationDetailsInfo(
      provinceId: VerificationStringField(
        value: '05a7608b-0978-42d1-b6b0-9f21198e6dfa',
        displayValue: 'Thành phố Hà Nội',
        requiresUpdate: true,
        adminFeedback: 'Province ID mismatch with tax document.',
      ),
      districtId: VerificationStringField(
        value: 'd7f692d1-e766-4c29-b855-894467308850',
        displayValue: 'Quận Ba Đình',
        requiresUpdate: true,
        adminFeedback: 'District ID mismatch with tax document.',
      ),
      wardId: VerificationStringField(
        value: '35a05597-60d5-4e7c-aa16-8d4952386d3c',
        displayValue: 'Huyện Thanh Trì',
        requiresUpdate: true,
        adminFeedback: 'Ward ID mismatch with tax document.',
      ),
      streetAddress: VerificationStringField(
        value: '123 Harmony Lane, Suite 400',
        displayValue: '123 Harmony Lane, Suite 400',
        requiresUpdate: true,
        adminFeedback: 'Please provide unit number if applicable.',
      ),
    );

    // Define legal representative with requiresUpdate flags
    const legalRepresentative = LegalRepresentativeInfo(
      fullName: VerificationStringField(
        value: 'Jane Doe',
        displayValue: 'Jane Doe',
        requiresUpdate: true,
        adminFeedback: 'Name mismatch with tax document.',
      ),
      position: VerificationStringField(
        value: 'CEO',
        displayValue: 'CEO',
        requiresUpdate: true,
        adminFeedback: 'Position mismatch with tax document.',
      ),
      phoneNumber: VerificationStringField(
        value: '+1 (555) 000-0000',
        displayValue: '+1 (555) 000-0000',
        requiresUpdate: true,
        adminFeedback: 'Phone number mismatch with tax document.',
      ),
      idType: VerificationStringField(
        value: 'ID Card',
        displayValue: 'ID Card',
        requiresUpdate: true,
        adminFeedback: 'ID type mismatch with tax document.',
      ),
      idNumber: VerificationStringField(
        value: 'A12345678',
        displayValue: 'A12345678',
        requiresUpdate: true,
        adminFeedback: 'ID number mismatch with tax document.',
      ),
      idIssueDate: VerificationStringField(
        value: '2020-01-15',
        displayValue: '2020-01-15',
        requiresUpdate: true,
        adminFeedback: 'ID issue date mismatch with tax document.',
      ),
      idFrontImage: VerificationDocument(
        id: 'id_front',
        label: 'Front Side ID',
        status: DocumentStatus.revisionRequired,
        requiresUpdate: true,
        adminFeedback: 'Front ID photo is too dark and blurry.',
      ),
      idBackImage: VerificationDocument(
        id: 'id_back',
        label: 'Back Side ID',
        fileUrl: 'https://example.com/id_back_v1.jpg',
        fileName: 'id_back_v1.jpg',
        status: DocumentStatus.approved,
        requiresUpdate: false,
      ),
      documents: DocumentVerificationInfo(
        businessLicense: VerificationDocument(
          id: 'business_license',
          label: 'Business License',
          fileUrl: 'https://example.com/business_license.pdf',
          fileName: 'business_license.pdf',
          status: DocumentStatus.approved,
          requiresUpdate: false,
        ),
        authorizationLetter: VerificationDocument(
          id: 'auth_letter',
          label: 'Authorization Letter',
          fileUrl: 'https://example.com/auth_letter.pdf',
          fileName: 'authorization_letter.pdf',
          status: DocumentStatus.approved,
          requiresUpdate: false,
        ),
        taxCertificate: VerificationDocument(
          id: 'tax_certificate',
          label: 'Tax Certificate',
          fileUrl: 'https://example.com/tax_certificate.pdf',
          fileName: 'tax_certificate.pdf',
          status: DocumentStatus.approved,
          requiresUpdate: false,
        ),
      ),
    );

    // Determine section statuses based on requiresUpdate values
    final businessEntityStatus = _hasBusinessEntityUpdates(partnerInfo)
        ? SectionStatus.revisionRequired
        : SectionStatus.completed;

    final locationDetailsStatus = _hasLocationDetailsUpdates(locationDetails)
        ? SectionStatus.revisionRequired
        : SectionStatus.completed;

    final legalRepresentativeStatus =
        _hasLegalRepresentativeUpdates(legalRepresentative)
        ? SectionStatus.revisionRequired
        : SectionStatus.completed;

    return ProviderVerificationStatusEntity(
      applicationId: '#SP-8821',
      status: VerificationRevisionStatus.revisionRequested,
      adminFeedback: 'Action Required: Revision Requested',
      adminFeedbackDetail:
          'Our verification team has reviewed your application. '
          'The front side of your Government ID is blurred and illegible. '
          'Please re-upload a clear, high-resolution photo of your ID card.',
      lastUpdated: DateTime.now(),
      sections: [
        VerificationSectionEntity(
          type: VerificationSectionType.businessEntity,
          label: 'Business Entity',
          status: businessEntityStatus,
          isLocked: false,
          stepNumber: 1,
        ),
        VerificationSectionEntity(
          type: VerificationSectionType.locationDetails,
          label: 'Location Details',
          status: locationDetailsStatus,
          isLocked: false,
          stepNumber: 2,
        ),
        VerificationSectionEntity(
          type: VerificationSectionType.legalRepresentative,
          label: 'Legal Representative',
          status: legalRepresentativeStatus,
          isLocked: false,
          stepNumber: 3,
        ),
        const VerificationSectionEntity(
          type: VerificationSectionType.accountSecurity,
          label: 'Documents',
          status: SectionStatus.completed,
          isLocked: false,
          stepNumber: 4,
        ),
      ],
      partnerInfo: partnerInfo,
      locationDetails: locationDetails,
      legalRepresentative: legalRepresentative,
    );
  }

  /// Checks if any business entity fields require update.
  bool _hasBusinessEntityUpdates(PartnerInfo partnerInfo) {
    return partnerInfo.taxCode.requiresUpdate ||
        partnerInfo.legalName.requiresUpdate ||
        partnerInfo.brandName.requiresUpdate ||
        partnerInfo.businessType.requiresUpdate ||
        (partnerInfo.phoneNumber?.requiresUpdate ?? false);
  }

  /// Checks if any location details fields require update.
  bool _hasLocationDetailsUpdates(LocationDetailsInfo locationDetails) {
    return locationDetails.provinceId.requiresUpdate ||
        locationDetails.districtId.requiresUpdate ||
        locationDetails.wardId.requiresUpdate ||
        locationDetails.streetAddress.requiresUpdate;
  }

  /// Checks if any legal representative fields require update.
  bool _hasLegalRepresentativeUpdates(LegalRepresentativeInfo legalRep) {
    return legalRep.fullName.requiresUpdate ||
        (legalRep.position?.requiresUpdate ?? false) ||
        (legalRep.phoneNumber?.requiresUpdate ?? false) ||
        legalRep.idType.requiresUpdate ||
        legalRep.idNumber.requiresUpdate ||
        legalRep.idIssueDate.requiresUpdate ||
        legalRep.idFrontImage.requiresUpdate ||
        legalRep.idBackImage.requiresUpdate;
  }

  @override
  Future<bool> resubmitApplication() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<VerificationDocument> uploadDocument({
    required String documentId,
    required String filePath,
  }) async {
    // Simulate upload delay
    await Future<void>.delayed(const Duration(seconds: 2));

    return VerificationDocument(
      id: documentId,
      label: documentId == 'id_front' ? 'Front Side ID' : 'Document',
      fileUrl: 'https://example.com/uploaded/$documentId.jpg',
      fileName: filePath.split('/').last,
      status: DocumentStatus.pendingReview,
      requiresUpdate: false,
    );
  }
}

/// Real implementation of [VerificationStatusRemoteDataSource].
///
/// Fetches partner profile from the API and maps to domain entities.
class VerificationStatusRemoteDataSourceImpl
    implements VerificationStatusRemoteDataSource {
  /// Creates a new [VerificationStatusRemoteDataSourceImpl].
  VerificationStatusRemoteDataSourceImpl({required this.apiService});

  /// The API service instance.
  final ApiService apiService;

  @override
  Future<ProviderVerificationStatusEntity> getVerificationStatus() async {
    final profile = await apiService.partnersApi
        .partnersControllerGetMyProfile();
    if (profile == null) {
      throw Exception('Failed to fetch partner profile');
    }
    return _mapToEntity(profile);
  }

  @override
  Future<bool> resubmitApplication() async {
    // TODO: Implement actual resubmit API call when available
    throw UnimplementedError('Resubmit API not yet implemented');
  }

  @override
  Future<VerificationDocument> uploadDocument({
    required String documentId,
    required String filePath,
  }) async {
    // TODO: Implement actual upload API call when available
    throw UnimplementedError('Upload document API not yet implemented');
  }

  /// Maps [MyProfileResponseDto] to [ProviderVerificationStatusEntity].
  ProviderVerificationStatusEntity _mapToEntity(MyProfileResponseDto dto) {
    final partnerInfo = _mapPartnerInfo(dto.partnerInfo);
    final locationDetails = _mapLocationDetails(dto.locationDetails);
    final legalRepresentative = _mapLegalRepresentative(
      dto.legalRepresentative,
    );

    return ProviderVerificationStatusEntity(
      applicationId: '#${dto.id.substring(0, 8).toUpperCase()}',
      status: _mapVerificationStatus(dto.verificationStatus),
      sections: _buildSections(
        partnerInfo: partnerInfo,
        locationDetails: locationDetails,
        legalRepresentative: legalRepresentative,
        verificationStatus: dto.verificationStatus,
      ),
      partnerInfo: partnerInfo,
      locationDetails: locationDetails,
      legalRepresentative: legalRepresentative,
      adminFeedback: _extractAdminFeedback(dto.verificationStatus),
      adminFeedbackDetail: _extractAdminFeedbackDetail(
        dto.legalRepresentative.documents,
      ),
      lastUpdated: dto.createdAt,
    );
  }

  /// Maps API verification status enum to domain enum.
  VerificationRevisionStatus _mapVerificationStatus(
    MyProfileResponseDtoVerificationStatusEnum status,
  ) {
    switch (status) {
      case MyProfileResponseDtoVerificationStatusEnum.PENDING:
        return VerificationRevisionStatus.pending;
      case MyProfileResponseDtoVerificationStatusEnum.APPROVED:
        return VerificationRevisionStatus.approved;
      case MyProfileResponseDtoVerificationStatusEnum.REJECTED:
        return VerificationRevisionStatus.rejected;
      case MyProfileResponseDtoVerificationStatusEnum.REQUIRED_RESUBMIT:
        return VerificationRevisionStatus.revisionRequested;
    }
    return VerificationRevisionStatus.pending;
  }

  /// Builds verification sections based on the profile data.
  List<VerificationSectionEntity> _buildSections({
    required PartnerInfo partnerInfo,
    required LocationDetailsInfo locationDetails,
    required LegalRepresentativeInfo legalRepresentative,
    required MyProfileResponseDtoVerificationStatusEnum verificationStatus,
  }) {
    return [
      VerificationSectionEntity(
        type: VerificationSectionType.businessEntity,
        label: 'Business Entity',
        status: _determineSectionStatus(
          hasUpdates: _hasPartnerInfoUpdates(partnerInfo),
          verificationStatus: verificationStatus,
        ),
        isLocked: false,
        stepNumber: 1,
      ),
      VerificationSectionEntity(
        type: VerificationSectionType.locationDetails,
        label: 'Location Details',
        status: _determineSectionStatus(
          hasUpdates: _hasLocationDetailsUpdates(locationDetails),
          verificationStatus: verificationStatus,
        ),
        isLocked: false,
        stepNumber: 2,
      ),
      VerificationSectionEntity(
        type: VerificationSectionType.legalRepresentative,
        label: 'Legal Representative',
        status: _determineSectionStatus(
          hasUpdates: _hasLegalRepresentativeUpdates(legalRepresentative),
          verificationStatus: verificationStatus,
        ),
        isLocked: false,
        stepNumber: 3,
      ),
      const VerificationSectionEntity(
        type: VerificationSectionType.accountSecurity,
        label: 'Documents',
        status: SectionStatus.completed,
        isLocked: false,
        stepNumber: 4,
      ),
    ];
  }

  /// Determines section status based on updates and verification status.
  SectionStatus _determineSectionStatus({
    required bool hasUpdates,
    required MyProfileResponseDtoVerificationStatusEnum verificationStatus,
  }) {
    if (hasUpdates) {
      return SectionStatus.revisionRequired;
    }

    switch (verificationStatus) {
      case MyProfileResponseDtoVerificationStatusEnum.APPROVED:
        return SectionStatus.completed;
      case MyProfileResponseDtoVerificationStatusEnum.PENDING:
        return SectionStatus.inProgress;
      case MyProfileResponseDtoVerificationStatusEnum.REJECTED:
      case MyProfileResponseDtoVerificationStatusEnum.REQUIRED_RESUBMIT:
        return SectionStatus.revisionRequired;
    }
    return SectionStatus.completed;
  }

  /// Checks if any partner info fields require update.
  bool _hasPartnerInfoUpdates(PartnerInfo info) {
    return info.taxCode.requiresUpdate ||
        info.legalName.requiresUpdate ||
        info.brandName.requiresUpdate ||
        info.businessType.requiresUpdate ||
        (info.phoneNumber?.requiresUpdate ?? false);
  }

  /// Checks if any location details fields require update.
  bool _hasLocationDetailsUpdates(LocationDetailsInfo info) {
    return info.provinceId.requiresUpdate ||
        info.districtId.requiresUpdate ||
        info.wardId.requiresUpdate ||
        info.streetAddress.requiresUpdate;
  }

  /// Checks if any legal representative fields require update.
  bool _hasLegalRepresentativeUpdates(LegalRepresentativeInfo info) {
    return info.fullName.requiresUpdate ||
        (info.position?.requiresUpdate ?? false) ||
        (info.phoneNumber?.requiresUpdate ?? false) ||
        info.idType.requiresUpdate ||
        info.idNumber.requiresUpdate ||
        info.idIssueDate.requiresUpdate ||
        info.idFrontImage.requiresUpdate ||
        info.idBackImage.requiresUpdate;
  }

  /// Maps partner (business entity) information from DTO.
  PartnerInfo _mapPartnerInfo(PartnerInfoDto dto) {
    return PartnerInfo(
      taxCode: _mapStringField(dto.taxCode),
      legalName: _mapStringField(dto.legalName),
      brandName: _mapStringField(dto.brandName),
      businessType: _mapStringField(dto.businessType),
      phoneNumber: _mapOptionalStringField(dto.phoneNumber),
    );
  }

  /// Maps location details information from DTO.
  LocationDetailsInfo _mapLocationDetails(LocationDetailsInfoDto dto) {
    return LocationDetailsInfo(
      provinceId: _mapStringField(dto.provinceId),
      districtId: _mapStringField(dto.districtId),
      wardId: _mapStringField(dto.wardId),
      streetAddress: _mapStringField(dto.streetAddress),
    );
  }

  /// Maps legal representative info from DTO.
  LegalRepresentativeInfo _mapLegalRepresentative(
    LegalRepresentativeInfoDto dto,
  ) {
    return LegalRepresentativeInfo(
      fullName: _mapStringField(dto.fullName),
      position: _mapStringField(dto.position),
      phoneNumber: _mapOptionalToStringField(dto.phoneNumber),
      idType: _mapStringField(dto.idType),
      idNumber: _mapStringField(dto.idNumber),
      idIssueDate: _mapStringField(dto.idIssueDate),
      idFrontImage: _mapDocumentDto(dto.idFrontImage),
      idBackImage: _mapDocumentDto(dto.idBackImage),
      documents: _mapDocumentVerification(dto.documents),
    );
  }

  /// Maps a verification string field DTO to domain entity.
  VerificationStringField _mapStringField(VerificationStringFieldDto dto) {
    return VerificationStringField(
      value: dto.value,
      displayValue: dto.displayValue,
      requiresUpdate: dto.requiresUpdate,
      adminFeedback: dto.adminFeedback?.toString(),
    );
  }

  /// Maps an optional verification string field DTO to domain entity.
  VerificationOptionalStringField? _mapOptionalStringField(
    VerificationOptionalStringFieldDto dto,
  ) {
    return VerificationOptionalStringField(
      value: dto.value?.toString(),
      displayValue: dto.displayValue?.toString() ?? '',
      requiresUpdate: dto.requiresUpdate,
      adminFeedback: dto.adminFeedback?.toString(),
    );
  }

  /// Maps an optional verification string field DTO to VerificationStringField.
  /// Used when the domain entity expects VerificationStringField? but the DTO
  /// provides VerificationOptionalStringFieldDto.
  VerificationStringField? _mapOptionalToStringField(
    VerificationOptionalStringFieldDto dto,
  ) {
    final value = dto.value?.toString();
    if (value == null || value.isEmpty) {
      return null;
    }
    return VerificationStringField(
      value: value,
      displayValue: dto.displayValue?.toString() ?? '',
      requiresUpdate: dto.requiresUpdate,
      adminFeedback: dto.adminFeedback?.toString(),
    );
  }

  /// Maps a verification document DTO to domain entity.
  VerificationDocument _mapDocumentDto(VerificationDocumentDto dto) {
    return VerificationDocument(
      id: dto.id,
      label: dto.label,
      fileUrl: dto.fileUrl?.toString(),
      fileName: dto.fileName?.toString(),
      status: _mapDocumentDtoStatus(dto.status),
      requiresUpdate: dto.requiresUpdate,
      adminFeedback: dto.adminFeedback?.toString(),
    );
  }

  /// Maps document verification info from DTO.
  DocumentVerificationInfo _mapDocumentVerification(
    DocumentVerificationInfoDto dto,
  ) {
    return DocumentVerificationInfo(
      businessLicense: dto.businessLicense != null
          ? _mapDocumentDto(dto.businessLicense!)
          : null,
      authorizationLetter: dto.authorizationLetter != null
          ? _mapDocumentDto(dto.authorizationLetter!)
          : null,
      taxCertificate: dto.taxCertificate != null
          ? _mapDocumentDto(dto.taxCertificate!)
          : null,
    );
  }

  /// Maps document status from DTO enum.
  DocumentStatus _mapDocumentDtoStatus(
    VerificationDocumentDtoStatusEnum status,
  ) {
    switch (status) {
      case VerificationDocumentDtoStatusEnum.missing:
        return DocumentStatus.notUploaded;
      case VerificationDocumentDtoStatusEnum.pending:
        return DocumentStatus.pendingReview;
      case VerificationDocumentDtoStatusEnum.approved:
        return DocumentStatus.approved;
      case VerificationDocumentDtoStatusEnum.rejected:
      case VerificationDocumentDtoStatusEnum.revisionRequired:
        return DocumentStatus.revisionRequired;
    }
    return DocumentStatus.notUploaded;
  }

  /// Extracts admin feedback title from verification status.
  String? _extractAdminFeedback(
    MyProfileResponseDtoVerificationStatusEnum status,
  ) {
    switch (status) {
      case MyProfileResponseDtoVerificationStatusEnum.REQUIRED_RESUBMIT:
        return 'Action Required: Revision Requested';
      case MyProfileResponseDtoVerificationStatusEnum.REJECTED:
        return 'Application Rejected';
      default:
        return null;
    }
  }

  /// Extracts detailed admin feedback from documents.
  String? _extractAdminFeedbackDetail(DocumentVerificationInfoDto documents) {
    final feedbacks = <String>[];

    if (documents.businessLicense?.adminFeedback != null) {
      feedbacks.add(documents.businessLicense!.adminFeedback.toString());
    }
    if (documents.authorizationLetter?.adminFeedback != null) {
      feedbacks.add(documents.authorizationLetter!.adminFeedback.toString());
    }
    if (documents.taxCertificate?.adminFeedback != null) {
      feedbacks.add(documents.taxCertificate!.adminFeedback.toString());
    }

    return feedbacks.isNotEmpty ? feedbacks.join(' ') : null;
  }
}
