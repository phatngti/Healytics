// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up.provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignUpState {

 SignupStep get step; SignUpRequestEntity get request; String get email; String get emailToken; String get otpToken;
/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpStateCopyWith<SignUpState> get copyWith => _$SignUpStateCopyWithImpl<SignUpState>(this as SignUpState, _$identity);

  /// Serializes this SignUpState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpState&&(identical(other.step, step) || other.step == step)&&(identical(other.request, request) || other.request == request)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailToken, emailToken) || other.emailToken == emailToken)&&(identical(other.otpToken, otpToken) || other.otpToken == otpToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,step,request,email,emailToken,otpToken);

@override
String toString() {
  return 'SignUpState(step: $step, request: $request, email: $email, emailToken: $emailToken, otpToken: $otpToken)';
}


}

/// @nodoc
abstract mixin class $SignUpStateCopyWith<$Res>  {
  factory $SignUpStateCopyWith(SignUpState value, $Res Function(SignUpState) _then) = _$SignUpStateCopyWithImpl;
@useResult
$Res call({
 SignupStep step, SignUpRequestEntity request, String email, String emailToken, String otpToken
});


$SignUpRequestEntityCopyWith<$Res> get request;

}
/// @nodoc
class _$SignUpStateCopyWithImpl<$Res>
    implements $SignUpStateCopyWith<$Res> {
  _$SignUpStateCopyWithImpl(this._self, this._then);

  final SignUpState _self;
  final $Res Function(SignUpState) _then;

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? request = null,Object? email = null,Object? emailToken = null,Object? otpToken = null,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SignupStep,request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as SignUpRequestEntity,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emailToken: null == emailToken ? _self.emailToken : emailToken // ignore: cast_nullable_to_non_nullable
as String,otpToken: null == otpToken ? _self.otpToken : otpToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SignUpRequestEntityCopyWith<$Res> get request {
  
  return $SignUpRequestEntityCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}


/// Adds pattern-matching-related methods to [SignUpState].
extension SignUpStatePatterns on SignUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignUpState value)  $default,){
final _that = this;
switch (_that) {
case _SignUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignUpState value)?  $default,){
final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SignupStep step,  SignUpRequestEntity request,  String email,  String emailToken,  String otpToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
return $default(_that.step,_that.request,_that.email,_that.emailToken,_that.otpToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SignupStep step,  SignUpRequestEntity request,  String email,  String emailToken,  String otpToken)  $default,) {final _that = this;
switch (_that) {
case _SignUpState():
return $default(_that.step,_that.request,_that.email,_that.emailToken,_that.otpToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SignupStep step,  SignUpRequestEntity request,  String email,  String emailToken,  String otpToken)?  $default,) {final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
return $default(_that.step,_that.request,_that.email,_that.emailToken,_that.otpToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignUpState implements SignUpState {
  const _SignUpState({this.step = SignupStep.email, this.request = const SignUpRequestEntity(), this.email = '', this.emailToken = '', this.otpToken = ''});
  factory _SignUpState.fromJson(Map<String, dynamic> json) => _$SignUpStateFromJson(json);

@override@JsonKey() final  SignupStep step;
@override@JsonKey() final  SignUpRequestEntity request;
@override@JsonKey() final  String email;
@override@JsonKey() final  String emailToken;
@override@JsonKey() final  String otpToken;

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpStateCopyWith<_SignUpState> get copyWith => __$SignUpStateCopyWithImpl<_SignUpState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignUpStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpState&&(identical(other.step, step) || other.step == step)&&(identical(other.request, request) || other.request == request)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailToken, emailToken) || other.emailToken == emailToken)&&(identical(other.otpToken, otpToken) || other.otpToken == otpToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,step,request,email,emailToken,otpToken);

@override
String toString() {
  return 'SignUpState(step: $step, request: $request, email: $email, emailToken: $emailToken, otpToken: $otpToken)';
}


}

/// @nodoc
abstract mixin class _$SignUpStateCopyWith<$Res> implements $SignUpStateCopyWith<$Res> {
  factory _$SignUpStateCopyWith(_SignUpState value, $Res Function(_SignUpState) _then) = __$SignUpStateCopyWithImpl;
@override @useResult
$Res call({
 SignupStep step, SignUpRequestEntity request, String email, String emailToken, String otpToken
});


@override $SignUpRequestEntityCopyWith<$Res> get request;

}
/// @nodoc
class __$SignUpStateCopyWithImpl<$Res>
    implements _$SignUpStateCopyWith<$Res> {
  __$SignUpStateCopyWithImpl(this._self, this._then);

  final _SignUpState _self;
  final $Res Function(_SignUpState) _then;

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? request = null,Object? email = null,Object? emailToken = null,Object? otpToken = null,}) {
  return _then(_SignUpState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SignupStep,request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as SignUpRequestEntity,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emailToken: null == emailToken ? _self.emailToken : emailToken // ignore: cast_nullable_to_non_nullable
as String,otpToken: null == otpToken ? _self.otpToken : otpToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SignUpRequestEntityCopyWith<$Res> get request {
  
  return $SignUpRequestEntityCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

// dart format on
