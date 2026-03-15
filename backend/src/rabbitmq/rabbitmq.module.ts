import { Module, Global } from '@nestjs/common';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ConfigModule, ConfigService } from '@nestjs/config';
import rabbitmqConfig from '@/config/rabbitmq.config';
import fs from 'fs';

export const RABBITMQ_CLIENT = 'RABBITMQ_CLIENT';

@Global()
@Module({
  imports: [
    ConfigModule.forFeature(rabbitmqConfig),
    ClientsModule.registerAsync([
      {
        name: RABBITMQ_CLIENT,
        imports: [ConfigModule],
        inject: [ConfigService],
        useFactory: (configService: ConfigService) => {
          const cfg = configService.get('rabbitmq') as {
            url: string;
            checkoutQueue: string;
            caCert?: string;
            clientCert?: string;
            clientKey?: string;
          };

          // NestJS v10 passes socketOptions.connectionOptions
          // to amqp-connection-manager → tls.connect()
          const socketOptions =
            cfg.caCert && cfg.clientCert && cfg.clientKey
              ? {
                  connectionOptions: {
                    ca: [fs.readFileSync(cfg.caCert)],
                    cert: fs.readFileSync(cfg.clientCert),
                    key: fs.readFileSync(cfg.clientKey),
                    rejectUnauthorized: false,
                  },
                }
              : undefined;

          return {
            transport: Transport.RMQ,
            options: {
              urls: [cfg.url],
              queue: cfg.checkoutQueue,
              queueOptions: {
                durable: true, // survive broker restarts
              },
              noAck: false, // require manual acknowledgment
              prefetchCount: 1, // process one message at a time (FIFO)
              socketOptions,
            },
          };
        },
      },
    ]),
  ],
  exports: [ClientsModule],
})
export class RabbitMQModule {}
