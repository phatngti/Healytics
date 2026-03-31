import 'dart:async';

import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';

/// WebSocket connection states.
enum ChatConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Typing event data.
class TypingEvent {
  final String conversationId;
  final String userId;
  final String? userName;

  const TypingEvent({
    required this.conversationId,
    required this.userId,
    this.userName,
  });
}

/// Read-receipt event data.
class ReadEvent {
  final String conversationId;
  final String readerId;
  final DateTime readAt;

  const ReadEvent({
    required this.conversationId,
    required this.readerId,
    required this.readAt,
  });
}

/// Payload for sending a message via WebSocket.
class SendMessagePayload {
  final String conversationId;
  final String content;
  final String? clientMessageId;

  const SendMessagePayload({
    required this.conversationId,
    required this.content,
    this.clientMessageId,
  });

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'content': content,
        if (clientMessageId != null)
          'clientMessageId': clientMessageId,
      };
}

/// Acknowledgement from a sent message.
class MessageSentAck {
  final String id;
  final String? clientMessageId;

  const MessageSentAck({
    required this.id,
    this.clientMessageId,
  });
}

/// Socket.IO client for the partner-side chat.
///
/// Connects to the `/partner-chat` namespace with JWT.
class PartnerChatSocketService {
  static final _log =
      Logger('PartnerChatSocketService');

  io.Socket? _socket;

  final _messageController =
      StreamController<PartnerChatMessage>.broadcast();
  final _typingController =
      StreamController<TypingEvent>.broadcast();
  final _stopTypingController =
      StreamController<TypingEvent>.broadcast();
  final _readController =
      StreamController<ReadEvent>.broadcast();
  final _connectionController =
      StreamController<ChatConnectionStatus>.broadcast();

  Stream<PartnerChatMessage> get onNewMessage =>
      _messageController.stream;
  Stream<TypingEvent> get onTyping =>
      _typingController.stream;
  Stream<TypingEvent> get onStopTyping =>
      _stopTypingController.stream;
  Stream<ReadEvent> get onMessagesRead =>
      _readController.stream;
  Stream<ChatConnectionStatus>
      get onConnectionChange =>
          _connectionController.stream;

  ChatConnectionStatus _status =
      ChatConnectionStatus.disconnected;
  ChatConnectionStatus get status => _status;

  /// Connect to `/partner-chat` namespace.
  void connect({
    required String baseUrl,
    required String token,
  }) {
    if (_socket != null) {
      disconnect();
    }

    _updateStatus(ChatConnectionStatus.connecting);

    _socket = io.io(
      '$baseUrl/partner-chat',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket!.onConnect((_) {
      _log.info('Connected to /partner-chat');
      _updateStatus(ChatConnectionStatus.connected);
    });

    _socket!.onDisconnect((_) {
      _log.info('Disconnected from /partner-chat');
      _updateStatus(
        ChatConnectionStatus.disconnected,
      );
    });

    _socket!.on('reconnecting', (_) {
      _updateStatus(
        ChatConnectionStatus.reconnecting,
      );
    });

    _socket!.onConnectError((data) {
      _log.severe('Connection error: $data');
      _updateStatus(ChatConnectionStatus.error);
    });

    // ── Server → Client events ──────────────

    _socket!.on('new_message', (data) {
      try {
        final map = data as Map<String, dynamic>;
        _messageController.add(PartnerChatMessage(
          id: map['id'] as String,
          conversationId:
              map['conversationId'] as String,
          senderId: map['senderId'] as String,
          senderName: map['senderName'] as String?,
          senderAvatar:
              map['senderAvatar'] as String?,
          content: map['content'] as String,
          messageType:
              _parseType(map['messageType']),
          clientMessageId:
              map['clientMessageId'] as String?,
          createdAt: DateTime.parse(
            map['createdAt'] as String,
          ),
        ));
      } catch (e, st) {
        _log.severe('Parse new_message error', e, st);
      }
    });

    _socket!.on('typing', (data) {
      try {
        final map = data as Map<String, dynamic>;
        _typingController.add(TypingEvent(
          conversationId:
              map['conversationId'] as String,
          userId: map['userId'] as String,
          userName: map['userName'] as String?,
        ));
      } catch (_) {}
    });

    _socket!.on('stop_typing', (data) {
      try {
        final map = data as Map<String, dynamic>;
        _stopTypingController.add(TypingEvent(
          conversationId:
              map['conversationId'] as String,
          userId: map['userId'] as String,
        ));
      } catch (_) {}
    });

    _socket!.on('messages_read', (data) {
      try {
        final map = data as Map<String, dynamic>;
        _readController.add(ReadEvent(
          conversationId:
              map['conversationId'] as String,
          readerId: map['readerId'] as String,
          readAt: DateTime.parse(
            map['readAt'] as String,
          ),
        ));
      } catch (_) {}
    });

    _socket!.connect();
  }

  void sendMessage(
    SendMessagePayload payload, {
    void Function(MessageSentAck)? onAck,
  }) {
    _socket?.emitWithAck(
      'send_message',
      payload.toJson(),
    );
    // Handle ack via event listener instead
    _socket?.once('message_sent', (response) {
      if (response is Map) {
        final data =
            response as Map<String, dynamic>;
        onAck?.call(MessageSentAck(
          id: data['id'] as String,
          clientMessageId:
              data['clientMessageId'] as String?,
        ));
      }
    });
  }

  void sendTyping(String conversationId) {
    _socket?.emit('typing', {
      'conversationId': conversationId,
    });
  }

  void sendStopTyping(String conversationId) {
    _socket?.emit('stop_typing', {
      'conversationId': conversationId,
    });
  }

  void markRead(String conversationId) {
    _socket?.emit('mark_read', {
      'conversationId': conversationId,
    });
  }

  void joinConversation(String conversationId) {
    _socket?.emit('join_conversation', {
      'conversationId': conversationId,
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _updateStatus(ChatConnectionStatus.disconnected);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _typingController.close();
    _stopTypingController.close();
    _readController.close();
    _connectionController.close();
  }

  void _updateStatus(ChatConnectionStatus s) {
    _status = s;
    _connectionController.add(s);
  }

  PartnerMessageType _parseType(dynamic raw) {
    if (raw == null) return PartnerMessageType.text;
    return raw.toString().toLowerCase() == 'system'
        ? PartnerMessageType.system
        : PartnerMessageType.text;
  }
}
