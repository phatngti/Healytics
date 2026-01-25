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

    return ProviderVerificationStatusEntity(
      applicationId: '#SP-8821',
      status: VerificationRevisionStatus.revisionRequested,
      adminFeedback: 'Action Required: Revision Requested',
      adminFeedbackDetail:
          'Our verification team has reviewed your application. '
          'The front side of your Government ID is blurred and illegible. '
          'Please re-upload a clear, high-resolution photo of your ID card.',
      lastUpdated: DateTime.now(),
      sections: const [
        VerificationSectionEntity(
          type: VerificationSectionType.businessEntity,
          label: 'Business Entity',
          status: SectionStatus.completed,
          isLocked: false,
          stepNumber: 1,
        ),
        VerificationSectionEntity(
          type: VerificationSectionType.locationDetails,
          label: 'Location Details',
          status: SectionStatus.completed,
          isLocked: false,
          stepNumber: 2,
        ),
        VerificationSectionEntity(
          type: VerificationSectionType.legalRepresentative,
          label: 'Legal Representative',
          status: SectionStatus.revisionRequired,
          isLocked: false,
          stepNumber: 3,
        ),
        VerificationSectionEntity(
          type: VerificationSectionType.accountSecurity,
          label: 'Account Security',
          status: SectionStatus.completed,
          isLocked: false,
          stepNumber: 4,
        ),
      ],
      businessEntity: const BusinessEntityInfo(
        companyName: VerificationStringField(
          value: 'Serenity Spa & Wellness LLC',
          requiresUpdate: true,
          adminFeedback: 'Name mismatch with tax document.',
        ),
        taxRegistrationCode: VerificationStringField(
          value: 'XX-1234567-Y',
          requiresUpdate: true,
          adminFeedback: 'Tax registration code mismatch with tax document.',
        ),
        businessEmail: VerificationStringField(
          value: 'partners@serenityspa.com',
          requiresUpdate: true,
          adminFeedback: 'Email mismatch with tax document.',
        ),
        businessPhone: VerificationStringField(
          value: '+1 (555) 000-0000',
          requiresUpdate: true,
          adminFeedback: 'Phone number mismatch with tax document.',
        ),
        serviceCategories: VerificationStringListField(
          value: ['Massage Therapy', 'Sauna', 'Facials', 'Aromatherapy'],
          requiresUpdate: true,
          adminFeedback: 'Service categories mismatch with tax document.',
        ),
      ),
      locationDetails: const LocationDetailsInfo(
        country: VerificationOptionalStringField(value: 'United States'),
        city: VerificationOptionalStringField(value: 'New York'),
        districtArea: VerificationOptionalStringField(value: 'Manhattan'),
        detailedAddress: VerificationStringField(
          value: '123 Harmony Lane, Suite 400',
          requiresUpdate: true,
          adminFeedback: 'Please provide unit number if applicable.',
        ),
      ),
      legalRepresentative: const LegalRepresentativeEntity(
        fullName: 'Jane Doe',
        govIdNumber: 'A12345678',
        idFront: VerificationDocument(
          id: 'id_front',
          label: 'Front Side ID',
          status: DocumentStatus.revisionRequired,
          requiresUpdate: true,
          adminFeedback: 'Front ID photo is too dark and blurry.',
        ),
        idBack: VerificationDocument(
          id: 'id_back',
          label: 'Back Side ID',
          fileUrl: 'https://example.com/id_back_v1.jpg',
          fileName: 'id_back_v1.jpg',
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
      ),
    );
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
/// TODO: Implement actual API calls when backend is ready.
class VerificationStatusRemoteDataSourceImpl
    implements VerificationStatusRemoteDataSource {
  @override
  Future<ProviderVerificationStatusEntity> getVerificationStatus() {
    // TODO: Implement actual API call
    throw UnimplementedError('API not yet implemented');
  }

  @override
  Future<bool> resubmitApplication() {
    // TODO: Implement actual API call
    throw UnimplementedError('API not yet implemented');
  }

  @override
  Future<VerificationDocument> uploadDocument({
    required String documentId,
    required String filePath,
  }) {
    // TODO: Implement actual API call
    throw UnimplementedError('API not yet implemented');
  }
}
