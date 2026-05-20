import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_sign_in_result.entity.freezed.dart';
part 'google_sign_in_result.entity.g.dart';

/// Result of an interactive Google Sign-In flow on the device.
///
/// Pure Dart; no Flutter or platform imports. Returned by
/// `GoogleSignInService.signIn()` so layers above the data layer never
/// see `package:google_sign_in/google_sign_in.dart` types.
@Freezed(toJson: true)
abstract class GoogleSignInResult with _$GoogleSignInResult {
  const factory GoogleSignInResult({
    required String idToken,
    required String email,
    String? displayName,
    String? photoUrl,
  }) = _GoogleSignInResult;

  factory GoogleSignInResult.fromJson(Map<String, dynamic> json) =>
      _$GoogleSignInResultFromJson(json);
}
