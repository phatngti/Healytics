import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/config/app_environment.dart';
import '../../../../../core/providers/api.provider.dart';
import '../../../../../core/services/api.service.dart';
import '../../../domain/entities/authenticate.entity.dart';
import 'package:employee_openapi/api.dart';

part 'authenticate_remote_datasource.g.dart';

final _log = Logger('AuthenticateRemoteDatasource');

/// Contract for auth data operations.
abstract class AuthenticateRemoteDatasource {
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  });
}

/// Real implementation using OpenAPI client.
class AuthenticateRemoteDatasourceImpl implements AuthenticateRemoteDatasource {
  final ApiService apiService;

  AuthenticateRemoteDatasourceImpl({required this.apiService});

  @override
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  }) async {
    final response = await apiService.authenticateApi.authControllerLoginAdmin(
      AdminLoginDto(email: email, password: password),
    );

    if (response == null) {
      throw ApiException(HttpStatus.notFound, 'Login response is null');
    }

    final decodedToken = JwtDecoder.decode(response.accessToken);
    final role = decodedToken['role'];
    if (role != 'employee') {
      throw ApiException(
        HttpStatus.forbidden,
        'Only employee accounts can sign in to the employee app.',
      );
    }

    final tokenEmail = decodedToken['email'];
    var basicInfo = BasicInfoEntity(
      email: tokenEmail is String && tokenEmail.trim().isNotEmpty
          ? tokenEmail
          : email,
    );
    _log.fine('decodedToken: $decodedToken');
    if (decodedToken['firstName'] != null && decodedToken['lastName'] != null) {
      basicInfo = basicInfo.copyWith(
        name:
            '${decodedToken['firstName']} '
            '${decodedToken['lastName']}',
      );
    }

    return AuthenticateEntity.fromJson({
      'accessToken': response.accessToken,
      'refreshToken': response.refreshToken,
      'basicInfo': basicInfo.toJson(),
    });
  }
}

/// Mock implementation for development.
class AuthenticateRemoteDatasourceMock implements AuthenticateRemoteDatasource {
  @override
  Future<AuthenticateEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final accessToken = _mockJwt(
      subject: 'mock-employee-account',
      email: email,
      validFor: const Duration(hours: 1),
    );
    final refreshToken = _mockJwt(
      subject: 'mock-employee-account',
      email: email,
      validFor: const Duration(days: 7),
    );

    return AuthenticateEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      basicInfo: BasicInfoEntity(email: email, name: 'John Employee'),
    );
  }

  String _mockJwt({
    required String subject,
    required String email,
    required Duration validFor,
  }) {
    final now = DateTime.now();
    final payload = <String, dynamic>{
      'sub': subject,
      'email': email,
      'role': 'employee',
      'firstName': 'John',
      'lastName': 'Employee',
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': now.add(validFor).millisecondsSinceEpoch ~/ 1000,
    };

    String encode(Map<String, dynamic> value) {
      return base64Url
          .encode(utf8.encode(jsonEncode(value)))
          .replaceAll('=', '');
    }

    return '${encode({'alg': 'none', 'typ': 'JWT'})}.${encode(payload)}.';
  }
}

@Riverpod(keepAlive: true)
AuthenticateRemoteDatasource authenticateRemoteDatasource(Ref ref) {
  if (AppEnvironment.current.useMock) {
    return AuthenticateRemoteDatasourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return AuthenticateRemoteDatasourceImpl(apiService: apiService);
}
