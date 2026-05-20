import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_openapi/api.dart';

part 'register_remote_datasource.g.dart';

abstract class RegisterRemoteDatasource {
  /// Checks whether the given email already exists.
  Future<bool> checkEmail({required String email});

  Future<void> sendOtp({required String email});

  Future<void> verifyCode({required String email, required String code});

  Future<AuthTokensEntity> completeRegistration({required UserEntity user});

  Future<void> completeSurvey({required Map<String, dynamic> jsonSurveys});

  /// Completes the authenticated user's profile via PATCH /auth/user/profile.
  ///
  /// Returns a fresh [AuthTokensEntity] when the backend issues new tokens
  /// in the success body. Returns `null` when the body has no token pair so
  /// the caller can fall back to `/v1/auth/refresh`.
  Future<AuthTokensEntity?> completeProfile(UserEntity profile);
}

class RegisterRemoteDatasourceImpl implements RegisterRemoteDatasource {
  final ApiService apiService;

  RegisterRemoteDatasourceImpl({required this.apiService});

  @override
  Future<bool> checkEmail({required String email}) async {
    final response = await apiService.authenticateApi.authControllerCheckEmail(
      CheckEmailDto(email: email),
    );
    return response?.exists ?? false;
  }

  @override
  Future<void> sendOtp({required String email}) async {
    await Future.delayed(const Duration(seconds: 1), () {});
    // return await apiService.sendOtp(email: email);
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    await Future.delayed(const Duration(seconds: 1), () {});
    // return await apiService.verifyCode(email: email, code: code);
  }

  @override
  Future<AuthTokensEntity> completeRegistration({
    required UserEntity user,
  }) async {
    debugPrint('completeRegistration: $user');
    final response = await apiService.apiClient.invokeAPI(
      '/auth/user/register',
      'POST',
      const [],
      {
        'email': user.email,
        'password': user.password,
        'profile': {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'dateOfBirth': user.dateOfBirth,
          if (user.address case final address?)
            'address': {
              'streetAddress': address.streetAddress,
              'provinceId': address.provinceId,
              'districtId': address.districtId,
              'wardId': address.wardId,
            },
        },
      },
      {'Content-Type': 'application/json'},
      {},
      'application/json',
    );

    if (response.statusCode >= 400 || response.body.isEmpty) {
      throw Exception('Failed to register');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final accessToken = body['access_token']?.toString() ?? '';
    final refreshToken = body['refresh_token']?.toString() ?? '';
    if (accessToken.isEmpty || refreshToken.isEmpty) {
      throw Exception('Failed to register');
    }

    await apiService.setAccessToken(accessToken);
    return AuthTokensEntity.fromJson({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
  }

  @override
  Future<void> completeSurvey({
    required Map<String, dynamic> jsonSurveys,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1), () {});
      final accessToken = Store.get(StoreKey.accessToken);
      if (accessToken.isEmpty) {
        throw Exception("Access token is empty");
      }
      await apiService.setAccessToken(accessToken);
      final response = await apiService.accountApi.accountControllerPostSurvey(
        SurveyDto(survey: jsonSurveys),
      );
      debugPrint("response: $response");
    } catch (e) {
      debugPrint("Error completing survey: $e");
      throw Exception("Failed to complete survey");
    }
  }

  @override
  Future<AuthTokensEntity?> completeProfile(UserEntity profile) async {
    final accessToken = Store.get(StoreKey.accessToken);
    if (accessToken.isEmpty) {
      throw Exception('Access token is empty');
    }
    await apiService.setAccessToken(accessToken);

    Future<dynamic> sendRequest() async {
      try {
        return await apiService.apiClient
            .invokeAPI(
              '/auth/user/profile',
              'PATCH',
              const [],
              {
                'firstName': profile.firstName,
                'lastName': profile.lastName,
                'dateOfBirth': profile.dateOfBirth,
                if (profile.address case final address?) ...{
                  'streetAddress': address.streetAddress,
                  'provinceId': address.provinceId,
                  'districtId': address.districtId,
                  'wardId': address.wardId,
                },
              },
              {'Content-Type': 'application/json'},
              {},
              'application/json',
            )
            .timeout(const Duration(seconds: 30));
      } on TimeoutException catch (error, trace) {
        throw ApiException.withInner(
          HttpStatus.requestTimeout,
          'Profile update request timed out',
          error,
          trace,
        );
      }
    }

    final response = await sendRequest();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        response.statusCode,
        _messageFromResponse(response.body, 'Unable to complete profile'),
      );
    }

    if (response.body.isEmpty) {
      return null;
    }

    final Map<String, dynamic> bodyMap;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw ApiException(
          response.statusCode,
          'Profile update response is invalid',
        );
      }
      bodyMap = decoded;
    } on FormatException {
      throw ApiException(
        response.statusCode,
        'Profile update response is invalid',
      );
    }

    final newAccessToken = bodyMap['access_token'];
    final newRefreshToken = bodyMap['refresh_token'];
    if (newAccessToken is String &&
        newAccessToken.trim().isNotEmpty &&
        newRefreshToken is String &&
        newRefreshToken.trim().isNotEmpty) {
      return AuthTokensEntity.fromJson({
        'accessToken': newAccessToken,
        'refreshToken': newRefreshToken,
      });
    }

    return null;
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

@riverpod
RegisterRemoteDatasource registerRemoteDatasource(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RegisterRemoteDatasourceImpl(apiService: apiService);
}
