import 'package:admin_panel/features/partner/profile_edit/data/public_profile_remote.datasource.dart';
import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.repository.dart';

/// Concrete repository that delegates to
/// [PublicProfileRemoteDataSource].
class PublicProfileRepositoryImpl implements PublicProfileRepository {
  PublicProfileRepositoryImpl({required this.dataSource});

  /// The underlying remote data source.
  final PublicProfileRemoteDataSource dataSource;

  @override
  Future<PartnerPublicProfileEntity> getPublicProfile() {
    return dataSource.getPublicProfile();
  }

  @override
  Future<PartnerPublicProfileEntity> updatePublicProfile(
    PublicProfileUpdateRequest request,
  ) {
    return dataSource.updatePublicProfile(request);
  }
}
