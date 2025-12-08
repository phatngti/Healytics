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
mixin _$SignUpRequestEntity {

 String get password; String get bussinessName; String get contractPersonName; String get bussinessEmail; String get bussinessPhone; String get address;
/// Create a copy of SignUpRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpRequestEntityCopyWith<SignUpRequestEntity> get copyWith => _$SignUpRequestEntityCopyWithImpl<SignUpRequestEntity>(this as SignUpRequestEntity, _$identity);

  /// Serializes this SignUpRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpRequestEntity&&(identical(other.password, password) || other.password == password)&&(identical(other.bussinessName, bussinessName) || other.bussinessName == bussinessName)&&(identical(other.contractPersonName, contractPersonName) || other.contractPersonName == contractPersonName)&&(identical(other.bussinessEmail, bussinessEmail) || other.bussinessEmail == bussinessEmail)&&(identical(other.bussinessPhone, bussinessPhone) || other.bussinessPhone == bussinessPhone)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password,bussinessName,contractPersonName,bussinessEmail,bussinessPhone,address);

@override
String toString() {
  return 'SignUpRequestEntity(password: $password, bussinessName: $bussinessName, contractPersonName: $contractPersonName, bussinessEmail: $bussinessEmail, bussinessPhone: $bussinessPhone, address: $address)';
}


}

/// @nodoc
abstract mixin class $SignUpRequestEntityCopyWith<$Res>  {
  factory $SignUpRequestEntityCopyWith(SignUpRequestEntity value, $Res Function(SignUpRequestEntity) _then) = _$SignUpRequestEntityCopyWithImpl;
@useResult
$Res call({
 String password, String bussinessName, String contractPersonName, String bussinessEmail, String bussinessPhone, String address
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
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,Object? bussinessName = null,Object? contractPersonName = null,Object? bussinessEmail = null,Object? bussinessPhone = null,Object? address = null,}) {
  return _then(_self.copyWith(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,bussinessName: null == bussinessName ? _self.bussinessName : bussinessName // ignore: cast_nullable_to_non_nullable
as String,contractPersonName: null == contractPersonName ? _self.contractPersonName : contractPersonName // ignore: cast_nullable_to_non_nullable
as String,bussinessEmail: null == bussinessEmail ? _self.bussinessEmail : bussinessEmail // ignore: cast_nullable_to_non_nullable
as String,bussinessPhone: null == bussinessPhone ? _self.bussinessPhone : bussinessPhone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String password,  String bussinessName,  String contractPersonName,  String bussinessEmail,  String bussinessPhone,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpRequestEntity() when $default != null:
return $default(_that.password,_that.bussinessName,_that.contractPersonName,_that.bussinessEmail,_that.bussinessPhone,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String password,  String bussinessName,  String contractPersonName,  String bussinessEmail,  String bussinessPhone,  String address)  $default,) {final _that = this;
switch (_that) {
case _SignUpRequestEntity():
return $default(_that.password,_that.bussinessName,_that.contractPersonName,_that.bussinessEmail,_that.bussinessPhone,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String password,  String bussinessName,  String contractPersonName,  String bussinessEmail,  String bussinessPhone,  String address)?  $default,) {final _that = this;
switch (_that) {
case _SignUpRequestEntity() when $default != null:
return $default(_that.password,_that.bussinessName,_that.contractPersonName,_that.bussinessEmail,_that.bussinessPhone,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignUpRequestEntity implements SignUpRequestEntity {
  const _SignUpRequestEntity({required this.password, required this.bussinessName, required this.contractPersonName, required this.bussinessEmail, required this.bussinessPhone, required this.address});
  factory _SignUpRequestEntity.fromJson(Map<String, dynamic> json) => _$SignUpRequestEntityFromJson(json);

@override final  String password;
@override final  String bussinessName;
@override final  String contractPersonName;
@override final  String bussinessEmail;
@override final  String bussinessPhone;
@override final  String address;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpRequestEntity&&(identical(other.password, password) || other.password == password)&&(identical(other.bussinessName, bussinessName) || other.bussinessName == bussinessName)&&(identical(other.contractPersonName, contractPersonName) || other.contractPersonName == contractPersonName)&&(identical(other.bussinessEmail, bussinessEmail) || other.bussinessEmail == bussinessEmail)&&(identical(other.bussinessPhone, bussinessPhone) || other.bussinessPhone == bussinessPhone)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password,bussinessName,contractPersonName,bussinessEmail,bussinessPhone,address);

@override
String toString() {
  return 'SignUpRequestEntity(password: $password, bussinessName: $bussinessName, contractPersonName: $contractPersonName, bussinessEmail: $bussinessEmail, bussinessPhone: $bussinessPhone, address: $address)';
}


}

/// @nodoc
abstract mixin class _$SignUpRequestEntityCopyWith<$Res> implements $SignUpRequestEntityCopyWith<$Res> {
  factory _$SignUpRequestEntityCopyWith(_SignUpRequestEntity value, $Res Function(_SignUpRequestEntity) _then) = __$SignUpRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String password, String bussinessName, String contractPersonName, String bussinessEmail, String bussinessPhone, String address
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
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,Object? bussinessName = null,Object? contractPersonName = null,Object? bussinessEmail = null,Object? bussinessPhone = null,Object? address = null,}) {
  return _then(_SignUpRequestEntity(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,bussinessName: null == bussinessName ? _self.bussinessName : bussinessName // ignore: cast_nullable_to_non_nullable
as String,contractPersonName: null == contractPersonName ? _self.contractPersonName : contractPersonName // ignore: cast_nullable_to_non_nullable
as String,bussinessEmail: null == bussinessEmail ? _self.bussinessEmail : bussinessEmail // ignore: cast_nullable_to_non_nullable
as String,bussinessPhone: null == bussinessPhone ? _self.bussinessPhone : bussinessPhone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
