// =============================================================
// AUTO-GENERATED from ws-contract.json — DO NOT EDIT BY HAND.
//
// Re-generate with:
//   ./bin/generate-integration.sh ws
// =============================================================

// ignore_for_file: type=lint
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: unused_element

Map<String, dynamic> _requireJsonMap(dynamic value, String context) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  throw FormatException('Expected JSON object for $context, got ${value.runtimeType}');
}

Map<String, dynamic>? _jsonMapOrNull(dynamic value, String context) {
  if (value == null) return null;
  return _requireJsonMap(value, context);
}

DateTime _requireDateTime(dynamic value, String context) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  throw FormatException('Expected DateTime string for $context, got ${value.runtimeType}');
}

DateTime? _dateTimeOrNull(dynamic value, String context) {
  if (value == null) return null;
  return _requireDateTime(value, context);
}

List<T> _requireJsonList<T>(
  dynamic value,
  String context,
  T Function(dynamic item) convert,
) {
  if (value is! List) {
    throw FormatException('Expected JSON list for $context, got ${value.runtimeType}');
  }
  return value.map(convert).toList(growable: false);
}

List<T>? _jsonListOrNull<T>(
  dynamic value,
  String context,
  T Function(dynamic item) convert,
) {
  if (value == null) return null;
  return _requireJsonList(value, context, convert);
}

/// Type of chat message content
enum WsMessageType {
  text,
  image,
  file,
  system,
}

WsMessageType wsMessageTypeFromJson(dynamic value) {
  if (value == null) return WsMessageType.text;
  final str = value.toString();
  switch (str) {
    case 'text':
      return WsMessageType.text;
    case 'image':
      return WsMessageType.image;
    case 'file':
      return WsMessageType.file;
    case 'system':
      return WsMessageType.system;
    default:
      return WsMessageType.text;
  }
}

String wsMessageTypeToJson(WsMessageType value) {
  switch (value) {
    case WsMessageType.text:
      return 'text';
    case WsMessageType.image:
      return 'image';
    case WsMessageType.file:
      return 'file';
    case WsMessageType.system:
      return 'system';
  }
}

/// Payload for sending a message via WebSocket
class WsSendMessagePayload {
  /// Target conversation UUID
  final String conversationId;

  /// Target receiver UUID
  final String receiverId;

  /// Message text content (max 5000 chars)
  final String content;

  /// Type of message
  final WsMessageType? messageType;

  /// Client-generated UUID for idempotent delivery
  final String? clientMessageId;

  const WsSendMessagePayload({
    required this.conversationId,
    required this.receiverId,
    required this.content,
    this.messageType = WsMessageType.text,
    this.clientMessageId,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsSendMessagePayload.fromJson(Map<String, dynamic> json) {
    return WsSendMessagePayload(
      conversationId: json['conversationId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      messageType: json['messageType'] != null ? wsMessageTypeFromJson(json['messageType']) : null,
      clientMessageId: json['clientMessageId'] as String?,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'receiverId': receiverId,
      'content': content,
      if (messageType != null) 'messageType': wsMessageTypeToJson(messageType!),
      if (clientMessageId != null) 'clientMessageId': clientMessageId!,
    };
  }

  @override
  String toString() {
    return 'WsSendMessagePayload(conversationId: $conversationId, receiverId: $receiverId, content: $content, messageType: $messageType, clientMessageId: $clientMessageId)';
  }
}

/// Payload containing only a conversation ID
class WsTypingPayload {
  /// Conversation UUID
  final String conversationId;

  /// Target receiver UUID
  final String receiverId;

  const WsTypingPayload({
    required this.conversationId,
    required this.receiverId,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsTypingPayload.fromJson(Map<String, dynamic> json) {
    return WsTypingPayload(
      conversationId: json['conversationId'] as String,
      receiverId: json['receiverId'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'receiverId': receiverId,
    };
  }

  @override
  String toString() {
    return 'WsTypingPayload(conversationId: $conversationId, receiverId: $receiverId)';
  }
}

/// Payload containing only a conversation ID
class WsMarkReadPayload {
  /// Conversation UUID
  final String conversationId;

  /// Target receiver UUID
  final String receiverId;

  const WsMarkReadPayload({
    required this.conversationId,
    required this.receiverId,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsMarkReadPayload.fromJson(Map<String, dynamic> json) {
    return WsMarkReadPayload(
      conversationId: json['conversationId'] as String,
      receiverId: json['receiverId'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'receiverId': receiverId,
    };
  }

  @override
  String toString() {
    return 'WsMarkReadPayload(conversationId: $conversationId, receiverId: $receiverId)';
  }
}

/// Payload containing only a conversation ID
class WsJoinConversationPayload {
  /// Conversation UUID
  final String conversationId;

  const WsJoinConversationPayload({
    required this.conversationId,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsJoinConversationPayload.fromJson(Map<String, dynamic> json) {
    return WsJoinConversationPayload(
      conversationId: json['conversationId'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
    };
  }

  @override
  String toString() {
    return 'WsJoinConversationPayload(conversationId: $conversationId)';
  }
}

/// Server acknowledgement after persisting a message
class WsMessageSentAck {
  /// Server-generated message UUID
  final String id;

  /// Echoed client message ID for matching
  final String? clientMessageId;

  const WsMessageSentAck({
    required this.id,
    this.clientMessageId,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsMessageSentAck.fromJson(Map<String, dynamic> json) {
    return WsMessageSentAck(
      id: json['id'] as String,
      clientMessageId: json['clientMessageId'] as String?,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      if (clientMessageId != null) 'clientMessageId': clientMessageId!,
    };
  }

  @override
  String toString() {
    return 'WsMessageSentAck(id: $id, clientMessageId: $clientMessageId)';
  }
}

/// Server event: a new message in a conversation
class WsNewMessageEvent {
  /// Server-generated message UUID
  final String id;

  /// Conversation UUID
  final String conversationId;

  /// Account ID of the sender
  final String senderId;

  /// Account ID of the receiver
  final String receiverId;

  /// Display name of the sender
  final String? senderName;

  /// Avatar URL of the sender
  final String? senderAvatar;

  /// Message text content
  final String content;

  /// Type of message
  final WsMessageType messageType;

  /// Echoed client message ID for matching
  final String? clientMessageId;

  /// When the message was created
  final DateTime createdAt;

  const WsNewMessageEvent({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    required this.messageType,
    this.clientMessageId,
    required this.createdAt,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsNewMessageEvent.fromJson(Map<String, dynamic> json) {
    return WsNewMessageEvent(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      senderName: json['senderName'] as String?,
      senderAvatar: json['senderAvatar'] as String?,
      content: json['content'] as String,
      messageType: wsMessageTypeFromJson(json['messageType']),
      clientMessageId: json['clientMessageId'] as String?,
      createdAt: _requireDateTime(json['createdAt'], 'WsNewMessageEvent.createdAt'),
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      if (senderName != null) 'senderName': senderName!,
      if (senderAvatar != null) 'senderAvatar': senderAvatar!,
      'content': content,
      'messageType': wsMessageTypeToJson(messageType),
      if (clientMessageId != null) 'clientMessageId': clientMessageId!,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WsNewMessageEvent(id: $id, conversationId: $conversationId, senderId: $senderId, receiverId: $receiverId, senderName: $senderName, senderAvatar: $senderAvatar, content: $content, messageType: $messageType, clientMessageId: $clientMessageId, createdAt: $createdAt)';
  }
}

/// Server event: messages were read by the other party
class WsMessagesReadEvent {
  /// Conversation UUID
  final String conversationId;

  /// Account ID of the reader
  final String readerId;

  /// Account ID of the message sender (who is being notified)
  final String receiverId;

  /// When the messages were marked as read
  final DateTime readAt;

  const WsMessagesReadEvent({
    required this.conversationId,
    required this.readerId,
    required this.receiverId,
    required this.readAt,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsMessagesReadEvent.fromJson(Map<String, dynamic> json) {
    return WsMessagesReadEvent(
      conversationId: json['conversationId'] as String,
      readerId: json['readerId'] as String,
      receiverId: json['receiverId'] as String,
      readAt: _requireDateTime(json['readAt'], 'WsMessagesReadEvent.readAt'),
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'readerId': readerId,
      'receiverId': receiverId,
      'readAt': readAt.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WsMessagesReadEvent(conversationId: $conversationId, readerId: $readerId, receiverId: $receiverId, readAt: $readAt)';
  }
}

/// Server event: the other party is typing
class WsTypingEvent {
  /// Conversation UUID
  final String conversationId;

  /// Account ID of the typer
  final String userId;

  /// Account ID of the receiver
  final String receiverId;

  /// Display name of the typer
  final String userName;

  const WsTypingEvent({
    required this.conversationId,
    required this.userId,
    required this.receiverId,
    required this.userName,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsTypingEvent.fromJson(Map<String, dynamic> json) {
    return WsTypingEvent(
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      receiverId: json['receiverId'] as String,
      userName: json['userName'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'userId': userId,
      'receiverId': receiverId,
      'userName': userName,
    };
  }

  @override
  String toString() {
    return 'WsTypingEvent(conversationId: $conversationId, userId: $userId, receiverId: $receiverId, userName: $userName)';
  }
}

/// Server event: the other party stopped typing
class WsStopTypingEvent {
  /// Conversation UUID
  final String conversationId;

  /// Account ID
  final String userId;

  /// Account ID of the receiver
  final String receiverId;

  const WsStopTypingEvent({
    required this.conversationId,
    required this.userId,
    required this.receiverId,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsStopTypingEvent.fromJson(Map<String, dynamic> json) {
    return WsStopTypingEvent(
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      receiverId: json['receiverId'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'userId': userId,
      'receiverId': receiverId,
    };
  }

  @override
  String toString() {
    return 'WsStopTypingEvent(conversationId: $conversationId, userId: $userId, receiverId: $receiverId)';
  }
}

/// Server error event
class WsErrorEvent {
  /// Error message
  final String message;

  const WsErrorEvent({
    required this.message,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsErrorEvent.fromJson(Map<String, dynamic> json) {
    return WsErrorEvent(
      message: json['message'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
    };
  }

  @override
  String toString() {
    return 'WsErrorEvent(message: $message)';
  }
}

/// Global notification event: a new chat message was received. Emitted on /chat-notifications namespace for popup notifications.
class WsNewMessageNotification {
  /// Conversation UUID
  final String conversationId;

  /// Server-generated message UUID
  final String messageId;

  /// Account ID of the message sender
  final String senderId;

  /// Display name of the sender (for notification title)
  final String senderName;

  /// Avatar URL of the sender (for notification icon)
  final String? senderAvatar;

  /// First ~100 characters of the message content (for preview)
  final String messagePreview;

  /// Type of message (text, image, file, etc.)
  final WsMessageType messageType;

  /// When the message was created
  final DateTime createdAt;

  const WsNewMessageNotification({
    required this.conversationId,
    required this.messageId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.messagePreview,
    required this.messageType,
    required this.createdAt,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsNewMessageNotification.fromJson(Map<String, dynamic> json) {
    return WsNewMessageNotification(
      conversationId: json['conversationId'] as String,
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String?,
      messagePreview: json['messagePreview'] as String,
      messageType: wsMessageTypeFromJson(json['messageType']),
      createdAt: _requireDateTime(json['createdAt'], 'WsNewMessageNotification.createdAt'),
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      if (senderAvatar != null) 'senderAvatar': senderAvatar!,
      'messagePreview': messagePreview,
      'messageType': wsMessageTypeToJson(messageType),
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WsNewMessageNotification(conversationId: $conversationId, messageId: $messageId, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, messagePreview: $messagePreview, messageType: $messageType, createdAt: $createdAt)';
  }
}

