import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/core/services/image_upload.service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_upload.provider.g.dart';

/// Provides a singleton [ImageUploadService] backed
/// by the existing [S3Service].
@Riverpod(keepAlive: true)
ImageUploadService imageUploadService(Ref ref) {
  final s3 = ref.watch(s3ServiceProvider);
  return ImageUploadService(s3);
}
