import 'dart:async';


import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';

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

/// Acknowledgement data from a sent message.
class MessageSentAck {
  final String id;
  final String? clientMessageId;

  const MessageSentAck({
    required this.id,
    this.clientMessageId,
  });
}

/// Centralized Socket.IO client for the user-side chat.
///
/// Connects to the `/user-chat` namespace on the backend
/// with JWT authentication. Provides event streams for
/// the presentation layer to react to.
class PartnerChatSocketService {
  static final _log = Logger('PartnerChatSocketService');

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

  /// Stream of incoming messages from the partner.
  Stream<PartnerChatMessage> get onNewMessage =>
      _messageController.stream;

  /// Stream of typing indicators.
  Stream<TypingEvent> get onTyping =>
      _typingController.stream;

  /// Stream of stop-typing indicators.
  Stream<TypingEvent> get onStopTyping =>
      _stopTypingController.stream;

  /// Stream of read-receipt events.
  Stream<ReadEvent> get onMessagesRead =>
      _readController.stream;

  /// Stream of connection state changes.
  Stream<ChatConnectionStatus> get onConnectionChange =>
      _connectionController.stream;

  /// Current connection status.
  ChatConnectionStatus _status =
      ChatConnectionStatus.disconnected;
  ChatConnectionStatus get status => _status;

  /// Connect to the `/user-chat` WebSocket namespace.
  ///
  /// [baseUrl] should be the backend URL without path
  /// (e.g. `http://localhost:8080`).
  /// [token] is the JWT access token for auth.
  void connect({
    required String baseUrl,
    required String token,
  }) {
    if (_socket != null) {
      _log.info('Already connected, disconnecting first');
      disconnect();
    }

    _updateStatus(ChatConnectionStatus.connecting);

    _socket = io.io(
      '$baseUrl/user-chat',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket!.onConnect((_) {
      _log.info('Connected to /user-chat');
      _updateStatus(ChatConnectionStatus.connected);
    });

    _socket!.onDisconnect((_) {
      _log.info('Disconnected from /user-chat');
      _updateStatus(ChatConnectionStatus.disconnected);
    });

    _socket!.on('reconnecting', (_) {
      _log.info('Reconnecting to /user-chat');
      _updateStatus(ChatConnectionStatus.reconnecting);
    });

    _socket!.onConnectError((data) {
      _log.severe('Connection error: $data');
      _updateStatus(ChatConnectionStatus.error);
    });

    _socket!.onError((data) {
      _log.severe('Socket error: $data');
    });

    // ── Server → Client events ──────────────────────

    _socket!.on('new_message', (data) {
      try {
        final map = data as Map<String, dynamic>;
        final message = PartnerChatMessage(
          id: map['id'] as String,
          conversationId:
              map['conversationId'] as String,
          senderId: map['senderId'] as String,
          senderName: map['senderName'] as String?,
          senderAvatar:
              map['senderAvatar'] as String?,
          content: map['content'] as String,
          messageType:
              _parseMessageType(map['messageType']),
          clientMessageId:
              map['clientMessageId'] as String?,
          createdAt: DateTime.parse(
            map['createdAt'] as String,
          ),
        );
        _messageController.add(message);
      } catch (e, st) {
        _log.severe(
          'Error parsing new_message',
          e,
          st,
        );
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
      } catch (e) {
        _log.warning('Error parsing typing event: $e');
      }
    });

    _socket!.on('stop_typing', (data) {
      try {
        final map = data as Map<String, dynamic>;
        _stopTypingController.add(TypingEvent(
          conversationId:
              map['conversationId'] as String,
          userId: map['userId'] as String,
        ));
      } catch (e) {
        _log.warning(
          'Error parsing stop_typing event: $e',
        );
      }
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
      } catch (e) {
        _log.warning(
          'Error parsing messages_read event: $e',
        );
      }
    });

    _socket!.connect();
  }

  /// Send a message via WebSocket.
  ///
  /// Returns the server acknowledgement with the
  /// permanent message ID.
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

  /// Notify the partner that the user is typing.
  void sendTyping(String conversationId) {
    _socket?.emit('typing', {
      'conversationId': conversationId,
    });
  }

  /// Notify the partner that the user stopped typing.
  void sendStopTyping(String conversationId) {
    _socket?.emit('stop_typing', {
      'conversationId': conversationId,
    });
  }

  /// Mark messages in a conversation as read.
  void markRead(String conversationId) {
    _socket?.emit('mark_read', {
      'conversationId': conversationId,
    });
  }

  /// Join a new conversation room (for newly created
  /// conversations).
  void joinConversation(String conversationId) {
    _socket?.emit('join_conversation', {
      'conversationId': conversationId,
    });
  }

  /// Disconnect from the WebSocket server.
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _updateStatus(ChatConnectionStatus.disconnected);
  }

  /// Clean up all resources.
  void dispose() {
    disconnect();
    _messageController.close();
    _typingController.close();
    _stopTypingController.close();
    _readController.close();
    _connectionController.close();
  }

  void _updateStatus(ChatConnectionStatus newStatus) {
    _status = newStatus;
    _connectionController.add(newStatus);
  }

  PartnerMessageType _parseMessageType(dynamic raw) {
    if (raw == null) return PartnerMessageType.text;
    final str = raw.toString().toLowerCase();
    return switch (str) {
      'system' => PartnerMessageType.system,
      _ => PartnerMessageType.text,
    };
  }
}
