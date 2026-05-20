// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_specialist.provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewSpecialistState {

/// Star rating (1–5).
 int get rating;/// Optional free-text comment.
 String get comment;/// Currently selected feedback tags.
 List<String> get selectedTags;/// Whether user would recommend the specialist.
 bool get wouldRecommend;/// True while the review is being submitted.
 bool get isSubmitting;/// True after a successful submission.
 bool get isSubmitted;
/// Create a copy of ReviewSpecialistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewSpecialistStateCopyWith<ReviewSpecialistState> get copyWith => _$ReviewSpecialistStateCopyWithImpl<ReviewSpecialistState>(this as ReviewSpecialistState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewSpecialistState&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.selectedTags, selectedTags)&&(identical(other.wouldRecommend, wouldRecommend) || other.wouldRecommend == wouldRecommend)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSubmitted, isSubmitted) || other.isSubmitted == isSubmitted));
}


@override
int get hashCode => Object.hash(runtimeType,rating,comment,const DeepCollectionEquality().hash(selectedTags),wouldRecommend,isSubmitting,isSubmitted);

@override
String toString() {
  return 'ReviewSpecialistState(rating: $rating, comment: $comment, selectedTags: $selectedTags, wouldRecommend: $wouldRecommend, isSubmitting: $isSubmitting, isSubmitted: $isSubmitted)';
}


}

/// @nodoc
abstract mixin class $ReviewSpecialistStateCopyWith<$Res>  {
  factory $ReviewSpecialistStateCopyWith(ReviewSpecialistState value, $Res Function(ReviewSpecialistState) _then) = _$ReviewSpecialistStateCopyWithImpl;
@useResult
$Res call({
 int rating, String comment, List<String> selectedTags, bool wouldRecommend, bool isSubmitting, bool isSubmitted
});




}
/// @nodoc
class _$ReviewSpecialistStateCopyWithImpl<$Res>
    implements $ReviewSpecialistStateCopyWith<$Res> {
  _$ReviewSpecialistStateCopyWithImpl(this._self, this._then);

  final ReviewSpecialistState _self;
  final $Res Function(ReviewSpecialistState) _then;

/// Create a copy of ReviewSpecialistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? comment = null,Object? selectedTags = null,Object? wouldRecommend = null,Object? isSubmitting = null,Object? isSubmitted = null,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,selectedTags: null == selectedTags ? _self.selectedTags : selectedTags // ignore: cast_nullable_to_non_nullable
as List<String>,wouldRecommend: null == wouldRecommend ? _self.wouldRecommend : wouldRecommend // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSubmitted: null == isSubmitted ? _self.isSubmitted : isSubmitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewSpecialistState].
extension ReviewSpecialistStatePatterns on ReviewSpecialistState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewSpecialistState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewSpecialistState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewSpecialistState value)  $default,){
final _that = this;
switch (_that) {
case _ReviewSpecialistState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewSpecialistState value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewSpecialistState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rating,  String comment,  List<String> selectedTags,  bool wouldRecommend,  bool isSubmitting,  bool isSubmitted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewSpecialistState() when $default != null:
return $default(_that.rating,_that.comment,_that.selectedTags,_that.wouldRecommend,_that.isSubmitting,_that.isSubmitted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rating,  String comment,  List<String> selectedTags,  bool wouldRecommend,  bool isSubmitting,  bool isSubmitted)  $default,) {final _that = this;
switch (_that) {
case _ReviewSpecialistState():
return $default(_that.rating,_that.comment,_that.selectedTags,_that.wouldRecommend,_that.isSubmitting,_that.isSubmitted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rating,  String comment,  List<String> selectedTags,  bool wouldRecommend,  bool isSubmitting,  bool isSubmitted)?  $default,) {final _that = this;
switch (_that) {
case _ReviewSpecialistState() when $default != null:
return $default(_that.rating,_that.comment,_that.selectedTags,_that.wouldRecommend,_that.isSubmitting,_that.isSubmitted);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewSpecialistState implements ReviewSpecialistState {
  const _ReviewSpecialistState({this.rating = defaultReviewRating, this.comment = '', final  List<String> selectedTags = const [], this.wouldRecommend = true, this.isSubmitting = false, this.isSubmitted = false}): _selectedTags = selectedTags;
  

/// Star rating (1–5).
@override@JsonKey() final  int rating;
/// Optional free-text comment.
@override@JsonKey() final  String comment;
/// Currently selected feedback tags.
 final  List<String> _selectedTags;
/// Currently selected feedback tags.
@override@JsonKey() List<String> get selectedTags {
  if (_selectedTags is EqualUnmodifiableListView) return _selectedTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedTags);
}

/// Whether user would recommend the specialist.
@override@JsonKey() final  bool wouldRecommend;
/// True while the review is being submitted.
@override@JsonKey() final  bool isSubmitting;
/// True after a successful submission.
@override@JsonKey() final  bool isSubmitted;

/// Create a copy of ReviewSpecialistState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewSpecialistStateCopyWith<_ReviewSpecialistState> get copyWith => __$ReviewSpecialistStateCopyWithImpl<_ReviewSpecialistState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewSpecialistState&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other._selectedTags, _selectedTags)&&(identical(other.wouldRecommend, wouldRecommend) || other.wouldRecommend == wouldRecommend)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSubmitted, isSubmitted) || other.isSubmitted == isSubmitted));
}


@override
int get hashCode => Object.hash(runtimeType,rating,comment,const DeepCollectionEquality().hash(_selectedTags),wouldRecommend,isSubmitting,isSubmitted);

@override
String toString() {
  return 'ReviewSpecialistState(rating: $rating, comment: $comment, selectedTags: $selectedTags, wouldRecommend: $wouldRecommend, isSubmitting: $isSubmitting, isSubmitted: $isSubmitted)';
}


}

/// @nodoc
abstract mixin class _$ReviewSpecialistStateCopyWith<$Res> implements $ReviewSpecialistStateCopyWith<$Res> {
  factory _$ReviewSpecialistStateCopyWith(_ReviewSpecialistState value, $Res Function(_ReviewSpecialistState) _then) = __$ReviewSpecialistStateCopyWithImpl;
@override @useResult
$Res call({
 int rating, String comment, List<String> selectedTags, bool wouldRecommend, bool isSubmitting, bool isSubmitted
});




}
/// @nodoc
class __$ReviewSpecialistStateCopyWithImpl<$Res>
    implements _$ReviewSpecialistStateCopyWith<$Res> {
  __$ReviewSpecialistStateCopyWithImpl(this._self, this._then);

  final _ReviewSpecialistState _self;
  final $Res Function(_ReviewSpecialistState) _then;

/// Create a copy of ReviewSpecialistState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? comment = null,Object? selectedTags = null,Object? wouldRecommend = null,Object? isSubmitting = null,Object? isSubmitted = null,}) {
  return _then(_ReviewSpecialistState(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,selectedTags: null == selectedTags ? _self._selectedTags : selectedTags // ignore: cast_nullable_to_non_nullable
as List<String>,wouldRecommend: null == wouldRecommend ? _self.wouldRecommend : wouldRecommend // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSubmitted: null == isSubmitted ? _self.isSubmitted : isSubmitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
