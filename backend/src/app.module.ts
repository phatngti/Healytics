import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { APP_INTERCEPTOR, DiscoveryModule } from '@nestjs/core';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ThrottlerModule } from '@nestjs/throttler';
import { ThrottlerRedisStorage } from './common/storage/throttler-redis.storage';
import { REDIS_CLIENT } from './redis/redis.service';
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
import { WishlistModule } from './wishlist/wishlist.module';
import { ProfileModule } from './profile/profile.module';
import { DashboardPartnerModule } from './dashboard-partner/dashboard-partner.module';
import { PartnerFinanceModule } from './partner-finance/partner-finance.module';
import { HealthModule } from './health/health.module';
import { TestBackdoorModule } from './test-backdoor/test-backdoor.module';
import { SearchModule } from './search/search.module';
import databaseConfig from './config/database.config';
import redisConfig from './config/redis.config';
import rabbitmqConfig from './config/rabbitmq.config';
import mapboxConfig from './config/mapbox.config';
import elasticsearchConfig from './config/elasticsearch.config';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { LoggingMiddleware } from './common/middleware/logging.middleware';
import { ResponseInterceptor } from './common/interceptors/response.interceptor';
import { PerformanceMetricsInterceptor } from './common/interceptors/performance-metrics.interceptor';
import { PublicThrottlerGuard } from './common/guards';
import { WsContractBootstrapService } from './common/services/ws-contract-bootstrap.service';

const envFilePath =
  process.env.NODE_ENV === 'test' ? ['.env.test', '.env'] : '.env';

@Module({
  imports: [
    DiscoveryModule,
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath,
      load: [
        databaseConfig,
        redisConfig,
        rabbitmqConfig,
        mapboxConfig,
        elasticsearchConfig,
      ],
    }),
    // Rate limiting: 1000 requests per 60 seconds per tracker for public routes
    // Uses Redis storage for distributed state across instances
    // Target: 1000 CCU / 100 UPS — per-tracker bucket needs headroom
    ThrottlerModule.forRootAsync({
      useFactory: (redisClient) => ({
        throttlers: [
          {
            ttl: 60000,
            limit: 1000,
          },
        ],
        storage: new ThrottlerRedisStorage(redisClient),
      }),
      inject: [REDIS_CLIENT],
    }),
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
          synchronize: db.synchronize || false,
          ssl: db.ssl ? { rejectUnauthorized: false } : false,
          // Connection pool: sized for the auth-heavy perf profile.
          // Revisit per-process max before scaling API workers horizontally.
          extra: {
            max: 50, // max pool connections (default: 10)
            idleTimeoutMillis: 30000, // close idle connections after 30s
            connectionTimeoutMillis: 5000, // fail fast if pool exhausted
          },
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
    WishlistModule,
    ProfileModule,
    DashboardPartnerModule,
    PartnerFinanceModule,
    HealthModule,
    SearchModule,
    ...(process.env.NODE_ENV === 'test' ? [TestBackdoorModule] : []),
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
      useClass: PerformanceMetricsInterceptor,
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
