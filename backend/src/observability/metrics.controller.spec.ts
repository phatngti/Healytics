import { MetricsController } from './metrics.controller';
import { ObservabilityMetricsService } from './observability-metrics.service';

describe('MetricsController', () => {
  const originalEnv = { ...process.env };

  afterEach(() => {
    process.env = { ...originalEnv };
    jest.restoreAllMocks();
  });

  it('rejects metrics scrape requests without a bearer token in production', async () => {
    process.env.NODE_ENV = 'production';
    delete process.env.METRICS_BEARER_TOKEN;

    const controller = new MetricsController(metricsService());
    const response = responseMock();

    await controller.collect(undefined, response as any);

    expect(response.status).toHaveBeenCalledWith(401);
    expect(response.send).toHaveBeenCalledWith('Unauthorized');
  });

  it('returns Prometheus metrics when the production bearer token matches', async () => {
    process.env.NODE_ENV = 'production';
    process.env.METRICS_BEARER_TOKEN = 'test-secret';

    const controller = new MetricsController(metricsService());
    const response = responseMock();

    await controller.collect('Bearer test-secret', response as any);

    expect(response.setHeader).toHaveBeenCalledWith(
      'Content-Type',
      'text/plain; version=0.0.4; charset=utf-8',
    );
    expect(response.send).toHaveBeenCalledWith('metric_payload');
  });

  function metricsService(): ObservabilityMetricsService {
    return {
      contentType: 'text/plain; version=0.0.4; charset=utf-8',
      metrics: jest.fn().mockResolvedValue('metric_payload'),
    } as unknown as ObservabilityMetricsService;
  }

  function responseMock() {
    return {
      status: jest.fn().mockReturnThis(),
      setHeader: jest.fn(),
      send: jest.fn().mockReturnThis(),
    };
  }
});
