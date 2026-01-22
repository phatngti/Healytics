import 'package:admin_panel/features/partner/verification_status/data/verification_status_remote.datasource.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_status_impl.repository.g.dart';

/// Flag to switch between mock and real data source.
///
/// Set to `false` to use mock data during development.
const bool _useRealApi = false;

/// Implementation of [VerificationStatusRepository].
///
/// Delegates operations to the appropriate data source based on
/// the [_useRealApi] flag.
class VerificationStatusRepositoryImpl implements VerificationStatusRepository {
  /// Creates a new [VerificationStatusRepositoryImpl].
  VerificationStatusRepositoryImpl({
    required VerificationStatusRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final VerificationStatusRemoteDataSource _dataSource;

  @override
  Future<ProviderVerificationStatusEntity> getVerificationStatus() {
    return _dataSource.getVerificationStatus();
  }

  @override
  Future<bool> resubmitApplication() {
    return _dataSource.resubmitApplication();
  }

  @override
  Future<VerificationDocument> uploadDocument({
    required String documentId,
    required String filePath,
  }) {
    return _dataSource.uploadDocument(
      documentId: documentId,
      filePath: filePath,
    );
  }
}

/// Provides the verification status data source.
@riverpod
VerificationStatusRemoteDataSource verificationStatusDataSource(Ref ref) {
  if (_useRealApi) {
    return VerificationStatusRemoteDataSourceImpl();
  }
  return VerificationStatusRemoteDataSourceMock();
}

/// Provides the verification status repository.
@riverpod
VerificationStatusRepository verificationStatusRepository(Ref ref) {
  final dataSource = ref.watch(verificationStatusDataSourceProvider);
  return VerificationStatusRepositoryImpl(dataSource: dataSource);
}
