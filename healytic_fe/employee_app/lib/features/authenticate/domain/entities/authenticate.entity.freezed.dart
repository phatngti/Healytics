// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authenticate.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BasicInfoEntity {

 String get email; String? get name;
/// Create a copy of BasicInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasicInfoEntityCopyWith<BasicInfoEntity> get copyWith => _$BasicInfoEntityCopyWithImpl<BasicInfoEntity>(this as BasicInfoEntity, _$identity);

  /// Serializes this BasicInfoEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasicInfoEntity&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,name);

@override
String toString() {
  return 'BasicInfoEntity(email: $email, name: $name)';
}


}

/// @nodoc
abstract mixin class $BasicInfoEntityCopyWith<$Res>  {
  factory $BasicInfoEntityCopyWith(BasicInfoEntity value, $Res Function(BasicInfoEntity) _then) = _$BasicInfoEntityCopyWithImpl;
@useResult
$Res call({
 String email, String? name
});




}
/// @nodoc
class _$BasicInfoEntityCopyWithImpl<$Res>
    implements $BasicInfoEntityCopyWith<$Res> {
  _$BasicInfoEntityCopyWithImpl(this._self, this._then);

  final BasicInfoEntity _self;
  final $Res Function(BasicInfoEntity) _then;

/// Create a copy of BasicInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? name = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BasicInfoEntity].
extension BasicInfoEntityPatterns on BasicInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasicInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasicInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasicInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _BasicInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasicInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BasicInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasicInfoEntity() when $default != null:
return $default(_that.email,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String? name)  $default,) {final _that = this;
switch (_that) {
case _BasicInfoEntity():
return $default(_that.email,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _BasicInfoEntity() when $default != null:
return $default(_that.email,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BasicInfoEntity implements BasicInfoEntity {
  const _BasicInfoEntity({required this.email, this.name});
  factory _BasicInfoEntity.fromJson(Map<String, dynamic> json) => _$BasicInfoEntityFromJson(json);

@override final  String email;
@override final  String? name;

/// Create a copy of BasicInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasicInfoEntityCopyWith<_BasicInfoEntity> get copyWith => __$BasicInfoEntityCopyWithImpl<_BasicInfoEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BasicInfoEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasicInfoEntity&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,name);

@override
String toString() {
  return 'BasicInfoEntity(email: $email, name: $name)';
}


}

/// @nodoc
abstract mixin class _$BasicInfoEntityCopyWith<$Res> implements $BasicInfoEntityCopyWith<$Res> {
  factory _$BasicInfoEntityCopyWith(_BasicInfoEntity value, $Res Function(_BasicInfoEntity) _then) = __$BasicInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String email, String? name
});




}
/// @nodoc
class __$BasicInfoEntityCopyWithImpl<$Res>
    implements _$BasicInfoEntityCopyWith<$Res> {
  __$BasicInfoEntityCopyWithImpl(this._self, this._then);

  final _BasicInfoEntity _self;
  final $Res Function(_BasicInfoEntity) _then;

/// Create a copy of BasicInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? name = freezed,}) {
  return _then(_BasicInfoEntity(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AuthenticateEntity {

 String get accessToken; String get refreshToken; BasicInfoEntity? get basicInfo;
/// Create a copy of AuthenticateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticateEntityCopyWith<AuthenticateEntity> get copyWith => _$AuthenticateEntityCopyWithImpl<AuthenticateEntity>(this as AuthenticateEntity, _$identity);

  /// Serializes this AuthenticateEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticateEntity&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.basicInfo, basicInfo) || other.basicInfo == basicInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,basicInfo);

@override
String toString() {
  return 'AuthenticateEntity(accessToken: $accessToken, refreshToken: $refreshToken, basicInfo: $basicInfo)';
}


}

/// @nodoc
abstract mixin class $AuthenticateEntityCopyWith<$Res>  {
  factory $AuthenticateEntityCopyWith(AuthenticateEntity value, $Res Function(AuthenticateEntity) _then) = _$AuthenticateEntityCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, BasicInfoEntity? basicInfo
});


$BasicInfoEntityCopyWith<$Res>? get basicInfo;

}
/// @nodoc
class _$AuthenticateEntityCopyWithImpl<$Res>
    implements $AuthenticateEntityCopyWith<$Res> {
  _$AuthenticateEntityCopyWithImpl(this._self, this._then);

  final AuthenticateEntity _self;
  final $Res Function(AuthenticateEntity) _then;

/// Create a copy of AuthenticateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? basicInfo = freezed,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,basicInfo: freezed == basicInfo ? _self.basicInfo : basicInfo // ignore: cast_nullable_to_non_nullable
as BasicInfoEntity?,
  ));
}
/// Create a copy of AuthenticateEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BasicInfoEntityCopyWith<$Res>? get basicInfo {
    if (_self.basicInfo == null) {
    return null;
  }

  return $BasicInfoEntityCopyWith<$Res>(_self.basicInfo!, (value) {
    return _then(_self.copyWith(basicInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthenticateEntity].
extension AuthenticateEntityPatterns on AuthenticateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthenticateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthenticateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthenticateEntity value)  $default,){
final _that = this;
switch (_that) {
case _AuthenticateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthenticateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AuthenticateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  BasicInfoEntity? basicInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthenticateEntity() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.basicInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  BasicInfoEntity? basicInfo)  $default,) {final _that = this;
switch (_that) {
case _AuthenticateEntity():
return $default(_that.accessToken,_that.refreshToken,_that.basicInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  BasicInfoEntity? basicInfo)?  $default,) {final _that = this;
switch (_that) {
case _AuthenticateEntity() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.basicInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthenticateEntity implements AuthenticateEntity {
  const _AuthenticateEntity({required this.accessToken, required this.refreshToken, this.basicInfo});
  factory _AuthenticateEntity.fromJson(Map<String, dynamic> json) => _$AuthenticateEntityFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  BasicInfoEntity? basicInfo;

/// Create a copy of AuthenticateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticateEntityCopyWith<_AuthenticateEntity> get copyWith => __$AuthenticateEntityCopyWithImpl<_AuthenticateEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticateEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticateEntity&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.basicInfo, basicInfo) || other.basicInfo == basicInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,basicInfo);

@override
String toString() {
  return 'AuthenticateEntity(accessToken: $accessToken, refreshToken: $refreshToken, basicInfo: $basicInfo)';
}


}

/// @nodoc
abstract mixin class _$AuthenticateEntityCopyWith<$Res> implements $AuthenticateEntityCopyWith<$Res> {
  factory _$AuthenticateEntityCopyWith(_AuthenticateEntity value, $Res Function(_AuthenticateEntity) _then) = __$AuthenticateEntityCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, BasicInfoEntity? basicInfo
});


@override $BasicInfoEntityCopyWith<$Res>? get basicInfo;

}
/// @nodoc
class __$AuthenticateEntityCopyWithImpl<$Res>
    implements _$AuthenticateEntityCopyWith<$Res> {
  __$AuthenticateEntityCopyWithImpl(this._self, this._then);

  final _AuthenticateEntity _self;
  final $Res Function(_AuthenticateEntity) _then;

/// Create a copy of AuthenticateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? basicInfo = freezed,}) {
  return _then(_AuthenticateEntity(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,basicInfo: freezed == basicInfo ? _self.basicInfo : basicInfo // ignore: cast_nullable_to_non_nullable
as BasicInfoEntity?,
  ));
}

/// Create a copy of AuthenticateEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BasicInfoEntityCopyWith<$Res>? get basicInfo {
    if (_self.basicInfo == null) {
    return null;
  }

  return $BasicInfoEntityCopyWith<$Res>(_self.basicInfo!, (value) {
    return _then(_self.copyWith(basicInfo: value));
  });
}
}

// dart format on
