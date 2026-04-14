import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';

/// Contract for fetching and updating the partner
/// public profile aggregate.
abstract class PublicProfileRemoteDataSource {
  /// Loads the full public profile aggregate.
  Future<PartnerPublicProfileEntity> getPublicProfile();

  /// Persists storefront updates and returns the
  /// refreshed profile aggregate.
  Future<PartnerPublicProfileEntity> updatePublicProfile(
    PublicProfileUpdateRequest request,
  );
}

/// Real implementation backed by generated OpenAPI
/// [PartnerPartnersApi] methods.
class PublicProfileRemoteDataSourceImpl
    implements PublicProfileRemoteDataSource {
  PublicProfileRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<PartnerPublicProfileEntity> getPublicProfile() async {
    final dto = await apiService.partnerPartnersApi
        .partnerSelfControllerGetPublicProfile();

    if (dto == null) {
      throw ApiException(404, 'Public profile data not found');
    }

    return _mapResponseToEntity(dto);
  }

  @override
  Future<PartnerPublicProfileEntity> updatePublicProfile(
    PublicProfileUpdateRequest request,
  ) async {
    final updateDto = _mapRequestToDto(request);

    final dto = await apiService.partnerPartnersApi
        .partnerSelfControllerUpdatePublicProfile(updateDto);

    if (dto == null) {
      throw ApiException(500, 'Update returned no data');
    }

    return _mapResponseToEntity(dto);
  }

  // ── DTO → Entity mapping ─────────────────────

  PartnerPublicProfileEntity _mapResponseToEntity(
    PartnerPublicProfileResponseDto dto,
  ) {
    return PartnerPublicProfileEntity(
      id: dto.id,
      businessInfo: _mapBusinessInfo(dto.businessInfo),
      address: _mapAddress(dto.address),
      legalSummary: dto.readOnlyLegalSummary != null
          ? _mapLegalSummary(dto.readOnlyLegalSummary!)
          : null,
      verificationStatus: dto.verificationStatus.value,
      storefront: _mapStorefront(dto.publicProfile),
      completionSummary: _mapCompletionSummary(dto.completionSummary),
    );
  }

  PublicProfileBusinessInfo _mapBusinessInfo(PublicProfileBusinessInfoDto dto) {
    return PublicProfileBusinessInfo(
      brandName: dto.brandName,
      legalName: dto.legalName,
      taxCode: dto.taxCode,
      businessType: dto.businessType,
      phoneNumber: dto.phoneNumber?.toString(),
      email: dto.email?.toString(),
      username: dto.username?.toString(),
    );
  }

  PublicProfileAddress _mapAddress(PublicProfileAddressDto dto) {
    return PublicProfileAddress(
      streetAddress: dto.streetAddress,
      ward: _parseLocationRef(dto.ward),
      district: _parseLocationRef(dto.district),
      province: _parseLocationRef(dto.province),
      latitude: dto.latitude?.toDouble(),
      longitude: dto.longitude?.toDouble(),
      formattedAddress: dto.formattedAddress?.toString(),
    );
  }

  /// Parses an `Object?` that is expected to be a
  /// `Map` with `id` and `name` keys into a
  /// [LocationRef]. Returns null if the structure
  /// is invalid.
  LocationRef? _parseLocationRef(Object? raw) {
    if (raw == null) return null;
    if (raw is Map) {
      final id = raw['id']?.toString();
      final name = raw['name']?.toString();
      if (id != null && name != null) {
        return LocationRef(id: id, name: name);
      }
    }
    return null;
  }

  PublicProfileLegalSummary _mapLegalSummary(PublicProfileLegalSummaryDto dto) {
    return PublicProfileLegalSummary(
      fullName: dto.fullName,
      position: dto.position,
      idType: dto.idType,
      idNumber: dto.idNumber,
    );
  }

  PublicProfileStorefront _mapStorefront(PublicProfileStorefrontDto dto) {
    return PublicProfileStorefront(
      coverImageUrl: dto.coverImageUrl?.toString(),
      logoImageUrl: dto.logoImageUrl?.toString(),
      description: dto.description?.toString(),
      gallery: dto.gallery,
      certifications: dto.certifications.map(_mapCertification).toList(),
    );
  }

  PublicProfileCertification _mapCertification(
    PublicProfileCertificationDto dto,
  ) {
    return PublicProfileCertification(
      id: dto.id,
      title: dto.title,
      subtitle: dto.subtitle?.toString(),
      iconName: dto.iconName,
      sortOrder: dto.sortOrder.toInt(),
    );
  }

  PublicProfileCompletionSummary _mapCompletionSummary(
    PublicProfileCompletionSummaryDto dto,
  ) {
    return PublicProfileCompletionSummary(
      checklist: dto.checklist.map(_mapChecklistItem).toList(),
      completionPercent: dto.completionPercent.toInt(),
      isCompleted: dto.isCompleted,
    );
  }

  PublicProfileChecklistItem _mapChecklistItem(
    PublicProfileChecklistItemDto dto,
  ) {
    return PublicProfileChecklistItem(
      key: dto.key,
      label: dto.label,
      isRequired: dto.required_,
      completed: dto.completed,
    );
  }

  // ── Entity → Update DTO mapping ──────────────

  UpdatePartnerPublicProfileDto _mapRequestToDto(
    PublicProfileUpdateRequest request,
  ) {
    return UpdatePartnerPublicProfileDto(
      coverImageUrl: request.coverImageUrl,
      logoImageUrl: request.logoImageUrl,
      description: request.description,
      gallery: request.gallery ?? const [],
      certifications: (request.certifications ?? const [])
          .map(_mapCertToDto)
          .toList(),
    );
  }

  UpdatePartnerCertificationDto _mapCertToDto(PublicProfileCertification item) {
    return UpdatePartnerCertificationDto(
      id: item.id,
      title: item.title,
      subtitle: item.subtitle,
      iconName: item.iconName,
      sortOrder: item.sortOrder,
    );
  }
}

/// Mock implementation for development and testing.
class PublicProfileRemoteDataSourceMock
    implements PublicProfileRemoteDataSource {
  PartnerPublicProfileEntity _entity = PartnerPublicProfileEntity(
    id: 'mock-partner-id',
    businessInfo: const PublicProfileBusinessInfo(
      brandName: 'Healytics Wellness Center',
      legalName: 'Healytics Wellness Joint Stock Company',
      taxCode: '0123456789',
      businessType: ['SPA_BEAUTY', 'MASSAGE_THERAPY'],
      phoneNumber: '0901234567',
      email: 'clinic@example.com',
      username: 'healytics_clinic',
    ),
    address: const PublicProfileAddress(
      streetAddress: '123 Nguyen Hue, Ward 1',
      ward: LocationRef(id: 'ward-1', name: 'Phường 1'),
      district: LocationRef(id: 'dist-1', name: 'Quận 1'),
      province: LocationRef(id: 'prov-hcm', name: 'TP. Hồ Chí Minh'),
      latitude: 10.7769,
      longitude: 106.7009,
      formattedAddress:
          '123 Nguyen Hue, Phường 1, '
          'Quận 1, TP. Hồ Chí Minh',
    ),
    legalSummary: const PublicProfileLegalSummary(
      fullName: 'Nguyễn Văn A',
      position: 'Giám đốc',
      idType: 'cccd',
      idNumber: '012345678901',
    ),
    verificationStatus: 'APPROVED',
    storefront: const PublicProfileStorefront(
      coverImageUrl: 'https://cdn.example.com/cover.jpg',
      logoImageUrl: 'https://cdn.example.com/logo.jpg',
      description:
          'A modern wellness clinic focused '
          'on long-term health and recovery. '
          'We specialise in massage therapy, '
          'spa treatments, and holistic '
          'wellness programs designed for '
          'the modern lifestyle.',
      gallery: [
        'https://cdn.example.com/g1.jpg',
        'https://cdn.example.com/g2.jpg',
        'https://cdn.example.com/g3.jpg',
      ],
      certifications: [
        PublicProfileCertification(
          id: 'cert-1',
          title: 'ISO 9001:2015',
          subtitle: 'Quality Management',
          iconName: 'workspace_premium',
          sortOrder: 0,
        ),
      ],
    ),
    completionSummary: const PublicProfileCompletionSummary(
      checklist: [
        PublicProfileChecklistItem(
          key: 'coverImageUrl',
          label: 'Clinic cover image',
          isRequired: true,
          completed: true,
        ),
        PublicProfileChecklistItem(
          key: 'logoImageUrl',
          label: 'Clinic logo image',
          isRequired: true,
          completed: true,
        ),
        PublicProfileChecklistItem(
          key: 'description',
          label: 'Clinic description',
          isRequired: true,
          completed: true,
        ),
        PublicProfileChecklistItem(
          key: 'gallery',
          label: 'Clinic gallery',
          isRequired: true,
          completed: true,
        ),
        PublicProfileChecklistItem(
          key: 'certifications',
          label: 'Trust badges and certifications',
          isRequired: false,
          completed: true,
        ),
      ],
      completionPercent: 100,
      isCompleted: true,
    ),
  );

  @override
  Future<PartnerPublicProfileEntity> getPublicProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _entity;
  }

  @override
  Future<PartnerPublicProfileEntity> updatePublicProfile(
    PublicProfileUpdateRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final sf = _entity.storefront;
    final cover = request.coverImageUrl ?? sf.coverImageUrl;
    final logo = request.logoImageUrl ?? sf.logoImageUrl;
    final desc = request.description ?? sf.description;
    final gallery = request.gallery ?? sf.gallery;
    final certs = request.certifications ?? sf.certifications;

    final checklist = _deriveChecklist(
      cover: cover,
      logo: logo,
      description: desc,
      gallery: gallery,
      certs: certs,
    );

    final completedCount = checklist.where((i) => i.completed).length;
    final percent = ((completedCount / checklist.length) * 100).round();
    final allRequired = checklist
        .where((i) => i.isRequired)
        .every((i) => i.completed);

    _entity = _entity.copyWith(
      storefront: PublicProfileStorefront(
        coverImageUrl: cover,
        logoImageUrl: logo,
        description: desc,
        gallery: gallery,
        certifications: certs,
      ),
      completionSummary: PublicProfileCompletionSummary(
        checklist: checklist,
        completionPercent: percent,
        isCompleted: allRequired,
      ),
    );

    return _entity;
  }

  List<PublicProfileChecklistItem> _deriveChecklist({
    String? cover,
    String? logo,
    String? description,
    required List<String> gallery,
    required List<PublicProfileCertification> certs,
  }) {
    final trimmed = description?.trim() ?? '';
    return [
      PublicProfileChecklistItem(
        key: 'coverImageUrl',
        label: 'Clinic cover image',
        isRequired: true,
        completed: cover != null && cover.isNotEmpty,
      ),
      PublicProfileChecklistItem(
        key: 'logoImageUrl',
        label: 'Clinic logo image',
        isRequired: true,
        completed: logo != null && logo.isNotEmpty,
      ),
      PublicProfileChecklistItem(
        key: 'description',
        label: 'Clinic description',
        isRequired: true,
        completed: trimmed.length >= 120 && trimmed.length <= 1000,
      ),
      PublicProfileChecklistItem(
        key: 'gallery',
        label: 'Clinic gallery',
        isRequired: true,
        completed: gallery.length >= 3,
      ),
      PublicProfileChecklistItem(
        key: 'certifications',
        label: 'Trust badges and certifications',
        isRequired: false,
        completed: certs.isNotEmpty,
      ),
    ];
  }
}
