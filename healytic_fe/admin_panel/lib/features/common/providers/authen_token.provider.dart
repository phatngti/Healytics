import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authen_token.provider.freezed.dart';
part 'authen_token.provider.g.dart';

@Freezed(toJson: true)
abstract class AuthenTokenEntity with _$AuthenTokenEntity {
  const factory AuthenTokenEntity({
    required String accessToken,
    required String refreshToken,
  }) = _AuthenTokenEntity;

  factory AuthenTokenEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthenTokenEntityFromJson(json);
}

@Riverpod(keepAlive: true)
class AuthenToken extends _$AuthenToken {
  @override
  FutureOr<AuthenTokenEntity?> build() async {
    final accessToken = Store.tryGet(StoreKey.accessToken);
    final refreshToken = Store.tryGet(StoreKey.refreshToken);
    if (accessToken != null && refreshToken != null) {
      return AuthenTokenEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
    return null;
  }

  Future<void> saveToken(AuthenTokenEntity token) async {
    state = AsyncValue.data(token);
  }

  Future<void> removeToken() async {
    state = AsyncValue.data(null);
  }

  Future<AuthenTokenEntity?> getToken() async {
    return state.value;
  }
}
