// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authenticate.provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthenticateStateData {

 AuthenticateEntity? get authenticate;
/// Create a copy of AuthenticateStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticateStateDataCopyWith<AuthenticateStateData> get copyWith => _$AuthenticateStateDataCopyWithImpl<AuthenticateStateData>(this as AuthenticateStateData, _$identity);

  /// Serializes this AuthenticateStateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticateStateData&&(identical(other.authenticate, authenticate) || other.authenticate == authenticate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authenticate);

@override
String toString() {
  return 'AuthenticateStateData(authenticate: $authenticate)';
}


}

/// @nodoc
abstract mixin class $AuthenticateStateDataCopyWith<$Res>  {
  factory $AuthenticateStateDataCopyWith(AuthenticateStateData value, $Res Function(AuthenticateStateData) _then) = _$AuthenticateStateDataCopyWithImpl;
@useResult
$Res call({
 AuthenticateEntity? authenticate
});


$AuthenticateEntityCopyWith<$Res>? get authenticate;

}
/// @nodoc
class _$AuthenticateStateDataCopyWithImpl<$Res>
    implements $AuthenticateStateDataCopyWith<$Res> {
  _$AuthenticateStateDataCopyWithImpl(this._self, this._then);

  final AuthenticateStateData _self;
  final $Res Function(AuthenticateStateData) _then;

/// Create a copy of AuthenticateStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authenticate = freezed,}) {
  return _then(_self.copyWith(
authenticate: freezed == authenticate ? _self.authenticate : authenticate // ignore: cast_nullable_to_non_nullable
as AuthenticateEntity?,
  ));
}
/// Create a copy of AuthenticateStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthenticateEntityCopyWith<$Res>? get authenticate {
    if (_self.authenticate == null) {
    return null;
  }

  return $AuthenticateEntityCopyWith<$Res>(_self.authenticate!, (value) {
    return _then(_self.copyWith(authenticate: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthenticateStateData].
extension AuthenticateStateDataPatterns on AuthenticateStateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthenticateStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthenticateStateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthenticateStateData value)  $default,){
final _that = this;
switch (_that) {
case _AuthenticateStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthenticateStateData value)?  $default,){
final _that = this;
switch (_that) {
case _AuthenticateStateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthenticateEntity? authenticate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthenticateStateData() when $default != null:
return $default(_that.authenticate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthenticateEntity? authenticate)  $default,) {final _that = this;
switch (_that) {
case _AuthenticateStateData():
return $default(_that.authenticate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthenticateEntity? authenticate)?  $default,) {final _that = this;
switch (_that) {
case _AuthenticateStateData() when $default != null:
return $default(_that.authenticate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthenticateStateData implements AuthenticateStateData {
  const _AuthenticateStateData({this.authenticate});
  factory _AuthenticateStateData.fromJson(Map<String, dynamic> json) => _$AuthenticateStateDataFromJson(json);

@override final  AuthenticateEntity? authenticate;

/// Create a copy of AuthenticateStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticateStateDataCopyWith<_AuthenticateStateData> get copyWith => __$AuthenticateStateDataCopyWithImpl<_AuthenticateStateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticateStateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticateStateData&&(identical(other.authenticate, authenticate) || other.authenticate == authenticate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authenticate);

@override
String toString() {
  return 'AuthenticateStateData(authenticate: $authenticate)';
}


}

/// @nodoc
abstract mixin class _$AuthenticateStateDataCopyWith<$Res> implements $AuthenticateStateDataCopyWith<$Res> {
  factory _$AuthenticateStateDataCopyWith(_AuthenticateStateData value, $Res Function(_AuthenticateStateData) _then) = __$AuthenticateStateDataCopyWithImpl;
@override @useResult
$Res call({
 AuthenticateEntity? authenticate
});


@override $AuthenticateEntityCopyWith<$Res>? get authenticate;

}
/// @nodoc
class __$AuthenticateStateDataCopyWithImpl<$Res>
    implements _$AuthenticateStateDataCopyWith<$Res> {
  __$AuthenticateStateDataCopyWithImpl(this._self, this._then);

  final _AuthenticateStateData _self;
  final $Res Function(_AuthenticateStateData) _then;

/// Create a copy of AuthenticateStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authenticate = freezed,}) {
  return _then(_AuthenticateStateData(
authenticate: freezed == authenticate ? _self.authenticate : authenticate // ignore: cast_nullable_to_non_nullable
as AuthenticateEntity?,
  ));
}

/// Create a copy of AuthenticateStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthenticateEntityCopyWith<$Res>? get authenticate {
    if (_self.authenticate == null) {
    return null;
  }

  return $AuthenticateEntityCopyWith<$Res>(_self.authenticate!, (value) {
    return _then(_self.copyWith(authenticate: value));
  });
}
}

// dart format on
