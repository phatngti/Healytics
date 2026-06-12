import { Controller, Get, Headers, Res } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { SkipThrottle } from '@nestjs/throttler';
import { Response } from 'express';
import { timingSafeEqual } from 'crypto';
import { Public } from '@/common/decorators/auth/public.decorator';
import { ObservabilityMetricsService } from './observability-metrics.service';

@ApiTags('Observability')
@Controller('metrics')
@Public()
@SkipThrottle()
export class MetricsController {
  constructor(private readonly metricsService: ObservabilityMetricsService) {}

  @Get()
  @ApiOkResponse({ description: 'Prometheus metrics scrape endpoint.' })
  async collect(
    @Headers('authorization') authorization: string | undefined,
    @Res() response: Response,
  ) {
    if (!this.isAuthorized(authorization)) {
      return response.status(401).send('Unauthorized');
    }

    response.setHeader('Content-Type', this.metricsService.contentType);
    return response.send(await this.metricsService.metrics());
  }

  private isAuthorized(authorization: string | undefined): boolean {
    const token = process.env.METRICS_BEARER_TOKEN;
    const shouldEnforce =
      process.env.NODE_ENV === 'production' || Boolean(token);

    if (!shouldEnforce) {
      return true;
    }

    if (!token || !authorization?.startsWith('Bearer ')) {
      return false;
    }

    const provided = authorization.slice('Bearer '.length);
    return this.safeEqual(provided, token);
  }

  private safeEqual(provided: string, expected: string): boolean {
    const providedBuffer = Buffer.from(provided);
    const expectedBuffer = Buffer.from(expected);

    return (
      providedBuffer.length === expectedBuffer.length &&
      timingSafeEqual(providedBuffer, expectedBuffer)
    );
  }
}
