import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import fs from 'fs';

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

  if (process.env.NODE_ENV == 'development') {
    const options = new DocumentBuilder()

      .setTitle('The Sync App API')
      .setDescription('This a the project document')
      .setVersion('0.0.1')
      .addBearerAuth()
      .build();
    const document = SwaggerModule.createDocument(app, options);
    const openapiPath = __dirname + '/../openapi/';
    // 2. Write the file to the root directory
    if (!fs.existsSync(openapiPath)) {
      fs.mkdirSync(openapiPath);
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

  await app.listen(process.env.PORT ?? 8080);
}

bootstrap();
