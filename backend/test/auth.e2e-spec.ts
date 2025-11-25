import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Auth (e2e)', () => {
  let app: INestApplication;
  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('register -> login -> logout flow', async () => {
    const email = `test+${Date.now()}@example.com`;
    const password = 's3cureP@ssw0rd';

    // register
    const regRes = await request(app.getHttpServer())
      .post('/auth/register')
      .send({ email, password });
    expect([200, 201]).toContain(regRes.status);

    // login
    const loginRes = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email, password });
    expect([200, 201]).toContain(loginRes.status);
    expect(loginRes.body).toHaveProperty('access_token');
    const access = loginRes.body.access_token;

    // logout with access token
    const logoutRes = await request(app.getHttpServer())
      .post('/auth/logout')
      .set('Authorization', `Bearer ${access}`);
    expect([200, 201]).toContain(logoutRes.status);
    expect(logoutRes.body).toHaveProperty('message');
  }, 20000);
});
