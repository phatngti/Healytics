import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';
import { jwtConstants } from '@/auth/constants';
import { AccountService } from '@/account/account.service';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private readonly accountService: AccountService,
    configService: ConfigService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtConstants.secret,
    });
  }

  async validate(payload: any) {
    // load user from DB and return sanitized user object
    const user = await this.accountService.findOne(payload.sub);
    if (!user) return null;
    const { passwordHash, refreshTokenHash, ...rest } = user as any;
    return rest;
  }
}
