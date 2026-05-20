// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_sign_in_result.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoogleSignInResult {

 String get idToken; String get email; String? get displayName; String? get photoUrl;
/// Create a copy of GoogleSignInResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoogleSignInResultCopyWith<GoogleSignInResult> get copyWith => _$GoogleSignInResultCopyWithImpl<GoogleSignInResult>(this as GoogleSignInResult, _$identity);

  /// Serializes this GoogleSignInResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleSignInResult&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken,email,displayName,photoUrl);

@override
String toString() {
  return 'GoogleSignInResult(idToken: $idToken, email: $email, displayName: $displayName, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class $GoogleSignInResultCopyWith<$Res>  {
  factory $GoogleSignInResultCopyWith(GoogleSignInResult value, $Res Function(GoogleSignInResult) _then) = _$GoogleSignInResultCopyWithImpl;
@useResult
$Res call({
 String idToken, String email, String? displayName, String? photoUrl
});




}
/// @nodoc
class _$GoogleSignInResultCopyWithImpl<$Res>
    implements $GoogleSignInResultCopyWith<$Res> {
  _$GoogleSignInResultCopyWithImpl(this._self, this._then);

  final GoogleSignInResult _self;
  final $Res Function(GoogleSignInResult) _then;

/// Create a copy of GoogleSignInResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idToken = null,Object? email = null,Object? displayName = freezed,Object? photoUrl = freezed,}) {
  return _then(_self.copyWith(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoogleSignInResult].
extension GoogleSignInResultPatterns on GoogleSignInResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoogleSignInResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoogleSignInResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoogleSignInResult value)  $default,){
final _that = this;
switch (_that) {
case _GoogleSignInResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoogleSignInResult value)?  $default,){
final _that = this;
switch (_that) {
case _GoogleSignInResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String idToken,  String email,  String? displayName,  String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoogleSignInResult() when $default != null:
return $default(_that.idToken,_that.email,_that.displayName,_that.photoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String idToken,  String email,  String? displayName,  String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _GoogleSignInResult():
return $default(_that.idToken,_that.email,_that.displayName,_that.photoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String idToken,  String email,  String? displayName,  String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _GoogleSignInResult() when $default != null:
return $default(_that.idToken,_that.email,_that.displayName,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoogleSignInResult implements GoogleSignInResult {
  const _GoogleSignInResult({required this.idToken, required this.email, this.displayName, this.photoUrl});
  factory _GoogleSignInResult.fromJson(Map<String, dynamic> json) => _$GoogleSignInResultFromJson(json);

@override final  String idToken;
@override final  String email;
@override final  String? displayName;
@override final  String? photoUrl;

/// Create a copy of GoogleSignInResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoogleSignInResultCopyWith<_GoogleSignInResult> get copyWith => __$GoogleSignInResultCopyWithImpl<_GoogleSignInResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoogleSignInResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoogleSignInResult&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken,email,displayName,photoUrl);

@override
String toString() {
  return 'GoogleSignInResult(idToken: $idToken, email: $email, displayName: $displayName, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$GoogleSignInResultCopyWith<$Res> implements $GoogleSignInResultCopyWith<$Res> {
  factory _$GoogleSignInResultCopyWith(_GoogleSignInResult value, $Res Function(_GoogleSignInResult) _then) = __$GoogleSignInResultCopyWithImpl;
@override @useResult
$Res call({
 String idToken, String email, String? displayName, String? photoUrl
});




}
/// @nodoc
class __$GoogleSignInResultCopyWithImpl<$Res>
    implements _$GoogleSignInResultCopyWith<$Res> {
  __$GoogleSignInResultCopyWithImpl(this._self, this._then);

  final _GoogleSignInResult _self;
  final $Res Function(_GoogleSignInResult) _then;

/// Create a copy of GoogleSignInResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idToken = null,Object? email = null,Object? displayName = freezed,Object? photoUrl = freezed,}) {
  return _then(_GoogleSignInResult(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
