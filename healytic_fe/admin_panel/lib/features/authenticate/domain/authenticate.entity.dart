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
    required String password,
    required String bussinessName,
    required String contractPersonName,
    required String bussinessEmail,
    required String bussinessPhone,
    required String address,
  }) = _SignUpRequestEntity;

  factory SignUpRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestEntityFromJson(json);
}
