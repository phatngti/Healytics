import '../entities/user_account.entity.dart';
import '../entities/profile_summary.entity.dart';
import '../entities/account_address.entity.dart';

/// Contract for fetching user profile data.
abstract class ProfileRepository {
  /// Fetches the current logged-in user's account details.
  Future<UserAccountEntity> getAccountMe();

  /// Fetches the formatted address captured during registration.
  Future<String?> getAccountLocation();

  /// Fetches the structured address captured during registration.
  Future<AccountAddressEntity?> getAccountAddress();

  Future<ProfileSummaryEntity> getProfileSummary();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount({required String password});

  Future<void> updateAccountAddress({
    required String streetAddress,
    required String provinceId,
    required String districtId,
    required String wardId,
  });

  Future<void> updateAccountProfile({
    required String firstName,
    String? lastName,
    String? phone,
  });

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
