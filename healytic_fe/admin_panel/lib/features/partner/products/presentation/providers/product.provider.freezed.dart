// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductState {

 String get searchQuery; ProductTableSort get sortBy; bool get sortAscending; String? get categoryFilter; ProductStatusFilter get statusFilter; Set<String> get selectedIds; int get reloadToken;
/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductStateCopyWith<ProductState> get copyWith => _$ProductStateCopyWithImpl<ProductState>(this as ProductState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending)&&(identical(other.categoryFilter, categoryFilter) || other.categoryFilter == categoryFilter)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&const DeepCollectionEquality().equals(other.selectedIds, selectedIds)&&(identical(other.reloadToken, reloadToken) || other.reloadToken == reloadToken));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,sortBy,sortAscending,categoryFilter,statusFilter,const DeepCollectionEquality().hash(selectedIds),reloadToken);

@override
String toString() {
  return 'ProductState(searchQuery: $searchQuery, sortBy: $sortBy, sortAscending: $sortAscending, categoryFilter: $categoryFilter, statusFilter: $statusFilter, selectedIds: $selectedIds, reloadToken: $reloadToken)';
}


}

/// @nodoc
abstract mixin class $ProductStateCopyWith<$Res>  {
  factory $ProductStateCopyWith(ProductState value, $Res Function(ProductState) _then) = _$ProductStateCopyWithImpl;
@useResult
$Res call({
 String searchQuery, ProductTableSort sortBy, bool sortAscending, String? categoryFilter, ProductStatusFilter statusFilter, Set<String> selectedIds, int reloadToken
});




}
/// @nodoc
class _$ProductStateCopyWithImpl<$Res>
    implements $ProductStateCopyWith<$Res> {
  _$ProductStateCopyWithImpl(this._self, this._then);

  final ProductState _self;
  final $Res Function(ProductState) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchQuery = null,Object? sortBy = null,Object? sortAscending = null,Object? categoryFilter = freezed,Object? statusFilter = null,Object? selectedIds = null,Object? reloadToken = null,}) {
  return _then(_self.copyWith(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as ProductTableSort,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,categoryFilter: freezed == categoryFilter ? _self.categoryFilter : categoryFilter // ignore: cast_nullable_to_non_nullable
as String?,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as ProductStatusFilter,selectedIds: null == selectedIds ? _self.selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,reloadToken: null == reloadToken ? _self.reloadToken : reloadToken // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductState].
extension ProductStatePatterns on ProductState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductState value)  $default,){
final _that = this;
switch (_that) {
case _ProductState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String searchQuery,  ProductTableSort sortBy,  bool sortAscending,  String? categoryFilter,  ProductStatusFilter statusFilter,  Set<String> selectedIds,  int reloadToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that.searchQuery,_that.sortBy,_that.sortAscending,_that.categoryFilter,_that.statusFilter,_that.selectedIds,_that.reloadToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String searchQuery,  ProductTableSort sortBy,  bool sortAscending,  String? categoryFilter,  ProductStatusFilter statusFilter,  Set<String> selectedIds,  int reloadToken)  $default,) {final _that = this;
switch (_that) {
case _ProductState():
return $default(_that.searchQuery,_that.sortBy,_that.sortAscending,_that.categoryFilter,_that.statusFilter,_that.selectedIds,_that.reloadToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String searchQuery,  ProductTableSort sortBy,  bool sortAscending,  String? categoryFilter,  ProductStatusFilter statusFilter,  Set<String> selectedIds,  int reloadToken)?  $default,) {final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that.searchQuery,_that.sortBy,_that.sortAscending,_that.categoryFilter,_that.statusFilter,_that.selectedIds,_that.reloadToken);case _:
  return null;

}
}

}

/// @nodoc


class _ProductState implements ProductState {
  const _ProductState({this.searchQuery = '', this.sortBy = ProductTableSort.name, this.sortAscending = true, this.categoryFilter, this.statusFilter = ProductStatusFilter.all, final  Set<String> selectedIds = const <String>{}, this.reloadToken = 0}): _selectedIds = selectedIds;
  

@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  ProductTableSort sortBy;
@override@JsonKey() final  bool sortAscending;
@override final  String? categoryFilter;
@override@JsonKey() final  ProductStatusFilter statusFilter;
 final  Set<String> _selectedIds;
@override@JsonKey() Set<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}

@override@JsonKey() final  int reloadToken;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductStateCopyWith<_ProductState> get copyWith => __$ProductStateCopyWithImpl<_ProductState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductState&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending)&&(identical(other.categoryFilter, categoryFilter) || other.categoryFilter == categoryFilter)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds)&&(identical(other.reloadToken, reloadToken) || other.reloadToken == reloadToken));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,sortBy,sortAscending,categoryFilter,statusFilter,const DeepCollectionEquality().hash(_selectedIds),reloadToken);

@override
String toString() {
  return 'ProductState(searchQuery: $searchQuery, sortBy: $sortBy, sortAscending: $sortAscending, categoryFilter: $categoryFilter, statusFilter: $statusFilter, selectedIds: $selectedIds, reloadToken: $reloadToken)';
}


}

/// @nodoc
abstract mixin class _$ProductStateCopyWith<$Res> implements $ProductStateCopyWith<$Res> {
  factory _$ProductStateCopyWith(_ProductState value, $Res Function(_ProductState) _then) = __$ProductStateCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, ProductTableSort sortBy, bool sortAscending, String? categoryFilter, ProductStatusFilter statusFilter, Set<String> selectedIds, int reloadToken
});




}
/// @nodoc
class __$ProductStateCopyWithImpl<$Res>
    implements _$ProductStateCopyWith<$Res> {
  __$ProductStateCopyWithImpl(this._self, this._then);

  final _ProductState _self;
  final $Res Function(_ProductState) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? sortBy = null,Object? sortAscending = null,Object? categoryFilter = freezed,Object? statusFilter = null,Object? selectedIds = null,Object? reloadToken = null,}) {
  return _then(_ProductState(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as ProductTableSort,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,categoryFilter: freezed == categoryFilter ? _self.categoryFilter : categoryFilter // ignore: cast_nullable_to_non_nullable
as String?,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as ProductStatusFilter,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,reloadToken: null == reloadToken ? _self.reloadToken : reloadToken // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
