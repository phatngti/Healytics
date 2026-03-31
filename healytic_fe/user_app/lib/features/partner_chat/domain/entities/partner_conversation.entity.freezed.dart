// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_conversation.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParticipantInfo {

 String get id; String get name; String? get avatar; String get role;
/// Create a copy of ParticipantInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantInfoCopyWith<ParticipantInfo> get copyWith => _$ParticipantInfoCopyWithImpl<ParticipantInfo>(this as ParticipantInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,role);

@override
String toString() {
  return 'ParticipantInfo(id: $id, name: $name, avatar: $avatar, role: $role)';
}


}

/// @nodoc
abstract mixin class $ParticipantInfoCopyWith<$Res>  {
  factory $ParticipantInfoCopyWith(ParticipantInfo value, $Res Function(ParticipantInfo) _then) = _$ParticipantInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatar, String role
});




}
/// @nodoc
class _$ParticipantInfoCopyWithImpl<$Res>
    implements $ParticipantInfoCopyWith<$Res> {
  _$ParticipantInfoCopyWithImpl(this._self, this._then);

  final ParticipantInfo _self;
  final $Res Function(ParticipantInfo) _then;

/// Create a copy of ParticipantInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,Object? role = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantInfo].
extension ParticipantInfoPatterns on ParticipantInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantInfo value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatar,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantInfo() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatar,  String role)  $default,) {final _that = this;
switch (_that) {
case _ParticipantInfo():
return $default(_that.id,_that.name,_that.avatar,_that.role);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatar,  String role)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantInfo() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _ParticipantInfo implements ParticipantInfo {
  const _ParticipantInfo({required this.id, required this.name, this.avatar, required this.role});
  

@override final  String id;
@override final  String name;
@override final  String? avatar;
@override final  String role;

/// Create a copy of ParticipantInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantInfoCopyWith<_ParticipantInfo> get copyWith => __$ParticipantInfoCopyWithImpl<_ParticipantInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,role);

@override
String toString() {
  return 'ParticipantInfo(id: $id, name: $name, avatar: $avatar, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ParticipantInfoCopyWith<$Res> implements $ParticipantInfoCopyWith<$Res> {
  factory _$ParticipantInfoCopyWith(_ParticipantInfo value, $Res Function(_ParticipantInfo) _then) = __$ParticipantInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatar, String role
});




}
/// @nodoc
class __$ParticipantInfoCopyWithImpl<$Res>
    implements _$ParticipantInfoCopyWith<$Res> {
  __$ParticipantInfoCopyWithImpl(this._self, this._then);

  final _ParticipantInfo _self;
  final $Res Function(_ParticipantInfo) _then;

/// Create a copy of ParticipantInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,Object? role = null,}) {
  return _then(_ParticipantInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LastMessagePreview {

 String? get text; DateTime? get timestamp; String? get senderId;
/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastMessagePreviewCopyWith<LastMessagePreview> get copyWith => _$LastMessagePreviewCopyWithImpl<LastMessagePreview>(this as LastMessagePreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastMessagePreview&&(identical(other.text, text) || other.text == text)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.senderId, senderId) || other.senderId == senderId));
}


@override
int get hashCode => Object.hash(runtimeType,text,timestamp,senderId);

@override
String toString() {
  return 'LastMessagePreview(text: $text, timestamp: $timestamp, senderId: $senderId)';
}


}

/// @nodoc
abstract mixin class $LastMessagePreviewCopyWith<$Res>  {
  factory $LastMessagePreviewCopyWith(LastMessagePreview value, $Res Function(LastMessagePreview) _then) = _$LastMessagePreviewCopyWithImpl;
@useResult
$Res call({
 String? text, DateTime? timestamp, String? senderId
});




}
/// @nodoc
class _$LastMessagePreviewCopyWithImpl<$Res>
    implements $LastMessagePreviewCopyWith<$Res> {
  _$LastMessagePreviewCopyWithImpl(this._self, this._then);

  final LastMessagePreview _self;
  final $Res Function(LastMessagePreview) _then;

/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? timestamp = freezed,Object? senderId = freezed,}) {
  return _then(_self.copyWith(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LastMessagePreview].
extension LastMessagePreviewPatterns on LastMessagePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastMessagePreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastMessagePreview value)  $default,){
final _that = this;
switch (_that) {
case _LastMessagePreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastMessagePreview value)?  $default,){
final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? text,  DateTime? timestamp,  String? senderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
return $default(_that.text,_that.timestamp,_that.senderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? text,  DateTime? timestamp,  String? senderId)  $default,) {final _that = this;
switch (_that) {
case _LastMessagePreview():
return $default(_that.text,_that.timestamp,_that.senderId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? text,  DateTime? timestamp,  String? senderId)?  $default,) {final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
return $default(_that.text,_that.timestamp,_that.senderId);case _:
  return null;

}
}

}

/// @nodoc


class _LastMessagePreview implements LastMessagePreview {
  const _LastMessagePreview({this.text, this.timestamp, this.senderId});
  

@override final  String? text;
@override final  DateTime? timestamp;
@override final  String? senderId;

/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastMessagePreviewCopyWith<_LastMessagePreview> get copyWith => __$LastMessagePreviewCopyWithImpl<_LastMessagePreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastMessagePreview&&(identical(other.text, text) || other.text == text)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.senderId, senderId) || other.senderId == senderId));
}


@override
int get hashCode => Object.hash(runtimeType,text,timestamp,senderId);

@override
String toString() {
  return 'LastMessagePreview(text: $text, timestamp: $timestamp, senderId: $senderId)';
}


}

/// @nodoc
abstract mixin class _$LastMessagePreviewCopyWith<$Res> implements $LastMessagePreviewCopyWith<$Res> {
  factory _$LastMessagePreviewCopyWith(_LastMessagePreview value, $Res Function(_LastMessagePreview) _then) = __$LastMessagePreviewCopyWithImpl;
@override @useResult
$Res call({
 String? text, DateTime? timestamp, String? senderId
});




}
/// @nodoc
class __$LastMessagePreviewCopyWithImpl<$Res>
    implements _$LastMessagePreviewCopyWith<$Res> {
  __$LastMessagePreviewCopyWithImpl(this._self, this._then);

  final _LastMessagePreview _self;
  final $Res Function(_LastMessagePreview) _then;

/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? timestamp = freezed,Object? senderId = freezed,}) {
  return _then(_LastMessagePreview(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PartnerConversation {

 String get id; String get status; String? get bookingId; ParticipantInfo get otherParticipant; LastMessagePreview get lastMessage; int get unreadCount; DateTime get createdAt;
/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerConversationCopyWith<PartnerConversation> get copyWith => _$PartnerConversationCopyWithImpl<PartnerConversation>(this as PartnerConversation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.otherParticipant, otherParticipant) || other.otherParticipant == otherParticipant)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,bookingId,otherParticipant,lastMessage,unreadCount,createdAt);

@override
String toString() {
  return 'PartnerConversation(id: $id, status: $status, bookingId: $bookingId, otherParticipant: $otherParticipant, lastMessage: $lastMessage, unreadCount: $unreadCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PartnerConversationCopyWith<$Res>  {
  factory $PartnerConversationCopyWith(PartnerConversation value, $Res Function(PartnerConversation) _then) = _$PartnerConversationCopyWithImpl;
@useResult
$Res call({
 String id, String status, String? bookingId, ParticipantInfo otherParticipant, LastMessagePreview lastMessage, int unreadCount, DateTime createdAt
});


$ParticipantInfoCopyWith<$Res> get otherParticipant;$LastMessagePreviewCopyWith<$Res> get lastMessage;

}
/// @nodoc
class _$PartnerConversationCopyWithImpl<$Res>
    implements $PartnerConversationCopyWith<$Res> {
  _$PartnerConversationCopyWithImpl(this._self, this._then);

  final PartnerConversation _self;
  final $Res Function(PartnerConversation) _then;

/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? bookingId = freezed,Object? otherParticipant = null,Object? lastMessage = null,Object? unreadCount = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,otherParticipant: null == otherParticipant ? _self.otherParticipant : otherParticipant // ignore: cast_nullable_to_non_nullable
as ParticipantInfo,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as LastMessagePreview,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantInfoCopyWith<$Res> get otherParticipant {
  
  return $ParticipantInfoCopyWith<$Res>(_self.otherParticipant, (value) {
    return _then(_self.copyWith(otherParticipant: value));
  });
}/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessagePreviewCopyWith<$Res> get lastMessage {
  
  return $LastMessagePreviewCopyWith<$Res>(_self.lastMessage, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [PartnerConversation].
extension PartnerConversationPatterns on PartnerConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerConversation value)  $default,){
final _that = this;
switch (_that) {
case _PartnerConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerConversation value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status,  String? bookingId,  ParticipantInfo otherParticipant,  LastMessagePreview lastMessage,  int unreadCount,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnerConversation() when $default != null:
return $default(_that.id,_that.status,_that.bookingId,_that.otherParticipant,_that.lastMessage,_that.unreadCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status,  String? bookingId,  ParticipantInfo otherParticipant,  LastMessagePreview lastMessage,  int unreadCount,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PartnerConversation():
return $default(_that.id,_that.status,_that.bookingId,_that.otherParticipant,_that.lastMessage,_that.unreadCount,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status,  String? bookingId,  ParticipantInfo otherParticipant,  LastMessagePreview lastMessage,  int unreadCount,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PartnerConversation() when $default != null:
return $default(_that.id,_that.status,_that.bookingId,_that.otherParticipant,_that.lastMessage,_that.unreadCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _PartnerConversation implements PartnerConversation {
  const _PartnerConversation({required this.id, required this.status, this.bookingId, required this.otherParticipant, required this.lastMessage, this.unreadCount = 0, required this.createdAt});
  

@override final  String id;
@override final  String status;
@override final  String? bookingId;
@override final  ParticipantInfo otherParticipant;
@override final  LastMessagePreview lastMessage;
@override@JsonKey() final  int unreadCount;
@override final  DateTime createdAt;

/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerConversationCopyWith<_PartnerConversation> get copyWith => __$PartnerConversationCopyWithImpl<_PartnerConversation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.otherParticipant, otherParticipant) || other.otherParticipant == otherParticipant)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,bookingId,otherParticipant,lastMessage,unreadCount,createdAt);

@override
String toString() {
  return 'PartnerConversation(id: $id, status: $status, bookingId: $bookingId, otherParticipant: $otherParticipant, lastMessage: $lastMessage, unreadCount: $unreadCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PartnerConversationCopyWith<$Res> implements $PartnerConversationCopyWith<$Res> {
  factory _$PartnerConversationCopyWith(_PartnerConversation value, $Res Function(_PartnerConversation) _then) = __$PartnerConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String status, String? bookingId, ParticipantInfo otherParticipant, LastMessagePreview lastMessage, int unreadCount, DateTime createdAt
});


@override $ParticipantInfoCopyWith<$Res> get otherParticipant;@override $LastMessagePreviewCopyWith<$Res> get lastMessage;

}
/// @nodoc
class __$PartnerConversationCopyWithImpl<$Res>
    implements _$PartnerConversationCopyWith<$Res> {
  __$PartnerConversationCopyWithImpl(this._self, this._then);

  final _PartnerConversation _self;
  final $Res Function(_PartnerConversation) _then;

/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? bookingId = freezed,Object? otherParticipant = null,Object? lastMessage = null,Object? unreadCount = null,Object? createdAt = null,}) {
  return _then(_PartnerConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,otherParticipant: null == otherParticipant ? _self.otherParticipant : otherParticipant // ignore: cast_nullable_to_non_nullable
as ParticipantInfo,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as LastMessagePreview,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantInfoCopyWith<$Res> get otherParticipant {
  
  return $ParticipantInfoCopyWith<$Res>(_self.otherParticipant, (value) {
    return _then(_self.copyWith(otherParticipant: value));
  });
}/// Create a copy of PartnerConversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessagePreviewCopyWith<$Res> get lastMessage {
  
  return $LastMessagePreviewCopyWith<$Res>(_self.lastMessage, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}

// dart format on
