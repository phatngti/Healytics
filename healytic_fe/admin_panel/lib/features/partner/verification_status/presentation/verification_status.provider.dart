import 'package:admin_panel/features/partner/verification_status/data/verification_status_impl.repository.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/document_verification_section.widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_status.provider.g.dart';

/// Provider for tracking pending document uploads during resubmission.
///
/// Stores a map of documentKey -> [DocumentUploadResult] for documents
/// that have been uploaded but not yet submitted to the backend.
@riverpod
class PendingUploads extends _$PendingUploads {
  @override
  Map<String, DocumentUploadResult> build() => {};

  /// Adds or updates an uploaded document in the pending uploads.
  void addUpload(DocumentUploadResult result) {
    state = {...state, result.documentKey: result};
  }

  /// Removes a document from pending uploads.
  void removeUpload(String documentKey) {
    state = Map.from(state)..remove(documentKey);
  }

  /// Clears all pending uploads.
  void clear() {
    state = {};
  }

  /// Gets all pending upload results as a list.
  List<DocumentUploadResult> get uploads => state.values.toList();
}

/// Provider for the current verification status.
///
/// Fetches the provider's verification status from the repository
/// and provides methods for resubmitting applications.
@riverpod
class VerificationStatus extends _$VerificationStatus {
  @override
  Future<ProviderVerificationStatusEntity> build() async {
    final repository = ref.watch(verificationStatusRepositoryProvider);
    return repository.getVerificationStatus();
  }

  /// Resubmits the application after making requested revisions.
  ///
  /// Collects all pending uploads and submits them along with the application.
  /// Shows loading state during submission and refreshes the status
  /// on success.
  Future<void> resubmitApplication() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(verificationStatusRepositoryProvider);
      final pendingUploadsNotifier = ref.read(pendingUploadsProvider.notifier);
      final uploads = pendingUploadsNotifier.uploads;

      print("uploads: $uploads");

      // await repository.resubmitApplication(uploads: uploads);

      // Clear pending uploads on successful submission
      // pendingUploadsNotifier.clear();
      // ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
