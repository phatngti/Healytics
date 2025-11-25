// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_flow_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterStateData {

 int get stepIndex; UserEntity? get user; Map<String, List<SurveyEntity>> get surveys; bool get isSurveyCompleted; bool get isRegistrationCompleted; AuthTokensEntity? get authTokens;
/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateDataCopyWith<RegisterStateData> get copyWith => _$RegisterStateDataCopyWithImpl<RegisterStateData>(this as RegisterStateData, _$identity);

  /// Serializes this RegisterStateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterStateData&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.surveys, surveys)&&(identical(other.isSurveyCompleted, isSurveyCompleted) || other.isSurveyCompleted == isSurveyCompleted)&&(identical(other.isRegistrationCompleted, isRegistrationCompleted) || other.isRegistrationCompleted == isRegistrationCompleted)&&(identical(other.authTokens, authTokens) || other.authTokens == authTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepIndex,user,const DeepCollectionEquality().hash(surveys),isSurveyCompleted,isRegistrationCompleted,authTokens);

@override
String toString() {
  return 'RegisterStateData(stepIndex: $stepIndex, user: $user, surveys: $surveys, isSurveyCompleted: $isSurveyCompleted, isRegistrationCompleted: $isRegistrationCompleted, authTokens: $authTokens)';
}


}

/// @nodoc
abstract mixin class $RegisterStateDataCopyWith<$Res>  {
  factory $RegisterStateDataCopyWith(RegisterStateData value, $Res Function(RegisterStateData) _then) = _$RegisterStateDataCopyWithImpl;
@useResult
$Res call({
 int stepIndex, UserEntity? user, Map<String, List<SurveyEntity>> surveys, bool isSurveyCompleted, bool isRegistrationCompleted, AuthTokensEntity? authTokens
});


$UserEntityCopyWith<$Res>? get user;$AuthTokensEntityCopyWith<$Res>? get authTokens;

}
/// @nodoc
class _$RegisterStateDataCopyWithImpl<$Res>
    implements $RegisterStateDataCopyWith<$Res> {
  _$RegisterStateDataCopyWithImpl(this._self, this._then);

  final RegisterStateData _self;
  final $Res Function(RegisterStateData) _then;

/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepIndex = null,Object? user = freezed,Object? surveys = null,Object? isSurveyCompleted = null,Object? isRegistrationCompleted = null,Object? authTokens = freezed,}) {
  return _then(_self.copyWith(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity?,surveys: null == surveys ? _self.surveys : surveys // ignore: cast_nullable_to_non_nullable
as Map<String, List<SurveyEntity>>,isSurveyCompleted: null == isSurveyCompleted ? _self.isSurveyCompleted : isSurveyCompleted // ignore: cast_nullable_to_non_nullable
as bool,isRegistrationCompleted: null == isRegistrationCompleted ? _self.isRegistrationCompleted : isRegistrationCompleted // ignore: cast_nullable_to_non_nullable
as bool,authTokens: freezed == authTokens ? _self.authTokens : authTokens // ignore: cast_nullable_to_non_nullable
as AuthTokensEntity?,
  ));
}
/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserEntityCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensEntityCopyWith<$Res>? get authTokens {
    if (_self.authTokens == null) {
    return null;
  }

  return $AuthTokensEntityCopyWith<$Res>(_self.authTokens!, (value) {
    return _then(_self.copyWith(authTokens: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterStateData].
extension RegisterStateDataPatterns on RegisterStateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterStateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterStateData value)  $default,){
final _that = this;
switch (_that) {
case _RegisterStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterStateData value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterStateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepIndex,  UserEntity? user,  Map<String, List<SurveyEntity>> surveys,  bool isSurveyCompleted,  bool isRegistrationCompleted,  AuthTokensEntity? authTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterStateData() when $default != null:
return $default(_that.stepIndex,_that.user,_that.surveys,_that.isSurveyCompleted,_that.isRegistrationCompleted,_that.authTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepIndex,  UserEntity? user,  Map<String, List<SurveyEntity>> surveys,  bool isSurveyCompleted,  bool isRegistrationCompleted,  AuthTokensEntity? authTokens)  $default,) {final _that = this;
switch (_that) {
case _RegisterStateData():
return $default(_that.stepIndex,_that.user,_that.surveys,_that.isSurveyCompleted,_that.isRegistrationCompleted,_that.authTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepIndex,  UserEntity? user,  Map<String, List<SurveyEntity>> surveys,  bool isSurveyCompleted,  bool isRegistrationCompleted,  AuthTokensEntity? authTokens)?  $default,) {final _that = this;
switch (_that) {
case _RegisterStateData() when $default != null:
return $default(_that.stepIndex,_that.user,_that.surveys,_that.isSurveyCompleted,_that.isRegistrationCompleted,_that.authTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterStateData implements RegisterStateData {
   _RegisterStateData({this.stepIndex = 0, this.user, final  Map<String, List<SurveyEntity>> surveys = const <String, List<SurveyEntity>>{}, this.isSurveyCompleted = false, this.isRegistrationCompleted = false, this.authTokens}): _surveys = surveys;
  factory _RegisterStateData.fromJson(Map<String, dynamic> json) => _$RegisterStateDataFromJson(json);

@override@JsonKey() final  int stepIndex;
@override final  UserEntity? user;
 final  Map<String, List<SurveyEntity>> _surveys;
@override@JsonKey() Map<String, List<SurveyEntity>> get surveys {
  if (_surveys is EqualUnmodifiableMapView) return _surveys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_surveys);
}

@override@JsonKey() final  bool isSurveyCompleted;
@override@JsonKey() final  bool isRegistrationCompleted;
@override final  AuthTokensEntity? authTokens;

/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateDataCopyWith<_RegisterStateData> get copyWith => __$RegisterStateDataCopyWithImpl<_RegisterStateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterStateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterStateData&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._surveys, _surveys)&&(identical(other.isSurveyCompleted, isSurveyCompleted) || other.isSurveyCompleted == isSurveyCompleted)&&(identical(other.isRegistrationCompleted, isRegistrationCompleted) || other.isRegistrationCompleted == isRegistrationCompleted)&&(identical(other.authTokens, authTokens) || other.authTokens == authTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepIndex,user,const DeepCollectionEquality().hash(_surveys),isSurveyCompleted,isRegistrationCompleted,authTokens);

@override
String toString() {
  return 'RegisterStateData(stepIndex: $stepIndex, user: $user, surveys: $surveys, isSurveyCompleted: $isSurveyCompleted, isRegistrationCompleted: $isRegistrationCompleted, authTokens: $authTokens)';
}


}

/// @nodoc
abstract mixin class _$RegisterStateDataCopyWith<$Res> implements $RegisterStateDataCopyWith<$Res> {
  factory _$RegisterStateDataCopyWith(_RegisterStateData value, $Res Function(_RegisterStateData) _then) = __$RegisterStateDataCopyWithImpl;
@override @useResult
$Res call({
 int stepIndex, UserEntity? user, Map<String, List<SurveyEntity>> surveys, bool isSurveyCompleted, bool isRegistrationCompleted, AuthTokensEntity? authTokens
});


@override $UserEntityCopyWith<$Res>? get user;@override $AuthTokensEntityCopyWith<$Res>? get authTokens;

}
/// @nodoc
class __$RegisterStateDataCopyWithImpl<$Res>
    implements _$RegisterStateDataCopyWith<$Res> {
  __$RegisterStateDataCopyWithImpl(this._self, this._then);

  final _RegisterStateData _self;
  final $Res Function(_RegisterStateData) _then;

/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepIndex = null,Object? user = freezed,Object? surveys = null,Object? isSurveyCompleted = null,Object? isRegistrationCompleted = null,Object? authTokens = freezed,}) {
  return _then(_RegisterStateData(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity?,surveys: null == surveys ? _self._surveys : surveys // ignore: cast_nullable_to_non_nullable
as Map<String, List<SurveyEntity>>,isSurveyCompleted: null == isSurveyCompleted ? _self.isSurveyCompleted : isSurveyCompleted // ignore: cast_nullable_to_non_nullable
as bool,isRegistrationCompleted: null == isRegistrationCompleted ? _self.isRegistrationCompleted : isRegistrationCompleted // ignore: cast_nullable_to_non_nullable
as bool,authTokens: freezed == authTokens ? _self.authTokens : authTokens // ignore: cast_nullable_to_non_nullable
as AuthTokensEntity?,
  ));
}

/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserEntityCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of RegisterStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensEntityCopyWith<$Res>? get authTokens {
    if (_self.authTokens == null) {
    return null;
  }

  return $AuthTokensEntityCopyWith<$Res>(_self.authTokens!, (value) {
    return _then(_self.copyWith(authTokens: value));
  });
}
}

// dart format on
