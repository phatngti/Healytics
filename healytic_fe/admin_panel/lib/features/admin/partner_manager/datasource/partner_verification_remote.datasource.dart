import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/datasource/data/partner_verification_mock_data.dart';
import 'package:admin_panel/features/admin/partner_manager/datasource/data/partner_verification_detail_mock_data.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_verification_remote.datasource.g.dart';

// ============================================================================
// 1. ABSTRACT INTERFACE
// ============================================================================

/// Abstract interface for partner verification data operations
abstract class PartnerVerificationRemoteDataSource {
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  });

  Future<int> getTotalRows({PartnerVerificationStatus? statusFilter});

  /// Get detailed partner verification information for review page
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  );

  Future<void> approvePartner(PartnerVerificationId id);

  Future<void> rejectPartner(PartnerVerificationId id, {String? reason});

  /// Submit a review decision for a partner with optional field-level feedback.
  ///
  /// [id] - The partner ID to review.
  /// [decision] - The review decision: 'APPROVED', 'CHANGES_REQUIRED', or 'REJECTED'.
  /// [generalComment] - Optional general comment/note for the review.
  /// [fieldFeedback] - Map of fieldKey to feedback note for fields requiring revision.
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  });

  Future<PartnerVerificationStats> getStats();
}

// ============================================================================
// 2. IMPLEMENTATION (Real API)
// ============================================================================

/// Real implementation using API service
class PartnerVerificationRemoteDataSourceImpl
    implements PartnerVerificationRemoteDataSource {
  final ApiService apiService;

  PartnerVerificationRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  }) async {
    // Calculate page number from offset (1-indexed)
    final page = (startingAt ~/ count) + 1;

    final response = await apiService.adminPartnersApi
        .adminPartnersControllerGetPartners(
          page: page,
          limit: count,
          verificationStatus: _mapStatusToQueryParam(statusFilter),
        );
    if (response == null) {
      return [];
    }

    return response.data.map((dto) => _mapPartnerItemToEntity(dto)).toList();
  }

  @override
  Future<int> getTotalRows({PartnerVerificationStatus? statusFilter}) async {
    final response = await apiService.adminPartnersApi
        .adminPartnersControllerGetTotalPartners();
    if (response == null) {
      return 0;
    }
    return response.total.toInt();
  }

  @override
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  ) async {
    debugPrint(
      'PartnerVerificationRemoteDataSourceImpl: Fetching id=${id.value}',
    );
    final dto = await apiService.adminPartnersApi
        .adminPartnersControllerGetPartnerDetail(id.value);
    if (dto == null) {
      throw Exception('Partner detail not found: $id');
    }
    debugPrint('PartnerVerificationRemoteDataSourceImpl: Received dto=$dto');
    return _mapToPartnerVerificationDetailEntity(dto);
  }

  @override
  Future<void> approvePartner(PartnerVerificationId id) async {
    final reviewDto = ReviewPartnerProfileDto(
      decision: ReviewPartnerProfileDtoDecisionEnum.APPROVED,
    );
    await apiService.adminPartnersApi.adminPartnersControllerReviewPartner(
      id.value,
      reviewDto,
    );
  }

  @override
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason}) async {
    final reviewDto = ReviewPartnerProfileDto(
      decision: ReviewPartnerProfileDtoDecisionEnum.REJECTED,
      generalComment: reason,
    );
    await apiService.adminPartnersApi.adminPartnersControllerReviewPartner(
      id.value,
      reviewDto,
    );
  }

  @override
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  }) async {
    // Map decision string to enum
    final decisionEnum = switch (decision) {
      'APPROVED' => ReviewPartnerProfileDtoDecisionEnum.APPROVED,
      'CHANGES_REQUIRED' =>
        ReviewPartnerProfileDtoDecisionEnum.CHANGES_REQUIRED,
      'REJECTED' => ReviewPartnerProfileDtoDecisionEnum.REJECTED,
      _ => throw ArgumentError('Invalid decision: $decision'),
    };

    // Build review items from field feedback
    final items = <ReviewItemDto>[];
    if (fieldFeedback != null) {
      for (final entry in fieldFeedback.entries) {
        items.add(
          ReviewItemDto(
            fieldKey: entry.key,
            isVerified: false, // Fields with feedback need revision
            feedback: entry.value,
          ),
        );
      }
    }

    final reviewDto = ReviewPartnerProfileDto(
      decision: decisionEnum,
      generalComment: generalComment,
      items: items,
    );

    debugPrint(
      'ReviewPartner: id=${id.value}, decision=$decision, '
      'comment=$generalComment, items=${items.length}',
    );

    await apiService.adminPartnersApi.adminPartnersControllerReviewPartner(
      id.value,
      reviewDto,
    );
  }

  @override
  Future<PartnerVerificationStats> getStats() async {
    // No dedicated stats endpoint - return defaults
    debugPrint(
      'PartnerVerificationRemoteDataSourceImpl.getStats called'
      ' - No stats endpoint available',
    );
    return const PartnerVerificationStats();
  }

  // ===========================================================================
  // MAPPING FUNCTIONS
  // ===========================================================================

  /// Maps [AdminPartnerDetailResponseDto] to [PartnerVerificationDetailEntity]
  PartnerVerificationDetailEntity _mapToPartnerVerificationDetailEntity(
    AdminPartnerDetailResponseDto dto,
  ) {
    final businessInfo = dto.businessInfo;
    return PartnerVerificationDetailEntity(
      id: PartnerVerificationId(dto.id),
      brandName: _mapVerifiedField<String>(businessInfo.brandName),
      taxRegistrationCode: businessInfo.taxRegistrationCode != null
          ? _mapVerifiedFieldNullable<String?>(
              businessInfo.taxRegistrationCode!,
            )
          : null,
      isTaxCodeValid: false, // TODO: Add isTaxCodeValid to DTO if available
      serviceTags: _mapVerifiedFieldList(businessInfo.serviceTags),
      address: _mapAddress(businessInfo.address),
      username: businessInfo.username != null
          ? _mapVerifiedFieldNullable<String?>(businessInfo.username!)
          : null,
      email: businessInfo.email != null
          ? _mapVerifiedFieldNullable<String?>(businessInfo.email!)
          : null,
      isEmailVerified: businessInfo.email?.isVerified ?? false,
      phoneNumber: businessInfo.phoneNumber != null
          ? _mapVerifiedFieldNullable<String?>(businessInfo.phoneNumber!)
          : null,
      legalRepresentative: _mapLegalRepresentative(dto.legalRepresentative),
      kycDocuments: _mapKycDocuments(dto.kycDocuments),
      status: _mapVerificationStatus(dto.status),
      priority: _mapPriority(dto.priority),
      submittedAt: dto.submittedAt,
      reviewNote: dto.reviewNote,
    );
  }

  /// Maps [VerifiedField] DTO to [VerifiedFieldEntity<T>]
  /// Handles non-nullable value conversion.
  VerifiedFieldEntity<T> _mapVerifiedField<T>(VerifiedField dto) {
    return VerifiedFieldEntity<T>(
      fieldKey: dto.fieldKey,
      value: _convertValue<T>(dto.value),
      isVerified: dto.isVerified,
      feedback: dto.feedback,
    );
  }

  /// Maps [VerifiedField] DTO to [VerifiedFieldEntity<T?>] for nullable values.
  VerifiedFieldEntity<T?> _mapVerifiedFieldNullable<T>(VerifiedField dto) {
    return VerifiedFieldEntity<T?>(
      fieldKey: dto.fieldKey,
      value: _convertValueNullable<T>(dto.value),
      isVerified: dto.isVerified,
      feedback: dto.feedback,
    );
  }

  /// Converts a dynamic value to the specified type [T].
  T _convertValue<T>(Object? value) {
    if (T == String) {
      return (value?.toString() ?? '') as T;
    }
    return value as T;
  }

  /// Converts a dynamic value to nullable type [T?].
  T? _convertValueNullable<T>(Object? value) {
    if (value == null) return null;
    if (T == String) {
      return value.toString() as T;
    }
    return value as T?;
  }

  /// Maps [VerifiedField] DTO to [VerifiedFieldEntity<List<String>>]
  VerifiedFieldEntity<List<String>> _mapVerifiedFieldList(VerifiedField dto) {
    final value = dto.value;
    final List<String> listValue;
    if (value is List) {
      listValue = value.map((e) => e.toString()).toList();
    } else if (value is String) {
      listValue = [value];
    } else {
      listValue = [];
    }
    return VerifiedFieldEntity<List<String>>(
      fieldKey: dto.fieldKey,
      value: listValue,
      isVerified: dto.isVerified,
      feedback: dto.feedback,
    );
  }

  /// Maps verification status enum
  PartnerVerificationStatus _mapVerificationStatus(
    AdminPartnerDetailResponseDtoStatusEnum status,
  ) {
    return switch (status) {
      AdminPartnerDetailResponseDtoStatusEnum.PENDING ||
      AdminPartnerDetailResponseDtoStatusEnum.REQUIRED_RESUBMIT =>
        PartnerVerificationStatus.pending,
      AdminPartnerDetailResponseDtoStatusEnum.APPROVED =>
        PartnerVerificationStatus.approved,
      AdminPartnerDetailResponseDtoStatusEnum.REJECTED =>
        PartnerVerificationStatus.rejected,
      _ => PartnerVerificationStatus.pending,
    };
  }

  /// Maps priority enum - maps API values to domain values
  /// Note: Domain only has 'normal' and 'high', so 'low' maps to 'normal'
  /// and 'urgent' maps to 'high'
  PartnerPriority _mapPriority(AdminPartnerDetailResponseDtoPriorityEnum p) {
    return switch (p) {
      AdminPartnerDetailResponseDtoPriorityEnum.low ||
      AdminPartnerDetailResponseDtoPriorityEnum.normal =>
        PartnerPriority.normal,
      AdminPartnerDetailResponseDtoPriorityEnum.high ||
      AdminPartnerDetailResponseDtoPriorityEnum.urgent => PartnerPriority.high,
      _ => PartnerPriority.normal,
    };
  }

  /// Maps [PartnerItemDto] to [PartnerVerificationEntity] for list responses
  PartnerVerificationEntity _mapPartnerItemToEntity(PartnerItemDto dto) {
    return PartnerVerificationEntity(
      id: PartnerVerificationId(dto.id),
      name: dto.brandName,
      initials: _getInitials(dto.brandName),
      serviceTypes: [dto.businessType.value],
      submittedAt: dto.createdAt,
      priority: PartnerPriority.normal,
      status: _mapItemVerificationStatus(dto.verificationStatus),
      isEmailVerified: true,
      providerId: dto.id,
    );
  }

  /// Maps verification status enum from list DTO
  PartnerVerificationStatus _mapItemVerificationStatus(
    PartnerItemDtoVerificationStatusEnum status,
  ) {
    return switch (status) {
      PartnerItemDtoVerificationStatusEnum.PENDING ||
      PartnerItemDtoVerificationStatusEnum.REQUIRED_RESUBMIT =>
        PartnerVerificationStatus.pending,
      PartnerItemDtoVerificationStatusEnum.APPROVED =>
        PartnerVerificationStatus.approved,
      PartnerItemDtoVerificationStatusEnum.REJECTED =>
        PartnerVerificationStatus.rejected,
      _ => PartnerVerificationStatus.pending,
    };
  }

  /// Converts domain status enum to API query parameter string
  String? _mapStatusToQueryParam(PartnerVerificationStatus? status) {
    if (status == null) return null;
    switch (status) {
      case PartnerVerificationStatus.pending:
        return 'PENDING';
      case PartnerVerificationStatus.approved:
        return 'APPROVED';
      case PartnerVerificationStatus.rejected:
        return 'REJECTED';
    }
  }

  /// Maps address DTO to domain entity.
  /// Now handles `VerifiedField` for streetAddress, ward, district, city.
  AddressInfo? _mapAddress(AddressInfoDto? dto) {
    if (dto == null) return null;
    return AddressInfo(
      streetAddress: VerifiedFieldEntity<String>(
        fieldKey: dto.streetAddress.fieldKey,
        value: dto.streetAddress.value.toString(),
        isVerified: dto.streetAddress.isVerified,
        feedback: dto.streetAddress.feedback,
      ),
      ward: dto.ward != null
          ? VerifiedFieldEntity<AddressLocation>(
              fieldKey: dto.ward!.fieldKey,
              value: _parseLocationValue(dto.ward!.value),
              isVerified: dto.ward!.isVerified,
              feedback: dto.ward!.feedback,
            )
          : null,
      district: dto.district != null
          ? VerifiedFieldEntity<AddressLocation>(
              fieldKey: dto.district!.fieldKey,
              value: _parseLocationValue(dto.district!.value),
              isVerified: dto.district!.isVerified,
              feedback: dto.district!.feedback,
            )
          : null,
      city: dto.city != null
          ? VerifiedFieldEntity<AddressLocation>(
              fieldKey: dto.city!.fieldKey,
              value: _parseLocationValue(dto.city!.value),
              isVerified: dto.city!.isVerified,
              feedback: dto.city!.feedback,
            )
          : null,
      country: dto.country,
      latitude: dto.latitude?.toDouble(),
      longitude: dto.longitude?.toDouble(),
    );
  }

  /// Parses location value from DTO which can be a Map or String
  AddressLocation _parseLocationValue(Object? value) {
    if (value is Map<String, dynamic>) {
      return AddressLocation(
        id: value['id']?.toString() ?? '',
        name: value['name']?.toString() ?? '',
      );
    }
    // Fallback: treat as string name with empty id
    return AddressLocation(id: '', name: value?.toString() ?? '');
  }

  /// Maps legal representative DTO to domain entity.
  /// Now handles `VerifiedField` for all fields.
  LegalRepresentative? _mapLegalRepresentative(LegalRepresentativeDto? dto) {
    if (dto == null) return null;
    return LegalRepresentative(
      fullName: VerifiedFieldEntity<String>(
        fieldKey: dto.fullName.fieldKey,
        value: dto.fullName.value.toString(),
        isVerified: dto.fullName.isVerified,
        feedback: dto.fullName.feedback,
      ),
      position: dto.position != null
          ? VerifiedFieldEntity<String>(
              fieldKey: dto.position!.fieldKey,
              value: dto.position!.value.toString(),
              isVerified: dto.position!.isVerified,
              feedback: dto.position!.feedback,
            )
          : null,
      idType: dto.idType != null
          ? VerifiedFieldEntity<String>(
              fieldKey: dto.idType!.fieldKey,
              value: dto.idType!.value.toString(),
              isVerified: dto.idType!.isVerified,
              feedback: dto.idType!.feedback,
            )
          : null,
      idNumber: dto.idNumber != null
          ? VerifiedFieldEntity<String>(
              fieldKey: dto.idNumber!.fieldKey,
              value: dto.idNumber!.value.toString(),
              isVerified: dto.idNumber!.isVerified,
              feedback: dto.idNumber!.feedback,
            )
          : null,
      idIssueDate: dto.idIssueDate != null
          ? VerifiedFieldEntity<String>(
              fieldKey: dto.idIssueDate!.fieldKey,
              value: dto.idIssueDate!.value.toString(),
              isVerified: dto.idIssueDate!.isVerified,
              feedback: dto.idIssueDate!.feedback,
            )
          : null,
    );
  }

  /// Maps KYC document DTOs to domain entities.
  /// Now handles `List<VerifiedField>` instead of `List<KycDocumentDto>`.
  /// Each VerifiedField contains a document object with id, fileName, etc.
  List<VerifiedFieldEntity<KycDocument>> _mapKycDocuments(
    List<VerifiedField> documents,
  ) {
    if (documents.isEmpty) return [];
    debugPrint('Mapping ${documents.length} KYC documents');

    return documents.map((verifiedField) {
      final value = verifiedField.value;
      KycDocument document;

      // The value is typically a Map containing document details
      if (value is Map<String, dynamic>) {
        document = KycDocument(
          id: value['id']?.toString() ?? verifiedField.fieldKey,
          documentKey: verifiedField.fieldKey,
          fileType: value['fileType']?.toString() ?? '',
          fileName: value['fileName']?.toString() ?? '',
          fileUrl: value['fileUrl']?.toString(),
          fileSize: value['fileSize']?.toString(),
          uploadedAt: value['uploadedAt'] != null
              ? DateTime.tryParse(value['uploadedAt'].toString())
              : null,
        );
      } else if (value is String) {
        // Fallback: if value is a string (URL), use it as fileUrl
        document = KycDocument(
          id: verifiedField.fieldKey,
          documentKey: verifiedField.fieldKey,
          fileType: _extractFileType(value),
          fileName: _extractFileName(value),
          fileUrl: value.isNotEmpty ? value : null,
        );
      } else {
        // Default fallback
        document = KycDocument(
          id: verifiedField.fieldKey,
          documentKey: verifiedField.fieldKey,
          fileType: '',
          fileName: '',
        );
      }

      return VerifiedFieldEntity<KycDocument>(
        fieldKey: verifiedField.fieldKey,
        value: document,
        isVerified: verifiedField.isVerified,
        feedback: verifiedField.feedback,
      );
    }).toList();
  }

  /// Extracts file type from URL or path
  String _extractFileType(String url) {
    if (url.isEmpty) return '';
    final extension = url.split('.').lastOrNull?.toLowerCase() ?? '';
    return extension;
  }

  /// Extracts file name from URL or path
  String _extractFileName(String url) {
    if (url.isEmpty) return '';
    return url.split('/').lastOrNull ?? '';
  }

  /// Gets initials from a name
  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first.substring(0, 2).toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

// ============================================================================
// 3. MOCK IMPLEMENTATION
// ============================================================================

/// Mock implementation with rich static data for UI testing
class PartnerVerificationRemoteDataSourceMock
    implements PartnerVerificationRemoteDataSource {
  final List<PartnerVerificationEntity> _mockData = partnerVerificationMockData;

  @override
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var filtered = _mockData.toList();

    // Apply status filter if provided
    if (statusFilter != null) {
      filtered = filtered.where((p) => p.status == statusFilter).toList();
    }

    // Apply sorting
    if (sortedBy != null) {
      switch (sortedBy) {
        case 'name':
          filtered.sort(
            (a, b) => sortedAsc == true
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name),
          );
        case 'priority':
          filtered.sort((a, b) {
            final comparison = a.priority.index.compareTo(b.priority.index);
            return sortedAsc == true ? comparison : -comparison;
          });
        case 'submittedAt':
        default:
          filtered.sort(
            (a, b) => sortedAsc == true
                ? a.submittedAt.compareTo(b.submittedAt)
                : b.submittedAt.compareTo(a.submittedAt),
          );
      }
    }

    final endIndex = (startingAt + count).clamp(0, filtered.length);
    return filtered.sublist(startingAt.clamp(0, filtered.length), endIndex);
  }

  @override
  Future<int> getTotalRows({PartnerVerificationStatus? statusFilter}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (statusFilter != null) {
      return _mockData.where((p) => p.status == statusFilter).length;
    }
    return _mockData.length;
  }

  @override
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final detail = partnerVerificationDetailMockData[id.value];
    if (detail == null) {
      throw Exception('Partner detail not found: $id');
    }
    return detail;
  }

  @override
  Future<void> approvePartner(PartnerVerificationId id) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Mock: Approved partner $id');
  }

  @override
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason}) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Mock: Rejected partner $id with reason: $reason');
  }

  @override
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint(
      'Mock: Reviewed partner $id with decision: $decision, '
      'comment: $generalComment, feedback items: ${fieldFeedback?.length ?? 0}',
    );
  }

  @override
  Future<PartnerVerificationStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final pending = _mockData
        .where((p) => p.status == PartnerVerificationStatus.pending)
        .length;
    final highPriority = _mockData
        .where((p) => p.priority == PartnerPriority.high)
        .length;
    final activeToday = _mockData
        .where((p) => p.status == PartnerVerificationStatus.approved)
        .length;

    return PartnerVerificationStats(
      pendingReview: pending,
      highPriority: highPriority,
      activeToday: activeToday,
      avgWaitTime: '4h 12m',
    );
  }
}

// ============================================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================================

@riverpod
PartnerVerificationRemoteDataSource partnerVerificationRemoteDataSource(
  Ref ref,
) {
  final isMock = Store.get(StoreKey.mockFlag, false);

  if (isMock) {
    return PartnerVerificationRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return PartnerVerificationRemoteDataSourceImpl(apiService: apiService);
}
