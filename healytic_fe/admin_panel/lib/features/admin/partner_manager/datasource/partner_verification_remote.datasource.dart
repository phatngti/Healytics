import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/datasource/data/partner_verification_mock_data.dart';
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

  Future<PartnerVerificationEntity> getPartnerById(PartnerVerificationId id);

  Future<void> approvePartner(PartnerVerificationId id);

  Future<void> rejectPartner(PartnerVerificationId id, {String? reason});

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
    // TODO: Implement real API call when endpoint is available
    debugPrint(
      'PartnerVerificationRemoteDataSourceImpl.getPartnerVerifications called'
      ' - API not implemented yet',
    );
    return [];
  }

  @override
  Future<int> getTotalRows({PartnerVerificationStatus? statusFilter}) async {
    // TODO: Implement real API call
    debugPrint(
      'PartnerVerificationRemoteDataSourceImpl.getTotalRows called'
      ' - API not implemented yet',
    );
    return 0;
  }

  @override
  Future<PartnerVerificationEntity> getPartnerById(
    PartnerVerificationId id,
  ) async {
    // TODO: Implement real API call
    throw UnimplementedError('Partner Verification API not implemented yet');
  }

  @override
  Future<void> approvePartner(PartnerVerificationId id) async {
    // TODO: Implement real API call
    throw UnimplementedError('Partner Verification API not implemented yet');
  }

  @override
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason}) async {
    // TODO: Implement real API call
    throw UnimplementedError('Partner Verification API not implemented yet');
  }

  @override
  Future<PartnerVerificationStats> getStats() async {
    // TODO: Implement real API call
    debugPrint(
      'PartnerVerificationRemoteDataSourceImpl.getStats called'
      ' - API not implemented yet',
    );
    return const PartnerVerificationStats();
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
  Future<PartnerVerificationEntity> getPartnerById(
    PartnerVerificationId id,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Partner not found: $id'),
    );
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
