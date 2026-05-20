import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/location_entity.dart';
import 'package:user_openapi/api.dart';

LocationEntity _mapLocationDto(LocationResponseDto dto) {
  return LocationEntity(
    id: dto.id,
    name: dto.name,
    fullName: dto.fullName,
    level: dto.level,
  );
}

final provincesProvider = FutureProvider.autoDispose<List<LocationEntity>>((
  ref,
) async {
  developer.log('Fetching provinces...', name: 'SignUpLocationProvider');

  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.locationsApi
      .locationsControllerGetProvinces();

  return response?.data.map(_mapLocationDto).toList() ??
      const <LocationEntity>[];
});

final districtsProvider = FutureProvider.autoDispose
    .family<List<LocationEntity>, String?>((ref, provinceId) async {
      if (provinceId == null || provinceId.isEmpty) {
        return const <LocationEntity>[];
      }

      developer.log(
        'Fetching districts for province: $provinceId',
        name: 'SignUpLocationProvider',
      );

      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.locationsApi
          .locationsControllerGetDistricts(provinceId);

      return response?.data.map(_mapLocationDto).toList() ??
          const <LocationEntity>[];
    });

final wardsProvider = FutureProvider.autoDispose
    .family<List<LocationEntity>, String?>((ref, districtId) async {
      if (districtId == null || districtId.isEmpty) {
        return const <LocationEntity>[];
      }

      developer.log(
        'Fetching wards for district: $districtId',
        name: 'SignUpLocationProvider',
      );

      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.locationsApi
          .locationsControllerGetWards(districtId);

      return response?.data.map(_mapLocationDto).toList() ??
          const <LocationEntity>[];
    });
