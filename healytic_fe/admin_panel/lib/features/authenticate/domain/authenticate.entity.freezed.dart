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
mixin _$SignInRequestEntity {

 String get email; String get password;
/// Create a copy of SignInRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInRequestEntityCopyWith<SignInRequestEntity> get copyWith => _$SignInRequestEntityCopyWithImpl<SignInRequestEntity>(this as SignInRequestEntity, _$identity);

  /// Serializes this SignInRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInRequestEntity&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'SignInRequestEntity(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignInRequestEntityCopyWith<$Res>  {
  factory $SignInRequestEntityCopyWith(SignInRequestEntity value, $Res Function(SignInRequestEntity) _then) = _$SignInRequestEntityCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$SignInRequestEntityCopyWithImpl<$Res>
    implements $SignInRequestEntityCopyWith<$Res> {
  _$SignInRequestEntityCopyWithImpl(this._self, this._then);

  final SignInRequestEntity _self;
  final $Res Function(SignInRequestEntity) _then;

/// Create a copy of SignInRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SignInRequestEntity].
extension SignInRequestEntityPatterns on SignInRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignInRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignInRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignInRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _SignInRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignInRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SignInRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignInRequestEntity() when $default != null:
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _SignInRequestEntity():
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _SignInRequestEntity() when $default != null:
return $default(_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignInRequestEntity implements SignInRequestEntity {
  const _SignInRequestEntity({required this.email, required this.password});
  factory _SignInRequestEntity.fromJson(Map<String, dynamic> json) => _$SignInRequestEntityFromJson(json);

@override final  String email;
@override final  String password;

/// Create a copy of SignInRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInRequestEntityCopyWith<_SignInRequestEntity> get copyWith => __$SignInRequestEntityCopyWithImpl<_SignInRequestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignInRequestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInRequestEntity&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'SignInRequestEntity(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$SignInRequestEntityCopyWith<$Res> implements $SignInRequestEntityCopyWith<$Res> {
  factory _$SignInRequestEntityCopyWith(_SignInRequestEntity value, $Res Function(_SignInRequestEntity) _then) = __$SignInRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$SignInRequestEntityCopyWithImpl<$Res>
    implements _$SignInRequestEntityCopyWith<$Res> {
  __$SignInRequestEntityCopyWithImpl(this._self, this._then);

  final _SignInRequestEntity _self;
  final $Res Function(_SignInRequestEntity) _then;

/// Create a copy of SignInRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_SignInRequestEntity(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SignInResponseEntity {

 String get accessToken; String get refreshToken; String get role;
/// Create a copy of SignInResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInResponseEntityCopyWith<SignInResponseEntity> get copyWith => _$SignInResponseEntityCopyWithImpl<SignInResponseEntity>(this as SignInResponseEntity, _$identity);

  /// Serializes this SignInResponseEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInResponseEntity&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,role);

@override
String toString() {
  return 'SignInResponseEntity(accessToken: $accessToken, refreshToken: $refreshToken, role: $role)';
}


}

/// @nodoc
abstract mixin class $SignInResponseEntityCopyWith<$Res>  {
  factory $SignInResponseEntityCopyWith(SignInResponseEntity value, $Res Function(SignInResponseEntity) _then) = _$SignInResponseEntityCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, String role
});




}
/// @nodoc
class _$SignInResponseEntityCopyWithImpl<$Res>
    implements $SignInResponseEntityCopyWith<$Res> {
  _$SignInResponseEntityCopyWithImpl(this._self, this._then);

  final SignInResponseEntity _self;
  final $Res Function(SignInResponseEntity) _then;

/// Create a copy of SignInResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? role = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SignInResponseEntity].
extension SignInResponseEntityPatterns on SignInResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignInResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignInResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignInResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _SignInResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignInResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SignInResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignInResponseEntity() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String role)  $default,) {final _that = this;
switch (_that) {
case _SignInResponseEntity():
return $default(_that.accessToken,_that.refreshToken,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  String role)?  $default,) {final _that = this;
switch (_that) {
case _SignInResponseEntity() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignInResponseEntity implements SignInResponseEntity {
  const _SignInResponseEntity({required this.accessToken, required this.refreshToken, required this.role});
  factory _SignInResponseEntity.fromJson(Map<String, dynamic> json) => _$SignInResponseEntityFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  String role;

/// Create a copy of SignInResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInResponseEntityCopyWith<_SignInResponseEntity> get copyWith => __$SignInResponseEntityCopyWithImpl<_SignInResponseEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignInResponseEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInResponseEntity&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,role);

@override
String toString() {
  return 'SignInResponseEntity(accessToken: $accessToken, refreshToken: $refreshToken, role: $role)';
}


}

/// @nodoc
abstract mixin class _$SignInResponseEntityCopyWith<$Res> implements $SignInResponseEntityCopyWith<$Res> {
  factory _$SignInResponseEntityCopyWith(_SignInResponseEntity value, $Res Function(_SignInResponseEntity) _then) = __$SignInResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, String role
});




}
/// @nodoc
class __$SignInResponseEntityCopyWithImpl<$Res>
    implements _$SignInResponseEntityCopyWith<$Res> {
  __$SignInResponseEntityCopyWithImpl(this._self, this._then);

  final _SignInResponseEntity _self;
  final $Res Function(_SignInResponseEntity) _then;

/// Create a copy of SignInResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? role = null,}) {
  return _then(_SignInResponseEntity(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SendOtpResponseEntity {

 String get emailToken; String get message;
/// Create a copy of SendOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOtpResponseEntityCopyWith<SendOtpResponseEntity> get copyWith => _$SendOtpResponseEntityCopyWithImpl<SendOtpResponseEntity>(this as SendOtpResponseEntity, _$identity);

  /// Serializes this SendOtpResponseEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOtpResponseEntity&&(identical(other.emailToken, emailToken) || other.emailToken == emailToken)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emailToken,message);

@override
String toString() {
  return 'SendOtpResponseEntity(emailToken: $emailToken, message: $message)';
}


}

/// @nodoc
abstract mixin class $SendOtpResponseEntityCopyWith<$Res>  {
  factory $SendOtpResponseEntityCopyWith(SendOtpResponseEntity value, $Res Function(SendOtpResponseEntity) _then) = _$SendOtpResponseEntityCopyWithImpl;
@useResult
$Res call({
 String emailToken, String message
});




}
/// @nodoc
class _$SendOtpResponseEntityCopyWithImpl<$Res>
    implements $SendOtpResponseEntityCopyWith<$Res> {
  _$SendOtpResponseEntityCopyWithImpl(this._self, this._then);

  final SendOtpResponseEntity _self;
  final $Res Function(SendOtpResponseEntity) _then;

/// Create a copy of SendOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emailToken = null,Object? message = null,}) {
  return _then(_self.copyWith(
emailToken: null == emailToken ? _self.emailToken : emailToken // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SendOtpResponseEntity].
extension SendOtpResponseEntityPatterns on SendOtpResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendOtpResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendOtpResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _SendOtpResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendOtpResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SendOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String emailToken,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendOtpResponseEntity() when $default != null:
return $default(_that.emailToken,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String emailToken,  String message)  $default,) {final _that = this;
switch (_that) {
case _SendOtpResponseEntity():
return $default(_that.emailToken,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String emailToken,  String message)?  $default,) {final _that = this;
switch (_that) {
case _SendOtpResponseEntity() when $default != null:
return $default(_that.emailToken,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendOtpResponseEntity implements SendOtpResponseEntity {
  const _SendOtpResponseEntity({required this.emailToken, required this.message});
  factory _SendOtpResponseEntity.fromJson(Map<String, dynamic> json) => _$SendOtpResponseEntityFromJson(json);

@override final  String emailToken;
@override final  String message;

/// Create a copy of SendOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOtpResponseEntityCopyWith<_SendOtpResponseEntity> get copyWith => __$SendOtpResponseEntityCopyWithImpl<_SendOtpResponseEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendOtpResponseEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOtpResponseEntity&&(identical(other.emailToken, emailToken) || other.emailToken == emailToken)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emailToken,message);

@override
String toString() {
  return 'SendOtpResponseEntity(emailToken: $emailToken, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SendOtpResponseEntityCopyWith<$Res> implements $SendOtpResponseEntityCopyWith<$Res> {
  factory _$SendOtpResponseEntityCopyWith(_SendOtpResponseEntity value, $Res Function(_SendOtpResponseEntity) _then) = __$SendOtpResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 String emailToken, String message
});




}
/// @nodoc
class __$SendOtpResponseEntityCopyWithImpl<$Res>
    implements _$SendOtpResponseEntityCopyWith<$Res> {
  __$SendOtpResponseEntityCopyWithImpl(this._self, this._then);

  final _SendOtpResponseEntity _self;
  final $Res Function(_SendOtpResponseEntity) _then;

/// Create a copy of SendOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emailToken = null,Object? message = null,}) {
  return _then(_SendOtpResponseEntity(
emailToken: null == emailToken ? _self.emailToken : emailToken // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VerifyOtpResponseEntity {

 String get otpToken; String get message;
/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpResponseEntityCopyWith<VerifyOtpResponseEntity> get copyWith => _$VerifyOtpResponseEntityCopyWithImpl<VerifyOtpResponseEntity>(this as VerifyOtpResponseEntity, _$identity);

  /// Serializes this VerifyOtpResponseEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtpResponseEntity&&(identical(other.otpToken, otpToken) || other.otpToken == otpToken)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,otpToken,message);

@override
String toString() {
  return 'VerifyOtpResponseEntity(otpToken: $otpToken, message: $message)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpResponseEntityCopyWith<$Res>  {
  factory $VerifyOtpResponseEntityCopyWith(VerifyOtpResponseEntity value, $Res Function(VerifyOtpResponseEntity) _then) = _$VerifyOtpResponseEntityCopyWithImpl;
@useResult
$Res call({
 String otpToken, String message
});




}
/// @nodoc
class _$VerifyOtpResponseEntityCopyWithImpl<$Res>
    implements $VerifyOtpResponseEntityCopyWith<$Res> {
  _$VerifyOtpResponseEntityCopyWithImpl(this._self, this._then);

  final VerifyOtpResponseEntity _self;
  final $Res Function(VerifyOtpResponseEntity) _then;

/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otpToken = null,Object? message = null,}) {
  return _then(_self.copyWith(
otpToken: null == otpToken ? _self.otpToken : otpToken // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VerifyOtpResponseEntity].
extension VerifyOtpResponseEntityPatterns on VerifyOtpResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyOtpResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyOtpResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyOtpResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String otpToken,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
return $default(_that.otpToken,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String otpToken,  String message)  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity():
return $default(_that.otpToken,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String otpToken,  String message)?  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponseEntity() when $default != null:
return $default(_that.otpToken,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerifyOtpResponseEntity implements VerifyOtpResponseEntity {
  const _VerifyOtpResponseEntity({required this.otpToken, required this.message});
  factory _VerifyOtpResponseEntity.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseEntityFromJson(json);

@override final  String otpToken;
@override final  String message;

/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpResponseEntityCopyWith<_VerifyOtpResponseEntity> get copyWith => __$VerifyOtpResponseEntityCopyWithImpl<_VerifyOtpResponseEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerifyOtpResponseEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtpResponseEntity&&(identical(other.otpToken, otpToken) || other.otpToken == otpToken)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,otpToken,message);

@override
String toString() {
  return 'VerifyOtpResponseEntity(otpToken: $otpToken, message: $message)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpResponseEntityCopyWith<$Res> implements $VerifyOtpResponseEntityCopyWith<$Res> {
  factory _$VerifyOtpResponseEntityCopyWith(_VerifyOtpResponseEntity value, $Res Function(_VerifyOtpResponseEntity) _then) = __$VerifyOtpResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 String otpToken, String message
});




}
/// @nodoc
class __$VerifyOtpResponseEntityCopyWithImpl<$Res>
    implements _$VerifyOtpResponseEntityCopyWith<$Res> {
  __$VerifyOtpResponseEntityCopyWithImpl(this._self, this._then);

  final _VerifyOtpResponseEntity _self;
  final $Res Function(_VerifyOtpResponseEntity) _then;

/// Create a copy of VerifyOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otpToken = null,Object? message = null,}) {
  return _then(_VerifyOtpResponseEntity(
otpToken: null == otpToken ? _self.otpToken : otpToken // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AccountRequestEntity {

 String get username; String get email; String get password;
/// Create a copy of AccountRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountRequestEntityCopyWith<AccountRequestEntity> get copyWith => _$AccountRequestEntityCopyWithImpl<AccountRequestEntity>(this as AccountRequestEntity, _$identity);

  /// Serializes this AccountRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountRequestEntity&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,email,password);



}

/// @nodoc
abstract mixin class $AccountRequestEntityCopyWith<$Res>  {
  factory $AccountRequestEntityCopyWith(AccountRequestEntity value, $Res Function(AccountRequestEntity) _then) = _$AccountRequestEntityCopyWithImpl;
@useResult
$Res call({
 String username, String email, String password
});




}
/// @nodoc
class _$AccountRequestEntityCopyWithImpl<$Res>
    implements $AccountRequestEntityCopyWith<$Res> {
  _$AccountRequestEntityCopyWithImpl(this._self, this._then);

  final AccountRequestEntity _self;
  final $Res Function(AccountRequestEntity) _then;

/// Create a copy of AccountRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountRequestEntity].
extension AccountRequestEntityPatterns on AccountRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _AccountRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AccountRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountRequestEntity() when $default != null:
return $default(_that.username,_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _AccountRequestEntity():
return $default(_that.username,_that.email,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _AccountRequestEntity() when $default != null:
return $default(_that.username,_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountRequestEntity implements AccountRequestEntity {
  const _AccountRequestEntity({required this.username, required this.email, required this.password});
  factory _AccountRequestEntity.fromJson(Map<String, dynamic> json) => _$AccountRequestEntityFromJson(json);

@override final  String username;
@override final  String email;
@override final  String password;

/// Create a copy of AccountRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountRequestEntityCopyWith<_AccountRequestEntity> get copyWith => __$AccountRequestEntityCopyWithImpl<_AccountRequestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountRequestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountRequestEntity&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,email,password);



}

/// @nodoc
abstract mixin class _$AccountRequestEntityCopyWith<$Res> implements $AccountRequestEntityCopyWith<$Res> {
  factory _$AccountRequestEntityCopyWith(_AccountRequestEntity value, $Res Function(_AccountRequestEntity) _then) = __$AccountRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String username, String email, String password
});




}
/// @nodoc
class __$AccountRequestEntityCopyWithImpl<$Res>
    implements _$AccountRequestEntityCopyWith<$Res> {
  __$AccountRequestEntityCopyWithImpl(this._self, this._then);

  final _AccountRequestEntity _self;
  final $Res Function(_AccountRequestEntity) _then;

/// Create a copy of AccountRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? email = null,Object? password = null,}) {
  return _then(_AccountRequestEntity(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PartnerRequestEntity {

 String get taxCode; String get legalName; String get brandName; String get businessType; String get provinceId; String get districtId; String get wardId; String get streetAddress; String? get phoneNumber;
/// Create a copy of PartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerRequestEntityCopyWith<PartnerRequestEntity> get copyWith => _$PartnerRequestEntityCopyWithImpl<PartnerRequestEntity>(this as PartnerRequestEntity, _$identity);

  /// Serializes this PartnerRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerRequestEntity&&(identical(other.taxCode, taxCode) || other.taxCode == taxCode)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.businessType, businessType) || other.businessType == businessType)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.wardId, wardId) || other.wardId == wardId)&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taxCode,legalName,brandName,businessType,provinceId,districtId,wardId,streetAddress,phoneNumber);

@override
String toString() {
  return 'PartnerRequestEntity(taxCode: $taxCode, legalName: $legalName, brandName: $brandName, businessType: $businessType, provinceId: $provinceId, districtId: $districtId, wardId: $wardId, streetAddress: $streetAddress, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $PartnerRequestEntityCopyWith<$Res>  {
  factory $PartnerRequestEntityCopyWith(PartnerRequestEntity value, $Res Function(PartnerRequestEntity) _then) = _$PartnerRequestEntityCopyWithImpl;
@useResult
$Res call({
 String taxCode, String legalName, String brandName, String businessType, String provinceId, String districtId, String wardId, String streetAddress, String? phoneNumber
});




}
/// @nodoc
class _$PartnerRequestEntityCopyWithImpl<$Res>
    implements $PartnerRequestEntityCopyWith<$Res> {
  _$PartnerRequestEntityCopyWithImpl(this._self, this._then);

  final PartnerRequestEntity _self;
  final $Res Function(PartnerRequestEntity) _then;

/// Create a copy of PartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taxCode = null,Object? legalName = null,Object? brandName = null,Object? businessType = null,Object? provinceId = null,Object? districtId = null,Object? wardId = null,Object? streetAddress = null,Object? phoneNumber = freezed,}) {
  return _then(_self.copyWith(
taxCode: null == taxCode ? _self.taxCode : taxCode // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,businessType: null == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String,provinceId: null == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as String,districtId: null == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String,wardId: null == wardId ? _self.wardId : wardId // ignore: cast_nullable_to_non_nullable
as String,streetAddress: null == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnerRequestEntity].
extension PartnerRequestEntityPatterns on PartnerRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _PartnerRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taxCode,  String legalName,  String brandName,  String businessType,  String provinceId,  String districtId,  String wardId,  String streetAddress,  String? phoneNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnerRequestEntity() when $default != null:
return $default(_that.taxCode,_that.legalName,_that.brandName,_that.businessType,_that.provinceId,_that.districtId,_that.wardId,_that.streetAddress,_that.phoneNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taxCode,  String legalName,  String brandName,  String businessType,  String provinceId,  String districtId,  String wardId,  String streetAddress,  String? phoneNumber)  $default,) {final _that = this;
switch (_that) {
case _PartnerRequestEntity():
return $default(_that.taxCode,_that.legalName,_that.brandName,_that.businessType,_that.provinceId,_that.districtId,_that.wardId,_that.streetAddress,_that.phoneNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taxCode,  String legalName,  String brandName,  String businessType,  String provinceId,  String districtId,  String wardId,  String streetAddress,  String? phoneNumber)?  $default,) {final _that = this;
switch (_that) {
case _PartnerRequestEntity() when $default != null:
return $default(_that.taxCode,_that.legalName,_that.brandName,_that.businessType,_that.provinceId,_that.districtId,_that.wardId,_that.streetAddress,_that.phoneNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartnerRequestEntity implements PartnerRequestEntity {
  const _PartnerRequestEntity({required this.taxCode, required this.legalName, required this.brandName, required this.businessType, required this.provinceId, required this.districtId, required this.wardId, required this.streetAddress, this.phoneNumber});
  factory _PartnerRequestEntity.fromJson(Map<String, dynamic> json) => _$PartnerRequestEntityFromJson(json);

@override final  String taxCode;
@override final  String legalName;
@override final  String brandName;
@override final  String businessType;
@override final  String provinceId;
@override final  String districtId;
@override final  String wardId;
@override final  String streetAddress;
@override final  String? phoneNumber;

/// Create a copy of PartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerRequestEntityCopyWith<_PartnerRequestEntity> get copyWith => __$PartnerRequestEntityCopyWithImpl<_PartnerRequestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartnerRequestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerRequestEntity&&(identical(other.taxCode, taxCode) || other.taxCode == taxCode)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.businessType, businessType) || other.businessType == businessType)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.wardId, wardId) || other.wardId == wardId)&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taxCode,legalName,brandName,businessType,provinceId,districtId,wardId,streetAddress,phoneNumber);

@override
String toString() {
  return 'PartnerRequestEntity(taxCode: $taxCode, legalName: $legalName, brandName: $brandName, businessType: $businessType, provinceId: $provinceId, districtId: $districtId, wardId: $wardId, streetAddress: $streetAddress, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class _$PartnerRequestEntityCopyWith<$Res> implements $PartnerRequestEntityCopyWith<$Res> {
  factory _$PartnerRequestEntityCopyWith(_PartnerRequestEntity value, $Res Function(_PartnerRequestEntity) _then) = __$PartnerRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String taxCode, String legalName, String brandName, String businessType, String provinceId, String districtId, String wardId, String streetAddress, String? phoneNumber
});




}
/// @nodoc
class __$PartnerRequestEntityCopyWithImpl<$Res>
    implements _$PartnerRequestEntityCopyWith<$Res> {
  __$PartnerRequestEntityCopyWithImpl(this._self, this._then);

  final _PartnerRequestEntity _self;
  final $Res Function(_PartnerRequestEntity) _then;

/// Create a copy of PartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taxCode = null,Object? legalName = null,Object? brandName = null,Object? businessType = null,Object? provinceId = null,Object? districtId = null,Object? wardId = null,Object? streetAddress = null,Object? phoneNumber = freezed,}) {
  return _then(_PartnerRequestEntity(
taxCode: null == taxCode ? _self.taxCode : taxCode // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,businessType: null == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String,provinceId: null == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as String,districtId: null == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String,wardId: null == wardId ? _self.wardId : wardId // ignore: cast_nullable_to_non_nullable
as String,streetAddress: null == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$IdImagesEntity {

 String get frontImgUrl; String get backImgUrl;
/// Create a copy of IdImagesEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdImagesEntityCopyWith<IdImagesEntity> get copyWith => _$IdImagesEntityCopyWithImpl<IdImagesEntity>(this as IdImagesEntity, _$identity);

  /// Serializes this IdImagesEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdImagesEntity&&(identical(other.frontImgUrl, frontImgUrl) || other.frontImgUrl == frontImgUrl)&&(identical(other.backImgUrl, backImgUrl) || other.backImgUrl == backImgUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,frontImgUrl,backImgUrl);

@override
String toString() {
  return 'IdImagesEntity(frontImgUrl: $frontImgUrl, backImgUrl: $backImgUrl)';
}


}

/// @nodoc
abstract mixin class $IdImagesEntityCopyWith<$Res>  {
  factory $IdImagesEntityCopyWith(IdImagesEntity value, $Res Function(IdImagesEntity) _then) = _$IdImagesEntityCopyWithImpl;
@useResult
$Res call({
 String frontImgUrl, String backImgUrl
});




}
/// @nodoc
class _$IdImagesEntityCopyWithImpl<$Res>
    implements $IdImagesEntityCopyWith<$Res> {
  _$IdImagesEntityCopyWithImpl(this._self, this._then);

  final IdImagesEntity _self;
  final $Res Function(IdImagesEntity) _then;

/// Create a copy of IdImagesEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? frontImgUrl = null,Object? backImgUrl = null,}) {
  return _then(_self.copyWith(
frontImgUrl: null == frontImgUrl ? _self.frontImgUrl : frontImgUrl // ignore: cast_nullable_to_non_nullable
as String,backImgUrl: null == backImgUrl ? _self.backImgUrl : backImgUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IdImagesEntity].
extension IdImagesEntityPatterns on IdImagesEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IdImagesEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IdImagesEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IdImagesEntity value)  $default,){
final _that = this;
switch (_that) {
case _IdImagesEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IdImagesEntity value)?  $default,){
final _that = this;
switch (_that) {
case _IdImagesEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String frontImgUrl,  String backImgUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IdImagesEntity() when $default != null:
return $default(_that.frontImgUrl,_that.backImgUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String frontImgUrl,  String backImgUrl)  $default,) {final _that = this;
switch (_that) {
case _IdImagesEntity():
return $default(_that.frontImgUrl,_that.backImgUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String frontImgUrl,  String backImgUrl)?  $default,) {final _that = this;
switch (_that) {
case _IdImagesEntity() when $default != null:
return $default(_that.frontImgUrl,_that.backImgUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IdImagesEntity implements IdImagesEntity {
  const _IdImagesEntity({required this.frontImgUrl, required this.backImgUrl});
  factory _IdImagesEntity.fromJson(Map<String, dynamic> json) => _$IdImagesEntityFromJson(json);

@override final  String frontImgUrl;
@override final  String backImgUrl;

/// Create a copy of IdImagesEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdImagesEntityCopyWith<_IdImagesEntity> get copyWith => __$IdImagesEntityCopyWithImpl<_IdImagesEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IdImagesEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdImagesEntity&&(identical(other.frontImgUrl, frontImgUrl) || other.frontImgUrl == frontImgUrl)&&(identical(other.backImgUrl, backImgUrl) || other.backImgUrl == backImgUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,frontImgUrl,backImgUrl);

@override
String toString() {
  return 'IdImagesEntity(frontImgUrl: $frontImgUrl, backImgUrl: $backImgUrl)';
}


}

/// @nodoc
abstract mixin class _$IdImagesEntityCopyWith<$Res> implements $IdImagesEntityCopyWith<$Res> {
  factory _$IdImagesEntityCopyWith(_IdImagesEntity value, $Res Function(_IdImagesEntity) _then) = __$IdImagesEntityCopyWithImpl;
@override @useResult
$Res call({
 String frontImgUrl, String backImgUrl
});




}
/// @nodoc
class __$IdImagesEntityCopyWithImpl<$Res>
    implements _$IdImagesEntityCopyWith<$Res> {
  __$IdImagesEntityCopyWithImpl(this._self, this._then);

  final _IdImagesEntity _self;
  final $Res Function(_IdImagesEntity) _then;

/// Create a copy of IdImagesEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? frontImgUrl = null,Object? backImgUrl = null,}) {
  return _then(_IdImagesEntity(
frontImgUrl: null == frontImgUrl ? _self.frontImgUrl : frontImgUrl // ignore: cast_nullable_to_non_nullable
as String,backImgUrl: null == backImgUrl ? _self.backImgUrl : backImgUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AuthorizationEntity {

 bool get isAuthorizedUser; String? get authLetterDocUrl;
/// Create a copy of AuthorizationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorizationEntityCopyWith<AuthorizationEntity> get copyWith => _$AuthorizationEntityCopyWithImpl<AuthorizationEntity>(this as AuthorizationEntity, _$identity);

  /// Serializes this AuthorizationEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorizationEntity&&(identical(other.isAuthorizedUser, isAuthorizedUser) || other.isAuthorizedUser == isAuthorizedUser)&&(identical(other.authLetterDocUrl, authLetterDocUrl) || other.authLetterDocUrl == authLetterDocUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isAuthorizedUser,authLetterDocUrl);

@override
String toString() {
  return 'AuthorizationEntity(isAuthorizedUser: $isAuthorizedUser, authLetterDocUrl: $authLetterDocUrl)';
}


}

/// @nodoc
abstract mixin class $AuthorizationEntityCopyWith<$Res>  {
  factory $AuthorizationEntityCopyWith(AuthorizationEntity value, $Res Function(AuthorizationEntity) _then) = _$AuthorizationEntityCopyWithImpl;
@useResult
$Res call({
 bool isAuthorizedUser, String? authLetterDocUrl
});




}
/// @nodoc
class _$AuthorizationEntityCopyWithImpl<$Res>
    implements $AuthorizationEntityCopyWith<$Res> {
  _$AuthorizationEntityCopyWithImpl(this._self, this._then);

  final AuthorizationEntity _self;
  final $Res Function(AuthorizationEntity) _then;

/// Create a copy of AuthorizationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAuthorizedUser = null,Object? authLetterDocUrl = freezed,}) {
  return _then(_self.copyWith(
isAuthorizedUser: null == isAuthorizedUser ? _self.isAuthorizedUser : isAuthorizedUser // ignore: cast_nullable_to_non_nullable
as bool,authLetterDocUrl: freezed == authLetterDocUrl ? _self.authLetterDocUrl : authLetterDocUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorizationEntity].
extension AuthorizationEntityPatterns on AuthorizationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorizationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorizationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorizationEntity value)  $default,){
final _that = this;
switch (_that) {
case _AuthorizationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorizationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorizationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAuthorizedUser,  String? authLetterDocUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorizationEntity() when $default != null:
return $default(_that.isAuthorizedUser,_that.authLetterDocUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAuthorizedUser,  String? authLetterDocUrl)  $default,) {final _that = this;
switch (_that) {
case _AuthorizationEntity():
return $default(_that.isAuthorizedUser,_that.authLetterDocUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAuthorizedUser,  String? authLetterDocUrl)?  $default,) {final _that = this;
switch (_that) {
case _AuthorizationEntity() when $default != null:
return $default(_that.isAuthorizedUser,_that.authLetterDocUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorizationEntity implements AuthorizationEntity {
  const _AuthorizationEntity({required this.isAuthorizedUser, this.authLetterDocUrl});
  factory _AuthorizationEntity.fromJson(Map<String, dynamic> json) => _$AuthorizationEntityFromJson(json);

@override final  bool isAuthorizedUser;
@override final  String? authLetterDocUrl;

/// Create a copy of AuthorizationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorizationEntityCopyWith<_AuthorizationEntity> get copyWith => __$AuthorizationEntityCopyWithImpl<_AuthorizationEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorizationEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorizationEntity&&(identical(other.isAuthorizedUser, isAuthorizedUser) || other.isAuthorizedUser == isAuthorizedUser)&&(identical(other.authLetterDocUrl, authLetterDocUrl) || other.authLetterDocUrl == authLetterDocUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isAuthorizedUser,authLetterDocUrl);

@override
String toString() {
  return 'AuthorizationEntity(isAuthorizedUser: $isAuthorizedUser, authLetterDocUrl: $authLetterDocUrl)';
}


}

/// @nodoc
abstract mixin class _$AuthorizationEntityCopyWith<$Res> implements $AuthorizationEntityCopyWith<$Res> {
  factory _$AuthorizationEntityCopyWith(_AuthorizationEntity value, $Res Function(_AuthorizationEntity) _then) = __$AuthorizationEntityCopyWithImpl;
@override @useResult
$Res call({
 bool isAuthorizedUser, String? authLetterDocUrl
});




}
/// @nodoc
class __$AuthorizationEntityCopyWithImpl<$Res>
    implements _$AuthorizationEntityCopyWith<$Res> {
  __$AuthorizationEntityCopyWithImpl(this._self, this._then);

  final _AuthorizationEntity _self;
  final $Res Function(_AuthorizationEntity) _then;

/// Create a copy of AuthorizationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAuthorizedUser = null,Object? authLetterDocUrl = freezed,}) {
  return _then(_AuthorizationEntity(
isAuthorizedUser: null == isAuthorizedUser ? _self.isAuthorizedUser : isAuthorizedUser // ignore: cast_nullable_to_non_nullable
as bool,authLetterDocUrl: freezed == authLetterDocUrl ? _self.authLetterDocUrl : authLetterDocUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PartnerDocumentVerificationEntity {

 String? get businessLicenseUrl; String? get authorizationLetterUrl; String? get taxCertificateUrl; List<String> get otherDocumentUrls;
/// Create a copy of PartnerDocumentVerificationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerDocumentVerificationEntityCopyWith<PartnerDocumentVerificationEntity> get copyWith => _$PartnerDocumentVerificationEntityCopyWithImpl<PartnerDocumentVerificationEntity>(this as PartnerDocumentVerificationEntity, _$identity);

  /// Serializes this PartnerDocumentVerificationEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerDocumentVerificationEntity&&(identical(other.businessLicenseUrl, businessLicenseUrl) || other.businessLicenseUrl == businessLicenseUrl)&&(identical(other.authorizationLetterUrl, authorizationLetterUrl) || other.authorizationLetterUrl == authorizationLetterUrl)&&(identical(other.taxCertificateUrl, taxCertificateUrl) || other.taxCertificateUrl == taxCertificateUrl)&&const DeepCollectionEquality().equals(other.otherDocumentUrls, otherDocumentUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,businessLicenseUrl,authorizationLetterUrl,taxCertificateUrl,const DeepCollectionEquality().hash(otherDocumentUrls));

@override
String toString() {
  return 'PartnerDocumentVerificationEntity(businessLicenseUrl: $businessLicenseUrl, authorizationLetterUrl: $authorizationLetterUrl, taxCertificateUrl: $taxCertificateUrl, otherDocumentUrls: $otherDocumentUrls)';
}


}

/// @nodoc
abstract mixin class $PartnerDocumentVerificationEntityCopyWith<$Res>  {
  factory $PartnerDocumentVerificationEntityCopyWith(PartnerDocumentVerificationEntity value, $Res Function(PartnerDocumentVerificationEntity) _then) = _$PartnerDocumentVerificationEntityCopyWithImpl;
@useResult
$Res call({
 String? businessLicenseUrl, String? authorizationLetterUrl, String? taxCertificateUrl, List<String> otherDocumentUrls
});




}
/// @nodoc
class _$PartnerDocumentVerificationEntityCopyWithImpl<$Res>
    implements $PartnerDocumentVerificationEntityCopyWith<$Res> {
  _$PartnerDocumentVerificationEntityCopyWithImpl(this._self, this._then);

  final PartnerDocumentVerificationEntity _self;
  final $Res Function(PartnerDocumentVerificationEntity) _then;

/// Create a copy of PartnerDocumentVerificationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? businessLicenseUrl = freezed,Object? authorizationLetterUrl = freezed,Object? taxCertificateUrl = freezed,Object? otherDocumentUrls = null,}) {
  return _then(_self.copyWith(
businessLicenseUrl: freezed == businessLicenseUrl ? _self.businessLicenseUrl : businessLicenseUrl // ignore: cast_nullable_to_non_nullable
as String?,authorizationLetterUrl: freezed == authorizationLetterUrl ? _self.authorizationLetterUrl : authorizationLetterUrl // ignore: cast_nullable_to_non_nullable
as String?,taxCertificateUrl: freezed == taxCertificateUrl ? _self.taxCertificateUrl : taxCertificateUrl // ignore: cast_nullable_to_non_nullable
as String?,otherDocumentUrls: null == otherDocumentUrls ? _self.otherDocumentUrls : otherDocumentUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnerDocumentVerificationEntity].
extension PartnerDocumentVerificationEntityPatterns on PartnerDocumentVerificationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerDocumentVerificationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerDocumentVerificationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerDocumentVerificationEntity value)  $default,){
final _that = this;
switch (_that) {
case _PartnerDocumentVerificationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerDocumentVerificationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerDocumentVerificationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? businessLicenseUrl,  String? authorizationLetterUrl,  String? taxCertificateUrl,  List<String> otherDocumentUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnerDocumentVerificationEntity() when $default != null:
return $default(_that.businessLicenseUrl,_that.authorizationLetterUrl,_that.taxCertificateUrl,_that.otherDocumentUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? businessLicenseUrl,  String? authorizationLetterUrl,  String? taxCertificateUrl,  List<String> otherDocumentUrls)  $default,) {final _that = this;
switch (_that) {
case _PartnerDocumentVerificationEntity():
return $default(_that.businessLicenseUrl,_that.authorizationLetterUrl,_that.taxCertificateUrl,_that.otherDocumentUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? businessLicenseUrl,  String? authorizationLetterUrl,  String? taxCertificateUrl,  List<String> otherDocumentUrls)?  $default,) {final _that = this;
switch (_that) {
case _PartnerDocumentVerificationEntity() when $default != null:
return $default(_that.businessLicenseUrl,_that.authorizationLetterUrl,_that.taxCertificateUrl,_that.otherDocumentUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartnerDocumentVerificationEntity implements PartnerDocumentVerificationEntity {
  const _PartnerDocumentVerificationEntity({this.businessLicenseUrl, this.authorizationLetterUrl, this.taxCertificateUrl, final  List<String> otherDocumentUrls = const []}): _otherDocumentUrls = otherDocumentUrls;
  factory _PartnerDocumentVerificationEntity.fromJson(Map<String, dynamic> json) => _$PartnerDocumentVerificationEntityFromJson(json);

@override final  String? businessLicenseUrl;
@override final  String? authorizationLetterUrl;
@override final  String? taxCertificateUrl;
 final  List<String> _otherDocumentUrls;
@override@JsonKey() List<String> get otherDocumentUrls {
  if (_otherDocumentUrls is EqualUnmodifiableListView) return _otherDocumentUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_otherDocumentUrls);
}


/// Create a copy of PartnerDocumentVerificationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerDocumentVerificationEntityCopyWith<_PartnerDocumentVerificationEntity> get copyWith => __$PartnerDocumentVerificationEntityCopyWithImpl<_PartnerDocumentVerificationEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartnerDocumentVerificationEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerDocumentVerificationEntity&&(identical(other.businessLicenseUrl, businessLicenseUrl) || other.businessLicenseUrl == businessLicenseUrl)&&(identical(other.authorizationLetterUrl, authorizationLetterUrl) || other.authorizationLetterUrl == authorizationLetterUrl)&&(identical(other.taxCertificateUrl, taxCertificateUrl) || other.taxCertificateUrl == taxCertificateUrl)&&const DeepCollectionEquality().equals(other._otherDocumentUrls, _otherDocumentUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,businessLicenseUrl,authorizationLetterUrl,taxCertificateUrl,const DeepCollectionEquality().hash(_otherDocumentUrls));

@override
String toString() {
  return 'PartnerDocumentVerificationEntity(businessLicenseUrl: $businessLicenseUrl, authorizationLetterUrl: $authorizationLetterUrl, taxCertificateUrl: $taxCertificateUrl, otherDocumentUrls: $otherDocumentUrls)';
}


}

/// @nodoc
abstract mixin class _$PartnerDocumentVerificationEntityCopyWith<$Res> implements $PartnerDocumentVerificationEntityCopyWith<$Res> {
  factory _$PartnerDocumentVerificationEntityCopyWith(_PartnerDocumentVerificationEntity value, $Res Function(_PartnerDocumentVerificationEntity) _then) = __$PartnerDocumentVerificationEntityCopyWithImpl;
@override @useResult
$Res call({
 String? businessLicenseUrl, String? authorizationLetterUrl, String? taxCertificateUrl, List<String> otherDocumentUrls
});




}
/// @nodoc
class __$PartnerDocumentVerificationEntityCopyWithImpl<$Res>
    implements _$PartnerDocumentVerificationEntityCopyWith<$Res> {
  __$PartnerDocumentVerificationEntityCopyWithImpl(this._self, this._then);

  final _PartnerDocumentVerificationEntity _self;
  final $Res Function(_PartnerDocumentVerificationEntity) _then;

/// Create a copy of PartnerDocumentVerificationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? businessLicenseUrl = freezed,Object? authorizationLetterUrl = freezed,Object? taxCertificateUrl = freezed,Object? otherDocumentUrls = null,}) {
  return _then(_PartnerDocumentVerificationEntity(
businessLicenseUrl: freezed == businessLicenseUrl ? _self.businessLicenseUrl : businessLicenseUrl // ignore: cast_nullable_to_non_nullable
as String?,authorizationLetterUrl: freezed == authorizationLetterUrl ? _self.authorizationLetterUrl : authorizationLetterUrl // ignore: cast_nullable_to_non_nullable
as String?,taxCertificateUrl: freezed == taxCertificateUrl ? _self.taxCertificateUrl : taxCertificateUrl // ignore: cast_nullable_to_non_nullable
as String?,otherDocumentUrls: null == otherDocumentUrls ? _self._otherDocumentUrls : otherDocumentUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$LegalRepresentativeEntity {

 String get fullName; String? get position; String? get phoneNumber; String get idType; String get idNumber; String get idIssueDate; IdImagesEntity get images; PartnerDocumentVerificationEntity get documents;
/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalRepresentativeEntityCopyWith<LegalRepresentativeEntity> get copyWith => _$LegalRepresentativeEntityCopyWithImpl<LegalRepresentativeEntity>(this as LegalRepresentativeEntity, _$identity);

  /// Serializes this LegalRepresentativeEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalRepresentativeEntity&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.position, position) || other.position == position)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.idIssueDate, idIssueDate) || other.idIssueDate == idIssueDate)&&(identical(other.images, images) || other.images == images)&&(identical(other.documents, documents) || other.documents == documents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,position,phoneNumber,idType,idNumber,idIssueDate,images,documents);

@override
String toString() {
  return 'LegalRepresentativeEntity(fullName: $fullName, position: $position, phoneNumber: $phoneNumber, idType: $idType, idNumber: $idNumber, idIssueDate: $idIssueDate, images: $images, documents: $documents)';
}


}

/// @nodoc
abstract mixin class $LegalRepresentativeEntityCopyWith<$Res>  {
  factory $LegalRepresentativeEntityCopyWith(LegalRepresentativeEntity value, $Res Function(LegalRepresentativeEntity) _then) = _$LegalRepresentativeEntityCopyWithImpl;
@useResult
$Res call({
 String fullName, String? position, String? phoneNumber, String idType, String idNumber, String idIssueDate, IdImagesEntity images, PartnerDocumentVerificationEntity documents
});


$IdImagesEntityCopyWith<$Res> get images;$PartnerDocumentVerificationEntityCopyWith<$Res> get documents;

}
/// @nodoc
class _$LegalRepresentativeEntityCopyWithImpl<$Res>
    implements $LegalRepresentativeEntityCopyWith<$Res> {
  _$LegalRepresentativeEntityCopyWithImpl(this._self, this._then);

  final LegalRepresentativeEntity _self;
  final $Res Function(LegalRepresentativeEntity) _then;

/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? position = freezed,Object? phoneNumber = freezed,Object? idType = null,Object? idNumber = null,Object? idIssueDate = null,Object? images = null,Object? documents = null,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,idType: null == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,idIssueDate: null == idIssueDate ? _self.idIssueDate : idIssueDate // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as IdImagesEntity,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as PartnerDocumentVerificationEntity,
  ));
}
/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdImagesEntityCopyWith<$Res> get images {
  
  return $IdImagesEntityCopyWith<$Res>(_self.images, (value) {
    return _then(_self.copyWith(images: value));
  });
}/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnerDocumentVerificationEntityCopyWith<$Res> get documents {
  
  return $PartnerDocumentVerificationEntityCopyWith<$Res>(_self.documents, (value) {
    return _then(_self.copyWith(documents: value));
  });
}
}


/// Adds pattern-matching-related methods to [LegalRepresentativeEntity].
extension LegalRepresentativeEntityPatterns on LegalRepresentativeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LegalRepresentativeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LegalRepresentativeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LegalRepresentativeEntity value)  $default,){
final _that = this;
switch (_that) {
case _LegalRepresentativeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LegalRepresentativeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LegalRepresentativeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String? position,  String? phoneNumber,  String idType,  String idNumber,  String idIssueDate,  IdImagesEntity images,  PartnerDocumentVerificationEntity documents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LegalRepresentativeEntity() when $default != null:
return $default(_that.fullName,_that.position,_that.phoneNumber,_that.idType,_that.idNumber,_that.idIssueDate,_that.images,_that.documents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String? position,  String? phoneNumber,  String idType,  String idNumber,  String idIssueDate,  IdImagesEntity images,  PartnerDocumentVerificationEntity documents)  $default,) {final _that = this;
switch (_that) {
case _LegalRepresentativeEntity():
return $default(_that.fullName,_that.position,_that.phoneNumber,_that.idType,_that.idNumber,_that.idIssueDate,_that.images,_that.documents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String? position,  String? phoneNumber,  String idType,  String idNumber,  String idIssueDate,  IdImagesEntity images,  PartnerDocumentVerificationEntity documents)?  $default,) {final _that = this;
switch (_that) {
case _LegalRepresentativeEntity() when $default != null:
return $default(_that.fullName,_that.position,_that.phoneNumber,_that.idType,_that.idNumber,_that.idIssueDate,_that.images,_that.documents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LegalRepresentativeEntity implements LegalRepresentativeEntity {
  const _LegalRepresentativeEntity({required this.fullName, this.position, this.phoneNumber, required this.idType, required this.idNumber, required this.idIssueDate, required this.images, required this.documents});
  factory _LegalRepresentativeEntity.fromJson(Map<String, dynamic> json) => _$LegalRepresentativeEntityFromJson(json);

@override final  String fullName;
@override final  String? position;
@override final  String? phoneNumber;
@override final  String idType;
@override final  String idNumber;
@override final  String idIssueDate;
@override final  IdImagesEntity images;
@override final  PartnerDocumentVerificationEntity documents;

/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LegalRepresentativeEntityCopyWith<_LegalRepresentativeEntity> get copyWith => __$LegalRepresentativeEntityCopyWithImpl<_LegalRepresentativeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LegalRepresentativeEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LegalRepresentativeEntity&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.position, position) || other.position == position)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.idIssueDate, idIssueDate) || other.idIssueDate == idIssueDate)&&(identical(other.images, images) || other.images == images)&&(identical(other.documents, documents) || other.documents == documents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,position,phoneNumber,idType,idNumber,idIssueDate,images,documents);

@override
String toString() {
  return 'LegalRepresentativeEntity(fullName: $fullName, position: $position, phoneNumber: $phoneNumber, idType: $idType, idNumber: $idNumber, idIssueDate: $idIssueDate, images: $images, documents: $documents)';
}


}

/// @nodoc
abstract mixin class _$LegalRepresentativeEntityCopyWith<$Res> implements $LegalRepresentativeEntityCopyWith<$Res> {
  factory _$LegalRepresentativeEntityCopyWith(_LegalRepresentativeEntity value, $Res Function(_LegalRepresentativeEntity) _then) = __$LegalRepresentativeEntityCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String? position, String? phoneNumber, String idType, String idNumber, String idIssueDate, IdImagesEntity images, PartnerDocumentVerificationEntity documents
});


@override $IdImagesEntityCopyWith<$Res> get images;@override $PartnerDocumentVerificationEntityCopyWith<$Res> get documents;

}
/// @nodoc
class __$LegalRepresentativeEntityCopyWithImpl<$Res>
    implements _$LegalRepresentativeEntityCopyWith<$Res> {
  __$LegalRepresentativeEntityCopyWithImpl(this._self, this._then);

  final _LegalRepresentativeEntity _self;
  final $Res Function(_LegalRepresentativeEntity) _then;

/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? position = freezed,Object? phoneNumber = freezed,Object? idType = null,Object? idNumber = null,Object? idIssueDate = null,Object? images = null,Object? documents = null,}) {
  return _then(_LegalRepresentativeEntity(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,idType: null == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,idIssueDate: null == idIssueDate ? _self.idIssueDate : idIssueDate // ignore: cast_nullable_to_non_nullable
as String,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as IdImagesEntity,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as PartnerDocumentVerificationEntity,
  ));
}

/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdImagesEntityCopyWith<$Res> get images {
  
  return $IdImagesEntityCopyWith<$Res>(_self.images, (value) {
    return _then(_self.copyWith(images: value));
  });
}/// Create a copy of LegalRepresentativeEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnerDocumentVerificationEntityCopyWith<$Res> get documents {
  
  return $PartnerDocumentVerificationEntityCopyWith<$Res>(_self.documents, (value) {
    return _then(_self.copyWith(documents: value));
  });
}
}


/// @nodoc
mixin _$RegisterPartnerRequestEntity {

 AccountRequestEntity get account; PartnerRequestEntity get partner; LegalRepresentativeEntity get legalRepresentative;
/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterPartnerRequestEntityCopyWith<RegisterPartnerRequestEntity> get copyWith => _$RegisterPartnerRequestEntityCopyWithImpl<RegisterPartnerRequestEntity>(this as RegisterPartnerRequestEntity, _$identity);

  /// Serializes this RegisterPartnerRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterPartnerRequestEntity&&(identical(other.account, account) || other.account == account)&&(identical(other.partner, partner) || other.partner == partner)&&(identical(other.legalRepresentative, legalRepresentative) || other.legalRepresentative == legalRepresentative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,account,partner,legalRepresentative);



}

/// @nodoc
abstract mixin class $RegisterPartnerRequestEntityCopyWith<$Res>  {
  factory $RegisterPartnerRequestEntityCopyWith(RegisterPartnerRequestEntity value, $Res Function(RegisterPartnerRequestEntity) _then) = _$RegisterPartnerRequestEntityCopyWithImpl;
@useResult
$Res call({
 AccountRequestEntity account, PartnerRequestEntity partner, LegalRepresentativeEntity legalRepresentative
});


$AccountRequestEntityCopyWith<$Res> get account;$PartnerRequestEntityCopyWith<$Res> get partner;$LegalRepresentativeEntityCopyWith<$Res> get legalRepresentative;

}
/// @nodoc
class _$RegisterPartnerRequestEntityCopyWithImpl<$Res>
    implements $RegisterPartnerRequestEntityCopyWith<$Res> {
  _$RegisterPartnerRequestEntityCopyWithImpl(this._self, this._then);

  final RegisterPartnerRequestEntity _self;
  final $Res Function(RegisterPartnerRequestEntity) _then;

/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? account = null,Object? partner = null,Object? legalRepresentative = null,}) {
  return _then(_self.copyWith(
account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountRequestEntity,partner: null == partner ? _self.partner : partner // ignore: cast_nullable_to_non_nullable
as PartnerRequestEntity,legalRepresentative: null == legalRepresentative ? _self.legalRepresentative : legalRepresentative // ignore: cast_nullable_to_non_nullable
as LegalRepresentativeEntity,
  ));
}
/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountRequestEntityCopyWith<$Res> get account {
  
  return $AccountRequestEntityCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnerRequestEntityCopyWith<$Res> get partner {
  
  return $PartnerRequestEntityCopyWith<$Res>(_self.partner, (value) {
    return _then(_self.copyWith(partner: value));
  });
}/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LegalRepresentativeEntityCopyWith<$Res> get legalRepresentative {
  
  return $LegalRepresentativeEntityCopyWith<$Res>(_self.legalRepresentative, (value) {
    return _then(_self.copyWith(legalRepresentative: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterPartnerRequestEntity].
extension RegisterPartnerRequestEntityPatterns on RegisterPartnerRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterPartnerRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterPartnerRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterPartnerRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _RegisterPartnerRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterPartnerRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterPartnerRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountRequestEntity account,  PartnerRequestEntity partner,  LegalRepresentativeEntity legalRepresentative)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterPartnerRequestEntity() when $default != null:
return $default(_that.account,_that.partner,_that.legalRepresentative);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountRequestEntity account,  PartnerRequestEntity partner,  LegalRepresentativeEntity legalRepresentative)  $default,) {final _that = this;
switch (_that) {
case _RegisterPartnerRequestEntity():
return $default(_that.account,_that.partner,_that.legalRepresentative);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountRequestEntity account,  PartnerRequestEntity partner,  LegalRepresentativeEntity legalRepresentative)?  $default,) {final _that = this;
switch (_that) {
case _RegisterPartnerRequestEntity() when $default != null:
return $default(_that.account,_that.partner,_that.legalRepresentative);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterPartnerRequestEntity implements RegisterPartnerRequestEntity {
  const _RegisterPartnerRequestEntity({required this.account, required this.partner, required this.legalRepresentative});
  factory _RegisterPartnerRequestEntity.fromJson(Map<String, dynamic> json) => _$RegisterPartnerRequestEntityFromJson(json);

@override final  AccountRequestEntity account;
@override final  PartnerRequestEntity partner;
@override final  LegalRepresentativeEntity legalRepresentative;

/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterPartnerRequestEntityCopyWith<_RegisterPartnerRequestEntity> get copyWith => __$RegisterPartnerRequestEntityCopyWithImpl<_RegisterPartnerRequestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterPartnerRequestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterPartnerRequestEntity&&(identical(other.account, account) || other.account == account)&&(identical(other.partner, partner) || other.partner == partner)&&(identical(other.legalRepresentative, legalRepresentative) || other.legalRepresentative == legalRepresentative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,account,partner,legalRepresentative);



}

/// @nodoc
abstract mixin class _$RegisterPartnerRequestEntityCopyWith<$Res> implements $RegisterPartnerRequestEntityCopyWith<$Res> {
  factory _$RegisterPartnerRequestEntityCopyWith(_RegisterPartnerRequestEntity value, $Res Function(_RegisterPartnerRequestEntity) _then) = __$RegisterPartnerRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 AccountRequestEntity account, PartnerRequestEntity partner, LegalRepresentativeEntity legalRepresentative
});


@override $AccountRequestEntityCopyWith<$Res> get account;@override $PartnerRequestEntityCopyWith<$Res> get partner;@override $LegalRepresentativeEntityCopyWith<$Res> get legalRepresentative;

}
/// @nodoc
class __$RegisterPartnerRequestEntityCopyWithImpl<$Res>
    implements _$RegisterPartnerRequestEntityCopyWith<$Res> {
  __$RegisterPartnerRequestEntityCopyWithImpl(this._self, this._then);

  final _RegisterPartnerRequestEntity _self;
  final $Res Function(_RegisterPartnerRequestEntity) _then;

/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? account = null,Object? partner = null,Object? legalRepresentative = null,}) {
  return _then(_RegisterPartnerRequestEntity(
account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountRequestEntity,partner: null == partner ? _self.partner : partner // ignore: cast_nullable_to_non_nullable
as PartnerRequestEntity,legalRepresentative: null == legalRepresentative ? _self.legalRepresentative : legalRepresentative // ignore: cast_nullable_to_non_nullable
as LegalRepresentativeEntity,
  ));
}

/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountRequestEntityCopyWith<$Res> get account {
  
  return $AccountRequestEntityCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartnerRequestEntityCopyWith<$Res> get partner {
  
  return $PartnerRequestEntityCopyWith<$Res>(_self.partner, (value) {
    return _then(_self.copyWith(partner: value));
  });
}/// Create a copy of RegisterPartnerRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LegalRepresentativeEntityCopyWith<$Res> get legalRepresentative {
  
  return $LegalRepresentativeEntityCopyWith<$Res>(_self.legalRepresentative, (value) {
    return _then(_self.copyWith(legalRepresentative: value));
  });
}
}


/// @nodoc
mixin _$RegisterPartnerResponseEntity {

 String get accountId; String get businessEntityId; String get status; String get message; String get accessToken; String get accessExpiresIn; String get refreshToken; String get refreshExpiresIn;
/// Create a copy of RegisterPartnerResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterPartnerResponseEntityCopyWith<RegisterPartnerResponseEntity> get copyWith => _$RegisterPartnerResponseEntityCopyWithImpl<RegisterPartnerResponseEntity>(this as RegisterPartnerResponseEntity, _$identity);

  /// Serializes this RegisterPartnerResponseEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterPartnerResponseEntity&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.businessEntityId, businessEntityId) || other.businessEntityId == businessEntityId)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessExpiresIn, accessExpiresIn) || other.accessExpiresIn == accessExpiresIn)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshExpiresIn, refreshExpiresIn) || other.refreshExpiresIn == refreshExpiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,businessEntityId,status,message,accessToken,accessExpiresIn,refreshToken,refreshExpiresIn);

@override
String toString() {
  return 'RegisterPartnerResponseEntity(accountId: $accountId, businessEntityId: $businessEntityId, status: $status, message: $message, accessToken: $accessToken, accessExpiresIn: $accessExpiresIn, refreshToken: $refreshToken, refreshExpiresIn: $refreshExpiresIn)';
}


}

/// @nodoc
abstract mixin class $RegisterPartnerResponseEntityCopyWith<$Res>  {
  factory $RegisterPartnerResponseEntityCopyWith(RegisterPartnerResponseEntity value, $Res Function(RegisterPartnerResponseEntity) _then) = _$RegisterPartnerResponseEntityCopyWithImpl;
@useResult
$Res call({
 String accountId, String businessEntityId, String status, String message, String accessToken, String accessExpiresIn, String refreshToken, String refreshExpiresIn
});




}
/// @nodoc
class _$RegisterPartnerResponseEntityCopyWithImpl<$Res>
    implements $RegisterPartnerResponseEntityCopyWith<$Res> {
  _$RegisterPartnerResponseEntityCopyWithImpl(this._self, this._then);

  final RegisterPartnerResponseEntity _self;
  final $Res Function(RegisterPartnerResponseEntity) _then;

/// Create a copy of RegisterPartnerResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = null,Object? businessEntityId = null,Object? status = null,Object? message = null,Object? accessToken = null,Object? accessExpiresIn = null,Object? refreshToken = null,Object? refreshExpiresIn = null,}) {
  return _then(_self.copyWith(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,businessEntityId: null == businessEntityId ? _self.businessEntityId : businessEntityId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessExpiresIn: null == accessExpiresIn ? _self.accessExpiresIn : accessExpiresIn // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshExpiresIn: null == refreshExpiresIn ? _self.refreshExpiresIn : refreshExpiresIn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterPartnerResponseEntity].
extension RegisterPartnerResponseEntityPatterns on RegisterPartnerResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterPartnerResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterPartnerResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterPartnerResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _RegisterPartnerResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterPartnerResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterPartnerResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountId,  String businessEntityId,  String status,  String message,  String accessToken,  String accessExpiresIn,  String refreshToken,  String refreshExpiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterPartnerResponseEntity() when $default != null:
return $default(_that.accountId,_that.businessEntityId,_that.status,_that.message,_that.accessToken,_that.accessExpiresIn,_that.refreshToken,_that.refreshExpiresIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountId,  String businessEntityId,  String status,  String message,  String accessToken,  String accessExpiresIn,  String refreshToken,  String refreshExpiresIn)  $default,) {final _that = this;
switch (_that) {
case _RegisterPartnerResponseEntity():
return $default(_that.accountId,_that.businessEntityId,_that.status,_that.message,_that.accessToken,_that.accessExpiresIn,_that.refreshToken,_that.refreshExpiresIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountId,  String businessEntityId,  String status,  String message,  String accessToken,  String accessExpiresIn,  String refreshToken,  String refreshExpiresIn)?  $default,) {final _that = this;
switch (_that) {
case _RegisterPartnerResponseEntity() when $default != null:
return $default(_that.accountId,_that.businessEntityId,_that.status,_that.message,_that.accessToken,_that.accessExpiresIn,_that.refreshToken,_that.refreshExpiresIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterPartnerResponseEntity implements RegisterPartnerResponseEntity {
  const _RegisterPartnerResponseEntity({required this.accountId, required this.businessEntityId, required this.status, required this.message, required this.accessToken, required this.accessExpiresIn, required this.refreshToken, required this.refreshExpiresIn});
  factory _RegisterPartnerResponseEntity.fromJson(Map<String, dynamic> json) => _$RegisterPartnerResponseEntityFromJson(json);

@override final  String accountId;
@override final  String businessEntityId;
@override final  String status;
@override final  String message;
@override final  String accessToken;
@override final  String accessExpiresIn;
@override final  String refreshToken;
@override final  String refreshExpiresIn;

/// Create a copy of RegisterPartnerResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterPartnerResponseEntityCopyWith<_RegisterPartnerResponseEntity> get copyWith => __$RegisterPartnerResponseEntityCopyWithImpl<_RegisterPartnerResponseEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterPartnerResponseEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterPartnerResponseEntity&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.businessEntityId, businessEntityId) || other.businessEntityId == businessEntityId)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessExpiresIn, accessExpiresIn) || other.accessExpiresIn == accessExpiresIn)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshExpiresIn, refreshExpiresIn) || other.refreshExpiresIn == refreshExpiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountId,businessEntityId,status,message,accessToken,accessExpiresIn,refreshToken,refreshExpiresIn);

@override
String toString() {
  return 'RegisterPartnerResponseEntity(accountId: $accountId, businessEntityId: $businessEntityId, status: $status, message: $message, accessToken: $accessToken, accessExpiresIn: $accessExpiresIn, refreshToken: $refreshToken, refreshExpiresIn: $refreshExpiresIn)';
}


}

/// @nodoc
abstract mixin class _$RegisterPartnerResponseEntityCopyWith<$Res> implements $RegisterPartnerResponseEntityCopyWith<$Res> {
  factory _$RegisterPartnerResponseEntityCopyWith(_RegisterPartnerResponseEntity value, $Res Function(_RegisterPartnerResponseEntity) _then) = __$RegisterPartnerResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 String accountId, String businessEntityId, String status, String message, String accessToken, String accessExpiresIn, String refreshToken, String refreshExpiresIn
});




}
/// @nodoc
class __$RegisterPartnerResponseEntityCopyWithImpl<$Res>
    implements _$RegisterPartnerResponseEntityCopyWith<$Res> {
  __$RegisterPartnerResponseEntityCopyWithImpl(this._self, this._then);

  final _RegisterPartnerResponseEntity _self;
  final $Res Function(_RegisterPartnerResponseEntity) _then;

/// Create a copy of RegisterPartnerResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? businessEntityId = null,Object? status = null,Object? message = null,Object? accessToken = null,Object? accessExpiresIn = null,Object? refreshToken = null,Object? refreshExpiresIn = null,}) {
  return _then(_RegisterPartnerResponseEntity(
accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,businessEntityId: null == businessEntityId ? _self.businessEntityId : businessEntityId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessExpiresIn: null == accessExpiresIn ? _self.accessExpiresIn : accessExpiresIn // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshExpiresIn: null == refreshExpiresIn ? _self.refreshExpiresIn : refreshExpiresIn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SignUpRequestEntity {

// Business Entity (Step 1)
 String get companyName; String get taxRegistrationCode; String get businessEmail; String get businessPhone; List<String> get serviceCategories;// Location (Step 2)
 String get country; String get city; String get district; String get detailedAddress;// Legal Representative (Step 3)
 String get representativeName; String get governmentIdNumber; String? get frontIdUrl; String? get backIdUrl; bool get requiresAuthorizationLetter; String? get authorizationLetterUrl;// Account Security
 String get password;
/// Create a copy of SignUpRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpRequestEntityCopyWith<SignUpRequestEntity> get copyWith => _$SignUpRequestEntityCopyWithImpl<SignUpRequestEntity>(this as SignUpRequestEntity, _$identity);

  /// Serializes this SignUpRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpRequestEntity&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.taxRegistrationCode, taxRegistrationCode) || other.taxRegistrationCode == taxRegistrationCode)&&(identical(other.businessEmail, businessEmail) || other.businessEmail == businessEmail)&&(identical(other.businessPhone, businessPhone) || other.businessPhone == businessPhone)&&const DeepCollectionEquality().equals(other.serviceCategories, serviceCategories)&&(identical(other.country, country) || other.country == country)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.detailedAddress, detailedAddress) || other.detailedAddress == detailedAddress)&&(identical(other.representativeName, representativeName) || other.representativeName == representativeName)&&(identical(other.governmentIdNumber, governmentIdNumber) || other.governmentIdNumber == governmentIdNumber)&&(identical(other.frontIdUrl, frontIdUrl) || other.frontIdUrl == frontIdUrl)&&(identical(other.backIdUrl, backIdUrl) || other.backIdUrl == backIdUrl)&&(identical(other.requiresAuthorizationLetter, requiresAuthorizationLetter) || other.requiresAuthorizationLetter == requiresAuthorizationLetter)&&(identical(other.authorizationLetterUrl, authorizationLetterUrl) || other.authorizationLetterUrl == authorizationLetterUrl)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,taxRegistrationCode,businessEmail,businessPhone,const DeepCollectionEquality().hash(serviceCategories),country,city,district,detailedAddress,representativeName,governmentIdNumber,frontIdUrl,backIdUrl,requiresAuthorizationLetter,authorizationLetterUrl,password);

@override
String toString() {
  return 'SignUpRequestEntity(companyName: $companyName, taxRegistrationCode: $taxRegistrationCode, businessEmail: $businessEmail, businessPhone: $businessPhone, serviceCategories: $serviceCategories, country: $country, city: $city, district: $district, detailedAddress: $detailedAddress, representativeName: $representativeName, governmentIdNumber: $governmentIdNumber, frontIdUrl: $frontIdUrl, backIdUrl: $backIdUrl, requiresAuthorizationLetter: $requiresAuthorizationLetter, authorizationLetterUrl: $authorizationLetterUrl, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignUpRequestEntityCopyWith<$Res>  {
  factory $SignUpRequestEntityCopyWith(SignUpRequestEntity value, $Res Function(SignUpRequestEntity) _then) = _$SignUpRequestEntityCopyWithImpl;
@useResult
$Res call({
 String companyName, String taxRegistrationCode, String businessEmail, String businessPhone, List<String> serviceCategories, String country, String city, String district, String detailedAddress, String representativeName, String governmentIdNumber, String? frontIdUrl, String? backIdUrl, bool requiresAuthorizationLetter, String? authorizationLetterUrl, String password
});




}
/// @nodoc
class _$SignUpRequestEntityCopyWithImpl<$Res>
    implements $SignUpRequestEntityCopyWith<$Res> {
  _$SignUpRequestEntityCopyWithImpl(this._self, this._then);

  final SignUpRequestEntity _self;
  final $Res Function(SignUpRequestEntity) _then;

/// Create a copy of SignUpRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = null,Object? taxRegistrationCode = null,Object? businessEmail = null,Object? businessPhone = null,Object? serviceCategories = null,Object? country = null,Object? city = null,Object? district = null,Object? detailedAddress = null,Object? representativeName = null,Object? governmentIdNumber = null,Object? frontIdUrl = freezed,Object? backIdUrl = freezed,Object? requiresAuthorizationLetter = null,Object? authorizationLetterUrl = freezed,Object? password = null,}) {
  return _then(_self.copyWith(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,taxRegistrationCode: null == taxRegistrationCode ? _self.taxRegistrationCode : taxRegistrationCode // ignore: cast_nullable_to_non_nullable
as String,businessEmail: null == businessEmail ? _self.businessEmail : businessEmail // ignore: cast_nullable_to_non_nullable
as String,businessPhone: null == businessPhone ? _self.businessPhone : businessPhone // ignore: cast_nullable_to_non_nullable
as String,serviceCategories: null == serviceCategories ? _self.serviceCategories : serviceCategories // ignore: cast_nullable_to_non_nullable
as List<String>,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,detailedAddress: null == detailedAddress ? _self.detailedAddress : detailedAddress // ignore: cast_nullable_to_non_nullable
as String,representativeName: null == representativeName ? _self.representativeName : representativeName // ignore: cast_nullable_to_non_nullable
as String,governmentIdNumber: null == governmentIdNumber ? _self.governmentIdNumber : governmentIdNumber // ignore: cast_nullable_to_non_nullable
as String,frontIdUrl: freezed == frontIdUrl ? _self.frontIdUrl : frontIdUrl // ignore: cast_nullable_to_non_nullable
as String?,backIdUrl: freezed == backIdUrl ? _self.backIdUrl : backIdUrl // ignore: cast_nullable_to_non_nullable
as String?,requiresAuthorizationLetter: null == requiresAuthorizationLetter ? _self.requiresAuthorizationLetter : requiresAuthorizationLetter // ignore: cast_nullable_to_non_nullable
as bool,authorizationLetterUrl: freezed == authorizationLetterUrl ? _self.authorizationLetterUrl : authorizationLetterUrl // ignore: cast_nullable_to_non_nullable
as String?,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SignUpRequestEntity].
extension SignUpRequestEntityPatterns on SignUpRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignUpRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignUpRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignUpRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _SignUpRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignUpRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SignUpRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyName,  String taxRegistrationCode,  String businessEmail,  String businessPhone,  List<String> serviceCategories,  String country,  String city,  String district,  String detailedAddress,  String representativeName,  String governmentIdNumber,  String? frontIdUrl,  String? backIdUrl,  bool requiresAuthorizationLetter,  String? authorizationLetterUrl,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpRequestEntity() when $default != null:
return $default(_that.companyName,_that.taxRegistrationCode,_that.businessEmail,_that.businessPhone,_that.serviceCategories,_that.country,_that.city,_that.district,_that.detailedAddress,_that.representativeName,_that.governmentIdNumber,_that.frontIdUrl,_that.backIdUrl,_that.requiresAuthorizationLetter,_that.authorizationLetterUrl,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyName,  String taxRegistrationCode,  String businessEmail,  String businessPhone,  List<String> serviceCategories,  String country,  String city,  String district,  String detailedAddress,  String representativeName,  String governmentIdNumber,  String? frontIdUrl,  String? backIdUrl,  bool requiresAuthorizationLetter,  String? authorizationLetterUrl,  String password)  $default,) {final _that = this;
switch (_that) {
case _SignUpRequestEntity():
return $default(_that.companyName,_that.taxRegistrationCode,_that.businessEmail,_that.businessPhone,_that.serviceCategories,_that.country,_that.city,_that.district,_that.detailedAddress,_that.representativeName,_that.governmentIdNumber,_that.frontIdUrl,_that.backIdUrl,_that.requiresAuthorizationLetter,_that.authorizationLetterUrl,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyName,  String taxRegistrationCode,  String businessEmail,  String businessPhone,  List<String> serviceCategories,  String country,  String city,  String district,  String detailedAddress,  String representativeName,  String governmentIdNumber,  String? frontIdUrl,  String? backIdUrl,  bool requiresAuthorizationLetter,  String? authorizationLetterUrl,  String password)?  $default,) {final _that = this;
switch (_that) {
case _SignUpRequestEntity() when $default != null:
return $default(_that.companyName,_that.taxRegistrationCode,_that.businessEmail,_that.businessPhone,_that.serviceCategories,_that.country,_that.city,_that.district,_that.detailedAddress,_that.representativeName,_that.governmentIdNumber,_that.frontIdUrl,_that.backIdUrl,_that.requiresAuthorizationLetter,_that.authorizationLetterUrl,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignUpRequestEntity implements SignUpRequestEntity {
  const _SignUpRequestEntity({this.companyName = '', this.taxRegistrationCode = '', this.businessEmail = '', this.businessPhone = '', final  List<String> serviceCategories = const [], this.country = '', this.city = '', this.district = '', this.detailedAddress = '', this.representativeName = '', this.governmentIdNumber = '', this.frontIdUrl, this.backIdUrl, this.requiresAuthorizationLetter = false, this.authorizationLetterUrl, this.password = ''}): _serviceCategories = serviceCategories;
  factory _SignUpRequestEntity.fromJson(Map<String, dynamic> json) => _$SignUpRequestEntityFromJson(json);

// Business Entity (Step 1)
@override@JsonKey() final  String companyName;
@override@JsonKey() final  String taxRegistrationCode;
@override@JsonKey() final  String businessEmail;
@override@JsonKey() final  String businessPhone;
 final  List<String> _serviceCategories;
@override@JsonKey() List<String> get serviceCategories {
  if (_serviceCategories is EqualUnmodifiableListView) return _serviceCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceCategories);
}

// Location (Step 2)
@override@JsonKey() final  String country;
@override@JsonKey() final  String city;
@override@JsonKey() final  String district;
@override@JsonKey() final  String detailedAddress;
// Legal Representative (Step 3)
@override@JsonKey() final  String representativeName;
@override@JsonKey() final  String governmentIdNumber;
@override final  String? frontIdUrl;
@override final  String? backIdUrl;
@override@JsonKey() final  bool requiresAuthorizationLetter;
@override final  String? authorizationLetterUrl;
// Account Security
@override@JsonKey() final  String password;

/// Create a copy of SignUpRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpRequestEntityCopyWith<_SignUpRequestEntity> get copyWith => __$SignUpRequestEntityCopyWithImpl<_SignUpRequestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignUpRequestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpRequestEntity&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.taxRegistrationCode, taxRegistrationCode) || other.taxRegistrationCode == taxRegistrationCode)&&(identical(other.businessEmail, businessEmail) || other.businessEmail == businessEmail)&&(identical(other.businessPhone, businessPhone) || other.businessPhone == businessPhone)&&const DeepCollectionEquality().equals(other._serviceCategories, _serviceCategories)&&(identical(other.country, country) || other.country == country)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.detailedAddress, detailedAddress) || other.detailedAddress == detailedAddress)&&(identical(other.representativeName, representativeName) || other.representativeName == representativeName)&&(identical(other.governmentIdNumber, governmentIdNumber) || other.governmentIdNumber == governmentIdNumber)&&(identical(other.frontIdUrl, frontIdUrl) || other.frontIdUrl == frontIdUrl)&&(identical(other.backIdUrl, backIdUrl) || other.backIdUrl == backIdUrl)&&(identical(other.requiresAuthorizationLetter, requiresAuthorizationLetter) || other.requiresAuthorizationLetter == requiresAuthorizationLetter)&&(identical(other.authorizationLetterUrl, authorizationLetterUrl) || other.authorizationLetterUrl == authorizationLetterUrl)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,taxRegistrationCode,businessEmail,businessPhone,const DeepCollectionEquality().hash(_serviceCategories),country,city,district,detailedAddress,representativeName,governmentIdNumber,frontIdUrl,backIdUrl,requiresAuthorizationLetter,authorizationLetterUrl,password);

@override
String toString() {
  return 'SignUpRequestEntity(companyName: $companyName, taxRegistrationCode: $taxRegistrationCode, businessEmail: $businessEmail, businessPhone: $businessPhone, serviceCategories: $serviceCategories, country: $country, city: $city, district: $district, detailedAddress: $detailedAddress, representativeName: $representativeName, governmentIdNumber: $governmentIdNumber, frontIdUrl: $frontIdUrl, backIdUrl: $backIdUrl, requiresAuthorizationLetter: $requiresAuthorizationLetter, authorizationLetterUrl: $authorizationLetterUrl, password: $password)';
}


}

/// @nodoc
abstract mixin class _$SignUpRequestEntityCopyWith<$Res> implements $SignUpRequestEntityCopyWith<$Res> {
  factory _$SignUpRequestEntityCopyWith(_SignUpRequestEntity value, $Res Function(_SignUpRequestEntity) _then) = __$SignUpRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String companyName, String taxRegistrationCode, String businessEmail, String businessPhone, List<String> serviceCategories, String country, String city, String district, String detailedAddress, String representativeName, String governmentIdNumber, String? frontIdUrl, String? backIdUrl, bool requiresAuthorizationLetter, String? authorizationLetterUrl, String password
});




}
/// @nodoc
class __$SignUpRequestEntityCopyWithImpl<$Res>
    implements _$SignUpRequestEntityCopyWith<$Res> {
  __$SignUpRequestEntityCopyWithImpl(this._self, this._then);

  final _SignUpRequestEntity _self;
  final $Res Function(_SignUpRequestEntity) _then;

/// Create a copy of SignUpRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? taxRegistrationCode = null,Object? businessEmail = null,Object? businessPhone = null,Object? serviceCategories = null,Object? country = null,Object? city = null,Object? district = null,Object? detailedAddress = null,Object? representativeName = null,Object? governmentIdNumber = null,Object? frontIdUrl = freezed,Object? backIdUrl = freezed,Object? requiresAuthorizationLetter = null,Object? authorizationLetterUrl = freezed,Object? password = null,}) {
  return _then(_SignUpRequestEntity(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,taxRegistrationCode: null == taxRegistrationCode ? _self.taxRegistrationCode : taxRegistrationCode // ignore: cast_nullable_to_non_nullable
as String,businessEmail: null == businessEmail ? _self.businessEmail : businessEmail // ignore: cast_nullable_to_non_nullable
as String,businessPhone: null == businessPhone ? _self.businessPhone : businessPhone // ignore: cast_nullable_to_non_nullable
as String,serviceCategories: null == serviceCategories ? _self._serviceCategories : serviceCategories // ignore: cast_nullable_to_non_nullable
as List<String>,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,detailedAddress: null == detailedAddress ? _self.detailedAddress : detailedAddress // ignore: cast_nullable_to_non_nullable
as String,representativeName: null == representativeName ? _self.representativeName : representativeName // ignore: cast_nullable_to_non_nullable
as String,governmentIdNumber: null == governmentIdNumber ? _self.governmentIdNumber : governmentIdNumber // ignore: cast_nullable_to_non_nullable
as String,frontIdUrl: freezed == frontIdUrl ? _self.frontIdUrl : frontIdUrl // ignore: cast_nullable_to_non_nullable
as String?,backIdUrl: freezed == backIdUrl ? _self.backIdUrl : backIdUrl // ignore: cast_nullable_to_non_nullable
as String?,requiresAuthorizationLetter: null == requiresAuthorizationLetter ? _self.requiresAuthorizationLetter : requiresAuthorizationLetter // ignore: cast_nullable_to_non_nullable
as bool,authorizationLetterUrl: freezed == authorizationLetterUrl ? _self.authorizationLetterUrl : authorizationLetterUrl // ignore: cast_nullable_to_non_nullable
as String?,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
