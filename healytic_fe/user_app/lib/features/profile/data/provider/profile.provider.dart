import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/profile.repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';
import '../repositories/profile_impl.repository.dart';

part 'profile.provider.g.dart';

/// Provides the [ProfileRepository] implementation
/// wired to the active remote datasource.
@riverpod
ProfileRepository profileRepository(Ref ref) {
  final remoteDatasource = ref.read(profileRemoteDatasourceProvider);
  return ProfileImplRepository(remoteDatasource: remoteDatasource);
}
