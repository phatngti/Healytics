import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/ws.service.dart';

part 'ws.provider.g.dart';

/// Singleton [WsService] provider — the centralised
/// façade for all WebSocket namespaces.
///
/// Mirrors [apiServiceProvider] for REST.
/// Disposing this provider tears down every active
/// socket connection.
@Riverpod(keepAlive: true)
WsService wsService(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  final wsService = WsService(apiService);
  ref.onDispose(wsService.dispose);
  return wsService;
}
