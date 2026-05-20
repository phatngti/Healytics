import 'package:logging/logging.dart';

import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/core/services/ws/ws_client.dart';

/// Normalizes the gateway URL before passing it to `socket_io_client`.
///
/// The package treats a missing explicit port as `0` in parts of its URI
/// handling. Supplying the scheme default avoids noisy `:0/socket.io` websocket
/// errors while the transport still omits default ports on the wire.
String normalizeSocketIoGatewayUrl(String gatewayUrl) {
  final trimmed = gatewayUrl.trim();
  if (trimmed.isEmpty) return '';

  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    return trimmed.replaceFirst(RegExp(r'/+$'), '');
  }

  final defaultPort = switch (uri.scheme) {
    'https' || 'wss' => 443,
    'http' || 'ws' => 80,
    _ => null,
  };
  final port = uri.hasPort ? uri.port : defaultPort;
  final path = uri.path.replaceFirst(RegExp(r'/+$'), '');
  final host = uri.host.contains(':') ? '[${uri.host}]' : uri.host;
  final userInfo = uri.userInfo.isEmpty ? '' : '${uri.userInfo}@';
  final portSegment = port == null ? '' : ':$port';

  return '${uri.scheme}://$userInfo$host$portSegment$path';
}

/// Centralised WebSocket service that wraps the
/// auto-generated Socket.IO clients in `ws/`.
///
/// Mirrors the role of [ApiService] for REST
/// (OpenAPI).  Each namespace gets a lazily-created,
/// singleton socket that is connected/disconnected
/// through this façade.
///
/// **Server config** (domain, path) is resolved here
/// via [ServicePrefix] — the generated client code
/// never hardcodes infra details.
///
/// ```dart
/// final wsService = WsService(apiService);
/// wsService.connectUserChat();
/// wsService.userChat.onNewMessage.listen(…);
/// ```
class WsService {
  WsService(this._apiService);

  final ApiService _apiService;
  static final _log = Logger('WsService');

  // ── Socket instances ─────────────────────────────

  UserChatSocket? _userChatSocket;
  BookingEventsSocket? _bookingEventsSocket;
  ChatNotificationsSocket? _chatNotificationsSocket;
  NotificationsSocket? _notificationsSocket;

  /// The `/user-chat` namespace socket.
  ///
  /// Created lazily on first access to avoid
  /// allocating resources when not needed.
  UserChatSocket get userChat => _userChatSocket ??= UserChatSocket();

  /// The `/booking-events` namespace socket.
  BookingEventsSocket get bookingEvents =>
      _bookingEventsSocket ??= BookingEventsSocket();

  /// The `/chat-notifications` namespace socket.
  ChatNotificationsSocket get chatNotifications =>
      _chatNotificationsSocket ??= ChatNotificationsSocket();

  /// The `/notifications` namespace socket.
  NotificationsSocket get notifications =>
      _notificationsSocket ??= NotificationsSocket();

  // ── Lifecycle ────────────────────────────────────

  /// Connect **all** WebSocket namespaces using the
  /// current gateway URL and access token from
  /// [ApiService].
  ///
  /// Call this after the user has authenticated.
  void connectAll() {
    _log.info('Connecting all WS namespaces');
    _connectSocket(userChat, ServicePrefix.userChat);
    _connectSocket(bookingEvents, ServicePrefix.bookingEvents);
    _connectSocket(chatNotifications, ServicePrefix.chatNotifications);
    _connectSocket(notifications, ServicePrefix.notifications);
  }

  /// Connect only the user-chat namespace.
  void connectUserChat() {
    _connectSocket(userChat, ServicePrefix.userChat);
  }

  /// Connect only the booking-events namespace.
  void connectBookingEvents() {
    _connectSocket(bookingEvents, ServicePrefix.bookingEvents);
  }

  /// Connect only the chat-notifications namespace.
  void connectChatNotifications() {
    _connectSocket(chatNotifications, ServicePrefix.chatNotifications);
  }

  /// Connect only the user notifications namespace.
  void connectNotifications() {
    _connectSocket(notifications, ServicePrefix.notifications);
  }

  /// Force reconnect the chat-notifications namespace.
  void reconnectChatNotifications() {
    chatNotifications.disconnect();
    _connectSocket(chatNotifications, ServicePrefix.chatNotifications);
  }

  /// Force reconnect the user notifications namespace.
  void reconnectNotifications() {
    notifications.disconnect();
    _connectSocket(notifications, ServicePrefix.notifications);
  }

  /// Disconnect **all** active sockets.
  void disconnectAll() {
    _log.info('Disconnecting all WS namespaces');
    _userChatSocket?.disconnect();
    _bookingEventsSocket?.disconnect();
    _chatNotificationsSocket?.disconnect();
    _notificationsSocket?.disconnect();
  }

  /// Dispose **all** sockets and release resources.
  ///
  /// Call once when the service is permanently
  /// destroyed (e.g. on logout).
  void dispose() {
    _log.info('Disposing WS service');
    _userChatSocket?.dispose();
    _bookingEventsSocket?.dispose();
    _chatNotificationsSocket?.dispose();
    _notificationsSocket?.dispose();
    _userChatSocket = null;
    _bookingEventsSocket = null;
    _chatNotificationsSocket = null;
    _notificationsSocket = null;
  }

  // ── Helpers ──────────────────────────────────────

  /// Reads the access token from the persistent
  /// [Store], matching the pattern used by
  /// [ApiService.getRequestHeaders].
  ///
  /// Falls back to [ApiService.accessToken] if the
  /// store value is empty.
  String _resolveAccessToken() {
    final storeToken = Store.tryGet(StoreKey.accessToken) ?? '';
    if (storeToken.isNotEmpty) return storeToken;
    return _apiService.accessToken ?? '';
  }

  /// Connects a [socket] using server config derived
  /// from [prefix].
  ///
  /// The namespace (e.g. `/user-chat`) is appended to
  /// the base URL — the Dart Socket.IO client parses
  /// it and negotiates the namespace in the protocol
  /// handshake. The HTTP transport path is always the
  /// standard `/socket.io/`.
  void _connectSocket(WsNamespaceSocket socket, ServicePrefix prefix) {
    if (socket.status == WsConnectionStatus.connected ||
        socket.status == WsConnectionStatus.connecting ||
        socket.status == WsConnectionStatus.reconnecting) {
      _log.fine('${prefix.path} already ${socket.status.name}');
      return;
    }

    final baseUrl = normalizeSocketIoGatewayUrl(_apiService.gatewayUrl);
    final token = _resolveAccessToken();

    if (baseUrl.isEmpty || token.isEmpty) {
      _log.warning(
        'Cannot connect WS: '
        'missing gateway URL or token',
      );
      return;
    }

    socket.connect(
      server: (url: '$baseUrl${prefix.path}', path: '/socket.io/'),
      token: token,
    );
  }
}
