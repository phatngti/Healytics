import 'dart:convert';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/utils/form_validators.dart';
import 'package:user_app/features/profile/data/provider/profile.provider.dart';
import 'package:user_app/features/profile/presentation/providers/profile.provider.dart';

part 'edit_profile_controller.provider.g.dart';

@riverpod
class EditProfileController extends _$EditProfileController {
  @override
  FutureOr<void> build() {
    // Controller state only manages the async submission
  }

  Future<bool> submitProfile({
    required String fullName,
    required String email,
    required String phone,
    required String location,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final fullNameError = FormValidators.fullName(
        fullName,
        fieldName: 'Full name',
      );
      if (fullNameError != null) {
        throw Exception(fullNameError);
      }

      final emailError = FormValidators.email(email);
      if (emailError != null) {
        throw Exception(emailError);
      }

      final phoneError = FormValidators.phone(phone);
      if (phoneError != null) {
        throw Exception(phoneError);
      }

      // Simulate network request
      await Future.delayed(const Duration(seconds: 1));

      // Mock JSON payload output
      final payload = {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'location': location,
      };

      log('Mock API Payload Reference:');
      log(const JsonEncoder.withIndent('  ').convert(payload));
    });

    return !state.hasError;
  }

  /// Uploads avatar via S3 presigned URL.
  Future<bool> uploadAvatar({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(
        profileRepositoryProvider,
      );
      await repo.uploadAvatar(
        fileName: fileName,
        contentType: contentType,
        bytes: bytes,
      );
      // Refresh account data to pick up
      // new avatarUrl
      ref.invalidate(accountMeProvider);
    });
    return !state.hasError;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentError = FormValidators.requiredField(
        currentPassword,
        fieldName: 'current password',
      );
      if (currentError != null) {
        throw Exception(currentError);
      }

      final passwordError = FormValidators.password(newPassword);
      if (passwordError != null) {
        throw Exception(passwordError);
      }

      final confirmError = FormValidators.confirmPassword(
        confirmPassword,
        password: newPassword,
      );
      if (confirmError != null) {
        throw Exception(confirmError);
      }

      if (currentPassword.trim() == newPassword.trim()) {
        throw Exception('New password must be different from current password');
      }

      final repo = ref.read(profileRepositoryProvider);
      await repo.changePassword(
        currentPassword: currentPassword.trim(),
        newPassword: newPassword.trim(),
      );
    });

    return !state.hasError;
  }

  Future<bool> deleteAccount({required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final passwordError = FormValidators.requiredField(
        password,
        fieldName: 'password',
      );
      if (passwordError != null) {
        throw Exception(passwordError);
      }

      final repo = ref.read(profileRepositoryProvider);
      await repo.deleteAccount(password: password.trim());
    });

    return !state.hasError;
  }
}
