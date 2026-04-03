import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import { isEmpty } from 'class-validator';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class LoggingMiddleware implements NestMiddleware {
  private readonly logger = new Logger('HTTP');
  private readonly maxResponseBodyLength = 1024; // Truncate response body at 1KB

  use(req: Request, res: Response, next: NextFunction) {
    const { method, originalUrl, ip } = req;
    const userAgent = req.get('user-agent') || '';
    const startTime = Date.now();
    const accessToken = req.get('authorization') || '';
    const query = req.query;
    const params = req.params;
    const body = req.body;

    // Log request
    this.logger.log(`→ ${method} ${originalUrl} - ${ip} - ${userAgent}`);

    [
      ['access token', accessToken],
      ['query', query],
      ['body', body],
      ['params', params],
    ].map(([key, value]) => {
      if (JSON.stringify(value) !== '{}') {
        this.logger.debug(`${key}: ${JSON.stringify(value)}`);
      }
    });

    // Capture response body
    const chunks: Buffer[] = [];
    const originalWrite = res.write.bind(res);
    const originalEnd = res.end.bind(res);

    res.write = function (
      chunk: any,
      encodingOrCallback?:
        | BufferEncoding
        | ((error: Error | null | undefined) => void),
      callback?: (error: Error | null | undefined) => void,
    ): boolean {
      if (chunk) {
        if (Buffer.isBuffer(chunk)) {
          chunks.push(chunk);
        } else if (typeof chunk === 'string') {
          const encoding =
            typeof encodingOrCallback === 'string'
              ? encodingOrCallback
              : 'utf8';
          chunks.push(Buffer.from(chunk, encoding));
        }
      }
      return originalWrite.call(
        res,
        chunk,
        encodingOrCallback as BufferEncoding,
        callback,
      );
    } as typeof res.write;

    res.end = function (
      chunk?: any,
      encodingOrCallback?: BufferEncoding | (() => void),
      callback?: () => void,
    ): Response {
      if (chunk && typeof chunk !== 'function') {
        if (Buffer.isBuffer(chunk)) {
          chunks.push(chunk);
        } else if (typeof chunk === 'string') {
          const encoding =
            typeof encodingOrCallback === 'string'
              ? encodingOrCallback
              : 'utf8';
          chunks.push(Buffer.from(chunk, encoding));
        }
      }
      return originalEnd.call(
        res,
        chunk,
        encodingOrCallback as BufferEncoding,
        callback,
      );
    } as typeof res.end;

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
