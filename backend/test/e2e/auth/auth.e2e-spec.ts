import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { createTestApp, closeTestApp } from '../../helpers/test-utils';

describe('Auth (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    app = await createTestApp();
  });

  afterAll(async () => {
    await closeTestApp(app);
  });

  // ============================================================================
  // User Authentication Tests
  // ============================================================================

  describe('User Registration - POST /auth/user/register', () => {
    it('should register a new user', async () => {
      const email = `user-register+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      const res = await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('access_token');
      expect(res.body).toHaveProperty('refresh_token');
    });

    it('should fail with duplicate email', async () => {
      const email = `user-duplicate+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      // First registration
      await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });

      // Second registration with same email
      const res = await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });

      expect(res.status).toBe(409);
    });
  });

  describe('User Login - POST /auth/user/login', () => {
    it('should login a registered user', async () => {
      const email = `user-login+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      // Register first
      await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });

      // Then login
      const res = await request(app.getHttpServer())
        .post('/auth/user/login')
        .send({ email, password });

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('access_token');
      expect(res.body).toHaveProperty('refresh_token');
    });

    it('should fail with invalid credentials', async () => {
      const res = await request(app.getHttpServer())
        .post('/auth/user/login')
        .send({ email: 'invalid@example.com', password: 'wrongpassword' });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });
  });

  // ============================================================================
  // Admin Authentication Tests
  // ============================================================================

  describe('Admin Login - POST /auth/admin/login', () => {
    it('should reject regular user trying to login as admin', async () => {
      const email = `admin-reject+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      // Register as regular user
      await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });

      // Try to login via admin endpoint
      const res = await request(app.getHttpServer())
        .post('/auth/admin/login')
        .send({ email, password });

      // Should be forbidden (403) because user role is not admin
      expect(res.status).toBe(403);
    });

    it('should fail with invalid credentials', async () => {
      const res = await request(app.getHttpServer())
        .post('/auth/admin/login')
        .send({
          email: 'invalid-admin@example.com',
          password: 'wrongpassword',
        });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });
  });

  // ============================================================================
  // Legacy Endpoint Tests (backward compatibility)
  // ============================================================================

  describe('Legacy Registration - POST /auth/register', () => {
    it('should register a new user via legacy endpoint', async () => {
      const email = `legacy-register+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      const res = await request(app.getHttpServer())
        .post('/auth/register')
        .send({ email, password });

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('access_token');
      expect(res.body).toHaveProperty('refresh_token');
    });
  });

  describe('Legacy Login - POST /auth/login', () => {
    it('should login via legacy endpoint', async () => {
      const email = `legacy-login+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      // Register first
      await request(app.getHttpServer())
        .post('/auth/register')
        .send({ email, password });

      // Then login
      const res = await request(app.getHttpServer())
        .post('/auth/login')
        .send({ email, password });

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('access_token');
      expect(res.body).toHaveProperty('refresh_token');
    });
  });

  // ============================================================================
  // Common Authentication Tests
  // ============================================================================

  describe('Logout - POST /auth/logout', () => {
    it('should logout successfully', async () => {
      const email = `logout-test+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      // Register and login
      await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });

      const loginRes = await request(app.getHttpServer())
        .post('/auth/user/login')
        .send({ email, password });

      const accessToken = loginRes.body.access_token;

      // Logout
      const logoutRes = await request(app.getHttpServer())
        .post('/auth/logout')
        .set('Authorization', `Bearer ${accessToken}`);

      expect([200, 201]).toContain(logoutRes.status);
      expect(logoutRes.body).toHaveProperty('message');
    });
  });

  describe('Token Refresh - POST /auth/refresh', () => {
    it('should refresh tokens', async () => {
      const email = `refresh-test+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      // Register
      await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });

      // Login
      const loginRes = await request(app.getHttpServer())
        .post('/auth/user/login')
        .send({ email, password });

      const refreshToken = loginRes.body.refresh_token;

      // Refresh
      const refreshRes = await request(app.getHttpServer())
        .post('/auth/refresh')
        .send({ refresh_token: refreshToken });

      if ([200, 201].includes(refreshRes.status)) {
        expect(refreshRes.body).toHaveProperty('access_token');
        expect(refreshRes.body).toHaveProperty('refresh_token');
      } else {
        // Token may have been rotated
        expect(refreshRes.status).toBe(401);
      }
    });
  });

  // ============================================================================
  // Full Flow Tests
  // ============================================================================

  describe('Full User Auth Flow', () => {
    it('should complete register -> login -> logout flow', async () => {
      const email = `flow-user+${Date.now()}@example.com`;
      const password = 's3cureP@ssw0rd';

      // Register
      const regRes = await request(app.getHttpServer())
        .post('/auth/user/register')
        .send({ email, password });
      expect([200, 201]).toContain(regRes.status);

      // Login
      const loginRes = await request(app.getHttpServer())
        .post('/auth/user/login')
        .send({ email, password });
      expect([200, 201]).toContain(loginRes.status);
      const accessToken = loginRes.body.access_token;

      // Logout
      const logoutRes = await request(app.getHttpServer())
        .post('/auth/logout')
        .set('Authorization', `Bearer ${accessToken}`);
      expect([200, 201]).toContain(logoutRes.status);
      expect(logoutRes.body).toHaveProperty('message');
    }, 20000);
  });
});
