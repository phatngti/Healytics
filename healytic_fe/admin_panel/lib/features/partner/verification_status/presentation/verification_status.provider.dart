import 'package:admin_panel/features/partner/verification_status/data/verification_status_impl.repository.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/document_verification_section.widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_status.provider.g.dart';

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
  /// Accepts [formValues] from FormBuilder containing all edited fields
  /// and uploaded documents. Returns a record with success status and
  /// optional error message.
  Future<({bool success, String? errorMessage})> resubmitApplication({
    required Map<String, dynamic> formValues,
  }) async {
    final previousState = state;
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(verificationStatusRepositoryProvider);

      // Extract edits (String/List values) and uploads (DocumentUploadResult values)
      final edits = <String, dynamic>{};
      final uploads = <DocumentUploadResult>[];

      formValues.forEach((key, value) {
        if (value is String && value.isNotEmpty) {
          edits[key] = value;
        } else if (value is List) {
          edits[key] = value;
        } else if (value is DocumentUploadResult) {
          uploads.add(value);
        }
      });

      // Call the repository to update the partner profile
      await repository.resubmitApplication(uploads: uploads, edits: edits);

      // Refresh the verification status
      ref.invalidateSelf();

      return (success: true, errorMessage: null);
    } catch (e) {
      // Restore previous state on error
      state = previousState;
      return (success: false, errorMessage: e.toString());
    }
  }
}
