import 'dart:developer' as developer;

import 'package:admin_panel/features/partner/service_tags/data/service_tag_impl.repository.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_tag.provider.freezed.dart';
part 'service_tag.provider.g.dart';

enum ServiceTagTableSort { name, status, usage, createdAt }

enum ServiceTagStatusFilter { all, active, inactive }

/// State for service tag management
@freezed
abstract class ServiceTagState with _$ServiceTagState {
  const factory ServiceTagState({
    @Default(0) int totalCount,
    @Default(0) int currentPage,
    @Default(10) int pageSize,
    @Default('') String searchQuery,
    @Default(ServiceTagTableSort.name) ServiceTagTableSort sortBy,
    @Default(true) bool sortAscending,
    @Default(ServiceTagStatusFilter.all) ServiceTagStatusFilter statusFilter,
    @Default(<String>{}) Set<String> selectedIds,
    @Default(0) int reloadToken,
  }) = _ServiceTagState;
}

/// Notifier for service tag state management
@riverpod
class ServiceTagNotifier extends _$ServiceTagNotifier {
  int? _visibleTagsCacheKey;
  Future<List<ServiceTagEntity>>? _visibleTagsCache;

  @override
  FutureOr<ServiceTagState> build() async {
    return const ServiceTagState();
  }

  /// Fetch service tags and update state
  Future<void> fetchServiceTags({
    int? startingAt,
    int? count,
    ServiceTagTableSort? sortBy,
    bool? sortAscending,
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
          sortBy: sortBy ?? currentState.sortBy,
          sortAscending: sortAscending ?? currentState.sortAscending,
        ),
      );
    } catch (e, st) {
      // Only update error state if provider is still mounted
      if (!ref.mounted) return;
      developer.log(
        'Error fetching service tags',
        name: 'ServiceTagNotifier',
        error: e,
        stackTrace: st,
      );
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh current page
  Future<void> refresh() async {
    final current = _currentState;
    _invalidateVisibleTagsCache();
    _setTableState(
      current.copyWith(
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  /// Get service tags
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    ServiceTagTableSort? sortBy,
    bool? sortAscending,
  }) async {
    final repo = ref.read(serviceTagRepositoryProvider);
    return repo.getServiceTags(
      startingAt: startingAt,
      count: count,
      sortedBy: sortBy?.name,
      sortedAsc: sortAscending,
    );
  }

  Future<int> getVisibleTotalRows() async {
    return (await _getVisibleServiceTags()).length;
  }

  Future<List<ServiceTagEntity>> getVisiblePage({
    required int startingAt,
    required int count,
  }) async {
    final tags = await _getVisibleServiceTags();
    return _page(tags, startingAt, count);
  }

  void setSearchQuery(String value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        searchQuery: value,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setSort(ServiceTagTableSort sortBy) {
    final current = _currentState;
    final nextAscending = current.sortBy == sortBy
        ? !current.sortAscending
        : _defaultSortAscending(sortBy);
    _setTableState(
      current.copyWith(
        sortBy: sortBy,
        sortAscending: nextAscending,
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setStatusFilter(ServiceTagStatusFilter value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        statusFilter: value,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void toggleSelection(String id, bool selected) {
    final current = _currentState;
    final selectedIds = {...current.selectedIds};
    if (selected) {
      selectedIds.add(id);
    } else {
      selectedIds.remove(id);
    }
    _setTableState(current.copyWith(selectedIds: selectedIds));
  }

  void clearSelection() {
    final current = _currentState;
    if (current.selectedIds.isEmpty) return;
    _setTableState(current.copyWith(selectedIds: const <String>{}));
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

  Future<void> deleteOne(String id) async {
    final repo = ref.read(serviceTagRepositoryProvider);
    await repo.deleteServiceTag(ServiceTagId(id));
    _afterDelete(idsToRemove: {id});
  }

  Future<void> deleteSelected() async {
    final ids = _currentState.selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    final repo = ref.read(serviceTagRepositoryProvider);
    await Future.wait(ids.map((id) => repo.deleteServiceTag(ServiceTagId(id))));
    _afterDelete(idsToRemove: ids.toSet());
  }

  /// Get active service tags for selection widgets
  Future<List<ServiceTagEntity>> getActiveServiceTags() async {
    final repo = ref.read(serviceTagRepositoryProvider);
    return repo.getActiveServiceTags();
  }

  ServiceTagState get _currentState => state.value ?? const ServiceTagState();

  void _setTableState(ServiceTagState value) {
    state = AsyncValue.data(value);
  }

  void _afterDelete({required Set<String> idsToRemove}) {
    final current = _currentState;
    _invalidateVisibleTagsCache();
    _setTableState(
      current.copyWith(
        selectedIds: current.selectedIds.difference(idsToRemove),
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  Future<List<ServiceTagEntity>> _getVisibleServiceTags() async {
    final cacheKey = _visibleTagsKey(_currentState);
    final cached = _visibleTagsCache;
    if (_visibleTagsCacheKey == cacheKey && cached != null) {
      return cached;
    }

    final future = _loadVisibleServiceTags(cacheKey);
    _visibleTagsCacheKey = cacheKey;
    _visibleTagsCache = future;
    return future;
  }

  Future<List<ServiceTagEntity>> _loadVisibleServiceTags(int cacheKey) async {
    try {
      return await _fetchVisibleServiceTags();
    } catch (_) {
      if (_visibleTagsCacheKey == cacheKey) {
        _invalidateVisibleTagsCache();
      }
      rethrow;
    }
  }

  Future<List<ServiceTagEntity>> _fetchVisibleServiceTags() async {
    final repo = ref.read(serviceTagRepositoryProvider);
    final tags = await repo.getAllServiceTags();
    final query = _currentState;
    final normalizedSearch = query.searchQuery.trim().toLowerCase();

    final filtered = tags.where((tag) {
      final matchesSearch =
          normalizedSearch.isEmpty ||
          tag.name.toLowerCase().contains(normalizedSearch) ||
          tag.description.toLowerCase().contains(normalizedSearch);

      final matchesStatus = switch (query.statusFilter) {
        ServiceTagStatusFilter.all => true,
        ServiceTagStatusFilter.active => tag.isActive,
        ServiceTagStatusFilter.inactive => !tag.isActive,
      };

      return matchesSearch && matchesStatus;
    }).toList();

    filtered.sort((a, b) {
      final comparison = switch (query.sortBy) {
        ServiceTagTableSort.name => _compareText(a.name, b.name),
        ServiceTagTableSort.status => (a.isActive ? 1 : 0).compareTo(
          b.isActive ? 1 : 0,
        ),
        ServiceTagTableSort.usage => a.usage.compareTo(b.usage),
        ServiceTagTableSort.createdAt => _compareNullableDateString(
          a.createdAt,
          b.createdAt,
        ),
      };
      return query.sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  int _visibleTagsKey(ServiceTagState state) {
    return Object.hash(
      state.searchQuery,
      state.sortBy,
      state.sortAscending,
      state.statusFilter,
      state.reloadToken,
    );
  }

  void _invalidateVisibleTagsCache() {
    _visibleTagsCacheKey = null;
    _visibleTagsCache = null;
  }

  List<T> _page<T>(List<T> items, int startingAt, int count) {
    if (startingAt >= items.length) return [];
    final end = (startingAt + count).clamp(0, items.length);
    return items.sublist(startingAt.clamp(0, items.length), end);
  }

  int _compareText(String a, String b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  }

  bool _defaultSortAscending(ServiceTagTableSort sortBy) {
    return switch (sortBy) {
      ServiceTagTableSort.createdAt => false,
      _ => true,
    };
  }

  int _compareNullableDateString(String? a, String? b) {
    final left = a == null ? null : DateTime.tryParse(a);
    final right = b == null ? null : DateTime.tryParse(b);
    if (left != null || right != null) {
      if (left == null) return -1;
      if (right == null) return 1;
      return left.compareTo(right);
    }
    return (a ?? '').compareTo(b ?? '');
  }
}
