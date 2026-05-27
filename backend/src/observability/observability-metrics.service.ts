import { Injectable, OnModuleDestroy, Optional } from '@nestjs/common';
import { monitorEventLoopDelay, IntervalHistogram } from 'perf_hooks';
import {
  collectDefaultMetrics,
  Counter,
  Gauge,
  Histogram,
  Registry,
} from 'prom-client';
import type { Namespace } from 'socket.io';
import { RedisService } from '@/redis/redis.service';

type HttpLabels = {
  method: string;
  route: string;
  status_code: string;
};

type HttpInFlightLabels = {
  method: string;
  route: string;
};

type LoginActiveUserLabels = {
  role: string;
};

type WsLabels = {
  namespace: string;
  role: string;
};

type WsSocketState = WsLabels & {
  userKey: string;
};

@Injectable()
export class ObservabilityMetricsService implements OnModuleDestroy {
  private readonly registry = new Registry();
  private readonly startTime = Date.now();
  private readonly wsNamespaces = new Map<string, Namespace>();
  private readonly wsSocketStates = new Map<string, WsSocketState>();
  private readonly wsConnectionCounts = new Map<string, number>();
  private readonly wsUserRefCounts = new Map<string, number>();
  private readonly wsActiveUserCounts = new Map<string, number>();
  private readonly wsGlobalUserRefCounts = new Map<string, number>();
  private readonly loginActiveUsersSeenAt = new Map<string, number>();
  private readonly eventLoopDelay: IntervalHistogram;
  private readonly eventLoopTimer: ReturnType<typeof setInterval>;
  private readonly loginCcuWindowSeconds: number;
  private readonly loginCcuWindowMs: number;
  private readonly loginCcuRedisPrefix = 'metrics:login-ccu';

  private readonly httpRequestsTotal: Counter<
    'method' | 'route' | 'status_code'
  >;
  private readonly httpErrorsTotal: Counter<'method' | 'route' | 'status_code'>;
  private readonly httpRequestDuration: Histogram<
    'method' | 'route' | 'status_code'
  >;
  private readonly httpInFlightRequests: Gauge<'method' | 'route'>;
  private readonly loginActiveUsers: Gauge<'role'>;
  private readonly loginActiveUsersTotal: Gauge<string>;
  private readonly wsActiveConnections: Gauge<'namespace' | 'role'>;
  private readonly wsActiveUsers: Gauge<'namespace' | 'role'>;
  private readonly wsActiveConnectionsTotal: Gauge<string>;
  private readonly wsActiveUsersTotal: Gauge<string>;
  private readonly wsConnectionEventsTotal: Counter<
    'namespace' | 'role' | 'event'
  >;
  private readonly backendUptimeSeconds: Gauge<string>;
  private readonly eventLoopDelaySeconds: Gauge<'quantile'>;

  constructor(@Optional() private readonly redisService?: RedisService) {
    this.registry.setDefaultLabels({
      service: process.env.OTEL_SERVICE_NAME || 'healytics-backend',
    });

    collectDefaultMetrics({
      register: this.registry,
      prefix: 'healytics_',
    });
    this.loginCcuWindowSeconds = this.parsePositiveInt(
      process.env.METRICS_LOGIN_CCU_WINDOW_SECONDS ??
        process.env.METRICS_HTTP_ACTIVE_USER_WINDOW_SECONDS,
      1800,
    );
    this.loginCcuWindowMs = this.loginCcuWindowSeconds * 1000;

    this.httpRequestsTotal = new Counter({
      name: 'healytics_http_requests_total',
      help: 'Total HTTP requests handled by the backend.',
      labelNames: ['method', 'route', 'status_code'],
      registers: [this.registry],
    });

    this.httpErrorsTotal = new Counter({
      name: 'healytics_http_errors_total',
      help: 'Total HTTP requests with status code >= 400.',
      labelNames: ['method', 'route', 'status_code'],
      registers: [this.registry],
    });

    this.httpRequestDuration = new Histogram({
      name: 'healytics_http_request_duration_seconds',
      help: 'HTTP request latency in seconds.',
      labelNames: ['method', 'route', 'status_code'],
      buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
      registers: [this.registry],
    });

    this.httpInFlightRequests = new Gauge({
      name: 'healytics_http_in_flight_requests',
      help: 'Current in-flight HTTP requests.',
      labelNames: ['method', 'route'],
      registers: [this.registry],
    });

    this.loginActiveUsers = new Gauge({
      name: 'healytics_login_active_users',
      help: 'Recently active users counted from successful login APIs by role.',
      labelNames: ['role'],
      registers: [this.registry],
    });

    this.loginActiveUsersTotal = new Gauge({
      name: 'healytics_login_active_users_total',
      help: 'Recently active users counted from successful login APIs across roles.',
      registers: [this.registry],
    });

    this.wsActiveConnections = new Gauge({
      name: 'healytics_ws_active_connections',
      help: 'Current active Socket.IO connections by namespace and role.',
      labelNames: ['namespace', 'role'],
      registers: [this.registry],
    });

    this.wsActiveUsers = new Gauge({
      name: 'healytics_ws_active_users',
      help: 'Current distinct authenticated WebSocket users by namespace and role.',
      labelNames: ['namespace', 'role'],
      registers: [this.registry],
    });

    this.wsActiveConnectionsTotal = new Gauge({
      name: 'healytics_ws_active_connections_total',
      help: 'Current active Socket.IO connections across tracked namespaces.',
      registers: [this.registry],
    });

    this.wsActiveUsersTotal = new Gauge({
      name: 'healytics_ws_active_users_total',
      help: 'Current distinct authenticated WebSocket users across tracked namespaces.',
      registers: [this.registry],
    });

    this.wsConnectionEventsTotal = new Counter({
      name: 'healytics_ws_connection_events_total',
      help: 'WebSocket connection and disconnection events.',
      labelNames: ['namespace', 'role', 'event'],
      registers: [this.registry],
    });

    this.backendUptimeSeconds = new Gauge({
      name: 'healytics_backend_uptime_seconds',
      help: 'Backend process uptime in seconds.',
      registers: [this.registry],
      collect: () => {
        this.backendUptimeSeconds.set((Date.now() - this.startTime) / 1000);
      },
    });

    this.eventLoopDelaySeconds = new Gauge({
      name: 'healytics_event_loop_delay_seconds',
      help: 'Node.js event loop delay summary in seconds.',
      labelNames: ['quantile'],
      registers: [this.registry],
    });

    this.eventLoopDelay = monitorEventLoopDelay({
      resolution: this.parsePositiveInt(
        process.env.METRICS_EVENT_LOOP_RESOLUTION_MS,
        20,
      ),
    });
    this.eventLoopDelay.enable();
    this.eventLoopTimer = setInterval(
      () => this.observeEventLoopDelay(),
      this.parsePositiveInt(process.env.METRICS_EVENT_LOOP_INTERVAL_MS, 10000),
    );
    this.eventLoopTimer.unref?.();

    this.initializeWsLabels();
  }

  get contentType(): string {
    return this.registry.contentType;
  }

  async metrics(): Promise<string> {
    this.syncRegisteredWsNamespaces();
    await this.updateLoginCcuGauges();
    this.observeEventLoopDelay();
    return this.registry.metrics();
  }

  startHttpRequest(labels: HttpInFlightLabels): void {
    this.httpInFlightRequests.inc(labels);
  }

  finishHttpRequest(labels: HttpLabels, durationSeconds: number): void {
    this.httpInFlightRequests.dec({
      method: labels.method,
      route: labels.route,
    });
    this.httpRequestsTotal.inc(labels);
    this.httpRequestDuration.observe(labels, durationSeconds);

    if (Number(labels.status_code) >= 400) {
      this.httpErrorsTotal.inc(labels);
    }
  }

  async recordLoginCcu(role: unknown, userId: unknown): Promise<void> {
    const userKey = String(userId ?? '').trim();
    if (!userKey) return;

    const labels: LoginActiveUserLabels = {
      role: this.normalizeLabel(String(role ?? 'unknown'), 'unknown'),
    };
    const now = Date.now();
    this.loginActiveUsersSeenAt.set(`${labels.role}\u0000${userKey}`, now);

    if (this.redisService) {
      try {
        await this.redisService.set(
          this.loginCcuKey(labels.role, userKey),
          String(now),
          this.loginCcuWindowSeconds,
        );
      } catch {
        // Metrics must never make login fail; the in-memory window remains as fallback.
      }
    }

    await this.updateLoginCcuGauges();
  }

  recordWsConnect(
    socketId: unknown,
    namespace: string,
    role: unknown,
    userId: unknown,
  ): void {
    const labels: WsLabels = {
      namespace: this.normalizeLabel(namespace, 'unknown'),
      role: this.normalizeLabel(String(role ?? 'unknown'), 'unknown'),
    };
    const socketKey = this.socketKey(socketId, labels.namespace);
    const previousState = this.wsSocketStates.get(socketKey);
    if (previousState) {
      this.recordWsDisconnect(socketId, labels.namespace);
    }

    const userKey = this.userKey(userId, socketKey);
    const labelKey = this.wsLabelKey(labels);
    const userRefKey = this.wsUserRefKey(labels, userKey);
    const currentUserRefs = this.wsUserRefCounts.get(userRefKey) ?? 0;
    const currentGlobalUserRefs = this.wsGlobalUserRefCounts.get(userKey) ?? 0;

    this.wsSocketStates.set(socketKey, { ...labels, userKey });
    this.wsConnectionCounts.set(
      labelKey,
      (this.wsConnectionCounts.get(labelKey) ?? 0) + 1,
    );
    this.wsUserRefCounts.set(userRefKey, currentUserRefs + 1);
    if (currentUserRefs === 0) {
      this.wsActiveUserCounts.set(
        labelKey,
        (this.wsActiveUserCounts.get(labelKey) ?? 0) + 1,
      );
    }
    this.wsGlobalUserRefCounts.set(userKey, currentGlobalUserRefs + 1);

    this.setWsGauges(labels);
    this.wsConnectionEventsTotal.inc({ ...labels, event: 'connect' });
  }

  recordWsDisconnect(socketId: unknown, namespace?: string): void {
    const socketKey = this.findSocketKey(socketId, namespace);
    const state = this.wsSocketStates.get(socketKey);
    if (!state) return;

    this.wsSocketStates.delete(socketKey);

    const labels: WsLabels = {
      namespace: state.namespace,
      role: state.role,
    };
    const labelKey = this.wsLabelKey(labels);
    const userRefKey = this.wsUserRefKey(labels, state.userKey);
    const nextConnectionCount = Math.max(
      0,
      (this.wsConnectionCounts.get(labelKey) ?? 0) - 1,
    );
    const nextUserRefs = Math.max(
      0,
      (this.wsUserRefCounts.get(userRefKey) ?? 0) - 1,
    );
    const nextGlobalUserRefs = Math.max(
      0,
      (this.wsGlobalUserRefCounts.get(state.userKey) ?? 0) - 1,
    );

    this.wsConnectionCounts.set(labelKey, nextConnectionCount);
    if (nextUserRefs === 0) {
      this.wsUserRefCounts.delete(userRefKey);
      this.wsActiveUserCounts.set(
        labelKey,
        Math.max(0, (this.wsActiveUserCounts.get(labelKey) ?? 0) - 1),
      );
    } else {
      this.wsUserRefCounts.set(userRefKey, nextUserRefs);
    }

    if (nextGlobalUserRefs === 0) {
      this.wsGlobalUserRefCounts.delete(state.userKey);
    } else {
      this.wsGlobalUserRefCounts.set(state.userKey, nextGlobalUserRefs);
    }

    this.setWsGauges(labels);
    this.wsConnectionEventsTotal.inc({ ...labels, event: 'disconnect' });
  }

  registerWsNamespace(namespace: string, server: Namespace): void {
    const normalizedNamespace = this.normalizeLabel(namespace, 'unknown');
    this.wsNamespaces.set(normalizedNamespace, server);
    this.syncRegisteredWsNamespaces();
  }

  onModuleDestroy() {
    clearInterval(this.eventLoopTimer);
    this.observeEventLoopDelay();
    this.eventLoopDelay.disable();
  }

  private observeEventLoopDelay(): void {
    this.eventLoopDelaySeconds.set(
      { quantile: 'p50' },
      this.eventLoopDelay.percentile(50) / 1_000_000_000,
    );
    this.eventLoopDelaySeconds.set(
      { quantile: 'p95' },
      this.eventLoopDelay.percentile(95) / 1_000_000_000,
    );
    this.eventLoopDelaySeconds.set(
      { quantile: 'p99' },
      this.eventLoopDelay.percentile(99) / 1_000_000_000,
    );
    this.eventLoopDelaySeconds.set(
      { quantile: 'max' },
      this.eventLoopDelay.max / 1_000_000_000,
    );
    this.eventLoopDelay.reset();
  }

  private normalizeLabel(value: string, fallback: string): string {
    const normalized = value
      .trim()
      .toLowerCase()
      .replace(/[^a-z0-9_-]/g, '_');
    return normalized || fallback;
  }

  private initializeWsLabels(): void {
    [
      ['user-chat', 'user'],
      ['partner-chat', 'health_partner'],
      ['partner-chat', 'employee'],
      ['chat-notifications', 'user'],
      ['chat-notifications', 'health_partner'],
      ['chat-notifications', 'employee'],
      ['notifications', 'user'],
      ['booking-events', 'user'],
      ['booking-events', 'health_partner'],
    ].forEach(([namespace, role]) => {
      const labels = { namespace, role };
      this.setWsGauges(labels);
    });
  }

  private async updateLoginCcuGauges(): Promise<void> {
    if (this.redisService) {
      try {
        const keys = await this.redisService.scanKeys(
          `${this.loginCcuRedisPrefix}:*`,
          500,
        );
        const roleCounts = new Map<string, number>();

        for (const key of keys) {
          const role = this.roleFromLoginCcuKey(key);
          roleCounts.set(role, (roleCounts.get(role) ?? 0) + 1);
        }

        this.setLoginCcuGauges(roleCounts, keys.length);
        return;
      } catch {
        // Fall back to the process-local cache when Redis is unavailable.
      }
    }

    const now = Date.now();
    const roleCounts = new Map<string, number>();
    let total = 0;

    for (const [key, lastSeenAt] of this.loginActiveUsersSeenAt.entries()) {
      if (now - lastSeenAt > this.loginCcuWindowMs) {
        this.loginActiveUsersSeenAt.delete(key);
        continue;
      }

      const [role] = key.split('\u0000');
      roleCounts.set(role, (roleCounts.get(role) ?? 0) + 1);
      total += 1;
    }

    this.setLoginCcuGauges(roleCounts, total);
  }

  private setLoginCcuGauges(
    roleCounts: Map<string, number>,
    total: number,
  ): void {
    for (const role of [
      'admin',
      'employee',
      'health_partner',
      'user',
      'unknown',
    ]) {
      this.loginActiveUsers.set({ role }, roleCounts.get(role) ?? 0);
    }
    for (const [role, count] of roleCounts.entries()) {
      this.loginActiveUsers.set({ role }, count);
    }
    this.loginActiveUsersTotal.set(total);
  }

  private loginCcuKey(role: string, userKey: string): string {
    return `${this.loginCcuRedisPrefix}:${role}:${encodeURIComponent(userKey)}`;
  }

  private roleFromLoginCcuKey(key: string): string {
    const prefix = `${this.loginCcuRedisPrefix}:`;
    if (!key.startsWith(prefix)) return 'unknown';

    const role = key.slice(prefix.length).split(':')[0];
    return role || 'unknown';
  }

  private syncRegisteredWsNamespaces(): void {
    if (this.wsNamespaces.size === 0) return;

    const connectionCounts = new Map<string, number>();
    const userRefCounts = new Map<string, number>();
    const activeUserCounts = new Map<string, number>();
    const globalUserRefCounts = new Map<string, number>();

    for (const [namespace, server] of this.wsNamespaces.entries()) {
      for (const socket of server.sockets.values()) {
        const user = socket.data?.user;
        const labels: WsLabels = {
          namespace,
          role: this.normalizeLabel(String(user?.role ?? 'unknown'), 'unknown'),
        };
        const socketKey = this.socketKey(socket.id, namespace);
        const userKey = this.userKey(user?.id, socketKey);
        const labelKey = this.wsLabelKey(labels);
        const userRefKey = this.wsUserRefKey(labels, userKey);

        connectionCounts.set(
          labelKey,
          (connectionCounts.get(labelKey) ?? 0) + 1,
        );
        const currentUserRefs = userRefCounts.get(userRefKey) ?? 0;
        userRefCounts.set(userRefKey, currentUserRefs + 1);
        if (currentUserRefs === 0) {
          activeUserCounts.set(
            labelKey,
            (activeUserCounts.get(labelKey) ?? 0) + 1,
          );
        }
        globalUserRefCounts.set(
          userKey,
          (globalUserRefCounts.get(userKey) ?? 0) + 1,
        );
      }
    }

    this.replaceMap(this.wsConnectionCounts, connectionCounts);
    this.replaceMap(this.wsUserRefCounts, userRefCounts);
    this.replaceMap(this.wsActiveUserCounts, activeUserCounts);
    this.replaceMap(this.wsGlobalUserRefCounts, globalUserRefCounts);

    this.initializeWsLabels();
    for (const labelKey of connectionCounts.keys()) {
      this.setWsGauges(this.labelsFromKey(labelKey));
    }
  }

  private setWsGauges(labels: WsLabels): void {
    const labelKey = this.wsLabelKey(labels);
    this.wsActiveConnections.set(
      labels,
      this.wsConnectionCounts.get(labelKey) ?? 0,
    );
    this.wsActiveUsers.set(labels, this.wsActiveUserCounts.get(labelKey) ?? 0);
    this.wsActiveConnectionsTotal.set(this.wsSocketStates.size);
    this.wsActiveUsersTotal.set(this.wsGlobalUserRefCounts.size);
  }

  private wsLabelKey(labels: WsLabels): string {
    return `${labels.namespace}\u0000${labels.role}`;
  }

  private wsUserRefKey(labels: WsLabels, userKey: string): string {
    return `${this.wsLabelKey(labels)}\u0000${userKey}`;
  }

  private socketKey(socketId: unknown, namespace?: string): string {
    const value = String(socketId ?? '').trim();
    const normalizedNamespace =
      namespace === undefined ? '' : this.normalizeLabel(namespace, 'unknown');
    return normalizedNamespace ? `${normalizedNamespace}\u0000${value}` : value;
  }

  private findSocketKey(socketId: unknown, namespace?: string): string {
    if (namespace !== undefined) {
      return this.socketKey(socketId, namespace);
    }

    const value = String(socketId ?? '').trim();
    if (this.wsSocketStates.has(value)) return value;

    for (const key of this.wsSocketStates.keys()) {
      if (key.endsWith(`\u0000${value}`)) return key;
    }

    return value;
  }

  private userKey(userId: unknown, socketKey: string): string {
    const value = String(userId ?? '').trim();
    return value || `socket:${socketKey}`;
  }

  private labelsFromKey(labelKey: string): WsLabels {
    const [namespace, role] = labelKey.split('\u0000');
    return {
      namespace: namespace || 'unknown',
      role: role || 'unknown',
    };
  }

  private replaceMap(
    target: Map<string, number>,
    source: Map<string, number>,
  ): void {
    target.clear();
    for (const [key, value] of source.entries()) {
      target.set(key, value);
    }
  }

  private parsePositiveInt(
    value: string | undefined,
    fallback: number,
  ): number {
    const parsed = Number(value);
    return Number.isInteger(parsed) && parsed > 0 ? parsed : fallback;
  }
}
