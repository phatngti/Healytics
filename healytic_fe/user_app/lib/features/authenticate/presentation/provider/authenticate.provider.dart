import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/utils/error_message_code.dart';
import 'package:user_app/features/authenticate/datasource/repository_implement.dart';
import 'package:user_app/features/authenticate/domain/authenticate.entity.dart';
import 'package:user_openapi/api.dart';

part 'authenticate.provider.freezed.dart';
part 'authenticate.provider.g.dart';

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
      state = AsyncData(AuthenticateStateData(authenticate: authenticate));
    } on ApiException catch (e) {
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
