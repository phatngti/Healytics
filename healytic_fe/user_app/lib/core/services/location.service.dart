import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/entities/location_coordinate.dart';

class LocationService {
  LocationService({GeolocatorPlatform? geolocator})
    : _geolocator = geolocator ?? GeolocatorPlatform.instance;

  static final _log = Logger('LocationService');

  final GeolocatorPlatform _geolocator;

  Future<LocationPermission> requestPermission() async {
    if (!_shouldRequestOnCurrentPlatform) {
      return _geolocator.checkPermission();
    }

    var permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
    }

    _log.info('Location permission status: $permission');
    return permission;
  }

  Future<LocationCoordinate> getCurrentCoordinate({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(seconds: 15),
  }) async {
    await _ensureLocationAccess();

    try {
      final position = await _geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeLimit,
        ),
      );

      return LocationCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on TimeoutException catch (error, stackTrace) {
      _log.warning(
        'Timed out while resolving current coordinate.',
        error,
        stackTrace,
      );
      throw const LocationServiceException(
        'Timed out while fetching the current location.',
      );
    } on LocationServiceDisabledException catch (error, stackTrace) {
      _log.warning(
        'Location services were disabled while resolving coordinate.',
        error,
        stackTrace,
      );
      throw const LocationServiceException(
        'Location services are disabled on this device.',
      );
    } catch (error, stackTrace) {
      _log.warning('Failed to fetch current coordinate.', error, stackTrace);
      throw LocationServiceException(
        'Failed to fetch the current location: $error',
      );
    }
  }

  Future<LocationCoordinate?> getLastKnownCoordinate() async {
    final position = await _geolocator.getLastKnownPosition();
    if (position == null) return null;

    return LocationCoordinate(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<String?> getCurrentlyLocationAddress() async {
    return getLocationAddress(await getCurrentCoordinate());
  }

  /// Reverse-geocodes the given [coordinate] and returns
  /// a formatted address string as "City - Country".
  ///
  /// Returns `null` when no meaningful address can be
  /// resolved (e.g. middle of the ocean).
  Future<String?> getLocationAddress(LocationCoordinate coordinate) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        coordinate.latitude,
        coordinate.longitude,
      );

      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first;
      final city = _resolveCity(placemark);
      final country = placemark.country;

      if (city == null && country == null) return null;
      if (city == null) return country;
      if (country == null) return city;

      return '$city - $country';
    } catch (error, stackTrace) {
      _log.warning('Failed to reverse-geocode coordinate.', error, stackTrace);
      return null;
    }
  }

  /// Picks the best "city" field from a [Placemark],
  /// falling back through sub-administrative and
  /// administrative areas when locality is unavailable.
  String? _resolveCity(Placemark placemark) {
    final candidates = [
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
    ];

    for (final candidate in candidates) {
      if (candidate != null && candidate.isNotEmpty) {
        return candidate;
      }
    }
    return null;
  }

  Future<bool> isLocationServiceEnabled() {
    return _geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() {
    return _geolocator.checkPermission();
  }

  Future<bool> openAppSettings() {
    return _geolocator.openAppSettings();
  }

  Future<bool> openLocationSettings() {
    return _geolocator.openLocationSettings();
  }

  Future<void> _ensureLocationAccess() async {
    final serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        'Location services are disabled on this device.',
      );
    }

    var permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException('Location permission was denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permission is permanently denied. Open app settings to grant access.',
      );
    }
  }

  bool get _shouldRequestOnCurrentPlatform {
    if (kIsWeb) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
  }
}

class LocationServiceException implements Exception {
  final String message;

  const LocationServiceException(this.message);

  @override
  String toString() => message;
}
