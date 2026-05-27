import { Global, Module } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { MetricsController } from './metrics.controller';
import { ObservabilityHttpMetricsInterceptor } from './observability-http-metrics.interceptor';
import { ObservabilityMetricsService } from './observability-metrics.service';

@Global()
@Module({
  controllers: [MetricsController],
  providers: [
    ObservabilityMetricsService,
    {
      provide: APP_INTERCEPTOR,
      useClass: ObservabilityHttpMetricsInterceptor,
    },
  ],
  exports: [ObservabilityMetricsService],
})
export class ObservabilityModule {}
