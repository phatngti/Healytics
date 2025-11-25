// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthTokensEntity {

 String get accessToken; String get refreshToken;
/// Create a copy of AuthTokensEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthTokensEntityCopyWith<AuthTokensEntity> get copyWith => _$AuthTokensEntityCopyWithImpl<AuthTokensEntity>(this as AuthTokensEntity, _$identity);

  /// Serializes this AuthTokensEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthTokensEntity&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'AuthTokensEntity(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class $AuthTokensEntityCopyWith<$Res>  {
  factory $AuthTokensEntityCopyWith(AuthTokensEntity value, $Res Function(AuthTokensEntity) _then) = _$AuthTokensEntityCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class _$AuthTokensEntityCopyWithImpl<$Res>
    implements $AuthTokensEntityCopyWith<$Res> {
  _$AuthTokensEntityCopyWithImpl(this._self, this._then);

  final AuthTokensEntity _self;
  final $Res Function(AuthTokensEntity) _then;

/// Create a copy of AuthTokensEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthTokensEntity].
extension AuthTokensEntityPatterns on AuthTokensEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthTokensEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthTokensEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthTokensEntity value)  $default,){
final _that = this;
switch (_that) {
case _AuthTokensEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthTokensEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AuthTokensEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthTokensEntity() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)  $default,) {final _that = this;
switch (_that) {
case _AuthTokensEntity():
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _AuthTokensEntity() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthTokensEntity implements AuthTokensEntity {
  const _AuthTokensEntity({required this.accessToken, required this.refreshToken});
  factory _AuthTokensEntity.fromJson(Map<String, dynamic> json) => _$AuthTokensEntityFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;

/// Create a copy of AuthTokensEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthTokensEntityCopyWith<_AuthTokensEntity> get copyWith => __$AuthTokensEntityCopyWithImpl<_AuthTokensEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthTokensEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthTokensEntity&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'AuthTokensEntity(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$AuthTokensEntityCopyWith<$Res> implements $AuthTokensEntityCopyWith<$Res> {
  factory _$AuthTokensEntityCopyWith(_AuthTokensEntity value, $Res Function(_AuthTokensEntity) _then) = __$AuthTokensEntityCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class __$AuthTokensEntityCopyWithImpl<$Res>
    implements _$AuthTokensEntityCopyWith<$Res> {
  __$AuthTokensEntityCopyWithImpl(this._self, this._then);

  final _AuthTokensEntity _self;
  final $Res Function(_AuthTokensEntity) _then;

/// Create a copy of AuthTokensEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_AuthTokensEntity(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SurveyEntity {

 String get question; String get value;
/// Create a copy of SurveyEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyEntityCopyWith<SurveyEntity> get copyWith => _$SurveyEntityCopyWithImpl<SurveyEntity>(this as SurveyEntity, _$identity);

  /// Serializes this SurveyEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyEntity&&(identical(other.question, question) || other.question == question)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,value);

@override
String toString() {
  return 'SurveyEntity(question: $question, value: $value)';
}


}

/// @nodoc
abstract mixin class $SurveyEntityCopyWith<$Res>  {
  factory $SurveyEntityCopyWith(SurveyEntity value, $Res Function(SurveyEntity) _then) = _$SurveyEntityCopyWithImpl;
@useResult
$Res call({
 String question, String value
});




}
/// @nodoc
class _$SurveyEntityCopyWithImpl<$Res>
    implements $SurveyEntityCopyWith<$Res> {
  _$SurveyEntityCopyWithImpl(this._self, this._then);

  final SurveyEntity _self;
  final $Res Function(SurveyEntity) _then;

/// Create a copy of SurveyEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? value = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyEntity].
extension SurveyEntityPatterns on SurveyEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyEntity value)  $default,){
final _that = this;
switch (_that) {
case _SurveyEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyEntity() when $default != null:
return $default(_that.question,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  String value)  $default,) {final _that = this;
switch (_that) {
case _SurveyEntity():
return $default(_that.question,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  String value)?  $default,) {final _that = this;
switch (_that) {
case _SurveyEntity() when $default != null:
return $default(_that.question,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyEntity implements SurveyEntity {
  const _SurveyEntity({required this.question, required this.value});
  factory _SurveyEntity.fromJson(Map<String, dynamic> json) => _$SurveyEntityFromJson(json);

@override final  String question;
@override final  String value;

/// Create a copy of SurveyEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyEntityCopyWith<_SurveyEntity> get copyWith => __$SurveyEntityCopyWithImpl<_SurveyEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyEntity&&(identical(other.question, question) || other.question == question)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,value);

@override
String toString() {
  return 'SurveyEntity(question: $question, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SurveyEntityCopyWith<$Res> implements $SurveyEntityCopyWith<$Res> {
  factory _$SurveyEntityCopyWith(_SurveyEntity value, $Res Function(_SurveyEntity) _then) = __$SurveyEntityCopyWithImpl;
@override @useResult
$Res call({
 String question, String value
});




}
/// @nodoc
class __$SurveyEntityCopyWithImpl<$Res>
    implements _$SurveyEntityCopyWith<$Res> {
  __$SurveyEntityCopyWithImpl(this._self, this._then);

  final _SurveyEntity _self;
  final $Res Function(_SurveyEntity) _then;

/// Create a copy of SurveyEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? value = null,}) {
  return _then(_SurveyEntity(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
