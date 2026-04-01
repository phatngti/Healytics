// =============================================================
// AUTO-GENERATED from ws-contract.json — DO NOT EDIT BY HAND.
//
// Re-generate with:
//   ./bin/generate-open-api.sh ws
// =============================================================

// ignore_for_file: lines_longer_than_80_chars

/// Type of chat message content
enum WsMessageType {
  text,
  image,
  file,
  system,
}

WsMessageType wsMessageTypeFromJson(dynamic value) {
  if (value == null) return WsMessageType.text;
  final str = value.toString().toLowerCase();
  return WsMessageType.values.firstWhere(
    (e) => e.name == str,
    orElse: () => WsMessageType.text,
  );
}

String wsMessageTypeToJson(WsMessageType value) => value.name;

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

  /// Serialize to a JSON map for Socket.IO emit.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversationId': conversationId,
      'receiverId': receiverId,
      'content': content,
      if (messageType != null) 'messageType': wsMessageTypeToJson(messageType!),
      if (clientMessageId != null) 'clientMessageId': clientMessageId,
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

  /// Serialize to a JSON map for Socket.IO emit.
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

  /// Serialize to a JSON map for Socket.IO emit.
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

  /// Serialize to a JSON map for Socket.IO emit.
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
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
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
      readAt: DateTime.parse(json['readAt'] as String),
    );
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

  @override
  String toString() {
    return 'WsErrorEvent(message: $message)';
  }
}

