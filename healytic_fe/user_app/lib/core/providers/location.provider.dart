import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/core/services/location.service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});
