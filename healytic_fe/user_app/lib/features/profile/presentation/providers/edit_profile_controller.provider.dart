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
    required String streetAddress,
    required String provinceId,
    required String districtId,
    required String wardId,
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

      final hasAddressInput = [
        streetAddress,
        provinceId,
        districtId,
        wardId,
      ].any((value) => value.trim().isNotEmpty);
      if (hasAddressInput) {
        final streetError = FormValidators.requiredField(
          streetAddress,
          fieldName: 'street address',
        );
        if (streetError != null) {
          throw Exception(streetError);
        }
        final provinceError = FormValidators.requiredField(
          provinceId,
          fieldName: 'province or city',
        );
        if (provinceError != null) {
          throw Exception(provinceError);
        }
        final districtError = FormValidators.requiredField(
          districtId,
          fieldName: 'district',
        );
        if (districtError != null) {
          throw Exception(districtError);
        }
        final wardError = FormValidators.requiredField(
          wardId,
          fieldName: 'ward',
        );
        if (wardError != null) {
          throw Exception(wardError);
        }
      }

      final repo = ref.read(profileRepositoryProvider);
      final splitName = _splitFullName(fullName);
      await repo.updateAccountProfile(
        firstName: splitName.firstName,
        lastName: splitName.lastName,
        phone: phone.trim().isEmpty ? null : phone.trim(),
      );
      if (hasAddressInput) {
        await repo.updateAccountAddress(
          streetAddress: streetAddress,
          provinceId: provinceId,
          districtId: districtId,
          wardId: wardId,
        );
      }
      ref.invalidate(accountMeProvider);
      ref.invalidate(accountLocationProvider);
      ref.invalidate(accountAddressProvider);
    });

    return !state.hasError;
  }

  ({String firstName, String? lastName}) _splitFullName(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.length == 1) {
      return (firstName: parts.first, lastName: null);
    }
    return (firstName: parts.first, lastName: parts.skip(1).join(' '));
  }

  /// Uploads avatar via S3 presigned URL.
  Future<bool> uploadAvatar({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
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
