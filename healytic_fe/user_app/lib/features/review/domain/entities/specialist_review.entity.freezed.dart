// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialist_review.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpecialistReviewEntity {

/// The appointment this review belongs to.
 String get appointmentId;/// The specialist being reviewed.
 String get specialistId;/// Star rating from 1 to 5.
 int get rating;/// Optional free-text feedback.
 String get comment;/// Selected feedback tags (e.g. Professional).
 List<String> get tags;/// Whether the user would recommend this
/// specialist to others.
 bool get wouldRecommend;
/// Create a copy of SpecialistReviewEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialistReviewEntityCopyWith<SpecialistReviewEntity> get copyWith => _$SpecialistReviewEntityCopyWithImpl<SpecialistReviewEntity>(this as SpecialistReviewEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialistReviewEntity&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.specialistId, specialistId) || other.specialistId == specialistId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.wouldRecommend, wouldRecommend) || other.wouldRecommend == wouldRecommend));
}


@override
int get hashCode => Object.hash(runtimeType,appointmentId,specialistId,rating,comment,const DeepCollectionEquality().hash(tags),wouldRecommend);

@override
String toString() {
  return 'SpecialistReviewEntity(appointmentId: $appointmentId, specialistId: $specialistId, rating: $rating, comment: $comment, tags: $tags, wouldRecommend: $wouldRecommend)';
}


}

/// @nodoc
abstract mixin class $SpecialistReviewEntityCopyWith<$Res>  {
  factory $SpecialistReviewEntityCopyWith(SpecialistReviewEntity value, $Res Function(SpecialistReviewEntity) _then) = _$SpecialistReviewEntityCopyWithImpl;
@useResult
$Res call({
 String appointmentId, String specialistId, int rating, String comment, List<String> tags, bool wouldRecommend
});




}
/// @nodoc
class _$SpecialistReviewEntityCopyWithImpl<$Res>
    implements $SpecialistReviewEntityCopyWith<$Res> {
  _$SpecialistReviewEntityCopyWithImpl(this._self, this._then);

  final SpecialistReviewEntity _self;
  final $Res Function(SpecialistReviewEntity) _then;

/// Create a copy of SpecialistReviewEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appointmentId = null,Object? specialistId = null,Object? rating = null,Object? comment = null,Object? tags = null,Object? wouldRecommend = null,}) {
  return _then(_self.copyWith(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,specialistId: null == specialistId ? _self.specialistId : specialistId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,wouldRecommend: null == wouldRecommend ? _self.wouldRecommend : wouldRecommend // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SpecialistReviewEntity].
extension SpecialistReviewEntityPatterns on SpecialistReviewEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpecialistReviewEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpecialistReviewEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpecialistReviewEntity value)  $default,){
final _that = this;
switch (_that) {
case _SpecialistReviewEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpecialistReviewEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SpecialistReviewEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appointmentId,  String specialistId,  int rating,  String comment,  List<String> tags,  bool wouldRecommend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpecialistReviewEntity() when $default != null:
return $default(_that.appointmentId,_that.specialistId,_that.rating,_that.comment,_that.tags,_that.wouldRecommend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appointmentId,  String specialistId,  int rating,  String comment,  List<String> tags,  bool wouldRecommend)  $default,) {final _that = this;
switch (_that) {
case _SpecialistReviewEntity():
return $default(_that.appointmentId,_that.specialistId,_that.rating,_that.comment,_that.tags,_that.wouldRecommend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appointmentId,  String specialistId,  int rating,  String comment,  List<String> tags,  bool wouldRecommend)?  $default,) {final _that = this;
switch (_that) {
case _SpecialistReviewEntity() when $default != null:
return $default(_that.appointmentId,_that.specialistId,_that.rating,_that.comment,_that.tags,_that.wouldRecommend);case _:
  return null;

}
}

}

/// @nodoc


class _SpecialistReviewEntity implements SpecialistReviewEntity {
  const _SpecialistReviewEntity({required this.appointmentId, required this.specialistId, required this.rating, this.comment = '', final  List<String> tags = const [], this.wouldRecommend = true}): _tags = tags;
  

/// The appointment this review belongs to.
@override final  String appointmentId;
/// The specialist being reviewed.
@override final  String specialistId;
/// Star rating from 1 to 5.
@override final  int rating;
/// Optional free-text feedback.
@override@JsonKey() final  String comment;
/// Selected feedback tags (e.g. Professional).
 final  List<String> _tags;
/// Selected feedback tags (e.g. Professional).
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Whether the user would recommend this
/// specialist to others.
@override@JsonKey() final  bool wouldRecommend;

/// Create a copy of SpecialistReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpecialistReviewEntityCopyWith<_SpecialistReviewEntity> get copyWith => __$SpecialistReviewEntityCopyWithImpl<_SpecialistReviewEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpecialistReviewEntity&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.specialistId, specialistId) || other.specialistId == specialistId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.wouldRecommend, wouldRecommend) || other.wouldRecommend == wouldRecommend));
}


@override
int get hashCode => Object.hash(runtimeType,appointmentId,specialistId,rating,comment,const DeepCollectionEquality().hash(_tags),wouldRecommend);

@override
String toString() {
  return 'SpecialistReviewEntity(appointmentId: $appointmentId, specialistId: $specialistId, rating: $rating, comment: $comment, tags: $tags, wouldRecommend: $wouldRecommend)';
}


}

/// @nodoc
abstract mixin class _$SpecialistReviewEntityCopyWith<$Res> implements $SpecialistReviewEntityCopyWith<$Res> {
  factory _$SpecialistReviewEntityCopyWith(_SpecialistReviewEntity value, $Res Function(_SpecialistReviewEntity) _then) = __$SpecialistReviewEntityCopyWithImpl;
@override @useResult
$Res call({
 String appointmentId, String specialistId, int rating, String comment, List<String> tags, bool wouldRecommend
});




}
/// @nodoc
class __$SpecialistReviewEntityCopyWithImpl<$Res>
    implements _$SpecialistReviewEntityCopyWith<$Res> {
  __$SpecialistReviewEntityCopyWithImpl(this._self, this._then);

  final _SpecialistReviewEntity _self;
  final $Res Function(_SpecialistReviewEntity) _then;

/// Create a copy of SpecialistReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appointmentId = null,Object? specialistId = null,Object? rating = null,Object? comment = null,Object? tags = null,Object? wouldRecommend = null,}) {
  return _then(_SpecialistReviewEntity(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,specialistId: null == specialistId ? _self.specialistId : specialistId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,wouldRecommend: null == wouldRecommend ? _self.wouldRecommend : wouldRecommend // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
