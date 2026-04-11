import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/features/partner/profile_completion/data/profile_completion_impl.repository.dart';
import 'package:admin_panel/features/partner/profile_completion/data/profile_completion_remote.datasource.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_completion.provider.g.dart';

/// Provides the datasource with mock-switching.
@riverpod
ProfileCompletionRemoteDataSource profileCompletionDataSource(Ref ref) {
  final isMock = Store.tryGet(StoreKey.mockFlag) ?? false;
  if (isMock) {
    return ProfileCompletionRemoteDataSourceMock();
  }
  return ProfileCompletionRemoteDataSourceImpl(
    apiService: ref.read(apiServiceProvider),
  );
}

/// Provides the repository backed by the datasource.
@riverpod
ProfileCompletionRepository profileCompletionRepository(Ref ref) {
  return ProfileCompletionRepositoryImpl(
    dataSource: ref.read(profileCompletionDataSourceProvider),
    apiServiceProvider: () => ref.read(apiServiceProvider),
  );
}
