import 'dart:async';

import 'package:flutter/foundation.dart';
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
