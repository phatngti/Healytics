// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BasicInfoEntity _$BasicInfoEntityFromJson(Map<String, dynamic> json) =>
    _BasicInfoEntity(
      email: json['email'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$BasicInfoEntityToJson(_BasicInfoEntity instance) =>
    <String, dynamic>{'email': instance.email, 'name': instance.name};

_AuthenticateEntity _$AuthenticateEntityFromJson(Map<String, dynamic> json) =>
    _AuthenticateEntity(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      basicInfo: json['basicInfo'] == null
          ? null
          : BasicInfoEntity.fromJson(json['basicInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthenticateEntityToJson(_AuthenticateEntity instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'basicInfo': instance.basicInfo,
    };
