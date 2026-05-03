import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';

/// Abstract repository contract for partner public
/// profile edit operations. Implemented in the data
/// layer and consumed by presentation notifiers.
abstract class PublicProfileRepository {
  /// Loads the full public profile aggregate
  /// including read-only context and editable
  /// storefront fields.
  Future<PartnerPublicProfileEntity> getPublicProfile();

  /// Persists updated storefront fields and
  /// returns the refreshed profile aggregate
  /// with recalculated completion summary.
  Future<PartnerPublicProfileEntity> updatePublicProfile(
    PublicProfileUpdateRequest request,
  );
}
