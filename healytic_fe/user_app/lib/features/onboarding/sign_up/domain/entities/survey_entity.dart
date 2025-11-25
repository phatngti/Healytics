import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_entity.freezed.dart';
part 'survey_entity.g.dart';

@Freezed(toJson: true)
abstract class AuthTokensEntity with _$AuthTokensEntity {
  const factory AuthTokensEntity({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokensEntity;

  factory AuthTokensEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class SurveyEntity with _$SurveyEntity {
  const factory SurveyEntity({
    required String question,
    required String value,
  }) = _SurveyEntity;

  factory SurveyEntity.fromJson(Map<String, dynamic> json) =>
      _$SurveyEntityFromJson(json);
}
