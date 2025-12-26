import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class LoggingMiddleware implements NestMiddleware {
  private readonly logger = new Logger('HTTP');

  use(req: Request, res: Response, next: NextFunction) {
    const { method, originalUrl, ip } = req;
    const userAgent = req.get('user-agent') || '';
    const startTime = Date.now();
    const accessToken = req.get('authorization') || '';
    const query = req.query;
    const params = req.params;
    const body = req.body;

    // Log request
    this.logger.log(
      `→ ${method} ${originalUrl} - ${ip} - ${userAgent}`,
    );
    this.logger.debug(`Access Token: ${accessToken}`);
    this.logger.debug(`Query: ${JSON.stringify(query)}`);
    this.logger.debug(`Params: ${JSON.stringify(params)}`);
    this.logger.debug(`Body: ${JSON.stringify(body)}`);

    // Capture response
    res.on('finish', () => {
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
}
