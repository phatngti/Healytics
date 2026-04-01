import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Reflector } from '@nestjs/core';
import { AuditService } from '../audit.service';
import {
  AUDIT_ACTION_KEY,
  AUDIT_TARGET_ENTITY_KEY,
} from '../decorators/audit.decorator';

@Injectable()
export class AuditInterceptor implements NestInterceptor {
  private readonly logger = new Logger(AuditInterceptor.name);

  constructor(
    private reflector: Reflector,
    private auditService: AuditService,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      tap(async () => {
        try {
          const action = this.reflector.get<string>(
            AUDIT_ACTION_KEY,
            context.getHandler(),
          );
          const targetEntity = this.reflector.get<string>(
            AUDIT_TARGET_ENTITY_KEY,
            context.getHandler(),
          );

          if (action && targetEntity) {
            const request = context.switchToHttp().getRequest();
            const user = request.user;
            const { id } = request.params;
            const body = request.body;

            if (!user || !user.id) {
              this.logger.warn('AuditInterceptor: User not found in request');
              return;
            }

            // Use param ID as targetId if available, otherwise fallback or leave empty/logic dependent.
            // For Partner Review, :id is the partner ID.
            const targetId = id;

            const ip = request.ip || request.connection.remoteAddress;
            const userAgent = request.headers['user-agent'];

            await this.auditService.logAction({
              actorId: user.id,
              action: action,
              targetEntity: targetEntity,
              targetId: targetId, // Assumption: audited routes usually have an :id param
              metadata: body, // Capture request body as metadata
              ipAddress: ip,
              userAgent: userAgent,
            });
          }
        } catch (error) {
          this.logger.error('Failed to log audit entry', error);
        }
      }),
    );
  }
}
