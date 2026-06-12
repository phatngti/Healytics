import {
  CallHandler,
  ExecutionContext,
  Injectable,
  Logger,
  NestInterceptor,
  OnModuleDestroy,
} from '@nestjs/common';
import { monitorEventLoopDelay, IntervalHistogram } from 'perf_hooks';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

interface RouteMetricWindow {
  count: number;
  errors: number;
  totalMs: number;
  maxMs: number;
  samples: number[];
}

@Injectable()
export class PerformanceMetricsInterceptor
  implements NestInterceptor, OnModuleDestroy
{
  private readonly logger = new Logger('PerfMetrics');
  private readonly enabled = process.env.PERF_METRICS_ENABLED === 'true';
  private readonly sampleLimit = this.parsePositiveInt(
    process.env.PERF_METRICS_ROUTE_SAMPLE_LIMIT,
    2048,
  );
  private readonly routeWindows = new Map<string, RouteMetricWindow>();
  private readonly eventLoopDelay?: IntervalHistogram;
  private readonly timer?: ReturnType<typeof setInterval>;

  constructor() {
    if (!this.enabled) {
      return;
    }

    this.eventLoopDelay = monitorEventLoopDelay({
      resolution: this.parsePositiveInt(
        process.env.PERF_EVENT_LOOP_RESOLUTION_MS,
        20,
      ),
    });
    this.eventLoopDelay.enable();

    this.timer = setInterval(
      () => this.flush(),
      this.parsePositiveInt(process.env.PERF_METRICS_LOG_INTERVAL_MS, 30000),
    );
    this.timer.unref?.();
  }

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    if (!this.enabled || context.getType() !== 'http') {
      return next.handle();
    }

    const req = context.switchToHttp().getRequest();
    const routeKey = this.getRouteKey(req);
    const startedAt = process.hrtime.bigint();

    return next.handle().pipe(
      tap({
        next: () => this.record(routeKey, startedAt, false),
        error: () => this.record(routeKey, startedAt, true),
      }),
    );
  }

  onModuleDestroy() {
    if (this.timer) {
      clearInterval(this.timer);
    }
    if (this.eventLoopDelay) {
      this.flush();
      this.eventLoopDelay.disable();
    }
  }

  private record(routeKey: string, startedAt: bigint, isError: boolean) {
    const durationMs = Number(process.hrtime.bigint() - startedAt) / 1_000_000;
    const metric = this.routeWindows.get(routeKey) ?? {
      count: 0,
      errors: 0,
      totalMs: 0,
      maxMs: 0,
      samples: [],
    };

    metric.count += 1;
    metric.errors += isError ? 1 : 0;
    metric.totalMs += durationMs;
    metric.maxMs = Math.max(metric.maxMs, durationMs);

    if (metric.samples.length < this.sampleLimit) {
      metric.samples.push(durationMs);
    } else {
      metric.samples[metric.count % this.sampleLimit] = durationMs;
    }

    this.routeWindows.set(routeKey, metric);
  }

  private flush() {
    if (!this.enabled) {
      return;
    }

    if (this.eventLoopDelay) {
      this.logger.log(
        [
          'event_loop_delay',
          `p50=${this.nsToMs(this.eventLoopDelay.percentile(50))}ms`,
          `p95=${this.nsToMs(this.eventLoopDelay.percentile(95))}ms`,
          `p99=${this.nsToMs(this.eventLoopDelay.percentile(99))}ms`,
          `max=${this.nsToMs(this.eventLoopDelay.max)}ms`,
        ].join(' '),
      );
      this.eventLoopDelay.reset();
    }

    for (const [route, metric] of this.routeWindows.entries()) {
      const sorted = metric.samples.slice().sort((a, b) => a - b);
      this.logger.log(
        [
          `route="${route}"`,
          `count=${metric.count}`,
          `errors=${metric.errors}`,
          `avg=${this.formatMs(metric.totalMs / metric.count)}ms`,
          `p50=${this.formatMs(this.percentile(sorted, 50))}ms`,
          `p95=${this.formatMs(this.percentile(sorted, 95))}ms`,
          `p99=${this.formatMs(this.percentile(sorted, 99))}ms`,
          `max=${this.formatMs(metric.maxMs)}ms`,
        ].join(' '),
      );
    }

    this.routeWindows.clear();
  }

  private getRouteKey(req: {
    method?: string;
    baseUrl?: string;
    route?: { path?: string };
    path?: string;
    originalUrl?: string;
    url?: string;
  }): string {
    const method = req.method ?? 'UNKNOWN';
    const routePath = req.route?.path;
    const path =
      typeof routePath === 'string'
        ? `${req.baseUrl ?? ''}${routePath}`
        : (req.path ?? req.originalUrl ?? req.url ?? 'unknown');

    return `${method} ${path}`;
  }

  private percentile(sorted: number[], pct: number): number {
    if (sorted.length === 0) {
      return 0;
    }
    const index = Math.ceil((pct / 100) * sorted.length) - 1;
    return sorted[Math.min(Math.max(index, 0), sorted.length - 1)];
  }

  private nsToMs(value: number): string {
    return this.formatMs(value / 1_000_000);
  }

  private formatMs(value: number): string {
    return value.toFixed(1);
  }

  private parsePositiveInt(
    value: string | undefined,
    fallback: number,
  ): number {
    const parsed = Number(value);
    return Number.isInteger(parsed) && parsed > 0 ? parsed : fallback;
  }
}
