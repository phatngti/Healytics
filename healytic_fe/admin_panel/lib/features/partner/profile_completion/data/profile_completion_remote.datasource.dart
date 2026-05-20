import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/checklist_key.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';

/// Contract for fetching and updating partner
/// profile completion data.
abstract class ProfileCompletionRemoteDataSource {
  /// Loads the current profile completion state
  /// including checklist and clinic identity.
  Future<PartnerProfileCompletionEntity> getProfileCompletion();

  /// Persists updated profile fields and returns
  /// the refreshed completion state.
  Future<PartnerProfileCompletionEntity> updateProfileCompletion(
    PartnerProfileCompletionUpdateRequest request,
  );

  /// Refreshes the partner JWT session so the
  /// `partnerProfileCompleted` flag is up-to-date.
  Future<AuthTokensDto?> refreshPartnerSession();
}

/// Real implementation backed by generated OpenAPI
/// [PartnerPartnersApi] methods.
class ProfileCompletionRemoteDataSourceImpl
    implements ProfileCompletionRemoteDataSource {
  ProfileCompletionRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<PartnerProfileCompletionEntity> getProfileCompletion() async {
    final dto = await apiService.partnerPartnersApi
        .partnerSelfControllerGetMyProfileCompletion();

    if (dto == null) {
      throw ApiException(404, 'Profile completion data not found');
    }

    return _mapResponseToEntity(dto);
  }

  @override
  Future<PartnerProfileCompletionEntity> updateProfileCompletion(
    PartnerProfileCompletionUpdateRequest request,
  ) async {
    final updateDto = _mapRequestToDto(request);

    final dto = await apiService.partnerPartnersApi
        .partnerSelfControllerUpdateMyProfileCompletion(updateDto);

    if (dto == null) {
      throw ApiException(500, 'Update returned no data');
    }

    return _mapResponseToEntity(dto);
  }

  @override
  Future<AuthTokensDto?> refreshPartnerSession() async {
    final refreshToken = Store.tryGet(StoreKey.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    return apiService.authenticateApi.authControllerRefreshPartner(
      RefreshTokenRequestDto(refreshToken: refreshToken),
    );
  }

  // ── DTO → Entity mapping ─────────────────────

  /// Maps the generated response DTO to the domain
  /// entity with defensive null/type handling for
  /// `Object?` fields.
  PartnerProfileCompletionEntity _mapResponseToEntity(
    MyProfileCompletionResponseDto dto,
  ) {
    return PartnerProfileCompletionEntity(
      id: dto.id,
      clinicIdentity: _mapIdentityDto(dto.clinicIdentity),
      coverImageUrl: dto.coverImageUrl?.toString(),
      logoImageUrl: dto.logoImageUrl?.toString(),
      description: dto.description?.toString(),
      gallery: dto.gallery,
      certifications: dto.certifications.map(_mapCertificationDto).toList(),
      checklist: dto.checklist.map(_mapChecklistDto).toList(),
      completionPercent: dto.completionPercent.round(),
      isCompleted: dto.isCompleted,
    );
  }

  ClinicIdentity _mapIdentityDto(PartnerProfileCompletionIdentityDto dto) {
    return ClinicIdentity(
      brandName: dto.brandName,
      legalName: dto.legalName,
      businessType: dto.businessType,
      phoneNumber: dto.phoneNumber?.toString(),
      address: dto.address?.toString(),
    );
  }

  PartnerCertificationItem _mapCertificationDto(
    PartnerProfileCompletionCertificationDto dto,
  ) {
    return PartnerCertificationItem(
      id: dto.id,
      title: dto.title,
      subtitle: dto.subtitle?.toString(),
      iconName: dto.iconName,
      sortOrder: dto.sortOrder.toInt(),
    );
  }

  CompletionChecklistItem _mapChecklistDto(CompletionChecklistItemDto dto) {
    return CompletionChecklistItem(
      key: dto.key,
      label: dto.label,
      isRequired: dto.required_,
      completed: dto.completed,
    );
  }

  // ── Entity → Update DTO mapping ──────────────

  /// Converts the presentation-layer update request
  /// into the generated OpenAPI DTO.
  UpdatePartnerProfileCompletionDto _mapRequestToDto(
    PartnerProfileCompletionUpdateRequest request,
  ) {
    return UpdatePartnerProfileCompletionDto(
      coverImageUrl: request.coverImageUrl!,
      logoImageUrl: request.logoImageUrl!,
      description: request.description!,
      gallery: request.gallery ?? const [],
      certifications: (request.certifications ?? const [])
          .map(_mapCertificationToDto)
          .toList(),
    );
  }

  UpdatePartnerCertificationDto _mapCertificationToDto(
    PartnerCertificationItem item,
  ) {
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
/// Constructs domain entities directly without DTOs.
///
/// Uses [UserRoleHelper.isProviderProfileCompleted]
/// to decide whether to return a fully completed
/// profile or an incomplete one.
class ProfileCompletionRemoteDataSourceMock
    implements ProfileCompletionRemoteDataSource {
  PartnerProfileCompletionEntity? _entity;

  /// Lazily initializes the entity based on the
  /// current mock account's profile-completed flag.
  PartnerProfileCompletionEntity get _currentEntity {
    return _entity ??= _buildInitialEntity();
  }

  set _currentEntity(PartnerProfileCompletionEntity e) {
    _entity = e;
  }

  static PartnerProfileCompletionEntity _buildInitialEntity() {
    final isCompleted = UserRoleHelper.isProviderProfileCompleted();

    if (isCompleted) {
      return _buildCompletedEntity();
    }
    return _buildIncompleteEntity();
  }

  static PartnerProfileCompletionEntity _buildCompletedEntity() {
    return PartnerProfileCompletionEntity(
      id: 'mock-partner-id',
      clinicIdentity: const ClinicIdentity(
        brandName: 'Healytics Wellness Center',
        legalName: 'Healytics Wellness Joint Stock Company',
        businessType: ['SPA_BEAUTY', 'MASSAGE_THERAPY'],
        phoneNumber: '0901234567',
        address:
            '123 Main Street, District 1, '
            'Ho Chi Minh City',
      ),
      coverImageUrl: 'https://picsum.photos/seed/cover/800/400',
      logoImageUrl: 'https://picsum.photos/seed/logo/200/200',
      description:
          'Healytics Wellness Center is a premier '
          'health and beauty destination offering '
          'spa treatments, massage therapy, and '
          'holistic wellness services. Our team of '
          'certified professionals is dedicated to '
          'helping you achieve balance and vitality.',
      gallery: [
        'https://picsum.photos/seed/g1/600/400',
        'https://picsum.photos/seed/g2/600/400',
        'https://picsum.photos/seed/g3/600/400',
        'https://picsum.photos/seed/g4/600/400',
      ],
      certifications: const [
        PartnerCertificationItem(
          id: 'cert-1',
          title: 'Licensed Spa',
          subtitle: 'Ministry of Health',
          iconName: 'verified',
          sortOrder: 0,
        ),
        PartnerCertificationItem(
          id: 'cert-2',
          title: 'ISO 9001:2015',
          subtitle: 'Quality Management',
          iconName: 'workspace_premium',
          sortOrder: 1,
        ),
      ],
      checklist: [
        CompletionChecklistItem(
          key: ChecklistKey.coverImageUrl.value,
          label: ChecklistKey.coverImageUrl.label,
          isRequired: true,
          completed: true,
        ),
        CompletionChecklistItem(
          key: ChecklistKey.logoImageUrl.value,
          label: ChecklistKey.logoImageUrl.label,
          isRequired: true,
          completed: true,
        ),
        CompletionChecklistItem(
          key: ChecklistKey.description.value,
          label: ChecklistKey.description.label,
          isRequired: true,
          completed: true,
        ),
        CompletionChecklistItem(
          key: ChecklistKey.gallery.value,
          label: ChecklistKey.gallery.label,
          isRequired: true,
          completed: true,
        ),
        CompletionChecklistItem(
          key: ChecklistKey.certifications.value,
          label: ChecklistKey.certifications.label,
          completed: true,
        ),
      ],
      completionPercent: 100,
      isCompleted: true,
    );
  }

  static PartnerProfileCompletionEntity _buildIncompleteEntity() {
    return PartnerProfileCompletionEntity(
      id: 'mock-partner-id',
      clinicIdentity: const ClinicIdentity(
        brandName: 'Healytics Wellness Center',
        legalName: 'Healytics Wellness Joint Stock Company',
        businessType: ['SPA_BEAUTY', 'MASSAGE_THERAPY'],
        phoneNumber: '0901234567',
        address:
            '123 Main Street, District 1, '
            'Ho Chi Minh City',
      ),
      checklist: [
        CompletionChecklistItem(
          key: ChecklistKey.coverImageUrl.value,
          label: ChecklistKey.coverImageUrl.label,
          isRequired: true,
        ),
        CompletionChecklistItem(
          key: ChecklistKey.logoImageUrl.value,
          label: ChecklistKey.logoImageUrl.label,
          isRequired: true,
        ),
        CompletionChecklistItem(
          key: ChecklistKey.description.value,
          label: ChecklistKey.description.label,
          isRequired: true,
        ),
        CompletionChecklistItem(
          key: ChecklistKey.gallery.value,
          label: ChecklistKey.gallery.label,
          isRequired: true,
        ),
      ],
    );
  }

  @override
  Future<PartnerProfileCompletionEntity> getProfileCompletion() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentEntity;
  }

  @override
  Future<AuthTokensDto?> refreshPartnerSession() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  @override
  Future<PartnerProfileCompletionEntity> updateProfileCompletion(
    PartnerProfileCompletionUpdateRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final gallery = request.gallery ?? _currentEntity.gallery;
    final description = request.description ?? _currentEntity.description;
    final coverImageUrl = request.coverImageUrl ?? _currentEntity.coverImageUrl;
    final logoImageUrl = request.logoImageUrl ?? _currentEntity.logoImageUrl;
    final certifications =
        request.certifications ?? _currentEntity.certifications;

    final checklist = [
      CompletionChecklistItem(
        key: ChecklistKey.coverImageUrl.value,
        label: ChecklistKey.coverImageUrl.label,
        isRequired: true,
        completed: coverImageUrl != null && coverImageUrl.isNotEmpty,
      ),
      CompletionChecklistItem(
        key: ChecklistKey.logoImageUrl.value,
        label: ChecklistKey.logoImageUrl.label,
        isRequired: true,
        completed: logoImageUrl != null && logoImageUrl.isNotEmpty,
      ),
      CompletionChecklistItem(
        key: ChecklistKey.description.value,
        label: ChecklistKey.description.label,
        isRequired: true,
        completed:
            description != null &&
            description.trim().length >= 120 &&
            description.trim().length <= 1000,
      ),
      CompletionChecklistItem(
        key: ChecklistKey.gallery.value,
        label: ChecklistKey.gallery.label,
        isRequired: true,
        completed: gallery.length >= 3,
      ),
      CompletionChecklistItem(
        key: ChecklistKey.certifications.value,
        label: ChecklistKey.certifications.label,
        completed: certifications.isNotEmpty,
      ),
    ];

    _currentEntity = PartnerProfileCompletionEntity(
      id: _currentEntity.id,
      clinicIdentity: _currentEntity.clinicIdentity,
      coverImageUrl: coverImageUrl,
      logoImageUrl: logoImageUrl,
      description: description,
      gallery: gallery,
      certifications: certifications,
      checklist: checklist,
      completionPercent:
          ((checklist.where((item) => item.completed).length /
                      checklist.length) *
                  100)
              .round(),
      isCompleted: checklist
          .where((item) => item.isRequired)
          .every((item) => item.completed),
    );

    return _currentEntity;
  }
}
