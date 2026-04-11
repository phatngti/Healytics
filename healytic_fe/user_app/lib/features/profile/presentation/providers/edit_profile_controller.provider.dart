import 'dart:convert';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/utils/form_validators.dart';

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
}
