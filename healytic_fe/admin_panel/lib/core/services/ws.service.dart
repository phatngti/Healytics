import 'package:logging/logging.dart';

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/core/services/ws/ws_client.dart';

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
/// wsService.connectPartnerChat();
/// wsService.partnerChat.onNewMessage.listen(…);
/// ```
class WsService {
  WsService(this._apiService);

  final ApiService _apiService;
  static final _log = Logger('WsService');

  // ── Socket instances ─────────────────────────────

  PartnerChatSocket? _partnerChatSocket;

  /// The `/partner-chat` namespace socket.
  ///
  /// Created lazily on first access to avoid
  /// allocating resources when not needed.
  PartnerChatSocket get partnerChat =>
      _partnerChatSocket ??= PartnerChatSocket();

  // ── Lifecycle ────────────────────────────────────

  /// Connect **all** WebSocket namespaces using the
  /// current gateway URL and access token from
  /// [ApiService].
  ///
  /// Call this after the user has authenticated.
  void connectAll() {
    _log.info('Connecting all WS namespaces');
    _connectSocket(
      partnerChat,
      ServicePrefix.partnerChat,
    );
  }

  /// Connect only the partner-chat namespace.
  void connectPartnerChat() {
    _connectSocket(
      partnerChat,
      ServicePrefix.partnerChat,
    );
  }

  /// Disconnect **all** active sockets.
  void disconnectAll() {
    _log.info('Disconnecting all WS namespaces');
    _partnerChatSocket?.disconnect();
  }

  /// Dispose **all** sockets and release resources.
  ///
  /// Call once when the service is permanently
  /// destroyed (e.g. on logout).
  void dispose() {
    _log.info('Disposing WS service');
    _partnerChatSocket?.dispose();
    _partnerChatSocket = null;
  }

  // ── Helpers ──────────────────────────────────────

  /// Reads the access token from the persistent
  /// [Store], matching the pattern used by
  /// [ApiService.getRequestHeaders].
  ///
  /// Falls back to [ApiService.accessToken] if the
  /// store value is empty.
  String _resolveAccessToken() {
    final storeToken =
        Store.tryGet(StoreKey.accessToken) ?? '';
    if (storeToken.isNotEmpty) return storeToken;
    return _apiService.accessToken ?? '';
  }

  /// Connects a [socket] using server config derived
  /// from [prefix].
  ///
  /// The namespace (e.g. `/partner-chat`) is appended
  /// to the base URL — the Dart Socket.IO client
  /// parses it and negotiates the namespace in the
  /// protocol handshake. The HTTP transport path is
  /// always the standard `/socket.io/`.
  void _connectSocket(
    WsNamespaceSocket socket,
    ServicePrefix prefix,
  ) {
    if (socket.status == WsConnectionStatus.connected ||
        socket.status == WsConnectionStatus.connecting ||
        socket.status == WsConnectionStatus.reconnecting) {
      _log.fine(
        '${prefix.path} already active '
        '(status: ${socket.status.name})',
      );
      return;
    }

    final baseUrl = _apiService.gatewayUrl;
    final token = _resolveAccessToken();

    if (baseUrl.isEmpty || token.isEmpty) {
      _log.warning(
        'Cannot connect WS: '
        'missing gateway URL or token',
      );
      return;
    }

    socket.connect(
      server: (
        url: '$baseUrl${prefix.path}',
        path: '/socket.io/',
      ),
      token: token,
    );
  }
}
