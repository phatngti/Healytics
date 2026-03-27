import { INestApplication } from '@nestjs/common';
import {
  createTestApp,
  closeTestApp,
  authenticateTestUser,
  authRequest,
} from '../../helpers/test-utils';
import {
  createAsyncCheckoutDto,
  createMicroLockDto,
  FAKE_UUID,
} from '../../fixtures/test-data.factory';

describe('Booking (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;

  beforeAll(async () => {
    app = await createTestApp();
    const auth = await authenticateTestUser(app, 'booking-test');
    accessToken = auth.accessToken;
  }, 30000);

  afterAll(async () => {
    await closeTestApp(app);
  });

  // ── POST /slots/micro-lock ──────────────────────────────

  describe('POST /slots/micro-lock', () => {
    it('should acquire a micro-lock and return lock result', async () => {
      const dto = createMicroLockDto();

      const res = await authRequest(app, accessToken)
        .post('/slots/micro-lock')
        .send(dto);

      expect(res.status).toBe(201); // POST default in NestJS
      expect(res.body).toHaveProperty('locked');
      expect(res.body).toHaveProperty('expiresIn');
      expect(typeof res.body.locked).toBe('boolean');
      expect(typeof res.body.expiresIn).toBe('number');
    });

    it('should fail without authentication', async () => {
      const dto = createMicroLockDto();

      const res = await authRequest(app, '')
        .post('/slots/micro-lock')
        .send(dto);

      expect(res.status).toBe(401);
    });
  });

  // ── POST /bookings/async-checkout ───────────────────────
  // NOTE: These tests require seeded user/staff/employee records in the database.
  // The FK constraint on checkout_tickets references accounts and employees tables.
  // Run these only in environments with seeded test data.

  describe('POST /bookings/async-checkout', () => {
    it('should validate DTO and reject invalid payload', async () => {
      const res = await authRequest(app, accessToken)
        .post('/bookings/async-checkout')
        .send({ invalid: true });

      expect(res.status).toBe(400);
    });

    it('should fail without authentication', async () => {
      const dto = createAsyncCheckoutDto();

      const res = await authRequest(app, '')
        .post('/bookings/async-checkout')
        .send(dto);

      expect(res.status).toBe(401);
    });
  });

  // ── GET /bookings/tickets/:id ───────────────────────────

  describe('GET /bookings/tickets/:id', () => {
    it('should return 404 for non-existent ticket', async () => {
      const res = await authRequest(app, accessToken)
        .get(`/bookings/tickets/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });

    it('should return 400 for non-UUID ticket ID', async () => {
      const res = await authRequest(app, accessToken)
        .get('/bookings/tickets/not-a-uuid');

      expect(res.status).toBe(400);
    });
  });

  // ── GET /bookings ───────────────────────────────────────

  describe('GET /bookings', () => {
    it('should return paginated bookings list', async () => {
      const res = await authRequest(app, accessToken)
        .get(`/bookings?page=1&limit=10&userId=${FAKE_UUID}`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.body)).toBe(true);
    });

    it('should fail without authentication', async () => {
      const res = await authRequest(app, '')
        .get('/bookings');

      expect(res.status).toBe(401);
    });
  });

  // ── GET /bookings/:id ───────────────────────────────────

  describe('GET /bookings/:id', () => {
    it('should return 404 for non-existent booking', async () => {
      const res = await authRequest(app, accessToken)
        .get(`/bookings/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });

    it('should return 400 for non-UUID booking ID', async () => {
      const res = await authRequest(app, accessToken)
        .get('/bookings/not-a-uuid');

      expect(res.status).toBe(400);
    });
  });
});
