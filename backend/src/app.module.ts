import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { APP_INTERCEPTOR, DiscoveryModule } from '@nestjs/core';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ThrottlerModule } from '@nestjs/throttler';
import { AccountModule } from './account/account.module';
import { AuthModule } from './auth/auth.module';
import { EmployeesModule } from './employees/employees.module';
import { CategoriesModule } from './categories/categories.module';
import { HealthServiceModule } from './health-service/health-service.module';
import { ServiceTagsModule } from './service-tags/service-tags.module';
import { S3Module } from './s3/s3.module';
import { LocationsModule } from './locations/locations.module';
import { PartnersModule } from './partners/partners.module';
import { AdminModule } from './admin/admin.module';
import { RedisModule } from './redis/redis.module';
import { RabbitMQModule } from './rabbitmq/rabbitmq.module';
import { BookingModule } from './booking/booking.module';
import { MapboxModule } from './mapbox/mapbox.module';
import { AppointmentModule } from './appointment/appointment.module';
import { AiServiceModule } from './ai-service/ai-service.module';
import { ReviewModule } from './review/review.module';
import { PaymentGatewayModule } from './payment-gateway/payment-gateway.module';
import { ChatModule } from './chat/chat.module';
import { NotificationModule } from './notification/notification.module';
import { CartModule } from './cart/cart.module';
import { ClinicModule } from './clinic/clinic.module';
import databaseConfig from './config/database.config';
import redisConfig from './config/redis.config';
import rabbitmqConfig from './config/rabbitmq.config';
import mapboxConfig from './config/mapbox.config';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { LoggingMiddleware } from './common/middleware/logging.middleware';
import { ResponseInterceptor } from './common/interceptors/response.interceptor';
import { PublicThrottlerGuard } from './common/guards';
import { WsContractBootstrapService } from './common/services/ws-contract-bootstrap.service';

@Module({
  imports: [
    DiscoveryModule,
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
      load: [databaseConfig, redisConfig, rabbitmqConfig, mapboxConfig],
    }),
    // Rate limiting: 100 requests per 60 seconds for public routes
    ThrottlerModule.forRoot([
      {
        ttl: 60000,
        limit: 100,
      },
    ]),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const db = configService.get('database') as Record<string, any>;
        return {
          type: 'postgres',
          host: db.host,
          port: db.port,
          username: db.username,
          password: db.password,
          database: db.database,
          entities: db.entities,
          synchronize: db.synchronize || process.env.NODE_ENV === 'development',
          ssl: db.ssl,
        } as const;
      },
    }),
    RedisModule,
    RabbitMQModule,
    AuthModule,
    AccountModule,
    EmployeesModule,
    CategoriesModule,
    HealthServiceModule,
    ServiceTagsModule,
    S3Module,
    LocationsModule,
    PartnersModule,
    AdminModule,
    BookingModule,
    MapboxModule,
    AppointmentModule,
    AiServiceModule,
    ReviewModule,
    PaymentGatewayModule,
    ChatModule,
    NotificationModule,
    CartModule,
    ClinicModule,
  ],
  providers: [
    {
      provide: 'APP_GUARD',
      useClass: JwtAuthGuard,
    },
    {
      provide: 'APP_GUARD',
      useClass: PublicThrottlerGuard,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: ResponseInterceptor,
    },
    WsContractBootstrapService,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply logging middleware to all routes
    consumer.apply(LoggingMiddleware).forRoutes('*');
  }
}
