import { randomUUID } from 'crypto';
import { INestApplication, ValidationPipe, VersioningType } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { Repository } from 'typeorm';
import request from 'supertest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { JwtService } from '@nestjs/jwt';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { DeviceToken } from '../../../src/common/entities/device-token.entity';
import { Account } from '../../../src/common/entities/account.entity';
import { Role } from '../../../src/account/enum/role.enum';
import { NotificationService } from '../../../src/notification/notification.service';
import { UserDeviceController } from '../../../src/notification/user-device.controller';
import { JwtStrategy } from '../../../src/auth/strategies/jwt.strategy';
import { JwtAuthGuard } from '../../../src/auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../src/auth/guards/roles.guard';
import { AccountService } from '../../../src/account/account.service';
import { ConfigService } from '@nestjs/config';
import { jwtConstants } from '../../../src/auth/constants';

type AccountRepoMock = Pick<
  Repository<Account>,
  'create' | 'save' | 'findOne'
>;
type DeviceTokenRepoMock = Pick<
  Repository<DeviceToken>,
  'create' | 'save' | 'findOne' | 'find' | 'update'
>;

describe('User Device API (e2e)', () => {
  let app: INestApplication;
  let deviceTokenRepo: DeviceTokenRepoMock;
  let accountRepo: AccountRepoMock;
  let jwtService: JwtService;
  let accounts: Account[];
  let deviceTokens: DeviceToken[];

  function api() {
    return request(app.getHttpAdapter().getInstance());
  }

  function createAccountRepoMock(): AccountRepoMock {
    return {
      create: (input: Partial<Account>) => input as Account,
      save: async (input: Partial<Account>) => {
        const account = {
          id: input.id ?? randomUUID(),
          email: input.email ?? null,
          role: input.role ?? Role.USER,
          passwordHash: input.passwordHash,
          refreshTokenHash: input.refreshTokenHash ?? null,
          survey: input.survey ?? null,
          isActive: input.isActive ?? true,
          createdAt: input.createdAt ?? new Date(),
          updatedAt: input.updatedAt ?? new Date(),
          deletedAt: input.deletedAt ?? null,
          userProfile: input.userProfile,
          partner: input.partner,
        } as Account;

        const existingIndex = accounts.findIndex(
          (candidate) => candidate.id === account.id,
        );
        if (existingIndex >= 0) {
          accounts[existingIndex] = account;
        } else {
          accounts.push(account);
        }

        return account;
      },
      findOne: async ({
        where,
      }: {
        where: Partial<Account>;
      }) =>
        accounts.find((account) =>
          Object.entries(where).every(
            ([key, value]) =>
              account[key as keyof Account] === value,
          ),
        ) ?? null,
    };
  }

  function createDeviceTokenRepoMock(): DeviceTokenRepoMock {
    return {
      create: (input: Partial<DeviceToken>) => input as DeviceToken,
      save: async (input: Partial<DeviceToken>) => {
        const entity = {
          id: input.id ?? randomUUID(),
          userId: input.userId!,
          token: input.token!,
          platform: input.platform!,
          isActive: input.isActive ?? true,
          createdAt: input.createdAt ?? new Date(),
          updatedAt: input.updatedAt ?? new Date(),
        } as DeviceToken;

        const existingIndex = deviceTokens.findIndex(
          (candidate) => candidate.id === entity.id || candidate.token === entity.token,
        );
        if (existingIndex >= 0) {
          deviceTokens[existingIndex] = entity;
        } else {
          deviceTokens.push(entity);
        }

        return entity;
      },
      findOne: async ({
        where,
      }: {
        where: Partial<DeviceToken>;
      }) =>
        deviceTokens.find((deviceToken) =>
          Object.entries(where).every(
            ([key, value]) =>
              deviceToken[key as keyof DeviceToken] === value,
          ),
        ) ?? null,
      find: async ({
        where,
      }: {
        where: Partial<DeviceToken>;
      }) =>
        deviceTokens.filter((deviceToken) =>
          Object.entries(where).every(
            ([key, value]) =>
              deviceToken[key as keyof DeviceToken] === value,
          ),
        ),
      update: async (
        criteria: string | Partial<DeviceToken>,
        partialEntity: Partial<DeviceToken>,
      ) => {
        for (const deviceToken of deviceTokens) {
          const matches =
            typeof criteria === 'string'
              ? deviceToken.id === criteria
              : Object.entries(criteria).every(
                  ([key, value]) =>
                    deviceToken[key as keyof DeviceToken] === value,
                );

          if (matches) {
            Object.assign(deviceToken, partialEntity, {
              updatedAt: new Date(),
            });
          }
        }

        return {
          generatedMaps: [],
          raw: [],
          affected: 0,
        };
      },
    };
  }

  async function createUserAndToken(emailPrefix: string, role = Role.USER): Promise<{
    accessToken: string;
    userId: string;
  }> {
    const email = `${emailPrefix}+${Date.now()}@example.com`;
    const user = await accountRepo.save(
      accountRepo.create({
        email,
        role,
      }),
    );

    return {
      accessToken: jwtService.sign({ sub: user.id, email: user.email, role }),
      userId: user.id,
    };
  }

  beforeAll(async () => {
    accounts = [];
    deviceTokens = [];

    const accountRepoMock = createAccountRepoMock();
    const deviceTokenRepoMock = createDeviceTokenRepoMock();

    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [
        PassportModule,
        JwtModule.register({
          secret: jwtConstants.secret,
        }),
      ],
      controllers: [UserDeviceController],
      providers: [
        JwtStrategy,
        JwtAuthGuard,
        RolesGuard,
        {
          provide: NotificationService,
          inject: [getRepositoryToken(DeviceToken)],
          useFactory: (repo: Repository<DeviceToken>) =>
            new NotificationService(
              {} as any,
              {} as any,
              repo,
              {} as any,
              {} as any,
              {} as any,
              {} as any,
              {} as any,
              {} as any,
            ),
        },
        {
          provide: AccountService,
          useValue: {
            findOne: async (id: string) =>
              accounts.find((account) => account.id === id) ?? null,
          },
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn(),
          },
        },
        {
          provide: getRepositoryToken(Account),
          useValue: accountRepoMock,
        },
        {
          provide: getRepositoryToken(DeviceToken),
          useValue: deviceTokenRepoMock,
        },
      ],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
        forbidNonWhitelisted: true,
      }),
    );
    app.enableVersioning({
      type: VersioningType.URI,
    });

    await app.init();

    deviceTokenRepo = app.get<DeviceTokenRepoMock>(
      getRepositoryToken(DeviceToken),
    );
    accountRepo = app.get<AccountRepoMock>(getRepositoryToken(Account));
    jwtService = app.get(JwtService);
  });

  beforeEach(() => {
    accounts.length = 0;
    deviceTokens.length = 0;
  });

  afterAll(async () => {
    await app?.close();
  });

  it('POST /v1/user/devices returns 201 and persists device token', async () => {
    const auth = await createUserAndToken('device-register');
    const token = `ios-token-${Date.now()}`;

    const res = await api()
      .post('/v1/user/devices')
      .set('Authorization', `Bearer ${auth.accessToken}`)
      .send({
        token,
        platform: 'ios',
      });

    expect(res.status).toBe(201);
    expect(res.body).toEqual({ message: 'Device registered successfully' });

    const saved = await deviceTokenRepo.findOne({
      where: { token },
    });

    expect(saved).toBeDefined();
    expect(saved?.userId).toBe(auth.userId);
    expect(saved?.platform).toBe('ios');
    expect(saved?.isActive).toBe(true);
  });

  it('POST /v1/user/devices returns 400 for invalid platform', async () => {
    const auth = await createUserAndToken('device-invalid-platform');

    const res = await api()
      .post('/v1/user/devices')
      .set('Authorization', `Bearer ${auth.accessToken}`)
      .send({
        token: `bad-platform-token-${Date.now()}`,
        platform: 'web',
      });

    expect(res.status).toBe(400);
  });

  it('POST /v1/user/devices returns 401 without JWT', async () => {
    const res = await api().post('/v1/user/devices').send({
      token: `unauthorized-token-${Date.now()}`,
      platform: 'android',
    });

    expect(res.status).toBe(401);
  });

  it('POST /v1/user/devices reassigns existing token to another user', async () => {
    const firstUser = await createUserAndToken('device-reassign-a');
    const secondUser = await createUserAndToken('device-reassign-b');
    const sharedToken = `shared-token-${Date.now()}`;

    const firstRes = await api()
      .post('/v1/user/devices')
      .set('Authorization', `Bearer ${firstUser.accessToken}`)
      .send({ token: sharedToken, platform: 'android' });

    expect(firstRes.status).toBe(201);

    const secondRes = await api()
      .post('/v1/user/devices')
      .set('Authorization', `Bearer ${secondUser.accessToken}`)
      .send({ token: sharedToken, platform: 'ios' });

    expect(secondRes.status).toBe(201);

    const rows = await deviceTokenRepo.find({ where: { token: sharedToken } });
    expect(rows).toHaveLength(1);
    expect(rows[0].userId).toBe(secondUser.userId);
    expect(rows[0].platform).toBe('ios');
    expect(rows[0].isActive).toBe(true);
  });

  it('DELETE /v1/user/devices/:token returns 204 and deactivates only caller token', async () => {
    const userA = await createUserAndToken('device-delete-a');
    const userB = await createUserAndToken('device-delete-b');

    const tokenA = `token-a-${Date.now()}`;
    const tokenB = `token-b-${Date.now()}`;

    await api()
      .post('/v1/user/devices')
      .set('Authorization', `Bearer ${userA.accessToken}`)
      .send({ token: tokenA, platform: 'ios' });

    await api()
      .post('/v1/user/devices')
      .set('Authorization', `Bearer ${userB.accessToken}`)
      .send({ token: tokenB, platform: 'android' });

    const deleteRes = await api()
      .delete(`/v1/user/devices/${tokenA}`)
      .set('Authorization', `Bearer ${userA.accessToken}`);

    expect(deleteRes.status).toBe(204);

    const afterA = await deviceTokenRepo.findOne({ where: { token: tokenA } });
    const afterB = await deviceTokenRepo.findOne({ where: { token: tokenB } });

    expect(afterA?.isActive).toBe(false);
    expect(afterB?.isActive).toBe(true);

    const unauthorizedDelete = await api()
      .delete(`/v1/user/devices/${tokenB}`)
      .set('Authorization', `Bearer ${userA.accessToken}`);

    expect(unauthorizedDelete.status).toBe(204);

    const unchangedB = await deviceTokenRepo.findOne({ where: { token: tokenB } });
    expect(unchangedB?.isActive).toBe(true);
  });

  it('POST /v1/user/devices returns 403 for non-USER role', async () => {
    const auth = await createUserAndToken('device-role-check', Role.ADMIN);

    const res = await api()
      .post('/v1/user/devices')
      .set('Authorization', `Bearer ${auth.accessToken}`)
      .send({
        token: `admin-role-token-${Date.now()}`,
        platform: 'android',
      });

    expect(res.status).toBe(403);
  });
});
