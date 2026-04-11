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
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      BusinessServiceDto(
        value: 'SPA_BEAUTY',
        label: 'Spa & Beauty',
        description: 'Spa & Làm đẹp',
      ),
      BusinessServiceDto(
        value: 'MASSAGE_THERAPY',
        label: 'Massage Therapy',
        description: 'Massage Thư giãn',
      ),
      BusinessServiceDto(
        value: 'MASSAGE_REHABILITATION',
        label: 'Rehabilitation Massage',
        description: 'Massage Trị liệu',
      ),
      BusinessServiceDto(
        value: 'FITNESS',
        label: 'Fitness (Gym/Yoga)',
        description: 'Thể hình (Gym/Yoga)',
      ),
      BusinessServiceDto(
        value: 'DENTAL',
        label: 'Dental',
        description: 'Nha khoa',
      ),
      BusinessServiceDto(
        value: 'DERMATOLOGY',
        label: 'Dermatology & Aesthetics',
        description: 'Da liễu & Thẩm mỹ',
      ),
    ];
  }

  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.partnersApi
      .partnersControllerGetBusinessServices();

  return response?.data ?? [];
}
