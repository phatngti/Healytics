import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_session.provider.dart';
import '../services/api.service.dart';
import '../services/auth_http_client.dart';

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
