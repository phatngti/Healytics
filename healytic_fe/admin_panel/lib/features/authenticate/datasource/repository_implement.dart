import 'package:admin_panel/features/authenticate/datasource/remote_datasource.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_implement.g.dart';

/// Implementation of [AuthenticateRepository] that delegates to the
/// remote datasource.
class AuthenticateRepositoryImplement implements AuthenticateRepository {
  final AuthenticateRemoteDatasource _remoteDatasource;

  AuthenticateRepositoryImplement({
    required AuthenticateRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<SignInResponseEntity> login(
    SignInRequestEntity request,
    String role,
  ) async {
    return _remoteDatasource.login(request, role);
  }

  @override
  Future<SendOtpResponseEntity> sendOtp(String email) async {
    return _remoteDatasource.sendOtp(email);
  }

  @override
  Future<VerifyOtpResponseEntity> verifyOtp(
    String emailToken,
    String otp,
  ) async {
    return _remoteDatasource.verifyOtp(emailToken, otp);
  }

  @override
  Future<RegisterPartnerResponseEntity> registerPartner(
    RegisterPartnerRequestEntity request,
  ) async {
    return _remoteDatasource.registerPartner(request);
  }
}

@Riverpod(keepAlive: true)
AuthenticateRepository authenticateRepository(Ref ref) {
  final remoteDatasource = ref.watch(authenticateRemoteDatasourceProvider);
  return AuthenticateRepositoryImplement(remoteDatasource: remoteDatasource);
}
