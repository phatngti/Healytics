import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';

/// Abstract repository contract for partner profile
/// completion operations. Implemented in the data
/// layer and consumed by presentation notifiers.
abstract class ProfileCompletionRepository {
  /// Loads the current profile completion state
  /// including checklist and clinic identity.
  Future<PartnerProfileCompletionEntity> getProfileCompletion();

  /// Persists updated profile fields and returns
  /// the refreshed completion state.
  Future<PartnerProfileCompletionEntity> updateProfileCompletion(
    PartnerProfileCompletionUpdateRequest request,
  );

  /// Persists updated profile fields, refreshes the
  /// partner JWT session, and returns the updated
  /// completion state. Sets session flags so the
  /// router recognises a completed profile.
  Future<PartnerProfileCompletionEntity> completeProfile(
    PartnerProfileCompletionUpdateRequest request,
  );
}
