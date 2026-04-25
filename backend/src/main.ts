import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from '@/common/filters/all-exceptions.filter';
import { ValidationPipe, Logger } from '@nestjs/common';
import helmet from 'helmet';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import fs from 'fs';
import path from 'path';
import { RedisIoAdapter } from '@/common/adapters/redis-io.adapter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: ['log', 'error', 'warn', 'debug', 'verbose'],
    rawBody: true, // Required for Stripe webhook signature verification
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
  });
  app.useWebSocketAdapter(redisIoAdapter);

  app.enableCors();
  app.use(helmet());

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

bootstrap();
