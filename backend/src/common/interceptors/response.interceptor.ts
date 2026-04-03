import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
  SetMetadata,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

export const LOG_RESPONSE_KEY = 'log_response';
export const LogResponse = () => SetMetadata(LOG_RESPONSE_KEY, true);

@Injectable()
export class ResponseInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');

  constructor(private readonly reflector: Reflector) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url } = request;

    const shouldLog = this.reflector.getAllAndOverride<boolean>(
      LOG_RESPONSE_KEY,
      [context.getHandler(), context.getClass()],
    );

    return next.handle().pipe(
      tap({
        next: (data) => {
          if (shouldLog) {
            this.logResponseBody(method, url, data);
          }
        },
        error: (error) => {
          this.logger.error(
            `Response Error [${method} ${url}]: ${error.message}`,
          );
        },
      }),
    );
  }

  private logResponseBody(method: string, url: string, data: any) {
    if (data === undefined || data === null) {
      this.logger.debug(`Response Body [${method} ${url}]: (empty)`);
      return;
    }

    try {
      const stringified = JSON.stringify(data, null, 2);
      this.logger.debug(`Response Body [${method} ${url}]: ${stringified}`);
    } catch {
      this.logger.debug(
        `Response Body [${method} ${url}]: [Unable to serialize]`,
      );
    }
  }
}
