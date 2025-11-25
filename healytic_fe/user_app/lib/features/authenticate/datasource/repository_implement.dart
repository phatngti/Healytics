import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/authenticate/datasource/remote_datasource.dart';
import 'package:user_app/features/authenticate/domain/authenticate.entity.dart';
import 'package:user_app/features/authenticate/domain/authenticate.repository.dart';

part 'repository_implement.g.dart';

class AuthenticateRepositoryImplement implements AuthenticateRepository {
  final AuthenticateRemoteDatasource _remoteDatasource;

  AuthenticateRepositoryImplement({
    required AuthenticateRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  }) async {
    final authenticate = await _remoteDatasource.login(
      email: email,
      password: password,
    );
    return authenticate;
  }
}

@Riverpod(keepAlive: true)
AuthenticateRepository authenticateRepository(Ref ref) {
  final remoteDatasource = ref.watch(authenticateRemoteDatasourceProvider);
  return AuthenticateRepositoryImplement(remoteDatasource: remoteDatasource);
}
