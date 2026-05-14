import 'package:admin_panel/features/partner/service_tags/data/service_tag_impl.repository.dart';
import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.repository.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/providers/service_tag.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'visible total and page rows share one service-tag list fetch',
    () async {
      final repository = _CountingServiceTagRepository(_serviceTags);
      final container = ProviderContainer(
        overrides: [serviceTagRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(serviceTagProvider.future);
      final notifier = container.read(serviceTagProvider.notifier);

      final totalRows = await notifier.getVisibleTotalRows();
      final page = await notifier.getVisiblePage(startingAt: 0, count: 2);

      expect(totalRows, _serviceTags.length);
      expect(page, hasLength(2));
      expect(repository.getAllCalls, 1);

      await notifier.getVisibleTotalRows();
      expect(repository.getAllCalls, 1);

      await notifier.refresh();
      await notifier.getVisibleTotalRows();
      expect(repository.getAllCalls, 2);
    },
  );
}

final _serviceTags = [
  ServiceTagEntity(
    id: ServiceTagId('beauty'),
    name: 'Beauty',
    description: 'Beauty services',
    colorValue: 0xFFE91E63,
    usage: 0,
    isActive: true,
    sortOrder: 1,
  ),
  ServiceTagEntity(
    id: ServiceTagId('dental'),
    name: 'Dental Care',
    description: 'Dental services',
    colorValue: 0xFF00BCD4,
    usage: 0,
    isActive: true,
    sortOrder: 2,
  ),
  ServiceTagEntity(
    id: ServiceTagId('fitness'),
    name: 'Fitness',
    description: 'Fitness services',
    colorValue: 0xFF009688,
    usage: 0,
    isActive: false,
    sortOrder: 3,
  ),
];

class _CountingServiceTagRepository implements ServiceTagRepository {
  _CountingServiceTagRepository(this.tags);

  final List<ServiceTagEntity> tags;
  int getAllCalls = 0;

  @override
  Future<List<ServiceTagEntity>> getAllServiceTags({
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    getAllCalls += 1;
    return [...tags];
  }

  @override
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final allTags = await getAllServiceTags(
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );
    final end = (startingAt + count).clamp(0, allTags.length);
    return allTags.sublist(startingAt.clamp(0, allTags.length), end);
  }

  @override
  Future<int> getTotalRows() async => tags.length;

  @override
  Future<List<ServiceTagEntity>> getActiveServiceTags() async {
    return tags.where((tag) => tag.isActive).toList();
  }

  @override
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id) async {
    return tags.firstWhere((tag) => tag.id == id);
  }

  @override
  Future<ServiceTagEntity> createServiceTag(CreateServiceTagRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateServiceTag({
    required ServiceTagId id,
    String? name,
    String? description,
    int? colorValue,
    bool? isActive,
    int? sortOrder,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteServiceTag(ServiceTagId id) {
    throw UnimplementedError();
  }
}
