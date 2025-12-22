import 'dart:io';

import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';

part 'remote_datasource.g.dart';

abstract class AuthenticateRemoteDatasource {
  Future<SignInResponseEntity> login(SignInRequestEntity request, String role);
}

class AuthenticateRemoteDatasourceImpl implements AuthenticateRemoteDatasource {
  final ApiService apiService;

  AuthenticateRemoteDatasourceImpl({required this.apiService});

  @override
  Future<SignInResponseEntity> login(
    SignInRequestEntity request,
    String role,
  ) async {
    AuthTokensDto? response;

    if (role == 'admin') {
      response = await apiService.authenticateApi.authControllerLoginAdmin(
        AdminLoginDto(email: request.email, password: request.password),
      );
    } else if (role == 'user') {
      response = await apiService.authenticateApi.authControllerLoginUser(
        LoginDto(email: request.email, password: request.password),
      );
    } else {
      response = await apiService.authenticateApi.authControllerLogin(
        LoginDto(email: request.email, password: request.password),
      );
    }

    if (response == null) {
      throw ApiException(HttpStatus.notFound, 'Login response is null');
    }

    return SignInResponseEntity(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      role: role,
    );
  }
}

@Riverpod(keepAlive: true)
AuthenticateRemoteDatasource authenticateRemoteDatasource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthenticateRemoteDatasourceImpl(apiService: apiService);
}
