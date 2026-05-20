import 'dart:io' show HttpStatus;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/authenticate/data/datasources/remote/authenticate_remote_datasource.dart';
import 'package:user_app/features/authenticate/data/services/google_sign_in.service.dart';
import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';
import 'package:user_app/features/authenticate/domain/repositories/authenticate.repository.dart';
import 'package:user_openapi/api.dart';

part 'authenticate_repository_impl.g.dart';

class AuthenticateRepositoryImplement implements AuthenticateRepository {
  final AuthenticateRemoteDatasource _remoteDatasource;
  final GoogleSignInService _googleSignInService;

  AuthenticateRepositoryImplement({
    required AuthenticateRemoteDatasource remoteDatasource,
    required GoogleSignInService googleSignInService,
  }) : _remoteDatasource = remoteDatasource,
       _googleSignInService = googleSignInService;

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

  @override
  Future<AuthenticateEntity> signInWithGoogle() async {
    final result = await _googleSignInService.signIn();
    if (result == null) {
      throw const GoogleSignInCancelledException();
    }
    if (result.idToken.isEmpty) {
      throw ApiException(
        HttpStatus.badRequest,
        'Google did not return an ID token',
      );
    }
    return _remoteDatasource.signInWithGoogle(idToken: result.idToken);
  }

  @override
  Future<void> requestPasswordReset({required String email}) {
    return _remoteDatasource.requestPasswordReset(email: email);
  }

  @override
  Future<String> validatePasswordResetCode({
    required String email,
    required String code,
  }) {
    return _remoteDatasource.validatePasswordResetCode(
      email: email,
      code: code,
    );
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) {
    return _remoteDatasource.resetPassword(token: token, password: password);
  }
}

@Riverpod(keepAlive: true)
AuthenticateRepository authenticateRepository(Ref ref) {
  final remoteDatasource = ref.watch(authenticateRemoteDatasourceProvider);
  final googleSignInService = ref.watch(googleSignInServiceProvider);
  return AuthenticateRepositoryImplement(
    remoteDatasource: remoteDatasource,
    googleSignInService: googleSignInService,
  );
}
