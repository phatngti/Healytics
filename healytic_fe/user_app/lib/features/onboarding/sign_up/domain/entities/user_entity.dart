import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@Freezed(toJson: true)
abstract class AddressEntity with _$AddressEntity {
  const factory AddressEntity({
    required String streetAddress,
    required String provinceId,
    required String districtId,
    required String wardId,
  }) = _AddressEntity;

  factory AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    String? id,
    required String email,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String password,
    AddressEntity? address,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
