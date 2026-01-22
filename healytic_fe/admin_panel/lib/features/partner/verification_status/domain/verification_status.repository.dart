import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';

/// Repository interface for verification status operations.
///
/// Defines the contract for fetching and updating provider verification
/// status. Implementations may connect to remote APIs or use mock data.
abstract class VerificationStatusRepository {
  /// Fetches the current verification status for the provider.
  ///
  /// Returns a [ProviderVerificationStatusEntity] containing all
  /// verification sections and their current states.
  Future<ProviderVerificationStatusEntity> getVerificationStatus();

  /// Resubmits the application after making requested revisions.
  ///
  /// Returns `true` if the resubmission was successful.
  Future<bool> resubmitApplication();

  /// Uploads a verification document.
  ///
  /// - [documentId]: The ID of the document being uploaded.
  /// - [filePath]: Local path to the file being uploaded.
  ///
  /// Returns the updated [VerificationDocument] with the new file URL.
  Future<VerificationDocument> uploadDocument({
    required String documentId,
    required String filePath,
  });
}
