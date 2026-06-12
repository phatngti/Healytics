// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finish_google_sign_up.provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompleteGoogleProfileStateData {

 bool get isProfileCompleted;
/// Create a copy of CompleteGoogleProfileStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompleteGoogleProfileStateDataCopyWith<CompleteGoogleProfileStateData> get copyWith => _$CompleteGoogleProfileStateDataCopyWithImpl<CompleteGoogleProfileStateData>(this as CompleteGoogleProfileStateData, _$identity);

  /// Serializes this CompleteGoogleProfileStateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompleteGoogleProfileStateData&&(identical(other.isProfileCompleted, isProfileCompleted) || other.isProfileCompleted == isProfileCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isProfileCompleted);

@override
String toString() {
  return 'CompleteGoogleProfileStateData(isProfileCompleted: $isProfileCompleted)';
}


}

/// @nodoc
abstract mixin class $CompleteGoogleProfileStateDataCopyWith<$Res>  {
  factory $CompleteGoogleProfileStateDataCopyWith(CompleteGoogleProfileStateData value, $Res Function(CompleteGoogleProfileStateData) _then) = _$CompleteGoogleProfileStateDataCopyWithImpl;
@useResult
$Res call({
 bool isProfileCompleted
});




}
/// @nodoc
class _$CompleteGoogleProfileStateDataCopyWithImpl<$Res>
    implements $CompleteGoogleProfileStateDataCopyWith<$Res> {
  _$CompleteGoogleProfileStateDataCopyWithImpl(this._self, this._then);

  final CompleteGoogleProfileStateData _self;
  final $Res Function(CompleteGoogleProfileStateData) _then;

/// Create a copy of CompleteGoogleProfileStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isProfileCompleted = null,}) {
  return _then(_self.copyWith(
isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CompleteGoogleProfileStateData].
extension CompleteGoogleProfileStateDataPatterns on CompleteGoogleProfileStateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompleteGoogleProfileStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompleteGoogleProfileStateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompleteGoogleProfileStateData value)  $default,){
final _that = this;
switch (_that) {
case _CompleteGoogleProfileStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompleteGoogleProfileStateData value)?  $default,){
final _that = this;
switch (_that) {
case _CompleteGoogleProfileStateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isProfileCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompleteGoogleProfileStateData() when $default != null:
return $default(_that.isProfileCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isProfileCompleted)  $default,) {final _that = this;
switch (_that) {
case _CompleteGoogleProfileStateData():
return $default(_that.isProfileCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isProfileCompleted)?  $default,) {final _that = this;
switch (_that) {
case _CompleteGoogleProfileStateData() when $default != null:
return $default(_that.isProfileCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompleteGoogleProfileStateData implements CompleteGoogleProfileStateData {
  const _CompleteGoogleProfileStateData({this.isProfileCompleted = false});
  factory _CompleteGoogleProfileStateData.fromJson(Map<String, dynamic> json) => _$CompleteGoogleProfileStateDataFromJson(json);

@override@JsonKey() final  bool isProfileCompleted;

/// Create a copy of CompleteGoogleProfileStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompleteGoogleProfileStateDataCopyWith<_CompleteGoogleProfileStateData> get copyWith => __$CompleteGoogleProfileStateDataCopyWithImpl<_CompleteGoogleProfileStateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompleteGoogleProfileStateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteGoogleProfileStateData&&(identical(other.isProfileCompleted, isProfileCompleted) || other.isProfileCompleted == isProfileCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isProfileCompleted);

@override
String toString() {
  return 'CompleteGoogleProfileStateData(isProfileCompleted: $isProfileCompleted)';
}


}

/// @nodoc
abstract mixin class _$CompleteGoogleProfileStateDataCopyWith<$Res> implements $CompleteGoogleProfileStateDataCopyWith<$Res> {
  factory _$CompleteGoogleProfileStateDataCopyWith(_CompleteGoogleProfileStateData value, $Res Function(_CompleteGoogleProfileStateData) _then) = __$CompleteGoogleProfileStateDataCopyWithImpl;
@override @useResult
$Res call({
 bool isProfileCompleted
});




}
/// @nodoc
class __$CompleteGoogleProfileStateDataCopyWithImpl<$Res>
    implements _$CompleteGoogleProfileStateDataCopyWith<$Res> {
  __$CompleteGoogleProfileStateDataCopyWithImpl(this._self, this._then);

  final _CompleteGoogleProfileStateData _self;
  final $Res Function(_CompleteGoogleProfileStateData) _then;

/// Create a copy of CompleteGoogleProfileStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isProfileCompleted = null,}) {
  return _then(_CompleteGoogleProfileStateData(
isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
