import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/features/partner/profile_completion/data/profile_completion_remote.datasource.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.repository.dart';

/// Concrete repository that delegates to
/// [ProfileCompletionRemoteDataSource] and handles
/// session refresh logic after profile completion.
class ProfileCompletionRepositoryImpl implements ProfileCompletionRepository {
  ProfileCompletionRepositoryImpl({
    required this.dataSource,
    required this.apiServiceProvider,
  });

  /// The underlying remote data source.
  final ProfileCompletionRemoteDataSource dataSource;

  /// Provider for [ApiService], used to persist
  /// refreshed tokens after session reload.
  final ApiServiceProvider apiServiceProvider;

  @override
  Future<PartnerProfileCompletionEntity> getProfileCompletion() {
    return dataSource.getProfileCompletion();
  }

  @override
  Future<PartnerProfileCompletionEntity> updateProfileCompletion(
    PartnerProfileCompletionUpdateRequest request,
  ) {
    return dataSource.updateProfileCompletion(request);
  }

  @override
  Future<PartnerProfileCompletionEntity> completeProfile(
    PartnerProfileCompletionUpdateRequest request,
  ) async {
    final result = await dataSource.updateProfileCompletion(request);

    final tokens = await dataSource.refreshPartnerSession();
    if (tokens != null) {
      await _syncPartnerSession(tokens);
    } else {
      await UserRoleHelper.setPartnerProfileCompleted(
        result.isCompleted,
      );
    }

    return result;
  }

  // ── Private helpers ───────────────────────────

  Future<void> _syncPartnerSession(dynamic tokens) async {
    final apiService = apiServiceProvider.call();
    await apiService.setAccessToken(tokens.accessToken);
    await Store.put(StoreKey.refreshToken, tokens.refreshToken);
    await UserRoleHelper.syncPartnerFlagsFromAccessToken(
      tokens.accessToken,
    );
  }
}

/// Typedef for the API service factory used in
/// the repository to avoid a direct Riverpod import
/// in the data layer.
typedef ApiServiceProvider = dynamic Function();
