import { ForbiddenException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TestBackdoorService } from './test-backdoor.service';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';

describe('TestBackdoorService', () => {
  const originalNodeEnv = process.env.NODE_ENV;

  afterEach(() => {
    process.env.NODE_ENV = originalNodeEnv;
    jest.restoreAllMocks();
  });

  it('rejects access outside NODE_ENV=test', () => {
    process.env.NODE_ENV = 'development';
    const service = new TestBackdoorService(
      makeDataSource({ database: 'healytics_test' }),
    );

    expect(() => service.status()).toThrow(ForbiddenException);
  });

  it('rejects access when the configured DB is not a test DB', () => {
    process.env.NODE_ENV = 'test';
    const service = new TestBackdoorService(
      makeDataSource({ database: 'healytics' }),
    );

    expect(() => service.status()).toThrow(ForbiddenException);
  });

  it('resets only non-master entity tables', async () => {
    process.env.NODE_ENV = 'test';
    const query = jest.fn().mockResolvedValue(undefined);
    const service = new TestBackdoorService(
      makeDataSource({
        database: 'healytics_test',
        entityMetadatas: [
          { tableName: 'account' },
          { tableName: 'location' },
          { tableName: 'health_partner_document_requirement' },
        ],
        query,
      }),
    );

    const result = await service.resetDb();

    expect(result).toEqual({ ok: true, truncatedTables: 1 });
    expect(query).toHaveBeenCalledWith(
      'TRUNCATE TABLE "account" RESTART IDENTITY CASCADE',
    );
  });

  it('seeds targeted notifications from scenario payloads', async () => {
    process.env.NODE_ENV = 'test';
    const manager = makeManager();
    const service = new TestBackdoorService(
      makeDataSource({
        database: 'healytics_test',
        transaction: (callback) => callback(manager),
      }),
    );

    const response = await service.seedPayload(
      {
        users: [
          {
            key: 'main_user',
            email: 'user@test.healytics.vn',
            password: 'Password123!',
          },
        ],
        notifications: [
          {
            key: 'welcome',
            userKey: 'main_user',
            type: NotificationType.SYSTEM_BROADCAST,
            title: 'Welcome',
            body: 'Hello from Patrol',
            isRead: true,
          },
        ],
      },
      'notifications',
    );

    expect(response.ok).toBe(true);
    expect(response.scenario).toBe('notifications');
    expect(response.ids.users.main_user).toBeDefined();
    expect(response.ids.notifications.welcome).toBeDefined();
    expect(manager.save).toHaveBeenCalledWith(
      expect.objectContaining({
        title: 'Welcome',
        isRead: true,
        readAt: expect.any(Date),
      }),
    );
  });

  it('seeds employee schedules for booking time-slot scenarios', async () => {
    process.env.NODE_ENV = 'test';
    const manager = makeManager();
    const service = new TestBackdoorService(
      makeDataSource({
        database: 'healytics_test',
        transaction: (callback) => callback(manager),
      }),
    );

    const response = await service.seedPayload(
      {
        partners: [
          {
            key: 'spa_partner',
            brandName: 'Patrol Spa',
          },
        ],
        employees: [
          {
            key: 'doctor_a',
            partnerKey: 'spa_partner',
            displayName: 'Dr. Patrol',
            role: EmployeeRole.DOCTOR,
            schedule: [
              {
                day: 'Wednesday',
                start: '08:00',
                end: '17:00',
                isWorking: true,
              },
            ],
          },
        ],
      },
      'booking',
    );

    expect(response.ok).toBe(true);
    expect(response.ids.employees.doctor_a).toBeDefined();
    expect(manager.save).toHaveBeenCalledWith(
      expect.objectContaining({
        fullName: 'Dr. Patrol',
        schedule: [
          {
            day: 'Wednesday',
            start: '08:00',
            end: '17:00',
            isWorking: true,
          },
        ],
      }),
    );
  });
});

function makeDataSource(overrides: Record<string, any> = {}) {
  return {
    options: { database: overrides.database ?? 'healytics_test' },
    entityMetadatas: overrides.entityMetadatas ?? [],
    query: overrides.query ?? jest.fn(),
    transaction:
      overrides.transaction ??
      ((callback: (manager: ReturnType<typeof makeManager>) => unknown) =>
        callback(makeManager())),
    getRepository: () => ({
      findOne: jest.fn().mockResolvedValue({ id: 'admin-id' }),
      create: (value: unknown) => value,
      save: jest.fn(),
    }),
  } as unknown as DataSource;
}

function makeManager() {
  let sequence = 0;
  return {
    create: (_entity: unknown, value: Record<string, unknown>) => ({
      ...value,
    }),
    save: jest.fn(async (value: Record<string, unknown>) => ({
      ...value,
      id: value.id ?? `seed-${++sequence}`,
    })),
    findOne: jest.fn().mockResolvedValue(null),
  };
}
