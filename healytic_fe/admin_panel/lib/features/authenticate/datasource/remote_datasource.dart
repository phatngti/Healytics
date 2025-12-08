import 'dart:io';

import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';

part 'remote_datasource.g.dart';

abstract class AuthenticateRemoteDatasource {
  Future<SignInResponseEntity> login(SignInRequestEntity request);
}

class AuthenticateRemoteDatasourceImpl implements AuthenticateRemoteDatasource {
  final ApiService apiService;

  AuthenticateRemoteDatasourceImpl({required this.apiService});

  @override
  Future<SignInResponseEntity> login(SignInRequestEntity request) async {
    final response = await apiService.authenticateApi.authControllerLogin(
      LoginDto(email: request.email, password: request.password),
    );

    if (response == null) {
      throw ApiException(HttpStatus.notFound, 'Login response is null');
    }

    return SignInResponseEntity(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      role:
          'admin', // Placeholder, actual role logic might need adjustment when integrating real API
    );
  }
}

@Riverpod(keepAlive: true)
AuthenticateRemoteDatasource authenticateRemoteDatasource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthenticateRemoteDatasourceImpl(apiService: apiService);
}
