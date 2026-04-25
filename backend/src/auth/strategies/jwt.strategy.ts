import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';
import { jwtConstants } from '@/auth/constants';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtConstants.secret,
    });
  }

  /**
   * Trust the JWT payload — no DB lookup required.
   *
   * The JWT is cryptographically signed; all claims embedded at sign-time
   * (sub, email, role, profile flags) are authoritative until the token
   * expires. This avoids a DB query + eager-loaded relation cascade
   * (Account → UserProfile → Address) on **every** authenticated request.
   *
   * If account ban-checking is needed, use a Redis set (`banned:<userId>`)
   * with a short TTL rather than a synchronous DB roundtrip.
   */
  async validate(payload: any) {
    if (!payload?.sub) return null;

    return {
      id: payload.sub,
      email: payload.email,
      role: payload.role,
      firstName: payload.firstName,
      lastName: payload.lastName,
      profileCompleted: payload.profileCompleted,
      verificationStatus: payload.verificationStatus,
      verificationCompletedAt: payload.verificationCompletedAt,
      partnerProfileCompleted: payload.partnerProfileCompleted,
    };
  }
}
