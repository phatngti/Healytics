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

/// Type of notification in the Healytics platform
enum WsNotificationType {
  bookingConfirmed,
  bookingCancelled,
  bookingCompleted,
  appointmentReminder,
  appointmentUpdated,
  newChatMessage,
  paymentSuccess,
  paymentFailed,
  systemBroadcast,
  systemMaintenance,
  partnerVerified,
  partnerRejected,
}

WsNotificationType wsNotificationTypeFromJson(dynamic value) {
  if (value == null) return WsNotificationType.bookingConfirmed;
  final str = value.toString();
  switch (str) {
    case 'booking_confirmed':
      return WsNotificationType.bookingConfirmed;
    case 'booking_cancelled':
      return WsNotificationType.bookingCancelled;
    case 'booking_completed':
      return WsNotificationType.bookingCompleted;
    case 'appointment_reminder':
      return WsNotificationType.appointmentReminder;
    case 'appointment_updated':
      return WsNotificationType.appointmentUpdated;
    case 'new_chat_message':
      return WsNotificationType.newChatMessage;
    case 'payment_success':
      return WsNotificationType.paymentSuccess;
    case 'payment_failed':
      return WsNotificationType.paymentFailed;
    case 'system_broadcast':
      return WsNotificationType.systemBroadcast;
    case 'system_maintenance':
      return WsNotificationType.systemMaintenance;
    case 'partner_verified':
      return WsNotificationType.partnerVerified;
    case 'partner_rejected':
      return WsNotificationType.partnerRejected;
    default:
      return WsNotificationType.bookingConfirmed;
  }
}

String wsNotificationTypeToJson(WsNotificationType value) {
  switch (value) {
    case WsNotificationType.bookingConfirmed:
      return 'booking_confirmed';
    case WsNotificationType.bookingCancelled:
      return 'booking_cancelled';
    case WsNotificationType.bookingCompleted:
      return 'booking_completed';
    case WsNotificationType.appointmentReminder:
      return 'appointment_reminder';
    case WsNotificationType.appointmentUpdated:
      return 'appointment_updated';
    case WsNotificationType.newChatMessage:
      return 'new_chat_message';
    case WsNotificationType.paymentSuccess:
      return 'payment_success';
    case WsNotificationType.paymentFailed:
      return 'payment_failed';
    case WsNotificationType.systemBroadcast:
      return 'system_broadcast';
    case WsNotificationType.systemMaintenance:
      return 'system_maintenance';
    case WsNotificationType.partnerVerified:
      return 'partner_verified';
    case WsNotificationType.partnerRejected:
      return 'partner_rejected';
  }
}

/// Public booking status emitted to realtime clients
enum PublicBookingStatus {
  processing,
  completed,
}

PublicBookingStatus publicBookingStatusFromJson(dynamic value) {
  if (value == null) return PublicBookingStatus.processing;
  final str = value.toString();
  switch (str) {
    case 'PROCESSING':
      return PublicBookingStatus.processing;
    case 'COMPLETED':
      return PublicBookingStatus.completed;
    default:
      return PublicBookingStatus.processing;
  }
}

String publicBookingStatusToJson(PublicBookingStatus value) {
  switch (value) {
    case PublicBookingStatus.processing:
      return 'PROCESSING';
    case PublicBookingStatus.completed:
      return 'COMPLETED';
  }
}

/// Persisted booking lifecycle status
enum BookingStatus {
  pendingPayment,
  confirmed,
  inProgress,
  cancelled,
  completed,
  noShow,
}

BookingStatus bookingStatusFromJson(dynamic value) {
  if (value == null) return BookingStatus.pendingPayment;
  final str = value.toString();
  switch (str) {
    case 'PENDING_PAYMENT':
      return BookingStatus.pendingPayment;
    case 'CONFIRMED':
      return BookingStatus.confirmed;
    case 'IN_PROGRESS':
      return BookingStatus.inProgress;
    case 'CANCELLED':
      return BookingStatus.cancelled;
    case 'COMPLETED':
      return BookingStatus.completed;
    case 'NO_SHOW':
      return BookingStatus.noShow;
    default:
      return BookingStatus.pendingPayment;
  }
}

String bookingStatusToJson(BookingStatus value) {
  switch (value) {
    case BookingStatus.pendingPayment:
      return 'PENDING_PAYMENT';
    case BookingStatus.confirmed:
      return 'CONFIRMED';
    case BookingStatus.inProgress:
      return 'IN_PROGRESS';
    case BookingStatus.cancelled:
      return 'CANCELLED';
    case BookingStatus.completed:
      return 'COMPLETED';
    case BookingStatus.noShow:
      return 'NO_SHOW';
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

/// Server event emitted when a booking status changes through the lifecycle API
class BookingStatusChangeEvent {
  /// 
  final String eventId;

  /// 
  final String bookingId;

  /// 
  final PublicBookingStatus status;

  /// 
  final BookingStatus persistedStatus;

  /// 
  final BookingStatus previousStatus;

  /// 
  final String userId;

  /// 
  final String? partnerId;

  /// 
  final String specialistId;

  /// 
  final BookingStatusChangedBy changedBy;

  /// 
  final String occurredAt;

  const BookingStatusChangeEvent({
    required this.eventId,
    required this.bookingId,
    required this.status,
    required this.persistedStatus,
    required this.previousStatus,
    required this.userId,
    this.partnerId,
    required this.specialistId,
    required this.changedBy,
    required this.occurredAt,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory BookingStatusChangeEvent.fromJson(Map<String, dynamic> json) {
    return BookingStatusChangeEvent(
      eventId: json['eventId'] as String,
      bookingId: json['bookingId'] as String,
      status: publicBookingStatusFromJson(json['status']),
      persistedStatus: bookingStatusFromJson(json['persistedStatus']),
      previousStatus: bookingStatusFromJson(json['previousStatus']),
      userId: json['userId'] as String,
      partnerId: json['partnerId'] as String?,
      specialistId: json['specialistId'] as String,
      changedBy: BookingStatusChangedBy.fromJson(_requireJsonMap(json['changedBy'], 'BookingStatusChangeEvent.changedBy')),
      occurredAt: json['occurredAt'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'eventId': eventId,
      'bookingId': bookingId,
      'status': publicBookingStatusToJson(status),
      'persistedStatus': bookingStatusToJson(persistedStatus),
      'previousStatus': bookingStatusToJson(previousStatus),
      'userId': userId,
      if (partnerId != null) 'partnerId': partnerId!,
      'specialistId': specialistId,
      'changedBy': changedBy.toJson(),
      'occurredAt': occurredAt,
    };
  }

  @override
  String toString() {
    return 'BookingStatusChangeEvent(eventId: $eventId, bookingId: $bookingId, status: $status, persistedStatus: $persistedStatus, previousStatus: $previousStatus, userId: $userId, partnerId: $partnerId, specialistId: $specialistId, changedBy: $changedBy, occurredAt: $occurredAt)';
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

/// Server event: a new notification pushed to the user in real-time
class WsNewNotificationEvent {
  /// Notification UUID
  final String id;

  /// The type of notification
  final WsNotificationType type;

  /// Notification title
  final String title;

  /// Notification body text
  final String body;

  /// Deep-link data for frontend routing
  final Map<String, dynamic>? data;

  /// Whether the notification has been read
  final bool isRead;

  /// When the notification was read
  final DateTime? readAt;

  /// Whether this is a system-wide broadcast
  final bool isBroadcast;

  /// When the notification was created
  final DateTime createdAt;

  const WsNewNotificationEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    this.readAt,
    required this.isBroadcast,
    required this.createdAt,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsNewNotificationEvent.fromJson(Map<String, dynamic> json) {
    return WsNewNotificationEvent(
      id: json['id'] as String,
      type: wsNotificationTypeFromJson(json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      data: _jsonMapOrNull(json['data'], 'WsNewNotificationEvent.data'),
      isRead: json['isRead'] as bool,
      readAt: _dateTimeOrNull(json['readAt'], 'WsNewNotificationEvent.readAt'),
      isBroadcast: json['isBroadcast'] as bool,
      createdAt: _requireDateTime(json['createdAt'], 'WsNewNotificationEvent.createdAt'),
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': wsNotificationTypeToJson(type),
      'title': title,
      'body': body,
      if (data != null) 'data': data!,
      'isRead': isRead,
      if (readAt != null) 'readAt': readAt!.toUtc().toIso8601String(),
      'isBroadcast': isBroadcast,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WsNewNotificationEvent(id: $id, type: $type, title: $title, body: $body, data: $data, isRead: $isRead, readAt: $readAt, isBroadcast: $isBroadcast, createdAt: $createdAt)';
  }
}

/// Server event: updated unread notification count for the user
class WsUnreadCountEvent {
  /// Current unread notification count
  final num count;

  const WsUnreadCountEvent({
    required this.count,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsUnreadCountEvent.fromJson(Map<String, dynamic> json) {
    return WsUnreadCountEvent(
      count: json['count'] as num,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'count': count,
    };
  }

  @override
  String toString() {
    return 'WsUnreadCountEvent(count: $count)';
  }
}

/// Server event: a system-wide broadcast was sent (admin-facing)
class WsBroadcastSentEvent {
  /// Notification UUID
  final String id;

  /// Notification title
  final String title;

  /// Notification body text
  final String body;

  /// When the broadcast was created
  final DateTime createdAt;

  const WsBroadcastSentEvent({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory WsBroadcastSentEvent.fromJson(Map<String, dynamic> json) {
    return WsBroadcastSentEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: _requireDateTime(json['createdAt'], 'WsBroadcastSentEvent.createdAt'),
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WsBroadcastSentEvent(id: $id, title: $title, body: $body, createdAt: $createdAt)';
  }
}

/// Actor that changed a booking status
class BookingStatusChangedBy {
  /// 
  final String accountId;

  /// 
  final String role;

  const BookingStatusChangedBy({
    required this.accountId,
    required this.role,
  });

  /// Deserialize from a Socket.IO JSON map.
  factory BookingStatusChangedBy.fromJson(Map<String, dynamic> json) {
    return BookingStatusChangedBy(
      accountId: json['accountId'] as String,
      role: json['role'] as String,
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accountId': accountId,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'BookingStatusChangedBy(accountId: $accountId, role: $role)';
  }
}

