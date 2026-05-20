// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressEntity _$AddressEntityFromJson(Map<String, dynamic> json) =>
    _AddressEntity(
      streetAddress: json['streetAddress'] as String,
      provinceId: json['provinceId'] as String,
      districtId: json['districtId'] as String,
      wardId: json['wardId'] as String,
    );

Map<String, dynamic> _$AddressEntityToJson(_AddressEntity instance) =>
    <String, dynamic>{
      'streetAddress': instance.streetAddress,
      'provinceId': instance.provinceId,
      'districtId': instance.districtId,
      'wardId': instance.wardId,
    };

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
  id: json['id'] as String?,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  dateOfBirth: json['dateOfBirth'] as String,
  password: json['password'] as String,
  address: json['address'] == null
      ? null
      : AddressEntity.fromJson(json['address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth,
      'password': instance.password,
      'address': instance.address?.toJson(),
    };
