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
