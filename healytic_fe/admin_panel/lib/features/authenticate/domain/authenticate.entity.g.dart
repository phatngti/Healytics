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
      companyName: json['companyName'] as String? ?? '',
      taxRegistrationCode: json['taxRegistrationCode'] as String? ?? '',
      businessEmail: json['businessEmail'] as String? ?? '',
      businessPhone: json['businessPhone'] as String? ?? '',
      serviceCategories:
          (json['serviceCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      detailedAddress: json['detailedAddress'] as String? ?? '',
      representativeName: json['representativeName'] as String? ?? '',
      governmentIdNumber: json['governmentIdNumber'] as String? ?? '',
      frontIdUrl: json['frontIdUrl'] as String?,
      backIdUrl: json['backIdUrl'] as String?,
      requiresAuthorizationLetter:
          json['requiresAuthorizationLetter'] as bool? ?? false,
      authorizationLetterUrl: json['authorizationLetterUrl'] as String?,
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$SignUpRequestEntityToJson(
  _SignUpRequestEntity instance,
) => <String, dynamic>{
  'companyName': instance.companyName,
  'taxRegistrationCode': instance.taxRegistrationCode,
  'businessEmail': instance.businessEmail,
  'businessPhone': instance.businessPhone,
  'serviceCategories': instance.serviceCategories,
  'country': instance.country,
  'city': instance.city,
  'district': instance.district,
  'detailedAddress': instance.detailedAddress,
  'representativeName': instance.representativeName,
  'governmentIdNumber': instance.governmentIdNumber,
  'frontIdUrl': instance.frontIdUrl,
  'backIdUrl': instance.backIdUrl,
  'requiresAuthorizationLetter': instance.requiresAuthorizationLetter,
  'authorizationLetterUrl': instance.authorizationLetterUrl,
  'password': instance.password,
};
