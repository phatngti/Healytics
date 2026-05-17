import 'package:user_app/features/profile/domain/entities/user_account.entity.dart';
import 'package:user_app/features/profile/domain/entities/profile_summary.entity.dart';
import '../../domain/repositories/profile.repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';

class ProfileImplRepository implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileImplRepository({required this.remoteDatasource});

  @override
  Future<UserAccountEntity> getAccountMe() {
    return remoteDatasource.getAccountMe();
  }

  @override
  Future<ProfileSummaryEntity> getProfileSummary() {
    return remoteDatasource.getProfileSummary();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return remoteDatasource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> deleteAccount({required String password}) {
    return remoteDatasource.deleteAccount(password: password);
  }

  @override
  Future<String> uploadAvatar({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) {
    return remoteDatasource.uploadAvatar(
      fileName: fileName,
      contentType: contentType,
      bytes: bytes,
    );
  }

  @override
  Future<void> updateAvatarUrl(String avatarUrl) {
    return remoteDatasource.updateAvatarUrl(
      avatarUrl,
    );
  }
}
