import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import session = require('express-session');
import * as passport from 'passport';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // app.use(
  //   session({
  //     secret: process.env.SESSION_SECRET || 'dev-secret',
  //     resave: false,
  //     saveUninitialized: false,
  //     cookie: { secure: false },
  //   }),
  // );

  app.enableCors();
  app.use(helmet());

  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));

  await app.listen(process.env.PORT ?? 8080);
}

bootstrap();
