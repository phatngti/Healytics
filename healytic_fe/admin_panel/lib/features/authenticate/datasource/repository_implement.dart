import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/features/authenticate/datasource/remote_datasource.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.repository.dart';

part 'repository_implement.g.dart';

class AuthenticateRepositoryImplement implements AuthenticateRepository {
  final AuthenticateRemoteDatasource _remoteDatasource;

  AuthenticateRepositoryImplement({
    required AuthenticateRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<SignInResponseEntity> login(SignInRequestEntity request) async {
    return _remoteDatasource.login(request);
  }
}

@Riverpod(keepAlive: true)
AuthenticateRepository authenticateRepository(Ref ref) {
  final remoteDatasource = ref.watch(authenticateRemoteDatasourceProvider);
  return AuthenticateRepositoryImplement(remoteDatasource: remoteDatasource);
}
