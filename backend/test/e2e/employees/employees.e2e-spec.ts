import { INestApplication } from '@nestjs/common';
import {
  createTestApp,
  closeTestApp,
  authenticateTestUser,
  authRequest,
} from '../../helpers/test-utils';
import {
  createDoctorDto,
  createTherapistDto,
  createReceptionistDto,
  createManagerDto,
  FAKE_UUID,
} from '../../fixtures/test-data.factory';

describe('Employees (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;
  let createdEmployeeId: string;

  beforeAll(async () => {
    app = await createTestApp();
    const auth = await authenticateTestUser(app, 'employees-test');
    accessToken = auth.accessToken;
  });

  afterAll(async () => {
    await closeTestApp(app);
  });

  describe('POST /employees', () => {
    it('should create a new doctor employee', async () => {
      const employeeData = createDoctorDto();

      const res = await authRequest(app, accessToken)
        .post('/employees')
        .send(employeeData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.fullName).toBe(employeeData.fullName);
      expect(res.body.email).toBe(employeeData.email);
      expect(res.body.role).toBe(employeeData.role);

      createdEmployeeId = res.body.id;
    });

    it('should create a new therapist employee', async () => {
      const employeeData = createTherapistDto();

      const res = await authRequest(app, accessToken)
        .post('/employees')
        .send(employeeData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.role).toBe('THERAPIST');
    });

    it('should create a receptionist employee', async () => {
      const employeeData = createReceptionistDto();

      const res = await authRequest(app, accessToken)
        .post('/employees')
        .send(employeeData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.role).toBe('RECEPTIONIST');
    });

    it('should create a manager employee', async () => {
      const employeeData = createManagerDto();

      const res = await authRequest(app, accessToken)
        .post('/employees')
        .send(employeeData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.role).toBe('MANAGER');
    });

    it('should fail to create employee without required fields', async () => {
      const res = await authRequest(app, accessToken)
        .post('/employees')
        .send({});

      expect(res.status).toBeGreaterThanOrEqual(400);
    });

    it('should fail to create employee without role', async () => {
      const res = await authRequest(app, accessToken)
        .post('/employees')
        .send({
          employeeCode: 'TEST001',
          fullName: 'Test Employee',
          email: 'test@example.com',
        });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });

    it('should fail to create employee with invalid email', async () => {
      const res = await authRequest(app, accessToken)
        .post('/employees')
        .send({
          employeeCode: 'TEST002',
          fullName: 'Test Employee',
          email: 'invalid-email',
          role: 'RECEPTIONIST',
        });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });
  });

  describe('GET /employees', () => {
    it('should get all employees', async () => {
      const res = await authRequest(app, accessToken).get('/employees');

      expect([200, 201]).toContain(res.status);
      expect(Array.isArray(res.body)).toBe(true);
    });
  });

  describe('GET /employees/:id', () => {
    it('should get an employee by id', async () => {
      const res = await authRequest(app, accessToken).get(`/employees/${createdEmployeeId}`);

      expect([200, 201]).toContain(res.status);
      expect(res.body.id).toBe(createdEmployeeId);
    });

    it('should return 404 for non-existent employee', async () => {
      const res = await authRequest(app, accessToken).get(`/employees/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });
  });

  describe('PATCH /employees/:id', () => {
    it('should update an employee', async () => {
      const updateData = {
        displayName: 'Updated Display Name',
        phone: '+9999999999',
      };

      const res = await authRequest(app, accessToken)
        .patch(`/employees/${createdEmployeeId}`)
        .send(updateData);

      expect([200, 201]).toContain(res.status);
      expect(res.body.displayName).toBe(updateData.displayName);
      expect(res.body.phone).toBe(updateData.phone);
    });

    it('should update employee status to ON_LEAVE', async () => {
      const res = await authRequest(app, accessToken)
        .patch(`/employees/${createdEmployeeId}`)
        .send({ status: 'ON_LEAVE' });

      expect([200, 201]).toContain(res.status);
      expect(res.body.status).toBe('ON_LEAVE');
    });

    it('should update employee status back to ACTIVE', async () => {
      const res = await authRequest(app, accessToken)
        .patch(`/employees/${createdEmployeeId}`)
        .send({ status: 'ACTIVE' });

      expect([200, 201]).toContain(res.status);
      expect(res.body.status).toBe('ACTIVE');
    });

    it('should return 404 when updating non-existent employee', async () => {
      const res = await authRequest(app, accessToken)
        .patch(`/employees/${FAKE_UUID}`)
        .send({ displayName: 'Updated' });

      expect(res.status).toBe(404);
    });
  });

  describe('DELETE /employees/:id', () => {
    it('should delete an employee', async () => {
      const employeeData = createReceptionistDto({
        employeeCode: `EMP-DEL-${Date.now()}`,
        fullName: 'Employee To Delete',
        email: `delete.me+${Date.now()}@example.com`,
      });

      const createRes = await authRequest(app, accessToken)
        .post('/employees')
        .send(employeeData);

      const employeeToDeleteId = createRes.body.id;

      const res = await authRequest(app, accessToken).delete(`/employees/${employeeToDeleteId}`);

      expect([200, 201, 204]).toContain(res.status);

      // Verify deletion
      const getRes = await authRequest(app, accessToken).get(`/employees/${employeeToDeleteId}`);
      expect(getRes.status).toBe(404);
    });

    it('should return 404 when deleting non-existent employee', async () => {
      const res = await authRequest(app, accessToken).delete(`/employees/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });
  });
});
