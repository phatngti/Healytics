import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
