import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_account.entity.freezed.dart';

@freezed
abstract class UserAccountEntity with _$UserAccountEntity {
  const factory UserAccountEntity({
    required String id,
    required String email,
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
    String? dateOfBirth,
    required bool profileCompleted,
  }) = _UserAccountEntity;

  const UserAccountEntity._();

  /// Computes a display name prioritizing full name,
  /// then username, and finally falling back to email.
  String get displayName {
    if (firstName != null && firstName!.isNotEmpty && lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    if (firstName != null && firstName!.isNotEmpty) return firstName!;
    if (lastName != null && lastName!.isNotEmpty) return lastName!;
    if (username != null && username!.isNotEmpty) return username!;
    return email;
  }
}
