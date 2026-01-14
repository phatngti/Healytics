import 'package:admin_panel/features/partner/service_tags/data/service_tag_impl.repository.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_tag.provider.freezed.dart';
part 'service_tag.provider.g.dart';

/// State for service tag management
@freezed
abstract class ServiceTagState with _$ServiceTagState {
  const factory ServiceTagState({
    @Default(0) int totalCount,
    @Default(0) int currentPage,
    @Default(10) int pageSize,
    String? sortedBy,
    @Default(true) bool sortedAsc,
  }) = _ServiceTagState;
}

/// Notifier for service tag state management
@riverpod
class ServiceTagNotifier extends _$ServiceTagNotifier {
  @override
  FutureOr<ServiceTagState> build() async {
    final repo = ref.read(serviceTagRepositoryProvider);
    final totalCount = await repo.getTotalRows();
    print("totalCount: $totalCount");
    return ServiceTagState(
      totalCount: totalCount,
      currentPage: 0,
      pageSize: 10,
      sortedAsc: true,
    );
  }

  /// Fetch service tags and update state
  Future<void> fetchServiceTags({
    int? startingAt,
    int? count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final currentState = state.value ?? const ServiceTagState();
    final pageSize = count ?? currentState.pageSize;
    final offset = startingAt ?? (currentState.currentPage * pageSize);

    state = const AsyncValue.loading();

    try {
      final repo = ref.read(serviceTagRepositoryProvider);
      final totalCount = await repo.getTotalRows();

      state = AsyncValue.data(
        currentState.copyWith(
          totalCount: totalCount,
          pageSize: pageSize,
          currentPage: offset ~/ pageSize,
          sortedBy: sortedBy ?? currentState.sortedBy,
          sortedAsc: sortedAsc ?? currentState.sortedAsc,
        ),
      );
    } catch (e, st) {
      // Only update error state if provider is still mounted
      if (!ref.mounted) return;
      print('Error fetching service tags: $e');
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh current page
  Future<void> refresh() async {
    final currentState = state.value ?? const ServiceTagState();
    await fetchServiceTags(
      startingAt: currentState.currentPage * currentState.pageSize,
      count: currentState.pageSize,
    );
  }

  /// Get service tags
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final repo = ref.read(serviceTagRepositoryProvider);
    return repo.getServiceTags(
      startingAt: startingAt,
      count: count,
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );
  }

  /// Get a single service tag by ID
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id) async {
    final repo = ref.read(serviceTagRepositoryProvider);
    return repo.getServiceTagById(id);
  }

  /// Create a new service tag
  Future<ServiceTagEntity> createServiceTag(
    CreateServiceTagRequest request,
  ) async {
    final repo = ref.read(serviceTagRepositoryProvider);
    final result = await repo.createServiceTag(request);

    // Refresh state after creation
    state = AsyncValue.data(state.value ?? const ServiceTagState());

    return result;
  }

  /// Update an existing service tag
  Future<void> updateServiceTag({
    required ServiceTagId id,
    String? name,
    String? description,
    int? colorValue,
    bool? isActive,
    int? sortOrder,
  }) async {
    final repo = ref.read(serviceTagRepositoryProvider);
    await repo.updateServiceTag(
      id: id,
      name: name,
      description: description,
      colorValue: colorValue,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }

  /// Delete a service tag by ID
  Future<void> deleteServiceTag(ServiceTagId id) async {
    final repo = ref.read(serviceTagRepositoryProvider);
    await repo.deleteServiceTag(id);
  }

  /// Get active service tags for selection widgets
  Future<List<ServiceTagEntity>> getActiveServiceTags() async {
    final repo = ref.read(serviceTagRepositoryProvider);
    return repo.getActiveServiceTags();
  }
}
