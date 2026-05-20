import '../entities/user_account.entity.dart';
import '../entities/profile_summary.entity.dart';

/// Contract for fetching user profile data.
abstract class ProfileRepository {
  /// Fetches the current logged-in user's account details.
  Future<UserAccountEntity> getAccountMe();

  Future<ProfileSummaryEntity> getProfileSummary();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount({required String password});

  /// Uploads avatar image via S3 presigned URL.
  /// Returns the storage key for the uploaded file.
  Future<String> uploadAvatar({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  /// Persists the S3 key as the user's avatar
  /// on the backend profile.
  Future<void> updateAvatarUrl(String avatarUrl);
}
