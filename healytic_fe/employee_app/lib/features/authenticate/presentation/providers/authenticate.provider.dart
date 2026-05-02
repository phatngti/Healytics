import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/entities/store.entity.dart';
import '../../../../core/models/store.model.dart';
import '../../../../core/utils/error_message_code.dart';
import '../../data/repositories/authenticate_repository_impl.dart';
import '../../domain/entities/authenticate.entity.dart';
import 'package:user_openapi/api.dart';

part 'authenticate.provider.freezed.dart';
part 'authenticate.provider.g.dart';

final _log = Logger('AuthenticateNotifier');

@Freezed(toJson: true)
abstract class AuthenticateStateData with _$AuthenticateStateData {
  const factory AuthenticateStateData({AuthenticateEntity? authenticate}) =
      _AuthenticateStateData;

  factory AuthenticateStateData.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateStateDataFromJson(json);
}

@Riverpod(keepAlive: true)
class AuthenticateNotifier extends _$AuthenticateNotifier {
  @override
  Future<AuthenticateStateData> build() async {
    return const AuthenticateStateData();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = const AsyncLoading();
      final authenticate = await ref
          .read(authenticateRepositoryProvider)
          .login(email: email, password: password);

      await Store.put(StoreKey.accessToken, authenticate.accessToken);
      await Store.put(StoreKey.refreshToken, authenticate.refreshToken);

      state = AsyncData(AuthenticateStateData(authenticate: authenticate));
    } on ApiException catch (e) {
      _log.warning('Login failed: ${e.code}');
      state = AsyncError<AuthenticateStateData>(
        errorMessageCode(e.code),
        e.stackTrace ?? StackTrace.current,
      );
      rethrow;
    } catch (e, stack) {
      state = AsyncError<AuthenticateStateData>(e, stack);
      rethrow;
    }
  }
}
