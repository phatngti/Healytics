import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/domain/create_service_tag.request.dart';

/// Abstract repository interface for ServiceTag operations
/// Domain layer - no dependencies on Flutter UI, Riverpod, or HTTP clients
abstract class ServiceTagRepository {
  /// Get paginated list of service tags for table display
  Future<List<ServiceTagEntity>> getServiceTags({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  });

  /// Get all service tags for client-side filtering/sorting.
  Future<List<ServiceTagEntity>> getAllServiceTags({
    String? sortedBy,
    bool? sortedAsc,
  });

  /// Get total count of service tags
  Future<int> getTotalRows();

  /// Get a single service tag by ID
  Future<ServiceTagEntity> getServiceTagById(ServiceTagId id);

  /// Create a new service tag
  Future<ServiceTagEntity> createServiceTag(CreateServiceTagRequest request);

  /// Update an existing service tag
  Future<void> updateServiceTag({
    required ServiceTagId id,
    String? name,
    String? description,
    int? colorValue,
    bool? isActive,
    int? sortOrder,
  });

  /// Delete a service tag by ID
  Future<void> deleteServiceTag(ServiceTagId id);

  /// Get all active service tags (for selection widgets)
  Future<List<ServiceTagEntity>> getActiveServiceTags();
}
