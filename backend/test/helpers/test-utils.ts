import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../../src/app.module';

/**
 * Creates and initializes a NestJS test application
 * @returns Initialized NestJS application instance
 */
export async function createTestApp(): Promise<INestApplication> {
  const moduleFixture: TestingModule = await Test.createTestingModule({
    imports: [AppModule],
  }).compile();

  const app = moduleFixture.createNestApplication();
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  await app.init();
  return app;
}

/**
 * Closes the test application properly
 * @param app - NestJS application instance to close
 */
export async function closeTestApp(app: INestApplication): Promise<void> {
  if (app) {
    await app.close();
  }
}

/**
 * Authentication result containing access token
 */
export interface AuthResult {
  accessToken: string;
  refreshToken?: string;
  email: string;
}

/**
 * Registers and logs in a test user
 * @param app - NestJS application instance
 * @param emailPrefix - Optional prefix for the test email (default: 'test')
 * @returns Authentication result with access token
 */
export async function authenticateTestUser(
  app: INestApplication,
  emailPrefix = 'test',
): Promise<AuthResult> {
  const email = `${emailPrefix}+${Date.now()}@example.com`;
  const password = 's3cureP@ssw0rd';

  // Register user (uses new endpoint, falls back to legacy)
  await request(app.getHttpServer())
    .post('/auth/user/register')
    .send({ email, password });

  // Login to get tokens (uses new endpoint, falls back to legacy)
  const loginRes = await request(app.getHttpServer())
    .post('/auth/user/login')
    .send({ email, password });

  return {
    accessToken: loginRes.body.access_token,
    refreshToken: loginRes.body.refresh_token,
    email,
  };
}

/**
 * Makes an authenticated request
 * @param app - NestJS application instance
 * @param accessToken - JWT access token
 */
export function authRequest(app: INestApplication, accessToken: string) {
  return {
    get: (url: string) =>
      request(app.getHttpServer())
        .get(url)
        .set('Authorization', `Bearer ${accessToken}`),

    post: (url: string) =>
      request(app.getHttpServer())
        .post(url)
        .set('Authorization', `Bearer ${accessToken}`),

    patch: (url: string) =>
      request(app.getHttpServer())
        .patch(url)
        .set('Authorization', `Bearer ${accessToken}`),

    delete: (url: string) =>
      request(app.getHttpServer())
        .delete(url)
        .set('Authorization', `Bearer ${accessToken}`),
  };
}
