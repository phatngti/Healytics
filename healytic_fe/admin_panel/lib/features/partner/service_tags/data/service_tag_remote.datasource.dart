import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/service_tags/data/data/service_tag_mock_data.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';
import 'package:admin_openapi/api.dart';
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

  Future<List<ServiceTagEntity>> getAllServiceTags({
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
    final entities = await getAllServiceTags(
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );

    // Apply pagination
    final end = (startingAt + count).clamp(0, entities.length);
    return entities.sublist(startingAt.clamp(0, entities.length), end);
  }

  @override
  Future<List<ServiceTagEntity>> getAllServiceTags({
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final response = await _serviceTagsApi.serviceTagsControllerFindAll();

    if (response == null) return [];

    final entities = response.map(_mapResponseToEntity).toList();

    // Apply sorting if requested
    if (sortedBy != null) {
      entities.sort((a, b) {
        final cmp = _compareByField(a, b, sortedBy);
        return (sortedAsc ?? true) ? cmp : -cmp;
      });
    }

    return entities;
  }

  /// Compares two [ServiceTagEntity] by [field] name.
  int _compareByField(ServiceTagEntity a, ServiceTagEntity b, String field) {
    switch (field) {
      case 'name':
        return a.name.compareTo(b.name);
      case 'sortOrder':
        return a.sortOrder.compareTo(b.sortOrder);
      case 'usage':
        return a.usage.compareTo(b.usage);
      case 'isActive':
        return (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0);
      case 'createdAt':
        return (a.createdAt ?? '').compareTo(b.createdAt ?? '');
      default:
        return 0;
    }
  }

  @override
  Future<int> getTotalRows() async {
    final response = await _serviceTagsApi.serviceTagsControllerFindAll();
    return response?.length ?? 0;
  }

  @override
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id) async {
    final response = await _serviceTagsApi.serviceTagsControllerFindOne(
      id.value,
    );

    if (response == null) {
      throw Exception('Service tag not found: ${id.value}');
    }

    return _mapResponseToEntity(response);
  }

  PartnerServiceTagsApi get _serviceTagsApi => apiService.serviceTagsApi;

  @override
  Future<ServiceTagEntity> createServiceTag(
    CreateServiceTagRequest request,
  ) async {
    final dto = CreateServiceTagDto(
      name: request.name,
      description: request.description,
      colorValue: request.colorValue
          .toRadixString(16)
          .toUpperCase()
          .padLeft(8, '0'),
      isActive: request.isActive,
      sortOrder: request.sortOrder,
    );

    final response = await _serviceTagsApi.serviceTagsControllerCreate(dto);

    if (response == null) {
      throw Exception('Failed to create service tag');
    }

    return _mapResponseToEntity(response);
  }

  /// Maps [ServiceTagResponseDto] → [ServiceTagEntity].
  ServiceTagEntity _mapResponseToEntity(ServiceTagResponseDto dto) {
    final colorStr = dto.colorValue.toString();
    final colorInt =
        int.tryParse(colorStr.replaceFirst('#', ''), radix: 16) ?? 0xFF6366F1;

    return ServiceTagEntity(
      id: ServiceTagId(dto.id),
      name: dto.name,
      description: dto.description?.toString() ?? '',
      colorValue: colorInt,
      usage: dto.usage.toInt(),
      isActive: dto.isActive,
      sortOrder: dto.sortOrder.toInt(),
      createdAt: dto.createdAt.toIso8601String(),
      updatedAt: dto.updatedAt.toIso8601String(),
    );
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
    final dto = UpdateServiceTagDto(
      name: name,
      description: description,
      colorValue: colorValue?.toRadixString(16).toUpperCase().padLeft(8, '0'),
      isActive: isActive,
      sortOrder: sortOrder,
    );

    await _serviceTagsApi.serviceTagsControllerUpdate(id.value, dto);
  }

  @override
  Future<void> deleteServiceTag(ServiceTagId id) async {
    await _serviceTagsApi.serviceTagsControllerRemove(id.value);
  }

  @override
  Future<List<ServiceTagEntity>> getActiveServiceTags() async {
    final response = await _serviceTagsApi.serviceTagsControllerFindActive();

    if (response == null) return [];

    return response.map(_mapResponseToEntity).toList();
  }
}

// ============================================================================
// 3. MOCK IMPLEMENTATION
// ============================================================================

/// Mock implementation with rich static data for UI testing
class ServiceTagRemoteDataSourceMock implements ServiceTagRemoteDataSource {
  final List<ServiceTagEntity> _tags = [...mockServiceTags];

  @override
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final tags = await getAllServiceTags(
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );

    final endIndex = (startingAt + count).clamp(0, tags.length);
    return tags.sublist(startingAt.clamp(0, tags.length), endIndex);
  }

  @override
  Future<List<ServiceTagEntity>> getAllServiceTags({
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('ServiceTagRemoteDataSourceMock.getAllServiceTags called');

    final tags = [..._tags];
    if (sortedBy != null) {
      tags.sort((a, b) {
        final cmp = switch (sortedBy) {
          'name' => a.name.compareTo(b.name),
          'sortOrder' => a.sortOrder.compareTo(b.sortOrder),
          'usage' => a.usage.compareTo(b.usage),
          'isActive' => (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0),
          'createdAt' => (a.createdAt ?? '').compareTo(b.createdAt ?? ''),
          _ => 0,
        };
        return (sortedAsc ?? true) ? cmp : -cmp;
      });
    }

    return tags;
  }

  @override
  Future<int> getTotalRows() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tags.length;
  }

  @override
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _tags.firstWhere(
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

    _tags.insert(0, newTag);
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
    final index = _tags.indexWhere((tag) => tag.id == id);
    if (index != -1) {
      final current = _tags[index];
      _tags[index] = current.copyWith(
        name: name ?? current.name,
        description: description ?? current.description,
        colorValue: colorValue ?? current.colorValue,
        isActive: isActive ?? current.isActive,
        sortOrder: sortOrder ?? current.sortOrder,
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
    debugPrint('Mock: Updated service tag $id');
  }

  @override
  Future<void> deleteServiceTag(ServiceTagId id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _tags.removeWhere((tag) => tag.id == id);
    debugPrint('Mock: Deleted service tag $id');
  }

  @override
  Future<List<ServiceTagEntity>> getActiveServiceTags() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tags.where((t) => t.isActive).toList();
  }
}

// ============================================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================================

@riverpod
ServiceTagRemoteDataSource serviceTagRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  debugPrint('isMock: $isMock');
  if (isMock) {
    return ServiceTagRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return ServiceTagRemoteDataSourceImpl(apiService: apiService);
}
