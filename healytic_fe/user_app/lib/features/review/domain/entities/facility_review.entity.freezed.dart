// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_review.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FacilityReviewEntity {

/// The appointment this review belongs to.
 String get appointmentId;/// The facility/clinic being reviewed
/// (partner ID).
 String get facilityId;/// Star rating from 1 to 5.
 int get rating;/// Optional free-text feedback.
 String get comment;/// Selected feedback tags
/// (e.g. 'Clean', 'Comfortable').
 List<String> get tags;/// Local file paths of attached photos.
 List<String> get photoPaths;
/// Create a copy of FacilityReviewEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacilityReviewEntityCopyWith<FacilityReviewEntity> get copyWith => _$FacilityReviewEntityCopyWithImpl<FacilityReviewEntity>(this as FacilityReviewEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacilityReviewEntity&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths));
}


@override
int get hashCode => Object.hash(runtimeType,appointmentId,facilityId,rating,comment,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(photoPaths));

@override
String toString() {
  return 'FacilityReviewEntity(appointmentId: $appointmentId, facilityId: $facilityId, rating: $rating, comment: $comment, tags: $tags, photoPaths: $photoPaths)';
}


}

/// @nodoc
abstract mixin class $FacilityReviewEntityCopyWith<$Res>  {
  factory $FacilityReviewEntityCopyWith(FacilityReviewEntity value, $Res Function(FacilityReviewEntity) _then) = _$FacilityReviewEntityCopyWithImpl;
@useResult
$Res call({
 String appointmentId, String facilityId, int rating, String comment, List<String> tags, List<String> photoPaths
});




}
/// @nodoc
class _$FacilityReviewEntityCopyWithImpl<$Res>
    implements $FacilityReviewEntityCopyWith<$Res> {
  _$FacilityReviewEntityCopyWithImpl(this._self, this._then);

  final FacilityReviewEntity _self;
  final $Res Function(FacilityReviewEntity) _then;

/// Create a copy of FacilityReviewEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appointmentId = null,Object? facilityId = null,Object? rating = null,Object? comment = null,Object? tags = null,Object? photoPaths = null,}) {
  return _then(_self.copyWith(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,facilityId: null == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FacilityReviewEntity].
extension FacilityReviewEntityPatterns on FacilityReviewEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacilityReviewEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacilityReviewEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacilityReviewEntity value)  $default,){
final _that = this;
switch (_that) {
case _FacilityReviewEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacilityReviewEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FacilityReviewEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appointmentId,  String facilityId,  int rating,  String comment,  List<String> tags,  List<String> photoPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacilityReviewEntity() when $default != null:
return $default(_that.appointmentId,_that.facilityId,_that.rating,_that.comment,_that.tags,_that.photoPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appointmentId,  String facilityId,  int rating,  String comment,  List<String> tags,  List<String> photoPaths)  $default,) {final _that = this;
switch (_that) {
case _FacilityReviewEntity():
return $default(_that.appointmentId,_that.facilityId,_that.rating,_that.comment,_that.tags,_that.photoPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appointmentId,  String facilityId,  int rating,  String comment,  List<String> tags,  List<String> photoPaths)?  $default,) {final _that = this;
switch (_that) {
case _FacilityReviewEntity() when $default != null:
return $default(_that.appointmentId,_that.facilityId,_that.rating,_that.comment,_that.tags,_that.photoPaths);case _:
  return null;

}
}

}

/// @nodoc


class _FacilityReviewEntity implements FacilityReviewEntity {
  const _FacilityReviewEntity({required this.appointmentId, required this.facilityId, required this.rating, this.comment = '', final  List<String> tags = const [], final  List<String> photoPaths = const []}): _tags = tags,_photoPaths = photoPaths;
  

/// The appointment this review belongs to.
@override final  String appointmentId;
/// The facility/clinic being reviewed
/// (partner ID).
@override final  String facilityId;
/// Star rating from 1 to 5.
@override final  int rating;
/// Optional free-text feedback.
@override@JsonKey() final  String comment;
/// Selected feedback tags
/// (e.g. 'Clean', 'Comfortable').
 final  List<String> _tags;
/// Selected feedback tags
/// (e.g. 'Clean', 'Comfortable').
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Local file paths of attached photos.
 final  List<String> _photoPaths;
/// Local file paths of attached photos.
@override@JsonKey() List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}


/// Create a copy of FacilityReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacilityReviewEntityCopyWith<_FacilityReviewEntity> get copyWith => __$FacilityReviewEntityCopyWithImpl<_FacilityReviewEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacilityReviewEntity&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths));
}


@override
int get hashCode => Object.hash(runtimeType,appointmentId,facilityId,rating,comment,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_photoPaths));

@override
String toString() {
  return 'FacilityReviewEntity(appointmentId: $appointmentId, facilityId: $facilityId, rating: $rating, comment: $comment, tags: $tags, photoPaths: $photoPaths)';
}


}

/// @nodoc
abstract mixin class _$FacilityReviewEntityCopyWith<$Res> implements $FacilityReviewEntityCopyWith<$Res> {
  factory _$FacilityReviewEntityCopyWith(_FacilityReviewEntity value, $Res Function(_FacilityReviewEntity) _then) = __$FacilityReviewEntityCopyWithImpl;
@override @useResult
$Res call({
 String appointmentId, String facilityId, int rating, String comment, List<String> tags, List<String> photoPaths
});




}
/// @nodoc
class __$FacilityReviewEntityCopyWithImpl<$Res>
    implements _$FacilityReviewEntityCopyWith<$Res> {
  __$FacilityReviewEntityCopyWithImpl(this._self, this._then);

  final _FacilityReviewEntity _self;
  final $Res Function(_FacilityReviewEntity) _then;

/// Create a copy of FacilityReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appointmentId = null,Object? facilityId = null,Object? rating = null,Object? comment = null,Object? tags = null,Object? photoPaths = null,}) {
  return _then(_FacilityReviewEntity(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,facilityId: null == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
