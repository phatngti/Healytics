import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/core/services/auth_http_client.dart';

part 'api.provider.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(Ref ref) {
  final authSession = ref.read(authSessionStoreProvider);
  final httpClient = AuthHttpClient(
    authSessionStore: authSession,
    backendBasePath: '',
  );
  return ApiService(httpClient: httpClient);
}
