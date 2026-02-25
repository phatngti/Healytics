import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/home/data/datasources/remote/service_details_remote_datasource.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Provider for fetching service details by [serviceId].
///
/// Uses `.family` so each service ID gets its own cached state.
final serviceDetailsProvider =
    FutureProvider.family<ServiceDetailsEntity, String>((ref, serviceId) async {
      final datasource = ref.read(serviceDetailsRemoteDatasourceProvider);
      return datasource.getServiceDetails(serviceId);
    });
