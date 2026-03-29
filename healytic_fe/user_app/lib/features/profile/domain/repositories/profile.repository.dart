import '../entities/user_account.entity.dart';

/// Contract for fetching user profile data.
abstract class ProfileRepository {
  /// Fetches the current logged-in user's account details.
  Future<UserAccountEntity> getAccountMe();
}
