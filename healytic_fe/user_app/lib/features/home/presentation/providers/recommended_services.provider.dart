import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';
import 'package:user_app/features/home/presentation/providers/service_details.provider.dart';

/// Derives recommended services from the cached
/// [serviceDetailsProvider] for a given [serviceId].
///
/// Watches the parent provider so any upstream refresh
/// automatically propagates here.
final recommendedServicesProvider =
    FutureProvider.family<List<RecommendedServiceEntity>, String>((
      ref,
      serviceId,
    ) async {
      final details = await ref.watch(serviceDetailsProvider(serviceId).future);
      return details.recommendedServices;
    });
