import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_services.provider.g.dart';

/// Provider that fetches business services from the API.
///
/// Returns a list of [BusinessServiceDto] containing value, label and description.
@riverpod
Future<List<BusinessServiceDto>> businessServices(Ref ref) async {
  final isMock = Store.get(StoreKey.mockFlag, false);

  if (isMock) {
    // Return mock data for development/testing
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      BusinessServiceDto(
        value: 'spa',
        label: 'Spa & Wellness',
        description: 'Relaxation and wellness services',
      ),
      BusinessServiceDto(
        value: 'beauty',
        label: 'Beauty & Aesthetics',
        description: 'Beauty treatments and aesthetics',
      ),
      BusinessServiceDto(
        value: 'medical',
        label: 'Medical Services',
        description: 'Medical and healthcare services',
      ),
      BusinessServiceDto(
        value: 'fitness',
        label: 'Fitness & Health',
        description: 'Fitness and health services',
      ),
      BusinessServiceDto(
        value: 'salon',
        label: 'Hair Salon',
        description: 'Hair care and styling services',
      ),
      BusinessServiceDto(
        value: 'massage',
        label: 'Massage Therapy',
        description: 'Professional massage services',
      ),
    ];
  }

  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.partnersApi
      .partnersControllerGetBusinessServices();

  return response?.data ?? [];
}
