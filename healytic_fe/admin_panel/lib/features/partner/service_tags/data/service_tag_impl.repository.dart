import 'package:admin_panel/features/partner/service_tags/data/service_tag_remote.datasource.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/domain/service_tag.repository.dart';
import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_tag_impl.repository.g.dart';

/// Repository implementation that delegates to the data source
class ServiceTagImplRepository implements ServiceTagRepository {
  final ServiceTagRemoteDataSource remoteDataSource;

  ServiceTagImplRepository({required this.remoteDataSource});

  @override
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) {
    return remoteDataSource.getServiceTags(
      startingAt: startingAt,
      count: count,
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );
  }

  @override
  Future<int> getTotalRows() {
    return remoteDataSource.getTotalRows();
  }

  @override
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id) {
    return remoteDataSource.getServiceTagById(id);
  }

  @override
  Future<ServiceTagEntity> createServiceTag(CreateServiceTagRequest request) {
    return remoteDataSource.createServiceTag(request);
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
    return remoteDataSource.updateServiceTag(
      id: id,
      name: name,
      description: description,
      colorValue: colorValue,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<void> deleteServiceTag(ServiceTagId id) {
    return remoteDataSource.deleteServiceTag(id);
  }

  @override
  Future<List<ServiceTagEntity>> getActiveServiceTags() {
    return remoteDataSource.getActiveServiceTags();
  }
}

/// Provider for the service tag repository
@riverpod
ServiceTagRepository serviceTagRepository(Ref ref) {
  final remoteDataSource = ref.read(serviceTagRemoteDataSourceProvider);
  return ServiceTagImplRepository(remoteDataSource: remoteDataSource);
}
