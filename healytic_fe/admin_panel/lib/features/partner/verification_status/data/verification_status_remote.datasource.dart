import 'package:admin_openapi/api.dart' as api;
import 'package:admin_panel/constants/field_keys.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/verification_status/domain/field_category.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/document_verification_section.widget.dart';

/// Abstract interface for verification status data source.
abstract class VerificationStatusRemoteDataSource {
  /// Fetches the verification status from the remote API.
  Future<ProviderVerificationStatusEntity> getVerificationStatus();

  /// Resubmits the application to the remote API.
  ///
  /// [uploads] contains the list of re-uploaded documents to submit.
  /// [edits] contains a map of field keys to their new string values.
  Future<bool> resubmitApplication({
    List<DocumentUploadResult> uploads = const [],
    Map<String, dynamic> edits = const {},
  });
}

/// Mock implementation of [VerificationStatusRemoteDataSource].
///
/// Returns sample data matching the design for development and testing.
class VerificationStatusRemoteDataSourceMock
    implements VerificationStatusRemoteDataSource {
  @override
  Future<ProviderVerificationStatusEntity> getVerificationStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    const businessInfo = BusinessInfo(
      brandName: VerifiedField(
        fieldKey: 'brand_name',
        value: 'Serenity Spa',
        isVerified: true,
      ),
      taxRegistrationCode: VerifiedField(
        fieldKey: 'tax_registration_code',
        value: 'XX-1234567-Y',
        isVerified: false,
        feedback: 'Tax code mismatch with tax document.',
      ),
      serviceTags: VerifiedField(
        fieldKey: 'service_tags',
        value: ['Spa', 'Wellness', 'Massage'],
        isVerified: true,
      ),
      address: AddressInfo(
        streetAddress: VerifiedField(
          fieldKey: 'street_address',
          value: '123 Harmony Lane, Suite 400',
          isVerified: false,
          feedback: 'Please provide unit number if applicable.',
        ),
        ward: VerifiedField(
          fieldKey: 'ward',
          value: {
            'id': '35a05597-60d5-4e7c-aa16-8d4952386d3c',
            'name': 'Phường Thanh Trì',
          },
          isVerified: false,
          feedback: 'Ward mismatch with tax document.',
        ),
        district: VerifiedField(
          fieldKey: 'district',
          value: {
            'id': 'd7f692d1-e766-4c29-b855-894467308850',
            'name': 'Quận Ba Đình',
          },
          isVerified: false,
          feedback: 'District mismatch with tax document.',
        ),
        city: VerifiedField(
          fieldKey: 'city',
          value: {
            'id': '05a7608b-0978-42d1-b6b0-9f21198e6dfa',
            'name': 'Thành phố Hà Nội',
          },
          isVerified: false,
          feedback: 'Province mismatch with tax document.',
        ),
        country: 'Vietnam',
      ),
      phoneNumber: VerifiedField(
        fieldKey: 'phone_number',
        value: '+1 (555) 000-0000',
        isVerified: false,
        feedback: 'Phone number mismatch with tax document.',
      ),
    );

    const legalRepresentative = LegalRepresentativeInfo(
      fullName: VerifiedField(
        fieldKey: 'full_name',
        value: 'Jane Doe',
        isVerified: false,
        feedback: 'Name mismatch with ID document.',
      ),
      position: VerifiedField(
        fieldKey: 'position',
        value: 'CEO',
        isVerified: false,
        feedback: 'Position mismatch with tax document.',
      ),
      phoneNumber: VerifiedField(
        fieldKey: 'legal_rep_phone_number',
        value: '+1 (555) 000-0000',
        isVerified: false,
        feedback: 'Phone number mismatch with tax document.',
      ),
      idType: VerifiedField(
        fieldKey: 'id_type',
        value: 'ID Card',
        isVerified: false,
        feedback: 'ID type mismatch with document.',
      ),
      idNumber: VerifiedField(
        fieldKey: 'id_number',
        value: 'A12345678',
        isVerified: false,
        feedback: 'ID number mismatch with document.',
      ),
      idIssueDate: VerifiedField(
        fieldKey: 'id_issue_date',
        value: '2020-01-15',
        isVerified: false,
        feedback: 'ID issue date mismatch with document.',
      ),
    );

    const kycDocuments = <VerifiedField>[
      VerifiedField(
        fieldKey: 'id_front_image',
        value: '',
        isVerified: false,
        feedback: 'Front ID photo is too dark and blurry.',
      ),
      VerifiedField(
        fieldKey: 'id_back_image',
        value: 'https://example.com/id_back_v1.jpg',
        isVerified: true,
      ),
      VerifiedField(
        fieldKey: 'business_license',
        value: 'https://example.com/business_license.pdf',
        isVerified: true,
      ),
      VerifiedField(
        fieldKey: 'authorization_letter',
        value: 'https://example.com/auth_letter.pdf',
        isVerified: true,
      ),
      VerifiedField(
        fieldKey: 'tax_certificate',
        value: 'https://example.com/tax_certificate.pdf',
        isVerified: true,
      ),
    ];

    final businessEntityStatus = _hasBusinessInfoUpdates(businessInfo)
        ? SectionStatus.revisionRequired
        : SectionStatus.completed;

    final locationDetailsStatus =
        businessInfo.address != null &&
            _hasAddressUpdates(businessInfo.address!)
        ? SectionStatus.revisionRequired
        : SectionStatus.completed;

    final legalRepresentativeStatus =
        _hasLegalRepresentativeUpdates(legalRepresentative)
        ? SectionStatus.revisionRequired
        : SectionStatus.completed;

    return ProviderVerificationStatusEntity(
      id: 'mock-partner-id-12345678',
      businessInfo: businessInfo,
      legalRepresentative: legalRepresentative,
      kycDocuments: kycDocuments,
      verificationStatus: VerificationRevisionStatus.requiredResubmit,
      createdAt: DateTime.now(),
      sections: [
        VerificationSectionEntity(
          type: VerificationSectionType.businessEntity,
          label: 'Business Entity',
          status: businessEntityStatus,
          stepNumber: 1,
        ),
        VerificationSectionEntity(
          type: VerificationSectionType.locationDetails,
          label: 'Location Details',
          status: locationDetailsStatus,
          stepNumber: 2,
        ),
        VerificationSectionEntity(
          type: VerificationSectionType.legalRepresentative,
          label: 'Legal Representative',
          status: legalRepresentativeStatus,
          stepNumber: 3,
        ),
        const VerificationSectionEntity(
          type: VerificationSectionType.accountSecurity,
          label: 'Documents',
          status: SectionStatus.completed,
          stepNumber: 4,
        ),
      ],
    );
  }

  bool _hasBusinessInfoUpdates(BusinessInfo info) {
    return !info.brandName.isVerified ||
        !(info.taxRegistrationCode?.isVerified ?? true) ||
        !info.serviceTags.isVerified ||
        !(info.phoneNumber?.isVerified ?? true);
  }

  bool _hasAddressUpdates(AddressInfo address) {
    return !address.streetAddress.isVerified ||
        !(address.ward?.isVerified ?? true) ||
        !(address.district?.isVerified ?? true) ||
        !(address.city?.isVerified ?? true);
  }

  bool _hasLegalRepresentativeUpdates(LegalRepresentativeInfo legalRep) {
    return !legalRep.fullName.isVerified ||
        !(legalRep.position?.isVerified ?? true) ||
        !(legalRep.phoneNumber?.isVerified ?? true) ||
        !(legalRep.idType?.isVerified ?? true) ||
        !(legalRep.idNumber?.isVerified ?? true) ||
        !(legalRep.idIssueDate?.isVerified ?? true);
  }

  @override
  Future<bool> resubmitApplication({
    List<DocumentUploadResult> uploads = const [],
    Map<String, dynamic> edits = const {},
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return true;
  }
}

/// Real implementation of [VerificationStatusRemoteDataSource].
class VerificationStatusRemoteDataSourceImpl
    implements VerificationStatusRemoteDataSource {
  VerificationStatusRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<ProviderVerificationStatusEntity> getVerificationStatus() async {
    final profile = await apiService.partnerPartnersApi
        .partnerSelfControllerGetMyProfile();
    if (profile == null) {
      throw Exception('Failed to fetch partner profile');
    }

    return _mapToEntity(profile);
  }

  @override
  Future<bool> resubmitApplication({
    List<DocumentUploadResult> uploads = const [],
    Map<String, dynamic> edits = const {},
  }) async {
    // Build the UpdatePartnerDto from edits and uploads
    final updateDto = _buildUpdateDto(edits: edits, uploads: uploads);

    // Call the PUT /partners/me API
    await apiService.partnerPartnersApi.partnerSelfControllerUpdateMyProfile(
      updateDto,
    );

    return true;
  }

  /// Builds [api.UpdatePartnerDto] from form edits and document uploads.
  ///
  /// Uses [FieldCategoryLookup] to categorize field keys and build
  /// appropriate DTO sections.
  api.UpdatePartnerDto _buildUpdateDto({
    required Map<String, dynamic> edits,
    required List<DocumentUploadResult> uploads,
  }) {
    // Build address DTO if any address field is edited
    api.AddressDto? addressDto;
    final stringEdits = edits.map(
      (key, value) => MapEntry(key, value is String ? value : value.toString()),
    );
    final hasAddressEdits = FieldCategoryLookup.hasEditsInCategory(
      stringEdits,
      FieldCategory.address,
    );
    if (hasAddressEdits) {
      final addressEdits = FieldCategoryLookup.editsForCategory(
        stringEdits,
        FieldCategory.address,
      );
      addressDto = api.AddressDto(
        streetAddress: addressEdits[FieldKeys.streetAddress],
        ward: addressEdits[FieldKeys.ward],
        district: addressEdits[FieldKeys.district],
        city: addressEdits[FieldKeys.city],
      );
    }

    // Build business info DTO if any business field is edited
    api.BusinessInfo? businessInfo;
    final hasBusinessEdits = FieldCategoryLookup.hasEditsInCategory(
      stringEdits,
      FieldCategory.businessInfo,
    );
    if (hasBusinessEdits || hasAddressEdits) {
      final businessEdits = FieldCategoryLookup.editsForCategory(
        stringEdits,
        FieldCategory.businessInfo,
      );
      // Handle businessType as List<String>
      final businessTypeValue = edits[FieldKeys.businessType];
      List<String>? businessTypes;
      if (businessTypeValue is List) {
        businessTypes = businessTypeValue.cast<String>();
      }

      businessInfo = api.BusinessInfo(
        brandName: businessEdits[FieldKeys.brandName],
        taxRegistrationCode: businessEdits[FieldKeys.taxCode],
        phoneNumber: businessEdits[FieldKeys.phoneNumber],
        serviceTags: businessTypes,
        address: addressDto,
      );
    }

    // Build legal representative DTO if any legal rep field is edited
    api.LegalRepresentativeDto? legalRepDto;
    final hasLegalRepEdits = FieldCategoryLookup.hasEditsInCategory(
      stringEdits,
      FieldCategory.legalRepresentative,
    );
    if (hasLegalRepEdits) {
      final legalEdits = FieldCategoryLookup.editsForCategory(
        stringEdits,
        FieldCategory.legalRepresentative,
      );
      legalRepDto = api.LegalRepresentativeDto(
        fullName: api.VerifiedField(
          fieldKey: FieldKeys.fullName,
          value: legalEdits[FieldKeys.fullName] ?? '',
          isVerified: false,
        ),
        position: legalEdits[FieldKeys.position] != null
            ? api.VerifiedField(
                fieldKey: FieldKeys.position,
                value: legalEdits[FieldKeys.position]!,
                isVerified: false,
              )
            : null,
        idType: legalEdits[FieldKeys.idType] != null
            ? api.VerifiedField(
                fieldKey: FieldKeys.idType,
                value: legalEdits[FieldKeys.idType]!,
                isVerified: false,
              )
            : null,
        idNumber: legalEdits[FieldKeys.idNumber] != null
            ? api.VerifiedField(
                fieldKey: FieldKeys.idNumber,
                value: legalEdits[FieldKeys.idNumber]!,
                isVerified: false,
              )
            : null,
        idIssueDate: legalEdits[FieldKeys.idIssueDate] != null
            ? api.VerifiedField(
                fieldKey: FieldKeys.idIssueDate,
                value: legalEdits[FieldKeys.idIssueDate]!,
                isVerified: false,
              )
            : null,
      );
    }

    // Build KYC documents from uploads
    final kycDocuments = uploads.map((upload) {
      return api.KycDocumentDto(
        fileUrl: upload.url,
        fileType: upload.documentKey,
      );
    }).toList();

    return api.UpdatePartnerDto(
      bussinessInfo: businessInfo,
      legalRepresentative: legalRepDto,
      kycDocuments: kycDocuments,
    );
  }

  ProviderVerificationStatusEntity _mapToEntity(api.MyProfileResponseDto dto) {
    final businessInfo = _mapBusinessInfo(dto.businessInfo);
    final legalRepresentative = _mapLegalRepresentative(
      dto.legalRepresentative,
    );
    final kycDocuments = _mapKycDocuments(dto.kycDocuments);

    return ProviderVerificationStatusEntity(
      id: dto.id,
      businessInfo: businessInfo,
      legalRepresentative: legalRepresentative,
      kycDocuments: kycDocuments,
      verificationStatus: _mapVerificationStatus(dto.verificationStatus),
      createdAt: dto.createdAt,
      sections: _buildSections(
        businessInfo: businessInfo,
        legalRepresentative: legalRepresentative,
        kycDocuments: kycDocuments,
        verificationStatus: dto.verificationStatus,
      ),
    );
  }

  VerificationRevisionStatus _mapVerificationStatus(
    api.PartnerVerificationStatus status,
  ) {
    if (status == api.PartnerVerificationStatus.ONBOARDING) {
      return VerificationRevisionStatus.onboarding;
    } else if (status == api.PartnerVerificationStatus.PENDING) {
      return VerificationRevisionStatus.pending;
    } else if (status == api.PartnerVerificationStatus.APPROVED) {
      return VerificationRevisionStatus.approved;
    } else if (status == api.PartnerVerificationStatus.REJECTED) {
      return VerificationRevisionStatus.rejected;
    } else if (status ==
        api.PartnerVerificationStatus.REQUIRED_RESUBMIT) {
      return VerificationRevisionStatus.requiredResubmit;
    }
    return VerificationRevisionStatus.onboarding;
  }

  BusinessInfo _mapBusinessInfo(api.BusinessInfoDto dto) {
    return BusinessInfo(
      brandName: _mapVerifiedFieldDto(dto.brandName, 'brand_name'),
      taxRegistrationCode: dto.taxRegistrationCode != null
          ? _mapVerifiedFieldDto(
              dto.taxRegistrationCode!,
              'tax_registration_code',
            )
          : null,
      serviceTags: _mapVerifiedFieldDto(dto.businessType, 'business_type'),
      address: _mapAddressInfo(dto.address),
      email: dto.email != null
          ? _mapVerifiedFieldDto(dto.email!, 'email')
          : null,
      phoneNumber: dto.phoneNumber != null
          ? _mapVerifiedFieldDto(dto.phoneNumber!, 'phone_number')
          : null,
    );
  }

  AddressInfo? _mapAddressInfo(api.AddressInfoDto? dto) {
    if (dto == null) return null;
    return AddressInfo(
      streetAddress: _mapVerifiedFieldDto(dto.streetAddress, 'street_address'),
      ward: dto.ward != null ? _mapVerifiedFieldDto(dto.ward!, 'ward') : null,
      district: dto.district != null
          ? _mapVerifiedFieldDto(dto.district!, 'district')
          : null,
      city: dto.city != null ? _mapVerifiedFieldDto(dto.city!, 'city') : null,
      country: dto.country,
      latitude: dto.latitude?.toDouble(),
      longitude: dto.longitude?.toDouble(),
    );
  }

  LegalRepresentativeInfo? _mapLegalRepresentative(
    api.LegalRepresentativeDto? dto,
  ) {
    if (dto == null) return null;
    return LegalRepresentativeInfo(
      fullName: _mapVerifiedFieldDto(dto.fullName, 'full_name'),
      position: dto.position != null
          ? _mapVerifiedFieldDto(dto.position!, 'position')
          : null,
      phoneNumber: dto.phoneNumber != null
          ? _mapVerifiedFieldDto(dto.phoneNumber!, 'legal_rep_phone_number')
          : null,
      idType: dto.idType != null
          ? _mapVerifiedFieldDto(dto.idType!, 'id_type')
          : null,
      idNumber: dto.idNumber != null
          ? _mapVerifiedFieldDto(dto.idNumber!, 'id_number')
          : null,
      idIssueDate: dto.idIssueDate != null
          ? _mapVerifiedFieldDto(dto.idIssueDate!, 'id_issue_date')
          : null,
    );
  }

  VerifiedField _mapVerifiedFieldDto(
    api.VerifiedField field,
    String defaultFieldKey,
  ) {
    // Use defaultFieldKey if fieldKey is empty (shouldn't happen per API contract)
    final resolvedKey = field.fieldKey.isEmpty
        ? defaultFieldKey
        : field.fieldKey;
    return VerifiedField(
      fieldKey: resolvedKey,
      value: field.value,
      isVerified: field.isVerified,
      feedback: field.feedback,
    );
  }

  List<VerifiedField> _mapKycDocuments(List<api.VerifiedField> kycDocuments) {
    return kycDocuments
        .map((doc) => _mapVerifiedFieldDto(doc, doc.fieldKey))
        .toList();
  }

  List<VerificationSectionEntity> _buildSections({
    required BusinessInfo businessInfo,
    required LegalRepresentativeInfo? legalRepresentative,
    required List<VerifiedField> kycDocuments,
    required api.PartnerVerificationStatus verificationStatus,
  }) {
    return [
      VerificationSectionEntity(
        type: VerificationSectionType.businessEntity,
        label: 'Business Entity',
        status: _determineSectionStatus(
          hasUpdates: _hasBusinessInfoUpdates(businessInfo),
          verificationStatus: verificationStatus,
        ),
        stepNumber: 1,
      ),
      VerificationSectionEntity(
        type: VerificationSectionType.locationDetails,
        label: 'Location Details',
        status: _determineSectionStatus(
          hasUpdates: businessInfo.address != null
              ? _hasAddressUpdates(businessInfo.address!)
              : false,
          verificationStatus: verificationStatus,
        ),
        stepNumber: 2,
      ),
      VerificationSectionEntity(
        type: VerificationSectionType.legalRepresentative,
        label: 'Legal Representative',
        status: _determineSectionStatus(
          hasUpdates: legalRepresentative != null
              ? _hasLegalRepresentativeUpdates(legalRepresentative)
              : false,
          verificationStatus: verificationStatus,
        ),
        stepNumber: 3,
      ),
      VerificationSectionEntity(
        type: VerificationSectionType.accountSecurity,
        label: 'Documents',
        status: _determineSectionStatus(
          hasUpdates: _hasKycDocumentUpdates(kycDocuments),
          verificationStatus: verificationStatus,
        ),
        stepNumber: 4,
      ),
    ];
  }

  SectionStatus _determineSectionStatus({
    required bool hasUpdates,
    required api.PartnerVerificationStatus verificationStatus,
  }) {
    if (hasUpdates) return SectionStatus.revisionRequired;

    if (verificationStatus ==
        api.PartnerVerificationStatus.APPROVED) {
      return SectionStatus.completed;
    } else if (verificationStatus ==
            api.PartnerVerificationStatus.ONBOARDING ||
        verificationStatus ==
            api.PartnerVerificationStatus.PENDING) {
      return SectionStatus.inProgress;
    } else if (verificationStatus ==
            api.PartnerVerificationStatus.REJECTED ||
        verificationStatus ==
            api.PartnerVerificationStatus.REQUIRED_RESUBMIT) {
      return SectionStatus.revisionRequired;
    }
    return SectionStatus.completed;
  }

  bool _hasBusinessInfoUpdates(BusinessInfo info) {
    return !info.brandName.isVerified ||
        !(info.taxRegistrationCode?.isVerified ?? true) ||
        !info.serviceTags.isVerified ||
        !(info.phoneNumber?.isVerified ?? true);
  }

  bool _hasAddressUpdates(AddressInfo address) {
    return !address.streetAddress.isVerified ||
        !(address.ward?.isVerified ?? true) ||
        !(address.district?.isVerified ?? true) ||
        !(address.city?.isVerified ?? true);
  }

  bool _hasLegalRepresentativeUpdates(LegalRepresentativeInfo info) {
    return !info.fullName.isVerified ||
        !(info.position?.isVerified ?? true) ||
        !(info.phoneNumber?.isVerified ?? true) ||
        !(info.idType?.isVerified ?? true) ||
        !(info.idNumber?.isVerified ?? true) ||
        !(info.idIssueDate?.isVerified ?? true);
  }

  bool _hasKycDocumentUpdates(List<VerifiedField> documents) {
    return documents.any((doc) => !doc.isVerified);
  }
}
