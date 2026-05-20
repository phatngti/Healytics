import 'package:glados/glados.dart';
import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';

/// Property: For all valid [AuthenticateEntity] values produced by the Google
/// sign-in path, [AuthenticateEntity.fromJson] applied to [entity.toJson]
/// returns an entity equal to the original.
///
/// Validates: Requirements 11.1, 11.2, 11.3.

// ASCII alphanumeric characters used to generate token-like strings. The
// Google sign-in path emits JWT-shaped tokens consisting of base64url ASCII
// segments; restricting to alphanumerics is a safe sub-alphabet.
const _alphaNumChars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

const _lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
const _localPartChars = 'abcdefghijklmnopqrstuvwxyz0123456789.';

// Generator for an ASCII alphanumeric token of length [minLength..maxLength).
Generator<String> _asciiToken({required int minLength, required int maxLength}) {
  return any
      .listWithLengthInRange(
        minLength,
        maxLength,
        any.choose(_alphaNumChars.split('')),
      )
      .map((chars) => chars.join());
}

Generator<String> _alphaList({required int minLength, required int maxLength}) {
  return any
      .listWithLengthInRange(
        minLength,
        maxLength,
        any.choose(_lowercaseChars.split('')),
      )
      .map((chars) => chars.join());
}

Generator<String> _localPart({required int minLength, required int maxLength}) {
  return any
      .listWithLengthInRange(
        minLength,
        maxLength,
        any.choose(_localPartChars.split('')),
      )
      .map((chars) => chars.join());
}

// Email matching the regex `^[a-z0-9.]+@[a-z]+\.[a-z]+$` from the task.
final Generator<String> _emailGen = any.combine3(
  _localPart(minLength: 1, maxLength: 12),
  _alphaList(minLength: 1, maxLength: 8),
  _alphaList(minLength: 2, maxLength: 4),
  (local, domain, tld) => '$local@$domain.$tld',
);

// Optional non-empty display name. Either `null` or 1..50 alphanumeric chars.
final Generator<String?> _nameGen =
    _asciiToken(minLength: 1, maxLength: 50).nullable;

final Generator<BasicInfoEntity> _basicInfoGen = any.combine2(
  _emailGen,
  _nameGen,
  (email, name) => BasicInfoEntity(email: email, name: name),
);

// Access/refresh tokens: ASCII alphanumeric, length 16..64 (matching the
// safe pinned sub-alphabet from the task description).
final Generator<String> _tokenGen =
    _asciiToken(minLength: 16, maxLength: 64);

final Generator<AuthenticateEntity> _authenticateEntityGen = any.combine3(
  _tokenGen,
  _tokenGen,
  _basicInfoGen.nullable,
  (accessToken, refreshToken, basicInfo) => AuthenticateEntity(
    accessToken: accessToken,
    refreshToken: refreshToken,
    basicInfo: basicInfo,
  ),
);

void main() {
  Glados<AuthenticateEntity>(_authenticateEntityGen).test(
    'AuthenticateEntity.fromJson(entity.toJson()) == entity',
    (entity) {
      final roundTripped =
          AuthenticateEntity.fromJson(entity.toJson());
      expect(roundTripped, equals(entity));
    },
  );
}
