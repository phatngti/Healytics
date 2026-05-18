import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';
import 'package:user_openapi/api.dart';

part 'authenticate_remote_datasource.g.dart';

abstract class AuthenticateRemoteDatasource {
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  });

  Future<void> requestPasswordReset({required String email});
}

class AuthenticateRemoteDatasourceImpl implements AuthenticateRemoteDatasource {
  final ApiService apiService;

  AuthenticateRemoteDatasourceImpl({required this.apiService});

  @override
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await apiService.authenticateApi.authControllerLoginUser(
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

  @override
  Future<void> requestPasswordReset({required String email}) async {
    final response = await apiService.apiClient.invokeAPI(
      '/auth/user/forgot-password',
      'POST',
      const [],
      {'email': email.trim().toLowerCase()},
      {'Content-Type': 'application/json'},
      {},
      'application/json',
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        response.statusCode,
        _messageFromResponse(
          response.body,
          'Unable to send password reset email',
        ),
      );
    }
  }

  String _messageFromResponse(String body, String fallback) {
    if (body.isEmpty) return fallback;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
        if (message is List && message.isNotEmpty) {
          return message.join('\n');
        }
      }
    } catch (_) {
      // Use fallback for non-JSON backend errors.
    }
    return fallback;
  }
}

@Riverpod(keepAlive: true)
AuthenticateRemoteDatasource authenticateRemoteDatasource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthenticateRemoteDatasourceImpl(apiService: apiService);
}
