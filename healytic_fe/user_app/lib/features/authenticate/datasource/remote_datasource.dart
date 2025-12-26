import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/authenticate/domain/authenticate.entity.dart';
import 'package:user_openapi/api.dart';

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
    debugPrint('decodedToken: $decodedToken');
    if (decodedToken['firstName'] != null && decodedToken['lastName'] != null) {
      basicInfo = basicInfo.copyWith(
        name: ('${decodedToken['firstName']} ${decodedToken['lastName']}'),
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
