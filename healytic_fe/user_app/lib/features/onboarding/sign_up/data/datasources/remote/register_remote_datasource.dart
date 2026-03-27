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
  Future<void> sendOtp({required String email});

  Future<void> verifyCode({required String email, required String code});

  Future<AuthTokensEntity> completeRegistration({required UserEntity user});

  Future<void> completeSurvey({required Map<String, dynamic> jsonSurveys});
}

class RegisterRemoteDatasourceImpl implements RegisterRemoteDatasource {
  final ApiService apiService;

  RegisterRemoteDatasourceImpl({required this.apiService});

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
    final response = await apiService.authenticateApi
        .authControllerRegisterUser(
          RegisterDto(
            email: user.email,
            password: user.password,
            profile: RegisterProfileDto(
              firstName: user.firstName,
              lastName: user.lastName,
              dateOfBirth: user.dateOfBirth,
            ),
          ),
        );
    if (response == null) {
      throw Exception('Failed to register');
    }
    await apiService.setAccessToken(response.accessToken);
    return AuthTokensEntity.fromJson({
      'accessToken': response.accessToken,
      'refreshToken': response.refreshToken,
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
}

@riverpod
RegisterRemoteDatasource registerRemoteDatasource(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RegisterRemoteDatasourceImpl(apiService: apiService);
}
