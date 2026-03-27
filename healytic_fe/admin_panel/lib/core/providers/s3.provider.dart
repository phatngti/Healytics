import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/s3.service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 's3.provider.g.dart';

@Riverpod(keepAlive: true)
S3Service s3Service(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return S3Service(apiService);
}
