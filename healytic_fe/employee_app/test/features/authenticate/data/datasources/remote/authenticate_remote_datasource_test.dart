import 'package:employee_app/features/authenticate/data/datasources/remote/authenticate_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() {
  test('mock employee login returns a valid employee JWT', () async {
    final datasource = AuthenticateRemoteDatasourceMock();

    final result = await datasource.login(
      email: 'employee.coordinator@healytics.vn',
      password: 'employee@123',
    );

    final claims = JwtDecoder.decode(result.accessToken);
    expect(claims['email'], 'employee.coordinator@healytics.vn');
    expect(claims['role'], 'employee');
    expect(JwtDecoder.isExpired(result.accessToken), isFalse);
  });
}
