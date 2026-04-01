// =============================================================
// AUTO-GENERATED from ws-contract.json — DO NOT EDIT BY HAND.
//
// Re-generate with:
//   ./bin/generate-open-api.sh ws
// =============================================================

// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'ws_events.dart';
import 'ws_models.dart';

export 'ws_events.dart';
export 'ws_models.dart';

/// Suppresses verbose internal loggers from
/// `socket_io_client` (Manager, engine, parser)
/// so ping/pong, packet-encoding, and JWT dumps
/// never flood the console.
bool _socketIoLoggersSilenced = false;
void _silenceSocketIoLoggers() {
  if (_socketIoLoggersSilenced) return;
  _socketIoLoggersSilenced = true;
  hierarchicalLoggingEnabled = true;
  for (final name in [
    'socket_io_client:Manager',
    'socket_io_client:engine.Socket',
    'socket_io:parser.Encoder',
    'socket_io:parser.Decoder',
  ]) {
    Logger(name).level = Level.WARNING;
  }
}

/// Server config for a WebSocket namespace.
///
/// [url]  — base server URL
///          (e.g. `https://healytics.me`)
/// [path] — Socket.IO transport path
///          (e.g. `/user-chat/socket.io/`)
typedef WsServerConfig = ({String url, String path});

/// WebSocket connection lifecycle states.
enum WsConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Common interface for all generated namespace
/// socket clients.
///
/// Allows [WsService] to manage sockets without
/// `dynamic` or per-type branching.
abstract interface class WsNamespaceSocket {
  /// Current connection status.
  WsConnectionStatus get status;

  /// Stream of connection state changes.
  Stream<WsConnectionStatus> get onConnectionChange;

  /// Connect to the WebSocket server.
  ///
  /// [server] provides the URL and Socket.IO
  /// transport path.
  /// [token] is the JWT access token.
  void connect({
    required WsServerConfig server,
    required String token,
  });

  /// Disconnect from the WebSocket server.
  void disconnect();

  /// Clean up all resources permanently.
  void dispose();
}

/// Typed Socket.IO client for the `/partner-chat` namespace.
///
/// Health Partner WebSocket gateway
///
/// **Auth:** JWT — roles: health_partner, employee
///
/// Usage:
/// ```dart
/// final socket = PartnerChatSocket();
/// socket.connect(
///   server: (url: gateway, path: '/partner-chat/socket.io/'),
///   token: token,
/// );
/// socket.onNewMessage.listen((msg) => print(msg));
/// socket.sendMessage(WsSendMessagePayload(...));
/// ```
class PartnerChatSocket implements WsNamespaceSocket {
  static final _log = Logger('PartnerChatSocket');

  io.Socket? _socket;

  final _newMessageController =
      StreamController<WsNewMessageEvent>.broadcast();
  final _messageSentController =
      StreamController<WsMessageSentAck>.broadcast();
  final _messagesReadController =
      StreamController<WsMessagesReadEvent>.broadcast();
  final _typingController =
      StreamController<WsTypingEvent>.broadcast();
  final _stopTypingController =
      StreamController<WsStopTypingEvent>.broadcast();
  final _errorController =
      StreamController<WsErrorEvent>.broadcast();
  final _connectionController =
      StreamController<WsConnectionStatus>.broadcast();

  /// A new message was sent in a conversation the user has joined
  Stream<WsNewMessageEvent> get onNewMessage =>
      _newMessageController.stream;

  /// Acknowledgement that the server persisted the user's message
  Stream<WsMessageSentAck> get onMessageSent =>
      _messageSentController.stream;

  /// The other party read messages in a conversation
  Stream<WsMessagesReadEvent> get onMessagesRead =>
      _messagesReadController.stream;

  /// The other party is typing in a conversation
  Stream<WsTypingEvent> get onTyping =>
      _typingController.stream;

  /// The other party stopped typing
  Stream<WsStopTypingEvent> get onStopTyping =>
      _stopTypingController.stream;

  /// A server error occurred while processing a WS event
  Stream<WsErrorEvent> get onError =>
      _errorController.stream;

  /// Stream of connection state changes.
  @override
  Stream<WsConnectionStatus> get onConnectionChange =>
      _connectionController.stream;

  /// Current connection status.
  WsConnectionStatus _status = WsConnectionStatus.disconnected;
  @override
  WsConnectionStatus get status => _status;

  /// Connect to the `/partner-chat` WebSocket namespace.
  ///
  /// [server] provides the base URL and Socket.IO
  /// transport path.
  /// [token] is the JWT access token.
  @override
  void connect({
    required WsServerConfig server,
    required String token,
  }) {
    _silenceSocketIoLoggers();

    if (_socket != null) {
      _log.info('Already connected, disconnecting first');
      disconnect();
    }

    _updateStatus(WsConnectionStatus.connecting);

    _socket = io.io(
      server.url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setPath(server.path)
          .setAuth({'token': token})
          .build(),
    );

    _socket!.onConnect((_) {
      _log.info('Connected to /partner-chat');
      _updateStatus(WsConnectionStatus.connected);
    });

    _socket!.onDisconnect((_) {
      _log.info('Disconnected from /partner-chat');
      _updateStatus(WsConnectionStatus.disconnected);
    });

    _socket!.on('reconnecting', (_) {
      _log.info('Reconnecting to /partner-chat');
      _updateStatus(WsConnectionStatus.reconnecting);
    });

    _socket!.onConnectError((err) {
      _log.severe('Connection error: $err');
      _updateStatus(WsConnectionStatus.error);
    });

    _socket!.onError((err) {
      _log.severe('Socket error: $err');
    });

    // ── Server → Client event listeners ─────────────

    _socket!.on(WsChatEvent.newMessage, (data) {
      try {
        final map = data as Map<String, dynamic>;
        _newMessageController.add(WsNewMessageEvent.fromJson(map));
      } catch (e, st) {
        _log.severe('Error parsing new_message', e, st);
      }
    });

    _socket!.on(WsChatEvent.messageSent, (data) {
      try {
        final map = data as Map<String, dynamic>;
        _messageSentController.add(WsMessageSentAck.fromJson(map));
      } catch (e, st) {
        _log.severe('Error parsing message_sent', e, st);
      }
    });

    _socket!.on(WsChatEvent.messagesRead, (data) {
      try {
        final map = data as Map<String, dynamic>;
        _messagesReadController.add(WsMessagesReadEvent.fromJson(map));
      } catch (e, st) {
        _log.severe('Error parsing messages_read', e, st);
      }
    });

    _socket!.on(WsChatEvent.typing, (data) {
      try {
        final map = data as Map<String, dynamic>;
        _typingController.add(WsTypingEvent.fromJson(map));
      } catch (e, st) {
        _log.severe('Error parsing typing', e, st);
      }
    });

    _socket!.on(WsChatEvent.stopTyping, (data) {
      try {
        final map = data as Map<String, dynamic>;
        _stopTypingController.add(WsStopTypingEvent.fromJson(map));
      } catch (e, st) {
        _log.severe('Error parsing stop_typing', e, st);
      }
    });

    _socket!.on(WsChatEvent.error, (data) {
      try {
        final map = data as Map<String, dynamic>;
        _errorController.add(WsErrorEvent.fromJson(map));
      } catch (e, st) {
        _log.severe('Error parsing error', e, st);
      }
    });

    _socket!.connect();
  }

  // ── Client → Server emitters ──────────────────────

  /// Send a chat message
  void sendMessage(
    WsSendMessagePayload payload, {
    void Function(WsMessageSentAck)? onAck,
  }) {
    _socket?.emitWithAck(
      WsChatEvent.sendMessage,
      payload.toJson(),
      ack: (response) {
        if (onAck != null && response is Map) {
          onAck(WsMessageSentAck.fromJson(
            Map<String, dynamic>.from(response),
          ));
        }
      },
    );
  }

  /// Notify the other party that the user is typing
  void typing(WsTypingPayload payload) {
    _socket?.emit(WsChatEvent.typing, payload.toJson());
  }

  /// Notify the other party that the user stopped typing
  void stopTyping(WsTypingPayload payload) {
    _socket?.emit(WsChatEvent.stopTyping, payload.toJson());
  }

  /// Mark all messages in a conversation as read
  void markRead(WsMarkReadPayload payload) {
    _socket?.emit(WsChatEvent.markRead, payload.toJson());
  }

  /// Join a conversation room (auto-joined on connect; use for new conversations)
  void joinConversation(String conversationId) {
    _socket?.emit(WsChatEvent.joinConversation, {
      'conversationId': conversationId,
    });
  }

  /// Disconnect from the WebSocket server.
  @override
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _updateStatus(WsConnectionStatus.disconnected);
  }

  /// Clean up all resources. Call when the service
  /// is permanently disposed.
  @override
  void dispose() {
    disconnect();
    _newMessageController.close();
    _messageSentController.close();
    _messagesReadController.close();
    _typingController.close();
    _stopTypingController.close();
    _errorController.close();
    _connectionController.close();
  }

  void _updateStatus(WsConnectionStatus newStatus) {
    _status = newStatus;
    _connectionController.add(newStatus);
  }
}

