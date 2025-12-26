import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import {
  createTestApp,
  closeTestApp,
} from '../../helpers/test-utils';
import { createSurveyDto } from '../../fixtures/test-data.factory';

describe('Auth + Survey (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    app = await createTestApp();
  });

  afterAll(async () => {
    await closeTestApp(app);
  });

  it('full auth flow and one-shot survey', async () => {
    const email = `e2e+${Date.now()}@example.com`;
    const password = 's3cureP@ssw0rd';

    // Register
    const regRes = await request(app.getHttpServer())
      .post('/auth/register')
      .send({ email, password });
    expect([200, 201]).toContain(regRes.status);
    expect(regRes.body).toHaveProperty('access_token');
    expect(regRes.body).toHaveProperty('refresh_token');

    // Login
    const loginRes = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email, password });
    expect([200, 201]).toContain(loginRes.status);
    expect(loginRes.body).toHaveProperty('access_token');
    expect(loginRes.body).toHaveProperty('refresh_token');

    const access = loginRes.body.access_token;
    const refresh = loginRes.body.refresh_token;

    // Create survey (one-shot)
    const surveyPayload = createSurveyDto({ q1: 'a1', q2: 2 });
    const postRes = await request(app.getHttpServer())
      .post('/account/survey')
      .set('Authorization', `Bearer ${access}`)
      .send(surveyPayload);
    expect([200, 201]).toContain(postRes.status);
    expect(postRes.body).toHaveProperty('survey');
    expect(postRes.body.survey).toMatchObject(surveyPayload.survey);

    // Second POST should conflict
    const postRes2 = await request(app.getHttpServer())
      .post('/account/survey')
      .set('Authorization', `Bearer ${access}`)
      .send(surveyPayload);
    expect(postRes2.status).toBe(409);

    // Get survey
    const getRes = await request(app.getHttpServer())
      .get('/account/survey')
      .set('Authorization', `Bearer ${access}`);
    expect([200, 201]).toContain(getRes.status);
    expect(getRes.body).toHaveProperty('survey');
    expect(getRes.body.survey).toMatchObject(surveyPayload.survey);

    // Refresh tokens
    const refreshRes = await request(app.getHttpServer())
      .post('/auth/refresh')
      .send({ refresh_token: refresh });
    if ([200, 201].includes(refreshRes.status)) {
      expect(refreshRes.body).toHaveProperty('access_token');
      expect(refreshRes.body).toHaveProperty('refresh_token');
    } else {
      expect(refreshRes.status).toBe(401);
    }

    // Logout - revoke refresh
    const logoutRes = await request(app.getHttpServer())
      .post('/auth/logout')
      .set('Authorization', `Bearer ${access}`);
    expect([200, 201]).toContain(logoutRes.status);
    expect(logoutRes.body).toHaveProperty('message');

    // Using old refresh token should now fail
    const refreshRes2 = await request(app.getHttpServer())
      .post('/auth/refresh')
      .send({ refresh_token: refresh });
    expect(refreshRes2.status).toBeGreaterThanOrEqual(400);
  }, 30000);
});
