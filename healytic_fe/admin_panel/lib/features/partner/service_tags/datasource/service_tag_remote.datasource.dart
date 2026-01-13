import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/service_tags/datasource/data/service_tag_mock_data.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_tag_remote.datasource.g.dart';

// ============================================================================
// 1. ABSTRACT INTERFACE
// ============================================================================

/// Abstract interface for service tag data operations
abstract class ServiceTagRemoteDataSource {
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  });

  Future<int> getTotalRows();

  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id);

  Future<ServiceTagEntity> createServiceTag(CreateServiceTagRequest request);

  Future<void> updateServiceTag({
    required ServiceTagId id,
    String? name,
    String? description,
    int? colorValue,
    bool? isActive,
    int? sortOrder,
  });

  Future<void> deleteServiceTag(ServiceTagId id);

  Future<List<ServiceTagEntity>> getActiveServiceTags();
}

// ============================================================================
// 2. IMPLEMENTATION (Real API)
// ============================================================================

/// Real implementation using API service
class ServiceTagRemoteDataSourceImpl implements ServiceTagRemoteDataSource {
  final ApiService apiService;

  ServiceTagRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    // TODO: Implement real API call when endpoint is available
    debugPrint(
      'ServiceTagRemoteDataSourceImpl.getServiceTags called - API not implemented yet',
    );
    return [];
  }

  @override
  Future<int> getTotalRows() async {
    // TODO: Implement real API call
    debugPrint(
      'ServiceTagRemoteDataSourceImpl.getTotalRows called - API not implemented yet',
    );
    return 0;
  }

  @override
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id) async {
    // TODO: Implement real API call
    throw UnimplementedError('ServiceTag API not implemented yet');
  }

  @override
  Future<ServiceTagEntity> createServiceTag(
    CreateServiceTagRequest request,
  ) async {
    // TODO: Implement real API call
    throw UnimplementedError('ServiceTag API not implemented yet');
  }

  @override
  Future<void> updateServiceTag({
    required ServiceTagId id,
    String? name,
    String? description,
    int? colorValue,
    bool? isActive,
    int? sortOrder,
  }) async {
    // TODO: Implement real API call
    throw UnimplementedError('ServiceTag API not implemented yet');
  }

  @override
  Future<void> deleteServiceTag(ServiceTagId id) async {
    // TODO: Implement real API call
    throw UnimplementedError('ServiceTag API not implemented yet');
  }

  @override
  Future<List<ServiceTagEntity>> getActiveServiceTags() async {
    final all = await getServiceTags(startingAt: 0, count: 1000);
    return all.where((t) => t.isActive).toList();
  }
}

// ============================================================================
// 3. MOCK IMPLEMENTATION
// ============================================================================

/// Mock implementation with rich static data for UI testing
class ServiceTagRemoteDataSourceMock implements ServiceTagRemoteDataSource {
  @override
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    print('ServiceTagRemoteDataSourceMock.getServiceTags called');

    final endIndex = (startingAt + count).clamp(0, mockServiceTags.length);
    print("endIndex: $endIndex");
    return mockServiceTags.sublist(
      startingAt.clamp(0, mockServiceTags.length),
      endIndex,
    );
  }

  @override
  Future<int> getTotalRows() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockServiceTags.length;
  }

  @override
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockServiceTags.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('ServiceTag not found: $id'),
    );
  }

  @override
  Future<ServiceTagEntity> createServiceTag(
    CreateServiceTagRequest request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final newTag = ServiceTagEntity(
      id: ServiceTagId('new-${DateTime.now().millisecondsSinceEpoch}'),
      name: request.name,
      description: request.description,
      colorValue: request.colorValue,
      usage: 0,
      isActive: request.isActive,
      sortOrder: request.sortOrder,
      createdAt: DateTime.now().toIso8601String(),
    );

    return newTag;
  }

  @override
  Future<void> updateServiceTag({
    required ServiceTagId id,
    String? name,
    String? description,
    int? colorValue,
    bool? isActive,
    int? sortOrder,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Mock: Updated service tag $id');
  }

  @override
  Future<void> deleteServiceTag(ServiceTagId id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Mock: Deleted service tag $id');
  }

  @override
  Future<List<ServiceTagEntity>> getActiveServiceTags() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockServiceTags.where((t) => t.isActive).toList();
  }
}

// ============================================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================================

@riverpod
ServiceTagRemoteDataSource serviceTagRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  print('isMock: $isMock');
  if (isMock) {
    return ServiceTagRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return ServiceTagRemoteDataSourceImpl(apiService: apiService);
}
