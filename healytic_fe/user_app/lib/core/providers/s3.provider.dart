import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/s3.service.dart';

/// Provides a singleton [S3Service] backed by the
/// current [ApiService].
final s3ServiceProvider = Provider<S3Service>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return S3Service(apiService);
});
