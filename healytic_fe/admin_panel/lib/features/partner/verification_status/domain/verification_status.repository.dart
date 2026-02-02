import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/document_verification_section.widget.dart';

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
  /// [uploads] contains the list of re-uploaded documents to submit.
  /// Returns `true` if the resubmission was successful.
  Future<bool> resubmitApplication({
    List<DocumentUploadResult> uploads = const [],
  });
}
