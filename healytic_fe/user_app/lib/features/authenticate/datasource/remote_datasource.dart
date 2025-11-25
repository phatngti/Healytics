import 'dart:io';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/authenticate/domain/authenticate.entity.dart';

part 'remote_datasource.g.dart';

abstract class AuthenticateRemoteDatasource {
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  });
}

class AuthenticateRemoteDatasourceImpl implements AuthenticateRemoteDatasource {
  final ApiService apiService;

  AuthenticateRemoteDatasourceImpl({required this.apiService});

  @override
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await apiService.authenticateApi.authControllerLogin(
      LoginDto(email: email, password: password),
    );

    if (response == null) {
      throw ApiException(HttpStatus.notFound, 'Login response is null');
    }

    // 1. Decode lấy dữ liệu (Payload)
    Map<String, dynamic> decodedToken = JwtDecoder.decode(response.accessToken);
    var basicInfo = BasicInfoEntity(email: decodedToken['email'] as String);
    if (decodedToken['profile'] != null) {
      basicInfo = basicInfo.copyWith(
        name:
            ('${decodedToken['profile']['firstName']} ${decodedToken['profile']['lastName']}'),
      );
    }

    return AuthenticateEntity.fromJson({
      'accessToken': response.accessToken,
      'refreshToken': response.refreshToken,
      'basicInfo': basicInfo.toJson(),
    });
  }
}

@Riverpod(keepAlive: true)
AuthenticateRemoteDatasource authenticateRemoteDatasource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthenticateRemoteDatasourceImpl(apiService: apiService);
}
