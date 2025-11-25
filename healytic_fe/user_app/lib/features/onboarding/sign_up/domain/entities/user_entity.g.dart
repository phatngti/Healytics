// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressEntity _$AddressEntityFromJson(Map<String, dynamic> json) =>
    _AddressEntity(
      street: json['street'] as String,
      ward: json['ward'] as String,
      district: json['district'] as String,
      cityOrProvince: json['cityOrProvince'] as String,
    );

Map<String, dynamic> _$AddressEntityToJson(_AddressEntity instance) =>
    <String, dynamic>{
      'street': instance.street,
      'ward': instance.ward,
      'district': instance.district,
      'cityOrProvince': instance.cityOrProvince,
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
