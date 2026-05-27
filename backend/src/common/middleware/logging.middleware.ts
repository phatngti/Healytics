import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class LoggingMiddleware implements NestMiddleware {
  private readonly logger = new Logger('HTTP');
  private readonly accessLogEnabled =
    process.env.HTTP_ACCESS_LOG_ENABLED === 'true';
  private readonly bodyLogEnabled =
    process.env.HTTP_BODY_LOG_ENABLED === 'true';
  private readonly sampleRate = this.parseSampleRate(
    process.env.HTTP_LOG_SAMPLE_RATE,
  );

  use(req: Request, res: Response, next: NextFunction) {
    const { method, originalUrl, ip } = req;
    const startTime = Date.now();
    const shouldLog = this.accessLogEnabled && Math.random() < this.sampleRate;

    if (shouldLog) {
      const userAgent = req.get('user-agent') || '';
      this.logger.log(`→ ${method} ${originalUrl} - ${ip} - ${userAgent}`);

      if (this.bodyLogEnabled) {
        this.logRequestDetails(req);
      }
    }

    res.on('finish', () => {
      if (!shouldLog) {
        return;
      }

      const { statusCode } = res;
      const contentLength = res.get('content-length') || 0;
      const duration = Date.now() - startTime;

      const logMessage = `← ${method} ${originalUrl} ${statusCode} - ${contentLength}b - ${duration}ms`;

      // Color-code based on status
      if (statusCode >= 500) {
        this.logger.error(logMessage);
      } else if (statusCode >= 400) {
        this.logger.warn(logMessage);
      } else {
        this.logger.log(logMessage);
      }
    });

    next();
  }

  private parseSampleRate(value?: string): number {
    if (value === undefined) {
      return 1;
    }

    const parsed = Number(value);
    if (!Number.isFinite(parsed)) {
      return 1;
    }

    return Math.min(1, Math.max(0, parsed));
  }

  private logRequestDetails(req: Request) {
    const fields: Array<[string, unknown]> = [
      ['query', req.query],
      ['body', req.body],
      ['params', req.params],
    ];

    for (const [key, value] of fields) {
      if (value && JSON.stringify(value) !== '{}') {
        this.logger.debug(`${key}: ${JSON.stringify(value)}`);
      }
    }
  }
}
