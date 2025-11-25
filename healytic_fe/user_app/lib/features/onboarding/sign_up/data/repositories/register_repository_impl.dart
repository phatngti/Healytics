import 'package:flutter/material.dart';
import 'package:user_app/features/onboarding/sign_up/data/datasouces/local/share_preferences_register_local_datasouce.dart';
import 'package:user_app/features/onboarding/sign_up/data/datasouces/remote/register_remote_datasource.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/repositories/register_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_repository_impl.g.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDatasource _remoteDatasource;
  final RegistrationLocalDatasource _localDatasource;

  RegisterRepositoryImpl({
    required RegisterRemoteDatasource remoteDatasource,
    required RegistrationLocalDatasource localDatasource,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource;

  @override
  Future<void> savePartialData(Map<String, dynamic> data) async {
    // Implementation for saving partial data
    // This could involve local storage or caching
    await _localDatasource.savePartialData(data);
  }

  @override
  Future<Map<String, dynamic>?> loadPartialData() async {
    // Implementation for loading partial data
    // This could involve local storage or caching
    return await _localDatasource.loadPartialData();
  }

  @override
  Future<void> clearPartialData() async {
    // Implementation for clearing partial data
    // This could involve local storage or caching
    await _localDatasource.clearPartialData();
  }

  @override
  Future<void> sendVerificationCode({required String email}) async {
    // Implementation for sending verification code
    try {
      // Simulate network call
      await _remoteDatasource.sendOtp(email: email);
    } catch (e) {
      throw Exception("Failed to send verification code");
    }
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    // Implementation for verifying the code
    try {
      return await _remoteDatasource.verifyCode(email: email, code: code);
    } catch (e) {
      throw Exception("Failed to verify code");
    }
  }

  @override
  Future<AuthTokensEntity> completeRegistration({
    required UserEntity user,
  }) async {
    // Implementation for completing registration
    try {
      return await _remoteDatasource.completeRegistration(user: user);
    } catch (e) {
      debugPrint('Error completing registration: $e');
      rethrow;
    }
  }

  @override
  Future<void> completeSurvey(Map<String, dynamic> jsonSurveys) async {
    // Implementation for completing survey
    try {
      return await _remoteDatasource.completeSurvey(jsonSurveys: jsonSurveys);
    } catch (e) {
      print("Error completing survey: $e");
      throw Exception("Failed to complete survey");
    }
  }
}

@riverpod
RegisterRepository registerRepository(Ref ref) {
  final remoteDatasource = ref.watch(registerRemoteDatasourceProvider);
  final localDatasource = ref.watch(registerLocalDatasourceProvider);
  return RegisterRepositoryImpl(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
  );
}
