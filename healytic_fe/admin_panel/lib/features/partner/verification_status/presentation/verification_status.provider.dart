import 'package:admin_panel/features/partner/verification_status/data/verification_status_impl.repository.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_status.provider.g.dart';

/// Provider for the current verification status.
///
/// Fetches the provider's verification status from the repository
/// and provides methods for resubmitting applications and uploading documents.
@riverpod
class VerificationStatus extends _$VerificationStatus {
  @override
  Future<ProviderVerificationStatusEntity> build() async {
    final repository = ref.watch(verificationStatusRepositoryProvider);
    return repository.getVerificationStatus();
  }

  /// Resubmits the application after making requested revisions.
  ///
  /// Shows loading state during submission and refreshes the status
  /// on success.
  Future<void> resubmitApplication() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(verificationStatusRepositoryProvider);
      await repository.resubmitApplication();
      // Refresh the status after resubmission
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Uploads a verification document.
  ///
  /// - [documentId]: The ID of the document being uploaded.
  /// - [filePath]: Local path to the file being uploaded.
  ///
  /// Returns the updated document on success.
  Future<VerificationDocument?> uploadDocument({
    required String documentId,
    required String filePath,
  }) async {
    try {
      final repository = ref.read(verificationStatusRepositoryProvider);
      final updatedDoc = await repository.uploadDocument(
        documentId: documentId,
        filePath: filePath,
      );
      // Refresh the status after upload
      ref.invalidateSelf();
      return updatedDoc;
    } catch (e) {
      // Re-throw to let the UI handle the error
      rethrow;
    }
  }
}
