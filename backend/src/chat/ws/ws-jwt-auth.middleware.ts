import { Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Socket } from 'socket.io';
import { jwtConstants } from '@/auth/constants';
import { AccountService } from '@/account/account.service';
import { Role } from '@/account/enum/role.enum';

const logger = new Logger('WsJwtAuthMiddleware');

/**
 * Socket.IO handshake middleware that validates JWT at connection time.
 *
 * Token is extracted from:
 * 1. `socket.handshake.auth.token` (recommended — Socket.IO auth object)
 * 2. `socket.handshake.headers.authorization` (Bearer token fallback)
 *
 * On success, attaches the sanitized user object to `socket.data.user`.
 * On failure, rejects the connection with a descriptive error.
 */
export function WsJwtAuthMiddleware(
  jwtService: JwtService,
  accountService: AccountService,
) {
  return async (socket: Socket, next: (err?: Error) => void) => {
    try {
      const token =
        socket.handshake.auth?.token ||
        socket.handshake.headers.authorization?.split(' ')[1];

      if (!token) {
        logger.warn('WebSocket connection rejected: no token provided');
        return next(new Error('AUTH_REQUIRED'));
      }

      const payload = jwtService.verify(token, {
        secret: jwtConstants.secret,
      });

      const user = await accountService.findOne(payload.sub);
      if (!user) {
        logger.warn(`WebSocket connection rejected: user ${payload.sub} not found`);
        return next(new Error('USER_NOT_FOUND'));
      }

      // Strip sensitive fields
      const { passwordHash, refreshTokenHash, ...safeUser } = user as any;
      socket.data.user = safeUser;

      logger.log(`WebSocket authenticated: ${safeUser.email} (${safeUser.role})`);
      next();
    } catch (error) {
      logger.warn(`WebSocket connection rejected: invalid token — ${(error as Error).message}`);
      next(new Error('INVALID_TOKEN'));
    }
  };
}

/**
 * Socket.IO middleware that enforces role-based access on a gateway namespace.
 * Must be applied AFTER WsJwtAuthMiddleware (which sets socket.data.user).
 */
export function WsRoleMiddleware(allowedRoles: Role[]) {
  return (socket: Socket, next: (err?: Error) => void) => {
    const user = socket.data.user;
    if (!user || !allowedRoles.includes(user.role)) {
      logger.warn(
        `WebSocket role rejected: ${user?.email ?? 'unknown'} has role ${user?.role}, needs one of [${allowedRoles}]`,
      );
      return next(new Error('INSUFFICIENT_ROLE'));
    }
    next();
  };
}
