import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/features/partner/profile_edit/data/public_profile_impl.repository.dart';
import 'package:admin_panel/features/partner/profile_edit/data/public_profile_remote.datasource.dart';
import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_profile.provider.g.dart';

/// Provides the datasource with mock-switching.
@riverpod
PublicProfileRemoteDataSource
    publicProfileDataSource(Ref ref) {
  final isMock =
      Store.tryGet(StoreKey.mockFlag) ?? false;
  if (isMock) {
    return PublicProfileRemoteDataSourceMock();
  }
  return PublicProfileRemoteDataSourceImpl(
    apiService: ref.read(apiServiceProvider),
  );
}

/// Provides the repository backed by the
/// datasource.
@riverpod
PublicProfileRepository publicProfileRepository(
  Ref ref,
) {
  return PublicProfileRepositoryImpl(
    dataSource: ref.read(
      publicProfileDataSourceProvider,
    ),
  );
}
