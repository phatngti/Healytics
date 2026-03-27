import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import {
  createTestApp,
  closeTestApp,
  authenticateTestUser,
  authRequest,
} from '../../helpers/test-utils';
import { createSurveyDto } from '../../fixtures/test-data.factory';

describe('Account (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;

  beforeAll(async () => {
    app = await createTestApp();
    const auth = await authenticateTestUser(app, 'account-test');
    accessToken = auth.accessToken;
  });

  afterAll(async () => {
    await closeTestApp(app);
  });

  describe('GET /account/survey', () => {
    it('should return null survey for new user', async () => {
      const res = await authRequest(app, accessToken).get('/account/survey');

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('survey');
      expect(res.body.survey).toBeNull();
    });

    it('should fail without authentication', async () => {
      const res = await request(app.getHttpServer()).get('/account/survey');

      expect(res.status).toBe(401);
    });
  });

  describe('POST /account/survey', () => {
    it('should create a survey for user', async () => {
      const surveyData = createSurveyDto();

      const res = await authRequest(app, accessToken)
        .post('/account/survey')
        .send(surveyData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('survey');
      expect(res.body.survey).toMatchObject(surveyData.survey);
    });

    it('should return conflict for duplicate survey', async () => {
      const surveyData = createSurveyDto({ healthGoals: ['improved_sleep'] });

      const res = await authRequest(app, accessToken)
        .post('/account/survey')
        .send(surveyData);

      expect(res.status).toBe(409);
    });

    it('should fail without authentication', async () => {
      const res = await request(app.getHttpServer())
        .post('/account/survey')
        .send(createSurveyDto());

      expect(res.status).toBe(401);
    });
  });

  describe('GET /account/survey after creation', () => {
    it('should return the created survey', async () => {
      const res = await authRequest(app, accessToken).get('/account/survey');

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('survey');
      expect(res.body.survey).not.toBeNull();
      expect(res.body.survey).toHaveProperty('healthGoals');
    });
  });
});
