import {
  CallHandler,
  ExecutionContext,
  HttpException,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { Observable } from 'rxjs';
import { finalize, tap } from 'rxjs/operators';
import { ObservabilityMetricsService } from './observability-metrics.service';

@Injectable()
export class ObservabilityHttpMetricsInterceptor implements NestInterceptor {
  constructor(private readonly metrics: ObservabilityMetricsService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    if (context.getType() !== 'http') {
      return next.handle();
    }

    const httpContext = context.switchToHttp();
    const request = httpContext.getRequest<Request>();
    const response = httpContext.getResponse<Response>();
    const method = request.method ?? 'UNKNOWN';
    const route = this.getRouteLabel(request);

    if (route === '/metrics') {
      return next.handle();
    }

    const startedAt = process.hrtime.bigint();
    let errorStatusCode: number | undefined;

    this.metrics.startHttpRequest({ method, route });

    return next.handle().pipe(
      tap({
        error: (error: unknown) => {
          errorStatusCode =
            error instanceof HttpException ? error.getStatus() : 500;
        },
      }),
      finalize(() => {
        const statusCode = errorStatusCode ?? response.statusCode ?? 200;
        const durationSeconds =
          Number(process.hrtime.bigint() - startedAt) / 1_000_000_000;

        this.metrics.finishHttpRequest(
          {
            method,
            route,
            status_code: String(statusCode),
          },
          durationSeconds,
        );
      }),
    );
  }

  private getRouteLabel(request: Request): string {
    const routePath = request.route?.path;
    const baseUrl = request.baseUrl ?? '';

    if (typeof routePath === 'string') {
      return this.normalizeRoute(`${baseUrl}${routePath}`);
    }

    if (Array.isArray(routePath) && typeof routePath[0] === 'string') {
      return this.normalizeRoute(`${baseUrl}${routePath[0]}`);
    }

    const rawPath = request.path ?? request.originalUrl ?? request.url ?? '/';
    return this.normalizeRoute(rawPath.split('?')[0]);
  }

  private normalizeRoute(route: string): string {
    const normalized =
      route
        .replace(
          /[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/gi,
          ':id',
        )
        .replace(/\/\d+(?=\/|$)/g, '/:id')
        .replace(/\/+/g, '/')
        .replace(/\/$/, '') || '/';

    return normalized;
  }
}
