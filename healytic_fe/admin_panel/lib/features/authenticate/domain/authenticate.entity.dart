import 'package:freezed_annotation/freezed_annotation.dart';

part 'authenticate.entity.freezed.dart';
part 'authenticate.entity.g.dart';

@Freezed(toJson: true)
abstract class SignInRequestEntity with _$SignInRequestEntity {
  const factory SignInRequestEntity({
    required String email,
    required String password,
  }) = _SignInRequestEntity;

  factory SignInRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class SignInResponseEntity with _$SignInResponseEntity {
  const factory SignInResponseEntity({
    required String accessToken,
    required String refreshToken,
    required String role,
  }) = _SignInResponseEntity;

  factory SignInResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class SignUpRequestEntity with _$SignUpRequestEntity {
  const factory SignUpRequestEntity({
    // Business Entity (Step 1)
    @Default('') String companyName,
    @Default('') String taxRegistrationCode,
    @Default('') String businessEmail,
    @Default('') String businessPhone,
    @Default([]) List<String> serviceCategories,

    // Location (Step 2)
    @Default('') String country,
    @Default('') String city,
    @Default('') String district,
    @Default('') String detailedAddress,

    // Legal Representative (Step 3)
    @Default('') String representativeName,
    @Default('') String governmentIdNumber,
    String? frontIdUrl,
    String? backIdUrl,
    @Default(false) bool requiresAuthorizationLetter,
    String? authorizationLetterUrl,

    // Account Security
    @Default('') String password,
  }) = _SignUpRequestEntity;

  factory SignUpRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestEntityFromJson(json);
}
