import 'dart:developer' as developer;

import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/features/authenticate/domain/location.entity.dart';
import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location.provider.g.dart';

/// Maps a [LocationResponseDto] from the API
/// to a [LocationEntity] domain model.
LocationEntity _mapLocationDto(LocationResponseDto dto) {
  return LocationEntity(
    id: dto.id,
    name: dto.name,
    fullName: dto.fullName,
    level: dto.level,
  );
}

/// Provider that fetches all provinces from the API.
///
/// This is the top-level provider in the location cascade.
/// Districts depend on the selected province, and wards depend on the
/// selected district.
@riverpod
Future<List<LocationEntity>> provinces(Ref ref) async {
  developer.log('Fetching provinces...', name: 'LocationProvider');

  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.locationsApi
      .locationsControllerGetProvinces();

  if (response == null) {
    developer.log('No provinces data received', name: 'LocationProvider');
    return [];
  }

  final provinces = response.data.map(_mapLocationDto).toList();
  developer.log(
    'Fetched ${provinces.length} provinces',
    name: 'LocationProvider',
  );

  return provinces;
}

/// Provider that fetches districts for a given province.
///
/// The [provinceId] parameter determines which province's districts to fetch.
/// Returns an empty list if provinceId is null or empty.
@riverpod
Future<List<LocationEntity>> districts(Ref ref, String? provinceId) async {
  if (provinceId == null || provinceId.isEmpty) {
    return [];
  }

  developer.log(
    'Fetching districts for province: $provinceId',
    name: 'LocationProvider',
  );

  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.locationsApi
      .locationsControllerGetDistricts(provinceId);

  if (response == null) {
    developer.log('No districts data received', name: 'LocationProvider');
    return [];
  }

  final districts = response.data.map(_mapLocationDto).toList();
  developer.log(
    'Fetched ${districts.length} districts',
    name: 'LocationProvider',
  );

  return districts;
}

/// Provider that fetches wards for a given district.
///
/// The [districtId] parameter determines which district's wards to fetch.
/// Returns an empty list if districtId is null or empty.
@riverpod
Future<List<LocationEntity>> wards(Ref ref, String? districtId) async {
  if (districtId == null || districtId.isEmpty) {
    return [];
  }

  developer.log(
    'Fetching wards for district: $districtId',
    name: 'LocationProvider',
  );

  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.locationsApi.locationsControllerGetWards(
    districtId,
  );

  if (response == null) {
    developer.log('No wards data received', name: 'LocationProvider');
    return [];
  }

  final wards = response.data.map(_mapLocationDto).toList();
  developer.log('Fetched ${wards.length} wards', name: 'LocationProvider');

  return wards;
}
