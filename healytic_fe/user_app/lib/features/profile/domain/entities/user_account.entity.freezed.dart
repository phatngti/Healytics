// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_account.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserAccountEntity {

 String get id; String get email; String? get firstName; String? get lastName; String? get phone; String? get dateOfBirth; bool get profileCompleted;
/// Create a copy of UserAccountEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountEntityCopyWith<UserAccountEntity> get copyWith => _$UserAccountEntityCopyWithImpl<UserAccountEntity>(this as UserAccountEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,phone,dateOfBirth,profileCompleted);

@override
String toString() {
  return 'UserAccountEntity(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phone: $phone, dateOfBirth: $dateOfBirth, profileCompleted: $profileCompleted)';
}


}

/// @nodoc
abstract mixin class $UserAccountEntityCopyWith<$Res>  {
  factory $UserAccountEntityCopyWith(UserAccountEntity value, $Res Function(UserAccountEntity) _then) = _$UserAccountEntityCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? firstName, String? lastName, String? phone, String? dateOfBirth, bool profileCompleted
});




}
/// @nodoc
class _$UserAccountEntityCopyWithImpl<$Res>
    implements $UserAccountEntityCopyWith<$Res> {
  _$UserAccountEntityCopyWithImpl(this._self, this._then);

  final UserAccountEntity _self;
  final $Res Function(UserAccountEntity) _then;

/// Create a copy of UserAccountEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? phone = freezed,Object? dateOfBirth = freezed,Object? profileCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAccountEntity].
extension UserAccountEntityPatterns on UserAccountEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? firstName,  String? lastName,  String? phone,  String? dateOfBirth,  bool profileCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountEntity() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phone,_that.dateOfBirth,_that.profileCompleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? firstName,  String? lastName,  String? phone,  String? dateOfBirth,  bool profileCompleted)  $default,) {final _that = this;
switch (_that) {
case _UserAccountEntity():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phone,_that.dateOfBirth,_that.profileCompleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? firstName,  String? lastName,  String? phone,  String? dateOfBirth,  bool profileCompleted)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountEntity() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phone,_that.dateOfBirth,_that.profileCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _UserAccountEntity extends UserAccountEntity {
  const _UserAccountEntity({required this.id, required this.email, this.firstName, this.lastName, this.phone, this.dateOfBirth, required this.profileCompleted}): super._();
  

@override final  String id;
@override final  String email;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? phone;
@override final  String? dateOfBirth;
@override final  bool profileCompleted;

/// Create a copy of UserAccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountEntityCopyWith<_UserAccountEntity> get copyWith => __$UserAccountEntityCopyWithImpl<_UserAccountEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,phone,dateOfBirth,profileCompleted);

@override
String toString() {
  return 'UserAccountEntity(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phone: $phone, dateOfBirth: $dateOfBirth, profileCompleted: $profileCompleted)';
}


}

/// @nodoc
abstract mixin class _$UserAccountEntityCopyWith<$Res> implements $UserAccountEntityCopyWith<$Res> {
  factory _$UserAccountEntityCopyWith(_UserAccountEntity value, $Res Function(_UserAccountEntity) _then) = __$UserAccountEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? firstName, String? lastName, String? phone, String? dateOfBirth, bool profileCompleted
});




}
/// @nodoc
class __$UserAccountEntityCopyWithImpl<$Res>
    implements _$UserAccountEntityCopyWith<$Res> {
  __$UserAccountEntityCopyWithImpl(this._self, this._then);

  final _UserAccountEntity _self;
  final $Res Function(_UserAccountEntity) _then;

/// Create a copy of UserAccountEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? phone = freezed,Object? dateOfBirth = freezed,Object? profileCompleted = null,}) {
  return _then(_UserAccountEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
