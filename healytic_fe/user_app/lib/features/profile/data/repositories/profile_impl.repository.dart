import 'package:user_app/features/profile/domain/entities/user_account.entity.dart';
import '../../domain/repositories/profile.repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';

class ProfileImplRepository implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileImplRepository({required this.remoteDatasource});

  @override
  Future<UserAccountEntity> getAccountMe() {
    return remoteDatasource.getAccountMe();
  }
}
