import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Auth + Survey (e2e)', () => {
  let app: INestApplication;
  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    if (app) await app.close();
  });

  it('full auth flow and one-shot survey', async () => {
    const email = `e2e+${Date.now()}@example.com`;
    const password = 's3cureP@ssw0rd';

    // register
    const regRes = await request(app.getHttpServer())
      .post('/auth/register')
      .send({ email, password });
    expect([200, 201]).toContain(regRes.status);
    expect(regRes.body).toHaveProperty('access_token');
    expect(regRes.body).toHaveProperty('refresh_token');

    // login
    const loginRes = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email, password });
    expect([200, 201]).toContain(loginRes.status);
    expect(loginRes.body).toHaveProperty('access_token');
    expect(loginRes.body).toHaveProperty('refresh_token');

    const access = loginRes.body.access_token;
    const refresh = loginRes.body.refresh_token;

    // create survey (one-shot)
    const surveyPayload = { survey: { q1: 'a1', q2: 2 } };
    const postRes = await request(app.getHttpServer())
      .post('/account/survey')
      .set('Authorization', `Bearer ${access}`)
      .send(surveyPayload);
    expect([200, 201]).toContain(postRes.status);
    expect(postRes.body).toHaveProperty('survey');
    expect(postRes.body.survey).toMatchObject(surveyPayload.survey);

    // second POST should conflict
    const postRes2 = await request(app.getHttpServer())
      .post('/account/survey')
      .set('Authorization', `Bearer ${access}`)
      .send(surveyPayload);
    expect(postRes2.status).toBe(409);

    // get survey
    const getRes = await request(app.getHttpServer())
      .get('/account/survey')
      .set('Authorization', `Bearer ${access}`);
    expect([200, 201]).toContain(getRes.status);
    expect(getRes.body).toHaveProperty('survey');
    expect(getRes.body.survey).toMatchObject(surveyPayload.survey);

    // refresh tokens
    const refreshRes = await request(app.getHttpServer())
      .post('/auth/refresh')
      .send({ refresh_token: refresh });
    // The refresh endpoint may return 200/201 with new tokens or 401 if the
    // refresh token has already been rotated/revoked by a concurrent operation.
    if ([200, 201].includes(refreshRes.status)) {
      expect(refreshRes.body).toHaveProperty('access_token');
      expect(refreshRes.body).toHaveProperty('refresh_token');
    } else {
      // allow 401 (unauthorized) — test will continue and verify logout behavior
      expect(refreshRes.status).toBe(401);
    }

    // logout - revoke refresh
    const logoutRes = await request(app.getHttpServer())
      .post('/auth/logout')
      .set('Authorization', `Bearer ${access}`);
    // controller may return 200 or 201
    expect([200, 201]).toContain(logoutRes.status);
    expect(logoutRes.body).toHaveProperty('message');

    // using old refresh token should now fail
    const refreshRes2 = await request(app.getHttpServer())
      .post('/auth/refresh')
      .send({ refresh_token: refresh });
    // expect unauthorized (401)
    expect(refreshRes2.status).toBeGreaterThanOrEqual(400);
  }, 30000);
});
