import 'dart:developer' as developer;
import 'dart:io';

import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_datasource.g.dart';

// ============================================================================
// 1. ABSTRACT INTERFACE
// ============================================================================

/// Abstract interface for authentication remote data operations.
///
/// Defines the contract for login and signup operations.
abstract class AuthenticateRemoteDatasource {
  /// Authenticates a user with email and password.
  Future<SignInResponseEntity> login(SignInRequestEntity request, String role);

  /// Sends OTP to the specified email address.
  ///
  /// Note: Backend doesn't have this endpoint yet, so implementation throws
  /// [UnsupportedError] and mock returns fake data.
  Future<SendOtpResponseEntity> sendOtp(String email);

  /// Verifies the OTP entered by the user.
  ///
  /// Note: Backend doesn't have this endpoint yet, so implementation throws
  /// [UnsupportedError] and mock returns fake data.
  Future<VerifyOtpResponseEntity> verifyOtp(String emailToken, String otp);

  /// Registers a new business partner.
  Future<RegisterPartnerResponseEntity> registerPartner(
    RegisterPartnerRequestEntity request,
  );
}

// ============================================================================
// 2. IMPLEMENTATION (Real API)
// ============================================================================

/// Real implementation of [AuthenticateRemoteDatasource] using API service.
class AuthenticateRemoteDatasourceImpl implements AuthenticateRemoteDatasource {
  /// Creates an instance with the required [ApiService].
  AuthenticateRemoteDatasourceImpl({required this.apiService});

  /// The API service for making network requests.
  final ApiService apiService;

  AuthenticationApi get _authApi => apiService.authenticateApi;

  @override
  Future<SignInResponseEntity> login(
    SignInRequestEntity request,
    String role,
  ) async {
    AuthTokensDto? response;

    if (role == 'admin') {
      response = await _authApi.authControllerLoginAdmin(
        AdminLoginDto(email: request.email, password: request.password),
      );
    } else if (role == 'user') {
      response = await _authApi.authControllerLoginUser(
        LoginDto(email: request.email, password: request.password),
      );
    } else if (role == 'health_partner') {
      response = await _authApi.authControllerLoginPartner(
        PartnerLoginDto(email: request.email, password: request.password),
      );
    } else {
      throw ApiException(
        HttpStatus.badRequest,
        'Invalid role: $role. Must be admin, user, or partner.',
      );
    }

    if (response == null) {
      throw ApiException(HttpStatus.notFound, 'Login response is null');
    }

    // decode token and check role in token with role in request
    final token = response.accessToken;
    final decodedToken = JwtDecoder.decode(token);
    final tokenRole = decodedToken['role'];
    final verificationStatus = decodedToken['verificationStatus'];
    String? verificationCompletedAt; // Declare as nullable String

    if (role != tokenRole) {
      throw ApiException(HttpStatus.unauthorized, 'Role not match');
    }

    // Extract verificationCompletedAt for health_partner role
    if (tokenRole == 'health_partner') {
      final rawVerificationCompletedAt =
          decodedToken['verificationCompletedAt'];
      if (rawVerificationCompletedAt != null) {
        verificationCompletedAt = rawVerificationCompletedAt.toString();
      }
    }

    return SignInResponseEntity(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      role: tokenRole,
      verificationStatus: verificationStatus,
      verificationCompletedAt: verificationCompletedAt,
    );
  }

  @override
  Future<SendOtpResponseEntity> sendOtp(String email) async {
    // Backend doesn't have OTP endpoint yet.
    // This will be implemented when the backend adds the endpoint.
    throw UnsupportedError(
      'OTP endpoint not available in backend. Use mock mode for testing.',
    );
  }

  @override
  Future<VerifyOtpResponseEntity> verifyOtp(
    String emailToken,
    String otp,
  ) async {
    // Backend doesn't have OTP endpoint yet.
    // This will be implemented when the backend adds the endpoint.
    throw UnsupportedError(
      'OTP endpoint not available in backend. Use mock mode for testing.',
    );
  }

  @override
  Future<RegisterPartnerResponseEntity> registerPartner(
    RegisterPartnerRequestEntity request,
  ) async {
    // Map domain entities to OpenAPI DTOs
    final dto = RegisterPartnerDto(
      account: AccountRequestDto(
        username: request.account.username,
        email: request.account.email,
        password: request.account.password,
      ),
      partner: PartnerRequestDto(
        taxCode: request.partner.taxCode,
        legalName: request.partner.legalName,
        brandName: request.partner.brandName,
        businessType: _mapBusinessTypes(request.partner.businessType),
        provinceId: request.partner.provinceId,
        districtId: request.partner.districtId,
        wardId: request.partner.wardId,
        streetAddress: request.partner.streetAddress,
        phoneNumber: request.partner.phoneNumber,
      ),
      legalRepresentative: LegalRepresentativeRequestDto(
        fullName: request.legalRepresentative.fullName,
        position: request.legalRepresentative.position,
        phoneNumber: request.legalRepresentative.phoneNumber,
        idType: _mapIdType(request.legalRepresentative.idType),
        idNumber: request.legalRepresentative.idNumber,
        idIssueDate: request.legalRepresentative.idIssueDate,
        // Map list of documents to list of DTOs
        documents: request.legalRepresentative.documents
            .map(
              (doc) => PartnerDocumentVerificationDto(
                fileType: doc.fileType,
                type: doc.type,
                documentKey: doc.documentKey,
                urls: doc.urls,
              ),
            )
            .toList(),
      ),
    );

    final response = await _authApi.authControllerRegisterPartner(dto);
    if (response == null) {
      throw ApiException(
        HttpStatus.internalServerError,
        'Register partner response is null',
      );
    }

    developer.log(
      'Registered partner: ${request.partner.brandName}',
      name: 'AuthenticateRemoteDatasource',
    );

    return RegisterPartnerResponseEntity(
      accountId: response.accountId,
      businessEntityId: response.businessEntityId,
      status: response.status,
      message: response.message,
      accessToken: response.accessToken,
      accessExpiresIn: response.accessExpiresIn,
      refreshToken: response.refreshToken,
      refreshExpiresIn: response.refreshExpiresIn,
    );
  }

  // ===========================================================================
  // Private Helper Methods
  // ===========================================================================

  List<PartnerRequestDtoBusinessTypeEnum> _mapBusinessTypes(
    List<String> businessTypes,
  ) {
    return businessTypes.map((type) {
      return switch (type.toUpperCase()) {
        'MASSAGE_THERAPY' => PartnerRequestDtoBusinessTypeEnum.MASSAGE_THERAPY,
        'MASSAGE_REHABILITATION' =>
          PartnerRequestDtoBusinessTypeEnum.MASSAGE_REHABILITATION,
        'SPA_BEAUTY' => PartnerRequestDtoBusinessTypeEnum.SPA_BEAUTY,
        'FITNESS' => PartnerRequestDtoBusinessTypeEnum.FITNESS,
        'PHARMACY' => PartnerRequestDtoBusinessTypeEnum.PHARMACY,
        'DENTAL' => PartnerRequestDtoBusinessTypeEnum.DENTAL,
        'TRADITIONAL_MEDICINE' =>
          PartnerRequestDtoBusinessTypeEnum.TRADITIONAL_MEDICINE,
        'PSYCHOLOGY' => PartnerRequestDtoBusinessTypeEnum.PSYCHOLOGY,
        'DERMATOLOGY' => PartnerRequestDtoBusinessTypeEnum.DERMATOLOGY,
        'NUTRITION' => PartnerRequestDtoBusinessTypeEnum.NUTRITION,
        'PSYCHIATRY' => PartnerRequestDtoBusinessTypeEnum.PSYCHIATRY,
        _ => PartnerRequestDtoBusinessTypeEnum.SPA_BEAUTY,
      };
    }).toList();
  }

  LegalRepresentativeRequestDtoIdTypeEnum _mapIdType(String idType) {
    return switch (idType.toUpperCase()) {
      'CITIZEN_ID' => LegalRepresentativeRequestDtoIdTypeEnum.CITIZEN_ID,
      'PASSPORT' => LegalRepresentativeRequestDtoIdTypeEnum.PASSPORT,
      'MILITARY_ID' => LegalRepresentativeRequestDtoIdTypeEnum.MILITARY_ID,
      _ => LegalRepresentativeRequestDtoIdTypeEnum.CITIZEN_ID,
    };
  }
}

// ============================================================================
// 3. MOCK IMPLEMENTATION
// ============================================================================

/// Mock implementation of [AuthenticateRemoteDatasource] for UI testing.
///
/// Provides simulated network delays and fake data.
class AuthenticateRemoteDatasourceMock implements AuthenticateRemoteDatasource {
  @override
  Future<SignInResponseEntity> login(
    SignInRequestEntity request,
    String role,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return SignInResponseEntity(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      role: role,
    );
  }

  @override
  Future<SendOtpResponseEntity> sendOtp(String email) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    developer.log(
      'Mock: Sent OTP to $email',
      name: 'AuthenticateRemoteDatasourceMock',
    );

    // Generate a mock token based on the email
    final mockToken = 'otp_token_${email.hashCode.abs()}';

    return SendOtpResponseEntity(
      emailToken: mockToken,
      message: 'OTP sent successfully to $email',
    );
  }

  @override
  Future<VerifyOtpResponseEntity> verifyOtp(
    String emailToken,
    String otp,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    developer.log(
      'Mock: Verified OTP $otp for token $emailToken',
      name: 'AuthenticateRemoteDatasourceMock',
    );

    // Generate a mock OTP token for the next step
    final mockOtpToken = 'verified_${emailToken}_$otp';

    return VerifyOtpResponseEntity(
      otpToken: mockOtpToken,
      message: 'OTP verified successfully',
    );
  }

  @override
  Future<RegisterPartnerResponseEntity> registerPartner(
    RegisterPartnerRequestEntity request,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    developer.log(
      'Mock: Registered partner ${request.partner.brandName}',
      name: 'AuthenticateRemoteDatasourceMock',
    );

    return RegisterPartnerResponseEntity(
      accountId: 'mock_account_${DateTime.now().millisecondsSinceEpoch}',
      businessEntityId: 'mock_entity_${DateTime.now().millisecondsSinceEpoch}',
      status: 'PENDING_VERIFICATION',
      message: 'Partner registered successfully. Awaiting verification.',
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      accessExpiresIn: '1h',
      refreshToken:
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshExpiresIn: '7d',
    );
  }
}

// ============================================================================
// 4. PROVIDER
// ============================================================================

@Riverpod(keepAlive: true)
AuthenticateRemoteDatasource authenticateRemoteDatasource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return AuthenticateRemoteDatasourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return AuthenticateRemoteDatasourceImpl(apiService: apiService);
}
