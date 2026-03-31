// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_chat_message.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PartnerChatMessage {

 String get id; String get conversationId; String get senderId; String? get senderName; String? get senderAvatar; String get content; PartnerMessageType get messageType; String? get clientMessageId; DateTime get createdAt; bool get isRead;
/// Create a copy of PartnerChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerChatMessageCopyWith<PartnerChatMessage> get copyWith => _$PartnerChatMessageCopyWithImpl<PartnerChatMessage>(this as PartnerChatMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}


@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderName,senderAvatar,content,messageType,clientMessageId,createdAt,isRead);

@override
String toString() {
  return 'PartnerChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, content: $content, messageType: $messageType, clientMessageId: $clientMessageId, createdAt: $createdAt, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class $PartnerChatMessageCopyWith<$Res>  {
  factory $PartnerChatMessageCopyWith(PartnerChatMessage value, $Res Function(PartnerChatMessage) _then) = _$PartnerChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String senderId, String? senderName, String? senderAvatar, String content, PartnerMessageType messageType, String? clientMessageId, DateTime createdAt, bool isRead
});




}
/// @nodoc
class _$PartnerChatMessageCopyWithImpl<$Res>
    implements $PartnerChatMessageCopyWith<$Res> {
  _$PartnerChatMessageCopyWithImpl(this._self, this._then);

  final PartnerChatMessage _self;
  final $Res Function(PartnerChatMessage) _then;

/// Create a copy of PartnerChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderName = freezed,Object? senderAvatar = freezed,Object? content = null,Object? messageType = null,Object? clientMessageId = freezed,Object? createdAt = null,Object? isRead = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderAvatar: freezed == senderAvatar ? _self.senderAvatar : senderAvatar // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as PartnerMessageType,clientMessageId: freezed == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnerChatMessage].
extension PartnerChatMessagePatterns on PartnerChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _PartnerChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String? senderName,  String? senderAvatar,  String content,  PartnerMessageType messageType,  String? clientMessageId,  DateTime createdAt,  bool isRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnerChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderName,_that.senderAvatar,_that.content,_that.messageType,_that.clientMessageId,_that.createdAt,_that.isRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String? senderName,  String? senderAvatar,  String content,  PartnerMessageType messageType,  String? clientMessageId,  DateTime createdAt,  bool isRead)  $default,) {final _that = this;
switch (_that) {
case _PartnerChatMessage():
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderName,_that.senderAvatar,_that.content,_that.messageType,_that.clientMessageId,_that.createdAt,_that.isRead);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String senderId,  String? senderName,  String? senderAvatar,  String content,  PartnerMessageType messageType,  String? clientMessageId,  DateTime createdAt,  bool isRead)?  $default,) {final _that = this;
switch (_that) {
case _PartnerChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.senderName,_that.senderAvatar,_that.content,_that.messageType,_that.clientMessageId,_that.createdAt,_that.isRead);case _:
  return null;

}
}

}

/// @nodoc


class _PartnerChatMessage implements PartnerChatMessage {
  const _PartnerChatMessage({required this.id, required this.conversationId, required this.senderId, this.senderName, this.senderAvatar, required this.content, this.messageType = PartnerMessageType.text, this.clientMessageId, required this.createdAt, this.isRead = false});
  

@override final  String id;
@override final  String conversationId;
@override final  String senderId;
@override final  String? senderName;
@override final  String? senderAvatar;
@override final  String content;
@override@JsonKey() final  PartnerMessageType messageType;
@override final  String? clientMessageId;
@override final  DateTime createdAt;
@override@JsonKey() final  bool isRead;

/// Create a copy of PartnerChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerChatMessageCopyWith<_PartnerChatMessage> get copyWith => __$PartnerChatMessageCopyWithImpl<_PartnerChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}


@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,senderName,senderAvatar,content,messageType,clientMessageId,createdAt,isRead);

@override
String toString() {
  return 'PartnerChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, content: $content, messageType: $messageType, clientMessageId: $clientMessageId, createdAt: $createdAt, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class _$PartnerChatMessageCopyWith<$Res> implements $PartnerChatMessageCopyWith<$Res> {
  factory _$PartnerChatMessageCopyWith(_PartnerChatMessage value, $Res Function(_PartnerChatMessage) _then) = __$PartnerChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String senderId, String? senderName, String? senderAvatar, String content, PartnerMessageType messageType, String? clientMessageId, DateTime createdAt, bool isRead
});




}
/// @nodoc
class __$PartnerChatMessageCopyWithImpl<$Res>
    implements _$PartnerChatMessageCopyWith<$Res> {
  __$PartnerChatMessageCopyWithImpl(this._self, this._then);

  final _PartnerChatMessage _self;
  final $Res Function(_PartnerChatMessage) _then;

/// Create a copy of PartnerChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? senderName = freezed,Object? senderAvatar = freezed,Object? content = null,Object? messageType = null,Object? clientMessageId = freezed,Object? createdAt = null,Object? isRead = null,}) {
  return _then(_PartnerChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderAvatar: freezed == senderAvatar ? _self.senderAvatar : senderAvatar // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as PartnerMessageType,clientMessageId: freezed == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
