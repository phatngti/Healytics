// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_sse_event.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatSseEvent {

/// The kind of event received.
 ChatSseEventType get type;/// Raw data payload from the event.
 Map<String, dynamic> get data;
/// Create a copy of ChatSseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSseEventCopyWith<ChatSseEvent> get copyWith => _$ChatSseEventCopyWithImpl<ChatSseEvent>(this as ChatSseEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSseEvent&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ChatSseEvent(type: $type, data: $data)';
}


}

/// @nodoc
abstract mixin class $ChatSseEventCopyWith<$Res>  {
  factory $ChatSseEventCopyWith(ChatSseEvent value, $Res Function(ChatSseEvent) _then) = _$ChatSseEventCopyWithImpl;
@useResult
$Res call({
 ChatSseEventType type, Map<String, dynamic> data
});




}
/// @nodoc
class _$ChatSseEventCopyWithImpl<$Res>
    implements $ChatSseEventCopyWith<$Res> {
  _$ChatSseEventCopyWithImpl(this._self, this._then);

  final ChatSseEvent _self;
  final $Res Function(ChatSseEvent) _then;

/// Create a copy of ChatSseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? data = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatSseEventType,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSseEvent].
extension ChatSseEventPatterns on ChatSseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSseEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSseEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSseEvent value)  $default,){
final _that = this;
switch (_that) {
case _ChatSseEvent():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSseEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSseEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatSseEventType type,  Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSseEvent() when $default != null:
return $default(_that.type,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatSseEventType type,  Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _ChatSseEvent():
return $default(_that.type,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatSseEventType type,  Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _ChatSseEvent() when $default != null:
return $default(_that.type,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ChatSseEvent extends ChatSseEvent {
  const _ChatSseEvent({required this.type, required final  Map<String, dynamic> data}): _data = data,super._();
  

/// The kind of event received.
@override final  ChatSseEventType type;
/// Raw data payload from the event.
 final  Map<String, dynamic> _data;
/// Raw data payload from the event.
@override Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of ChatSseEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSseEventCopyWith<_ChatSseEvent> get copyWith => __$ChatSseEventCopyWithImpl<_ChatSseEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSseEvent&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ChatSseEvent(type: $type, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChatSseEventCopyWith<$Res> implements $ChatSseEventCopyWith<$Res> {
  factory _$ChatSseEventCopyWith(_ChatSseEvent value, $Res Function(_ChatSseEvent) _then) = __$ChatSseEventCopyWithImpl;
@override @useResult
$Res call({
 ChatSseEventType type, Map<String, dynamic> data
});




}
/// @nodoc
class __$ChatSseEventCopyWithImpl<$Res>
    implements _$ChatSseEventCopyWith<$Res> {
  __$ChatSseEventCopyWithImpl(this._self, this._then);

  final _ChatSseEvent _self;
  final $Res Function(_ChatSseEvent) _then;

/// Create a copy of ChatSseEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? data = null,}) {
  return _then(_ChatSseEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatSseEventType,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
