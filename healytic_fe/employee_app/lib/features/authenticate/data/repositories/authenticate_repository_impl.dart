import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../datasources/remote/authenticate_remote_datasource.dart';
import '../../domain/entities/authenticate.entity.dart';
import '../../domain/repositories/authenticate.repository.dart';

part 'authenticate_repository_impl.g.dart';

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
    return await _remoteDatasource.login(email: email, password: password);
  }
}

@Riverpod(keepAlive: true)
AuthenticateRepository authenticateRepository(Ref ref) {
  final remoteDatasource = ref.watch(authenticateRemoteDatasourceProvider);
  return AuthenticateRepositoryImplement(remoteDatasource: remoteDatasource);
}
