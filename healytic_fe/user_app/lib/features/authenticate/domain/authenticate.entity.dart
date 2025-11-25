import 'package:freezed_annotation/freezed_annotation.dart';

part 'authenticate.entity.freezed.dart';
part 'authenticate.entity.g.dart';

@Freezed(toJson: true)
abstract class BasicInfoEntity with _$BasicInfoEntity {
  const factory BasicInfoEntity({required String email, String? name}) =
      _BasicInfoEntity;

  factory BasicInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$BasicInfoEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class AuthenticateEntity with _$AuthenticateEntity {
  const factory AuthenticateEntity({
    required String accessToken,
    required String refreshToken,
    BasicInfoEntity? basicInfo,
  }) = _AuthenticateEntity;

  factory AuthenticateEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateEntityFromJson(json);
}
