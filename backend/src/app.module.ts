import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ThrottlerModule } from '@nestjs/throttler';
import { AccountModule } from './account/account.module';
import { AuthModule } from './auth/auth.module';
import { EmployeesModule } from './employees/employees.module';
import { CategoriesModule } from './categories/categories.module';
import { ProductsModule } from './products/products.module';
import { ServiceTagsModule } from './service-tags/service-tags.module';
import { S3Module } from './s3/s3.module';
import { LocationsModule } from './locations/locations.module';
import { PartnersModule } from './partners/partners.module';
import { AdminModule } from './admin/admin.module';
import databaseConfig from './config/database.config';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { LoggingMiddleware } from './common/middleware/logging.middleware';
import { ResponseInterceptor } from './common/interceptors/response.interceptor';
import { PublicThrottlerGuard } from './common/guards';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
      load: [databaseConfig],
    }),
    // Rate limiting: 100 requests per 60 seconds for public routes
    ThrottlerModule.forRoot([{
      ttl: 60000,
      limit: 100,
    }]),
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
        } as const;
      },
    }),
    AuthModule,
    AccountModule,
    EmployeesModule,
    CategoriesModule,
    ProductsModule,
    ServiceTagsModule,
    S3Module,
    LocationsModule,
    PartnersModule,
    AdminModule,
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
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply logging middleware to all routes
    consumer.apply(LoggingMiddleware).forRoutes('*');
  }
}
