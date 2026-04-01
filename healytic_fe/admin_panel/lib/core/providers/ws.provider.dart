import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/ws.service.dart';

part 'ws.provider.g.dart';

/// Singleton [WsService] provider.
///
/// Wired to [apiServiceProvider] so it can resolve
/// gateway URL and access token automatically.
@Riverpod(keepAlive: true)
WsService wsService(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  final ws = WsService(apiService);
  ref.onDispose(ws.dispose);
  return ws;
}
