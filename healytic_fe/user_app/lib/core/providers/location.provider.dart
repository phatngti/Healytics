import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/core/services/location.service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Resolves the current device location into a
/// human-readable "City - Country" string.
final currentLocationAddressProvider = FutureProvider<String?>((ref) async {
  final service = ref.read(locationServiceProvider);
  return service.getCurrentlyLocationAddress();
});
