// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignInRequestEntity _$SignInRequestEntityFromJson(Map<String, dynamic> json) =>
    _SignInRequestEntity(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignInRequestEntityToJson(
  _SignInRequestEntity instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};

_SignInResponseEntity _$SignInResponseEntityFromJson(
  Map<String, dynamic> json,
) => _SignInResponseEntity(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$SignInResponseEntityToJson(
  _SignInResponseEntity instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'role': instance.role,
};

_SignUpRequestEntity _$SignUpRequestEntityFromJson(Map<String, dynamic> json) =>
    _SignUpRequestEntity(
      password: json['password'] as String,
      bussinessName: json['bussinessName'] as String,
      contractPersonName: json['contractPersonName'] as String,
      bussinessEmail: json['bussinessEmail'] as String,
      bussinessPhone: json['bussinessPhone'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$SignUpRequestEntityToJson(
  _SignUpRequestEntity instance,
) => <String, dynamic>{
  'password': instance.password,
  'bussinessName': instance.bussinessName,
  'contractPersonName': instance.contractPersonName,
  'bussinessEmail': instance.bussinessEmail,
  'bussinessPhone': instance.bussinessPhone,
  'address': instance.address,
};
