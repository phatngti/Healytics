import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from '@/common/filters/all-exceptions.filter';
import { ValidationPipe, Logger, LogLevel } from '@nestjs/common';
import helmet from 'helmet';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import fs from 'fs';
import path from 'path';
import express, { Request, Response } from 'express';
import { RedisIoAdapter } from '@/common/adapters/redis-io.adapter';
import { TestBackdoorModule } from './test-backdoor/test-backdoor.module';
import { config } from 'dotenv';

// Load .env BEFORE anything else so process.env is populated
config({
  path: process.env.NODE_ENV === 'test' ? '.env.test' : '.env',
});

async function bootstrap() {
  const logLevels: LogLevel[] =
    process.env.PERF_MODE === 'true' || process.env.NODE_ENV === 'production'
      ? ['error', 'warn', 'log']
      : ['log', 'error', 'warn', 'debug', 'verbose'];

  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    logger: logLevels,
    bodyParser: false,
  });

  // app.use(
  //   session({
  //     secret: process.env.SESSION_SECRET || 'dev-secret',
  //     resave: false,
  //     saveUninitialized: false,
  //     cookie: { secure: false },
  //   }),
  // );

  // ── Redis WebSocket Adapter (for horizontal scaling) ─────
  const redisIoAdapter = new RedisIoAdapter(app);
  await redisIoAdapter.connectToRedis({
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT || '6379', 10),
    password: process.env.REDIS_PASSWORD || undefined,
    username: process.env.REDIS_USERNAME || undefined,
    tls: process.env.REDIS_TLS === 'true',
  });
  app.useWebSocketAdapter(redisIoAdapter);

  app.enableCors();
  app.use(helmet());
  configureBodyParsers(app);

  // ── Serve the Jest HTML test report at /test-report (opt-in) ───
  if (process.env.SERVE_TEST_REPORT === 'true') {
    const reportPath = path.resolve(process.cwd(), 'test-report');
    console.log(`[test-report] __dirname=${__dirname} cwd=${process.cwd()} reportPath=${reportPath} exists=${fs.existsSync(reportPath)}`);
    if (fs.existsSync(reportPath)) {
      // Get the underlying Express instance and mount static middleware
      const httpAdapter = app.getHttpAdapter();
      httpAdapter.use('/test-report', express.static(reportPath) as any);
      // console.log(`Test report: http://localhost:${process.env.PORT ?? 8080}/test-report/`);
    }
  }

  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  app.useGlobalFilters(new AllExceptionsFilter());

  if (process.env.NODE_ENV == 'development') {
    const options = new DocumentBuilder()

      .setTitle('The Sync App API')
      .setDescription('This a the project document')
      .setVersion('0.0.1')
      .addBearerAuth()
      .addApiKey(
        {
          type: 'apiKey',
          name: 'X-AI-API-Key',
          in: 'header',
          description: 'AI Service API Token',
        },
        'X-AI-API-Key',
      )
      .build();
    const document = SwaggerModule.createDocument(app, options);
    const openapiPath = __dirname + '/../../openapi/';
    // 2. Write the file to the root directory
    if (!fs.existsSync(openapiPath)) {
      fs.mkdirSync(openapiPath, { recursive: true });
    }
    fs.writeFileSync(
      openapiPath + 'openapi.json',
      JSON.stringify(document, null, 2),
    );

    // ── Test Backdoor spec (separate file for Patrol / integration tests) ──
    const testBackdoorOptions = new DocumentBuilder()
      .setTitle('Healytics Test Backdoor API')
      .setDescription(
        'Endpoints used exclusively by Patrol / integration tests to seed and reset the test database.',
      )
      .setVersion('1.0.0')
      .build();
    const testBackdoorDocument = SwaggerModule.createDocument(
      app,
      testBackdoorOptions,
      { include: [TestBackdoorModule] },
    );
    fs.writeFileSync(
      openapiPath + 'openapi-test.json',
      JSON.stringify(testBackdoorDocument, null, 2),
    );

    SwaggerModule.setup('/api/docs', app, document, {
      swaggerOptions: { tagsSorter: 'alpha' },
    });
    console.log(`Docs: http://localhost:${process.env.PORT ?? 8080}/api/docs`);
  }

  // ── RabbitMQ Microservice Consumer ───────────────────────
  const rmqUrl =
    process.env.RABBITMQ_URL ||
    'amqps://backend:backend%40rmq123@localhost:5671/healytics';
  const rmqQueue = process.env.RABBITMQ_QUEUE_CHECKOUT || 'checkout_queue';

  // Build TLS socket options if cert env vars are provided
  const caCert = process.env.RABBITMQ_CA_CERT
    ? path.resolve(process.env.RABBITMQ_CA_CERT)
    : undefined;
  const clientCert = process.env.RABBITMQ_CLIENT_CERT
    ? path.resolve(process.env.RABBITMQ_CLIENT_CERT)
    : undefined;
  const clientKey = process.env.RABBITMQ_CLIENT_KEY
    ? path.resolve(process.env.RABBITMQ_CLIENT_KEY)
    : undefined;

  // NestJS v10 ServerRMQ passes socketOptions.connectionOptions
  // to amqp-connection-manager, which forwards them to tls.connect()
  const socketOptions =
    caCert && clientCert && clientKey
      ? {
          connectionOptions: {
            ca: [fs.readFileSync(caCert)],
            cert: fs.readFileSync(clientCert),
            key: fs.readFileSync(clientKey),
            rejectUnauthorized: false,
          },
        }
      : undefined;

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.RMQ,
    options: {
      urls: [rmqUrl],
      queue: rmqQueue,
      queueOptions: { durable: true },
      noAck: false,
      prefetchCount: 1,
      socketOptions,
    },
  });

  await app.startAllMicroservices();
  const logger = new Logger('Bootstrap');
  logger.log(`RabbitMQ consumer started on queue: ${rmqQueue}`);

  await app.listen(process.env.PORT ?? 8080);
}

function configureBodyParsers(app: NestExpressApplication) {
  const captureRawBody = (
    req: Request & { rawBody?: Buffer },
    _res: Response,
    buffer: Buffer,
  ) => {
    if (buffer?.length) {
      req.rawBody = buffer;
    }
  };

  const stripeRawParser = express.raw({
    type: 'application/json',
    limit: process.env.STRIPE_WEBHOOK_BODY_LIMIT || '2mb',
    verify: captureRawBody,
  });

  // Keep raw body capture scoped to Stripe signature verification.
  app.use('/stripe/webhook', stripeRawParser);
  app.use('/v1/stripe/webhook', stripeRawParser);
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
}

bootstrap();
