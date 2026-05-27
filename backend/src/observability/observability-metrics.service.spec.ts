import { ObservabilityMetricsService } from './observability-metrics.service';

describe('ObservabilityMetricsService', () => {
  let service: ObservabilityMetricsService;

  beforeEach(() => {
    service = new ObservabilityMetricsService();
  });

  afterEach(() => {
    service.onModuleDestroy();
  });

  it('records HTTP request count, error count, latency, and in-flight metrics', async () => {
    service.startHttpRequest({ method: 'GET', route: '/health' });
    service.finishHttpRequest(
      { method: 'GET', route: '/health', status_code: '200' },
      0.025,
    );
    service.startHttpRequest({ method: 'POST', route: '/auth/login' });
    service.finishHttpRequest(
      { method: 'POST', route: '/auth/login', status_code: '401' },
      0.05,
    );

    const metrics = await service.metrics();

    expect(metrics).toContain('healytics_http_requests_total');
    expect(metrics).toMatch(
      /healytics_http_requests_total\{[^}]*method="GET"[^}]*route="\/health"[^}]*status_code="200"[^}]*} 1/,
    );
    expect(metrics).toMatch(
      /healytics_http_errors_total\{[^}]*method="POST"[^}]*route="\/auth\/login"[^}]*status_code="401"[^}]*} 1/,
    );
    expect(metrics).toContain('healytics_http_request_duration_seconds_bucket');
    expect(metrics).toMatch(
      /healytics_http_in_flight_requests\{[^}]*method="GET"[^}]*route="\/health"[^}]*} 0/,
    );
  });

  it('tracks WebSocket connections and distinct CCU exactly by socket id', async () => {
    service.recordWsConnect('socket-1', 'user-chat', 'USER', 'user-1');
    service.recordWsConnect('socket-2', 'user-chat', 'USER', 'user-1');
    service.recordWsConnect('socket-3', 'user-chat', 'USER', 'user-2');
    service.recordWsDisconnect('socket-1');

    let metrics = await service.metrics();

    expect(metrics).toMatch(
      /healytics_ws_active_connections\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 2/,
    );
    expect(metrics).toMatch(
      /healytics_ws_active_users\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 2/,
    );
    expect(metrics).toMatch(/healytics_ws_active_connections_total\{[^}]*} 2/);
    expect(metrics).toMatch(/healytics_ws_active_users_total\{[^}]*} 2/);

    service.recordWsDisconnect('socket-2');
    service.recordWsDisconnect('socket-2');
    service.recordWsDisconnect('never-connected');

    metrics = await service.metrics();

    expect(metrics).toMatch(
      /healytics_ws_active_connections\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 1/,
    );
    expect(metrics).toMatch(
      /healytics_ws_active_users\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 1/,
    );
    expect(metrics).toMatch(/healytics_ws_active_connections_total\{[^}]*} 1/);
    expect(metrics).toMatch(/healytics_ws_active_users_total\{[^}]*} 1/);
  });

  it('tracks successful login users as 30-minute CCU fallback', async () => {
    await service.recordLoginCcu('ADMIN', 'admin-1');
    await service.recordLoginCcu('ADMIN', 'admin-1');
    await service.recordLoginCcu('USER', 'user-1');

    const metrics = await service.metrics();

    expect(metrics).toMatch(
      /healytics_login_active_users\{[^}]*role="admin"[^}]*} 1/,
    );
    expect(metrics).toMatch(
      /healytics_login_active_users\{[^}]*role="user"[^}]*} 1/,
    );
    expect(metrics).toMatch(/healytics_login_active_users_total\{[^}]*} 2/);
  });

  it('stores login CCU in Redis with the configured TTL when cache is available', async () => {
    const redisService = {
      set: jest.fn().mockResolvedValue(undefined),
      scanKeys: jest
        .fn()
        .mockResolvedValue([
          'metrics:login-ccu:admin:admin-1',
          'metrics:login-ccu:user:user-1',
        ]),
    };
    const cachedService = new ObservabilityMetricsService(redisService as any);

    await cachedService.recordLoginCcu('ADMIN', 'admin-1');
    const metrics = await cachedService.metrics();

    expect(redisService.set).toHaveBeenCalledWith(
      'metrics:login-ccu:admin:admin-1',
      expect.any(String),
      1800,
    );
    expect(redisService.scanKeys).toHaveBeenCalledWith(
      'metrics:login-ccu:*',
      500,
    );
    expect(metrics).toMatch(
      /healytics_login_active_users\{[^}]*role="admin"[^}]*} 1/,
    );
    expect(metrics).toMatch(
      /healytics_login_active_users\{[^}]*role="user"[^}]*} 1/,
    );
    expect(metrics).toMatch(/healytics_login_active_users_total\{[^}]*} 2/);

    cachedService.onModuleDestroy();
  });

  it('syncs CCU from live Socket.IO namespace sockets before export', async () => {
    const sockets = new Map<string, any>([
      [
        'socket-1',
        {
          id: 'socket-1',
          data: { user: { id: 'user-1', role: 'USER' } },
        },
      ],
      [
        'socket-2',
        {
          id: 'socket-2',
          data: { user: { id: 'user-1', role: 'USER' } },
        },
      ],
      [
        'socket-3',
        {
          id: 'socket-3',
          data: { user: { id: 'user-2', role: 'USER' } },
        },
      ],
    ]);

    service.registerWsNamespace('user-chat', { sockets } as any);

    let metrics = await service.metrics();

    expect(metrics).toMatch(
      /healytics_ws_active_connections\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 3/,
    );
    expect(metrics).toMatch(
      /healytics_ws_active_users\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 2/,
    );

    sockets.delete('socket-1');
    sockets.delete('socket-2');

    metrics = await service.metrics();

    expect(metrics).toMatch(
      /healytics_ws_active_connections\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 1/,
    );
    expect(metrics).toMatch(
      /healytics_ws_active_users\{[^}]*namespace="user-chat"[^}]*role="user"[^}]*} 1/,
    );
  });
});
