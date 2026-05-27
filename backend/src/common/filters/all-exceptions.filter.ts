import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { QueryFailedError } from 'typeorm';
import { Request, Response } from 'express';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const message =
      exception instanceof HttpException
        ? exception.getResponse()
        : 'Internal server error';

    // ── Build rich error context ─────────────────────────────
    const errorContext: Record<string, unknown> = {
      httpStatus: status,
      method: request.method,
      path: request.url,
      message:
        typeof message === 'string'
          ? message
          : ((message as any)?.message ?? message),
    };

    // Include request body for mutation endpoints (POST/PUT/PATCH)
    if (['POST', 'PUT', 'PATCH'].includes(request.method) && request.body) {
      errorContext.requestBody = this.sanitizeBody(request.body);
    }

    // Include route params if present
    if (request.params && Object.keys(request.params).length > 0) {
      errorContext.params = request.params;
    }

    // Include query params if present
    if (request.query && Object.keys(request.query).length > 0) {
      errorContext.query = request.query;
    }

    // Include authenticated user id if available
    if ((request as any).user?.id) {
      errorContext.authenticatedUserId = (request as any).user.id;
    }

    // ── Database-specific error context ─────────────────────
    if (exception instanceof QueryFailedError) {
      const dbError = exception as QueryFailedError & {
        code?: string;
        detail?: string;
        constraint?: string;
        table?: string;
      };
      errorContext.dbErrorCode = dbError.code;
      errorContext.dbDetail = dbError.detail;
      errorContext.dbConstraint = dbError.constraint;
      errorContext.dbTable = dbError.table;
    }

    // ── Log ──────────────────────────────────────────────────
    this.logger.error(
      `[${request.method} ${request.url}] ${status} — ${JSON.stringify(errorContext)}`,
    );

    if (
      exception instanceof Error &&
      (status >= 500 || !(exception instanceof HttpException))
    ) {
      this.logger.error(`Stack: ${exception.stack}`);
    }

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message: message,
    });
  }

  /**
   * Redact sensitive fields from request body before logging.
   */
  private sanitizeBody(body: Record<string, unknown>): Record<string, unknown> {
    const sensitiveKeys = [
      'password',
      'token',
      'secret',
      'authorization',
      'accessToken',
      'refreshToken',
      'creditCard',
      'cardNumber',
      'cvv',
    ];
    const sanitized = { ...body };
    for (const key of Object.keys(sanitized)) {
      if (
        sensitiveKeys.some((s) => key.toLowerCase().includes(s.toLowerCase()))
      ) {
        sanitized[key] = '***REDACTED***';
      }
    }
    return sanitized;
  }
}
