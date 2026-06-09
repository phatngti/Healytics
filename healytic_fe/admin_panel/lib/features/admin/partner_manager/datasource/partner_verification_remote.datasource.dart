import 'dart:developer' as developer;

import 'package:admin_openapi/api.dart'
    hide PartnerVerificationStatus, PartnerPriority;
import 'package:admin_openapi/api.dart' as openapi;
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/datasource/data/partner_verification_mock_data.dart';
import 'package:admin_panel/features/admin/partner_manager/datasource/data/partner_verification_detail_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_verification_remote.datasource.g.dart';

// ============================================================
// 1. ABSTRACT INTERFACE
// ============================================================

/// Abstract interface for partner verification data
/// operations.
abstract class PartnerVerificationRemoteDataSource {
  /// Get paginated list of partner verifications
  /// filtered by scope, search, status, and sort.
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  });

  /// Get one paginated page plus the filtered total
  /// returned by the same list endpoint.
  Future<PartnerVerificationPageEntity> getPartnerVerificationPage({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  });

  /// Get total count matching current filters.
  Future<int> getTotalRows({
    required PartnerManagerScope scope,
    String? searchQuery,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  });

  /// Get detailed partner verification information
  /// for review page.
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  );

  /// Approve a partner verification request.
  Future<void> approvePartner(PartnerVerificationId id);

  /// Reject a partner verification request.
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason});

  /// Submit a review decision for a partner with
  /// optional field-level feedback.
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  });

  /// Get dashboard statistics.
  Future<PartnerVerificationStats> getStats({
    PartnerManagerScope scope,
    String? searchQuery,
  });
}

// ============================================================
// 2. IMPLEMENTATION (Real API)
// ============================================================

/// Real implementation using the generated
/// AdminPartnersApi.
class PartnerVerificationRemoteDataSourceImpl
    implements PartnerVerificationRemoteDataSource {
  final ApiService apiService;

  PartnerVerificationRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  }) async {
    final page = await getPartnerVerificationPage(
      startingAt: startingAt,
      count: count,
      scope: scope,
      searchQuery: searchQuery,
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
      statusFilter: statusFilter,
      quickFilter: quickFilter,
    );
    return page.items;
  }

  @override
  Future<PartnerVerificationPageEntity> getPartnerVerificationPage({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  }) async {
    if (quickFilter == PartnerManagerQuickFilter.highPriority) {
      return _getHighPriorityPartnerVerificationPage(
        startingAt: startingAt,
        count: count,
        scope: scope,
        searchQuery: searchQuery,
        sortedBy: sortedBy,
        sortedAsc: sortedAsc,
        statusFilter: statusFilter,
      );
    }

    final page = (startingAt ~/ count) + 1;
    final effectiveScope =
        quickFilter == PartnerManagerQuickFilter.pendingReview
        ? PartnerManagerScope.verificationQueue
        : scope;

    final response = await apiService.adminPartnersApi
        .adminPartnersControllerGetPartners(
          page: page,
          limit: count,
          scope: _mapScope(effectiveScope),
          search: searchQuery,
          verificationStatus: _mapStatusToQueryParam(statusFilter),
          sortBy: _mapSortBy(sortedBy),
          sortDirection: _mapSortDirection(sortedAsc),
        );

    if (response == null) {
      return const PartnerVerificationPageEntity(items: [], total: 0);
    }

    return PartnerVerificationPageEntity(
      items: response.data.map(_mapPartnerItemToEntity).toList(),
      total: response.total.toInt(),
    );
  }

  @override
  Future<int> getTotalRows({
    required PartnerManagerScope scope,
    String? searchQuery,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  }) async {
    if (quickFilter != null) {
      final page = await getPartnerVerificationPage(
        startingAt: 0,
        count: 1,
        scope: scope,
        searchQuery: searchQuery,
        statusFilter: statusFilter,
        quickFilter: quickFilter,
      );
      return page.total;
    }

    final response = await apiService.adminPartnersApi
        .adminPartnersControllerGetTotalPartners(
          scope: _mapScope(scope),
          search: searchQuery,
          verificationStatus: _mapStatusToQueryParam(statusFilter),
        );
    if (response == null) return 0;
    return response.total.toInt();
  }

  Future<PartnerVerificationPageEntity>
  _getHighPriorityPartnerVerificationPage({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  }) async {
    const pageSize = 100;
    var page = 1;
    var fetched = 0;
    var total = 0;
    final highPriority = <PartnerVerificationEntity>[];

    do {
      final response = await apiService.adminPartnersApi
          .adminPartnersControllerGetPartners(
            page: page,
            limit: pageSize,
            scope: _mapScope(PartnerManagerScope.verificationQueue),
            search: searchQuery,
            verificationStatus: _mapStatusToQueryParam(statusFilter),
            sortBy: _mapSortBy(sortedBy),
            sortDirection: _mapSortDirection(sortedAsc),
          );

      if (response == null) {
        break;
      }

      total = response.total.toInt();
      final items = response.data.map(_mapPartnerItemToEntity).toList();
      fetched += items.length;
      highPriority.addAll(
        items.where((item) => item.priority == PartnerPriority.high),
      );

      if (items.isEmpty) {
        break;
      }
      page += 1;
    } while (fetched < total);

    final start = startingAt.clamp(0, highPriority.length).toInt();
    final end = (startingAt + count).clamp(0, highPriority.length).toInt();

    return PartnerVerificationPageEntity(
      items: highPriority.sublist(start, end),
      total: highPriority.length,
    );
  }

  @override
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  ) async {
    final dto = await apiService.adminPartnersApi
        .adminPartnersControllerGetPartnerDetail(id.value);
    if (dto == null) {
      throw Exception('Partner detail not found: $id');
    }
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
    final decisionEnum = switch (decision) {
      'APPROVED' => ReviewPartnerProfileDtoDecisionEnum.APPROVED,
      'CHANGES_REQUIRED' =>
        ReviewPartnerProfileDtoDecisionEnum.CHANGES_REQUIRED,
      'REJECTED' => ReviewPartnerProfileDtoDecisionEnum.REJECTED,
      _ => throw ArgumentError('Invalid decision: $decision'),
    };

    final items = <ReviewItemDto>[];
    if (fieldFeedback != null) {
      for (final entry in fieldFeedback.entries) {
        items.add(ReviewItemDto(fieldKey: entry.key, feedback: entry.value));
      }
    }

    final reviewDto = ReviewPartnerProfileDto(
      decision: decisionEnum,
      generalComment: generalComment,
      items: items,
    );

    await apiService.adminPartnersApi.adminPartnersControllerReviewPartner(
      id.value,
      reviewDto,
    );
  }

  @override
  Future<PartnerVerificationStats> getStats({
    PartnerManagerScope scope = PartnerManagerScope.verificationQueue,
    String? searchQuery,
  }) async {
    try {
      final response = await apiService.adminPartnersApi
          .adminPartnersControllerGetPartnerStats(
            scope: _mapScope(scope),
            search: searchQuery,
          );
      if (response == null) {
        return const PartnerVerificationStats();
      }
      return PartnerVerificationStats(
        pendingReview: response.pendingReview.toInt(),
        highPriority: response.highPriority.toInt(),
        activeToday: response.activeToday.toInt(),
        avgWaitSeconds: response.avgWaitSeconds.toInt(),
        avgWaitTime: response.avgWaitTime,
        totalProviders: response.totalProviders.toInt(),
        requiredResubmit: response.requiredResubmit.toInt(),
        approved: response.approved.toInt(),
        rejected: response.rejected.toInt(),
      );
    } catch (e, st) {
      developer.log(
        'Failed to fetch partner stats',
        name: 'PartnerVerificationDataSource',
        error: e,
        stackTrace: st,
      );
      return const PartnerVerificationStats();
    }
  }

  // ========================================================
  // MAPPING: List Item
  // ========================================================

  PartnerVerificationEntity _mapPartnerItemToEntity(AdminPartnerItemDto dto) {
    final displayName = _getDisplayName(dto);

    return PartnerVerificationEntity(
      id: PartnerVerificationId(dto.id),
      name: displayName,
      initials: _getInitials(displayName),
      serviceTypes: dto.businessType.map(_formatBusinessType).toList(),
      submittedAt: dto.createdAt,
      priority: _mapPriority(dto.priority),
      status: _mapItemVerificationStatus(dto.verificationStatus),
      isAccountActive: dto.isAccountActive,
      providerId: dto.id,
    );
  }

  String _getDisplayName(AdminPartnerItemDto dto) {
    final brandName = dto.brandName.trim();
    if (brandName.isNotEmpty) return brandName;

    final legalName = dto.legalName.trim();
    if (legalName.isNotEmpty) return legalName;

    final email = dto.email.trim();
    if (email.isNotEmpty) return email;

    return dto.id;
  }

  /// Formats backend BusinessType enum value into
  /// a UI-friendly label.
  static String _formatBusinessType(openapi.BusinessType type) {
    return switch (type) {
      openapi.BusinessType.MASSAGE_THERAPY => 'Massage Therapy',
      openapi.BusinessType.MASSAGE_REHABILITATION => 'Rehabilitation',
      openapi.BusinessType.SPA_BEAUTY => 'Spa & Beauty',
      openapi.BusinessType.FITNESS => 'Fitness',
      openapi.BusinessType.PHARMACY => 'Pharmacy',
      openapi.BusinessType.DENTAL => 'Dental',
      openapi.BusinessType.TRADITIONAL_MEDICINE => 'Traditional Medicine',
      openapi.BusinessType.PSYCHOLOGY => 'Psychology',
      openapi.BusinessType.DERMATOLOGY => 'Dermatology',
      openapi.BusinessType.NUTRITION => 'Nutrition',
      openapi.BusinessType.PSYCHIATRY => 'Psychiatry',
      _ => type.value,
    };
  }

  // ========================================================
  // MAPPING: Status & Priority
  // ========================================================

  PartnerVerificationStatus _mapVerificationStatus(
    openapi.PartnerVerificationStatus status,
  ) {
    return switch (status) {
      openapi.PartnerVerificationStatus.APPROVED =>
        PartnerVerificationStatus.approved,
      openapi.PartnerVerificationStatus.REJECTED =>
        PartnerVerificationStatus.rejected,
      openapi.PartnerVerificationStatus.REQUIRED_RESUBMIT =>
        PartnerVerificationStatus.requiredResubmit,
      _ => PartnerVerificationStatus.pending,
    };
  }

  PartnerVerificationStatus _mapItemVerificationStatus(
    openapi.PartnerVerificationStatus status,
  ) {
    return _mapVerificationStatus(status);
  }

  PartnerPriority _mapPriority(openapi.PartnerPriority p) {
    if (p == openapi.PartnerPriority.high ||
        p == openapi.PartnerPriority.urgent) {
      return PartnerPriority.high;
    }
    return PartnerPriority.normal;
  }

  // ========================================================
  // MAPPING: Query Params
  // ========================================================

  AdminPartnerScope? _mapScope(PartnerManagerScope scope) {
    return switch (scope) {
      PartnerManagerScope.verificationQueue =>
        AdminPartnerScope.VERIFICATION_QUEUE,
      PartnerManagerScope.allProviders => AdminPartnerScope.ALL_PROVIDERS,
    };
  }

  openapi.PartnerVerificationStatus? _mapStatusToQueryParam(
    PartnerVerificationStatus? status,
  ) {
    if (status == null) return null;
    return switch (status) {
      PartnerVerificationStatus.pending =>
        openapi.PartnerVerificationStatus.PENDING,
      PartnerVerificationStatus.requiredResubmit =>
        openapi.PartnerVerificationStatus.REQUIRED_RESUBMIT,
      PartnerVerificationStatus.approved =>
        openapi.PartnerVerificationStatus.APPROVED,
      PartnerVerificationStatus.rejected =>
        openapi.PartnerVerificationStatus.REJECTED,
    };
  }

  AdminPartnerSortBy? _mapSortBy(String? sortedBy) {
    if (sortedBy == null) return null;
    return switch (sortedBy) {
      'name' => AdminPartnerSortBy.brandName,
      'submittedAt' => AdminPartnerSortBy.createdAt,
      'priority' => AdminPartnerSortBy.priority,
      'status' => AdminPartnerSortBy.verificationStatus,
      _ => AdminPartnerSortBy.createdAt,
    };
  }

  AdminPartnerSortDirection? _mapSortDirection(bool? sortedAsc) {
    if (sortedAsc == null) return null;
    return sortedAsc
        ? AdminPartnerSortDirection.ASC
        : AdminPartnerSortDirection.DESC;
  }

  // ========================================================
  // MAPPING: Detail
  // ========================================================

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
      isTaxCodeValid: false,
      address: _mapAddress(businessInfo.address),
      email: businessInfo.email != null
          ? _mapVerifiedFieldNullable<String?>(businessInfo.email!)
          : null,
      isEmailVerified: businessInfo.email?.isVerified ?? false,
      phoneNumber: businessInfo.phoneNumber != null
          ? _mapVerifiedFieldNullable<String?>(businessInfo.phoneNumber!)
          : null,
      businessType: _mapVerifiedFieldList(businessInfo.businessType),
      legalRepresentative: _mapLegalRepresentative(dto.legalRepresentative),
      kycDocuments: _mapKycDocuments(dto.kycDocuments),
      status: _mapVerificationStatus(dto.status),
      priority: _mapPriority(dto.priority),
      submittedAt: dto.submittedAt,
      reviewNote: dto.reviewNote,
    );
  }

  VerifiedFieldEntity<T> _mapVerifiedField<T>(VerifiedField dto) {
    return VerifiedFieldEntity<T>(
      fieldKey: dto.fieldKey,
      value: _convertValue<T>(dto.value),
      isVerified: dto.isVerified,
      feedback: dto.feedback,
    );
  }

  VerifiedFieldEntity<T?> _mapVerifiedFieldNullable<T>(VerifiedField dto) {
    return VerifiedFieldEntity<T?>(
      fieldKey: dto.fieldKey,
      value: _convertValueNullable<T>(dto.value),
      isVerified: dto.isVerified,
      feedback: dto.feedback,
    );
  }

  T _convertValue<T>(Object? value) {
    if (T == String) {
      return (value?.toString() ?? '') as T;
    }
    return value as T;
  }

  T? _convertValueNullable<T>(Object? value) {
    if (value == null) return null;
    if (T == String) return value.toString() as T;
    return value as T?;
  }

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

  AddressLocation _parseLocationValue(Object? value) {
    if (value is Map<String, dynamic>) {
      return AddressLocation(
        id: value['id']?.toString() ?? '',
        name: value['name']?.toString() ?? '',
      );
    }
    return AddressLocation(id: '', name: value?.toString() ?? '');
  }

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

  List<VerifiedFieldEntity<KycDocument>> _mapKycDocuments(
    List<VerifiedField> documents,
  ) {
    if (documents.isEmpty) return [];

    return documents.map((verifiedField) {
      final value = verifiedField.value;
      KycDocument document;

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
        document = KycDocument(
          id: verifiedField.fieldKey,
          documentKey: verifiedField.fieldKey,
          fileType: _extractFileType(value),
          fileName: _extractFileName(value),
          fileUrl: value.isNotEmpty ? value : null,
        );
      } else {
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

  String _extractFileType(String url) {
    if (url.isEmpty) return '';
    return url.split('.').lastOrNull?.toLowerCase() ?? '';
  }

  String _extractFileName(String url) {
    if (url.isEmpty) return '';
    return url.split('/').lastOrNull ?? '';
  }

  String _getInitials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final word = words.first;
      final end = word.length >= 2 ? 2 : word.length;
      return word.substring(0, end).toUpperCase();
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

// ============================================================
// 3. MOCK IMPLEMENTATION
// ============================================================

/// Mock implementation with rich static data for
/// UI testing.
class PartnerVerificationRemoteDataSourceMock
    implements PartnerVerificationRemoteDataSource {
  final List<PartnerVerificationEntity> _mockData = partnerVerificationMockData;

  @override
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  }) async {
    final page = await getPartnerVerificationPage(
      startingAt: startingAt,
      count: count,
      scope: scope,
      searchQuery: searchQuery,
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
      statusFilter: statusFilter,
      quickFilter: quickFilter,
    );
    return page.items;
  }

  @override
  Future<PartnerVerificationPageEntity> getPartnerVerificationPage({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final filtered = _applyMockFilters(
      scope: scope,
      searchQuery: searchQuery,
      statusFilter: statusFilter,
      quickFilter: quickFilter,
    );

    _applyMockSort(filtered, sortedBy, sortedAsc);

    final start = startingAt.clamp(0, filtered.length).toInt();
    final end = (startingAt + count).clamp(0, filtered.length).toInt();

    return PartnerVerificationPageEntity(
      items: filtered.sublist(start, end),
      total: filtered.length,
    );
  }

  @override
  Future<int> getTotalRows({
    required PartnerManagerScope scope,
    String? searchQuery,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _applyMockFilters(
      scope: scope,
      searchQuery: searchQuery,
      statusFilter: statusFilter,
      quickFilter: quickFilter,
    ).length;
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
    developer.log(
      'Mock: Approved partner $id',
      name: 'PartnerVerificationMock',
    );
  }

  @override
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason}) async {
    await Future.delayed(const Duration(seconds: 1));
    developer.log(
      'Mock: Rejected partner $id reason=$reason',
      name: 'PartnerVerificationMock',
    );
  }

  @override
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    developer.log(
      'Mock: Reviewed partner $id '
      'decision=$decision '
      'items=${fieldFeedback?.length ?? 0}',
      name: 'PartnerVerificationMock',
    );
  }

  @override
  Future<PartnerVerificationStats> getStats({
    PartnerManagerScope scope = PartnerManagerScope.verificationQueue,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final pending = _mockData
        .where((p) => p.status == PartnerVerificationStatus.pending)
        .length;
    final resubmit = _mockData
        .where((p) => p.status == PartnerVerificationStatus.requiredResubmit)
        .length;
    final highPriority = _mockData
        .where((p) => p.priority == PartnerPriority.high)
        .length;
    final approved = _mockData
        .where((p) => p.status == PartnerVerificationStatus.approved)
        .length;
    final rejected = _mockData
        .where((p) => p.status == PartnerVerificationStatus.rejected)
        .length;

    return PartnerVerificationStats(
      pendingReview: pending + resubmit,
      highPriority: highPriority,
      activeToday: approved,
      avgWaitSeconds: 15120,
      avgWaitTime: '4h 12m',
      totalProviders: _mockData.length,
      requiredResubmit: resubmit,
      approved: approved,
      rejected: rejected,
    );
  }

  // ─── Mock filter helpers ──────────────────────────

  List<PartnerVerificationEntity> _applyMockFilters({
    required PartnerManagerScope scope,
    String? searchQuery,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  }) {
    var filtered = _mockData.toList();
    final effectiveScope =
        quickFilter == PartnerManagerQuickFilter.pendingReview
        ? PartnerManagerScope.verificationQueue
        : scope;

    // Apply scope
    if (effectiveScope == PartnerManagerScope.verificationQueue) {
      filtered = filtered
          .where(
            (p) =>
                p.status == PartnerVerificationStatus.pending ||
                p.status == PartnerVerificationStatus.requiredResubmit,
          )
          .toList();
    }

    // Apply status filter
    if (statusFilter != null) {
      filtered = filtered.where((p) => p.status == statusFilter).toList();
    }

    if (quickFilter == PartnerManagerQuickFilter.highPriority) {
      filtered = filtered
          .where((p) => p.priority == PartnerPriority.high)
          .toList();
    }

    // Apply search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (p) =>
                p.name.toLowerCase().contains(query) ||
                (p.providerId?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    return filtered;
  }

  void _applyMockSort(
    List<PartnerVerificationEntity> filtered,
    String? sortedBy,
    bool? sortedAsc,
  ) {
    if (sortedBy == null) return;

    switch (sortedBy) {
      case 'name':
        filtered.sort(
          (a, b) => sortedAsc == true
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name),
        );
      case 'priority':
        filtered.sort((a, b) {
          final cmp = a.priority.index.compareTo(b.priority.index);
          return sortedAsc == true ? cmp : -cmp;
        });
      case 'submittedAt':
      case 'createdAt':
      default:
        filtered.sort(
          (a, b) => sortedAsc == true
              ? a.submittedAt.compareTo(b.submittedAt)
              : b.submittedAt.compareTo(a.submittedAt),
        );
    }
  }
}

// ============================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================

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
