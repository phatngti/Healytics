import { NestFactory } from '@nestjs/core';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Module } from '@nestjs/common';
import databaseConfig from '@/config/database.config';
import { SeederModule } from './seeder.module';
import { SeederService } from './seeder.service';

/**
 * Root module for the standalone seed CLI.
 * Bootstraps TypeORM with the same database config as the main app,
 * then imports SeederModule to provide all seeders.
 */
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
      load: [databaseConfig],
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
          synchronize: false,
          ssl: db.ssl,
        } as const;
      },
    }),
    SeederModule,
  ],
})
class SeedAppModule {}

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(SeedAppModule);
  const isClear = process.argv.includes('--clear');
  const isClearAll = process.argv.includes('--clear-all');

  try {
    const seeder = app.get(SeederService);

    if (isClearAll) {
      await seeder.clearAll();
    } else if (isClear) {
      await seeder.clear();
    } else {
      await seeder.seed();
    }
  } catch (error) {
    const label = isClearAll
      ? '❌ Clear-all failed:'
      : isClear
        ? '❌ Clearing failed:'
        : '❌ Seeding failed:';
    console.error(label, error);
    process.exitCode = 1;
  } finally {
    await app.close();
  }
}

bootstrap();
