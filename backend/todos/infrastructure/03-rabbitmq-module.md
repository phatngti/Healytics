# 03 — RabbitMQ Module

**Status:** ✅ COMPLETED

## Context

RabbitMQ provides the async message queue for the booking checkout pipeline. Messages are published to a checkout queue and consumed by background workers.

## Prerequisites

- ✅ RabbitMQ server provisioned
- ✅ `@nestjs/microservices`, `amqplib`, `amqp-connection-manager` installed
- ✅ Env vars: `RABBITMQ_URL`, `RABBITMQ_QUEUE_CHECKOUT`

## Tasks

### 1. Create `src/rabbitmq/rabbitmq.module.ts`
```typescript
@Global()
@Module({
  providers: [
    {
      provide: 'RABBITMQ_CLIENT',
      useFactory: () =>
        ClientProxyFactory.create({
          transport: Transport.RMQ,
          options: {
            urls: [process.env.RABBITMQ_URL],
            queue: process.env.RABBITMQ_QUEUE_CHECKOUT,
            queueOptions: { durable: true },
          },
        }),
    },
  ],
  exports: ['RABBITMQ_CLIENT'],
})
```
Global module — `RABBITMQ_CLIENT` (ClientProxy) available everywhere.

### 2. Configure hybrid microservice in `main.ts`
```typescript
app.connectMicroservice({
  transport: Transport.RMQ,
  options: {
    urls: [process.env.RABBITMQ_URL],
    queue: process.env.RABBITMQ_QUEUE_CHECKOUT,
    queueOptions: { durable: true },
    noAck: false,
    prefetchCount: 1,
  },
});
await app.startAllMicroservices();
```

## Completed

Global RabbitMQ module with durable queue. Hybrid NestJS app configuration for both HTTP and message consumers. Used by booking module for async checkout flow.
