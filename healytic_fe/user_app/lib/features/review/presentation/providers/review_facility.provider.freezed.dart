// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_facility.provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewFacilityState {

/// Star rating (0 = unset, 1–5).
 int get rating;/// Optional free-text comment.
 String get comment;/// Currently selected feedback tags.
 List<String> get selectedTags;/// Local file paths of selected photos.
 List<String> get photoPaths;/// True while the review is being submitted.
 bool get isSubmitting;/// True after a successful submission.
 bool get isSubmitted;/// Non-null when submission fails.
 String? get errorMessage;
/// Create a copy of ReviewFacilityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewFacilityStateCopyWith<ReviewFacilityState> get copyWith => _$ReviewFacilityStateCopyWithImpl<ReviewFacilityState>(this as ReviewFacilityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewFacilityState&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.selectedTags, selectedTags)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSubmitted, isSubmitted) || other.isSubmitted == isSubmitted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,rating,comment,const DeepCollectionEquality().hash(selectedTags),const DeepCollectionEquality().hash(photoPaths),isSubmitting,isSubmitted,errorMessage);

@override
String toString() {
  return 'ReviewFacilityState(rating: $rating, comment: $comment, selectedTags: $selectedTags, photoPaths: $photoPaths, isSubmitting: $isSubmitting, isSubmitted: $isSubmitted, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ReviewFacilityStateCopyWith<$Res>  {
  factory $ReviewFacilityStateCopyWith(ReviewFacilityState value, $Res Function(ReviewFacilityState) _then) = _$ReviewFacilityStateCopyWithImpl;
@useResult
$Res call({
 int rating, String comment, List<String> selectedTags, List<String> photoPaths, bool isSubmitting, bool isSubmitted, String? errorMessage
});




}
/// @nodoc
class _$ReviewFacilityStateCopyWithImpl<$Res>
    implements $ReviewFacilityStateCopyWith<$Res> {
  _$ReviewFacilityStateCopyWithImpl(this._self, this._then);

  final ReviewFacilityState _self;
  final $Res Function(ReviewFacilityState) _then;

/// Create a copy of ReviewFacilityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? comment = null,Object? selectedTags = null,Object? photoPaths = null,Object? isSubmitting = null,Object? isSubmitted = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,selectedTags: null == selectedTags ? _self.selectedTags : selectedTags // ignore: cast_nullable_to_non_nullable
as List<String>,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSubmitted: null == isSubmitted ? _self.isSubmitted : isSubmitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewFacilityState].
extension ReviewFacilityStatePatterns on ReviewFacilityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewFacilityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewFacilityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewFacilityState value)  $default,){
final _that = this;
switch (_that) {
case _ReviewFacilityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewFacilityState value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewFacilityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rating,  String comment,  List<String> selectedTags,  List<String> photoPaths,  bool isSubmitting,  bool isSubmitted,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewFacilityState() when $default != null:
return $default(_that.rating,_that.comment,_that.selectedTags,_that.photoPaths,_that.isSubmitting,_that.isSubmitted,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rating,  String comment,  List<String> selectedTags,  List<String> photoPaths,  bool isSubmitting,  bool isSubmitted,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ReviewFacilityState():
return $default(_that.rating,_that.comment,_that.selectedTags,_that.photoPaths,_that.isSubmitting,_that.isSubmitted,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rating,  String comment,  List<String> selectedTags,  List<String> photoPaths,  bool isSubmitting,  bool isSubmitted,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ReviewFacilityState() when $default != null:
return $default(_that.rating,_that.comment,_that.selectedTags,_that.photoPaths,_that.isSubmitting,_that.isSubmitted,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewFacilityState implements ReviewFacilityState {
  const _ReviewFacilityState({this.rating = 0, this.comment = '', final  List<String> selectedTags = const [], final  List<String> photoPaths = const [], this.isSubmitting = false, this.isSubmitted = false, this.errorMessage}): _selectedTags = selectedTags,_photoPaths = photoPaths;
  

/// Star rating (0 = unset, 1–5).
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

/// Local file paths of selected photos.
 final  List<String> _photoPaths;
/// Local file paths of selected photos.
@override@JsonKey() List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

/// True while the review is being submitted.
@override@JsonKey() final  bool isSubmitting;
/// True after a successful submission.
@override@JsonKey() final  bool isSubmitted;
/// Non-null when submission fails.
@override final  String? errorMessage;

/// Create a copy of ReviewFacilityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewFacilityStateCopyWith<_ReviewFacilityState> get copyWith => __$ReviewFacilityStateCopyWithImpl<_ReviewFacilityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewFacilityState&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other._selectedTags, _selectedTags)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSubmitted, isSubmitted) || other.isSubmitted == isSubmitted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,rating,comment,const DeepCollectionEquality().hash(_selectedTags),const DeepCollectionEquality().hash(_photoPaths),isSubmitting,isSubmitted,errorMessage);

@override
String toString() {
  return 'ReviewFacilityState(rating: $rating, comment: $comment, selectedTags: $selectedTags, photoPaths: $photoPaths, isSubmitting: $isSubmitting, isSubmitted: $isSubmitted, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ReviewFacilityStateCopyWith<$Res> implements $ReviewFacilityStateCopyWith<$Res> {
  factory _$ReviewFacilityStateCopyWith(_ReviewFacilityState value, $Res Function(_ReviewFacilityState) _then) = __$ReviewFacilityStateCopyWithImpl;
@override @useResult
$Res call({
 int rating, String comment, List<String> selectedTags, List<String> photoPaths, bool isSubmitting, bool isSubmitted, String? errorMessage
});




}
/// @nodoc
class __$ReviewFacilityStateCopyWithImpl<$Res>
    implements _$ReviewFacilityStateCopyWith<$Res> {
  __$ReviewFacilityStateCopyWithImpl(this._self, this._then);

  final _ReviewFacilityState _self;
  final $Res Function(_ReviewFacilityState) _then;

/// Create a copy of ReviewFacilityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? comment = null,Object? selectedTags = null,Object? photoPaths = null,Object? isSubmitting = null,Object? isSubmitted = null,Object? errorMessage = freezed,}) {
  return _then(_ReviewFacilityState(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,selectedTags: null == selectedTags ? _self._selectedTags : selectedTags // ignore: cast_nullable_to_non_nullable
as List<String>,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSubmitted: null == isSubmitted ? _self.isSubmitted : isSubmitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
