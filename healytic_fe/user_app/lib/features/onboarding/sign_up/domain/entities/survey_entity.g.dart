// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthTokensEntity _$AuthTokensEntityFromJson(Map<String, dynamic> json) =>
    _AuthTokensEntity(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthTokensEntityToJson(_AuthTokensEntity instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

_SurveyEntity _$SurveyEntityFromJson(Map<String, dynamic> json) =>
    _SurveyEntity(
      question: json['question'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$SurveyEntityToJson(_SurveyEntity instance) =>
    <String, dynamic>{'question': instance.question, 'value': instance.value};
