import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import {
  createTestApp,
  closeTestApp,
} from '../helpers/test-utils';

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    app = await createTestApp();
  });

  afterAll(async () => {
    await closeTestApp(app);
  });

  it('/ (GET) - should return 404 for undefined root route', () => {
    return request(app.getHttpServer())
      .get('/')
      .expect(404);
  });
});
