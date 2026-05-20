import 'dart:async';
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

  Future<AuthenticateEntity> signInWithGoogle({required String idToken});

  Future<void> requestPasswordReset({required String email});

  Future<String> validatePasswordResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({required String token, required String password});
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
  Future<AuthenticateEntity> signInWithGoogle({
    required String idToken,
  }) async {
    Future<dynamic> sendRequest() async {
      try {
        return await apiService.apiClient
            .invokeAPI(
              '/auth/user/google',
              'POST',
              const [],
              {'id_token': idToken},
              {'Content-Type': 'application/json'},
              {},
              'application/json',
            )
            .timeout(const Duration(seconds: 30));
      } on TimeoutException catch (error, trace) {
        throw ApiException.withInner(
          HttpStatus.requestTimeout,
          'Google sign-in request timed out',
          error,
          trace,
        );
      }
    }

    final response = await sendRequest();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        response.statusCode,
        _messageFromResponse(
          response.body,
          'Unable to complete Google sign-in',
        ),
      );
    }

    final Map<String, dynamic> bodyMap;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw ApiException(
          response.statusCode,
          'Google sign-in response is invalid',
        );
      }
      bodyMap = decoded;
    } on FormatException {
      throw ApiException(
        response.statusCode,
        'Google sign-in response is invalid',
      );
    }

    final accessToken = bodyMap['access_token'];
    final refreshToken = bodyMap['refresh_token'];
    if (accessToken is! String ||
        accessToken.trim().isEmpty ||
        refreshToken is! String ||
        refreshToken.trim().isEmpty) {
      throw ApiException(
        response.statusCode,
        'Google sign-in response is missing tokens',
      );
    }

    final Map<String, dynamic> decodedToken;
    try {
      decodedToken = JwtDecoder.decode(accessToken);
    } on FormatException catch (error, trace) {
      throw ApiException.withInner(
        response.statusCode,
        'Google sign-in token could not be decoded',
        error,
        trace,
      );
    }

    final email = decodedToken['email'];
    if (email is! String || email.isEmpty) {
      throw ApiException(
        response.statusCode,
        'Google sign-in token is missing email claim',
      );
    }

    var basicInfo = BasicInfoEntity(email: email);
    if (decodedToken['firstName'] != null && decodedToken['lastName'] != null) {
      basicInfo = basicInfo.copyWith(
        name: '${decodedToken['firstName']} ${decodedToken['lastName']}',
      );
    }

    return AuthenticateEntity.fromJson({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
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
          'Unable to send password reset code',
        ),
      );
    }
  }

  @override
  Future<String> validatePasswordResetCode({
    required String email,
    required String code,
  }) async {
    final response = await apiService.apiClient.invokeAPI(
      '/auth/user/validate-reset-code',
      'POST',
      const [],
      {'email': email.trim().toLowerCase(), 'code': code.trim()},
      {'Content-Type': 'application/json'},
      {},
      'application/json',
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        response.statusCode,
        _messageFromResponse(response.body, 'Invalid password reset code'),
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final resetToken = decoded['resetToken'];
        if (resetToken is String && resetToken.trim().isNotEmpty) {
          return resetToken;
        }
      }
    } catch (_) {
      // Fall through to the structured API exception below.
    }

    throw ApiException(
      HttpStatus.badRequest,
      'Password reset code response is invalid',
    );
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    final response = await apiService.apiClient.invokeAPI(
      '/auth/user/reset-password',
      'POST',
      const [],
      {'token': token, 'password': password},
      {'Content-Type': 'application/json'},
      {},
      'application/json',
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        response.statusCode,
        _messageFromResponse(response.body, 'Unable to reset password'),
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
