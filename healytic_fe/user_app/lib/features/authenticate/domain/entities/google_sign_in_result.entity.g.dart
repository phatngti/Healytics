// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_result.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoogleSignInResult _$GoogleSignInResultFromJson(Map<String, dynamic> json) =>
    _GoogleSignInResult(
      idToken: json['idToken'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$GoogleSignInResultToJson(_GoogleSignInResult instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
    };
