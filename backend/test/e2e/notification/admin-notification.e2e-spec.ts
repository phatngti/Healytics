import { randomUUID } from 'crypto';
import {
  INestApplication,
  ValidationPipe,
  VersioningType,
} from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { JwtModule, JwtService } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';
import request from 'supertest';
import type { App as SupertestApp } from 'supertest/types';
import { AdminNotificationController } from '../../../src/notification/admin-notification.controller';
import { NotificationService } from '../../../src/notification/notification.service';
import { NotificationType } from '../../../src/notification/enums/notification-type.enum';
import { NotificationResponseDto } from '../../../src/notification/dto/notification-response.dto';
import { JwtStrategy } from '../../../src/auth/strategies/jwt.strategy';
import { JwtAuthGuard } from '../../../src/auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../src/auth/guards/roles.guard';
import { Role } from '../../../src/account/enum/role.enum';
import { jwtConstants } from '../../../src/auth/constants';

type CreateBroadcastParams = {
  title: string;
  body: string;
  data?: Record<string, unknown>;
  senderId: string;
};

type CreateAndPushBroadcast = (
  params: CreateBroadcastParams,
) => Promise<NotificationResponseDto>;

type GetBroadcasts = () => Promise<NotificationResponseDto[]>;

describe('Admin Notification API (e2e)', () => {
  let app: INestApplication;
  let jwtService: JwtService;
  let notificationService: {
    createAndPushBroadcast: jest.MockedFunction<CreateAndPushBroadcast>;
    getBroadcasts: jest.MockedFunction<GetBroadcasts>;
  };

  const createdAt = new Date('2026-04-25T00:00:00.000Z');

  function api() {
    return request(app.getHttpServer() as unknown as SupertestApp);
  }

  function createToken(role: Role = Role.ADMIN): {
    accessToken: string;
    userId: string;
  } {
    const userId = randomUUID();
    return {
      userId,
      accessToken: jwtService.sign({
        sub: userId,
        email: `${role}+${Date.now()}@example.com`,
        role,
      }),
    };
  }

  beforeAll(async () => {
    notificationService = {
      createAndPushBroadcast:
        jest.fn() as jest.MockedFunction<CreateAndPushBroadcast>,
      getBroadcasts: jest.fn() as jest.MockedFunction<GetBroadcasts>,
    };

    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [
        PassportModule,
        JwtModule.register({
          secret: jwtConstants.secret,
        }),
      ],
      controllers: [AdminNotificationController],
      providers: [
        JwtStrategy,
        JwtAuthGuard,
        RolesGuard,
        {
          provide: NotificationService,
          useValue: notificationService,
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn(),
          },
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
    jwtService = app.get(JwtService);
  });

  beforeEach(() => {
    jest.clearAllMocks();
    notificationService.createAndPushBroadcast.mockImplementation((params) =>
      Promise.resolve({
        id: 'broadcast-id',
        type: NotificationType.SYSTEM_BROADCAST,
        title: params.title,
        body: params.body,
        data: params.data ?? null,
        isRead: false,
        readAt: null,
        isBroadcast: true,
        createdAt,
      }),
    );
  });

  afterAll(async () => {
    await app?.close();
  });

  it('POST /v1/admin/notifications/broadcast returns 201 and a NotificationResponseDto', async () => {
    const auth = createToken();

    const res = await api()
      .post('/v1/admin/notifications/broadcast')
      .set('Authorization', `Bearer ${auth.accessToken}`)
      .send({
        title: '  Maintenance starts at 01:00 ICT  ',
        body: '  The platform will enter maintenance mode.  ',
      });

    expect(res.status).toBe(201);
    expect(res.body).toEqual({
      id: 'broadcast-id',
      type: NotificationType.SYSTEM_BROADCAST,
      title: 'Maintenance starts at 01:00 ICT',
      body: 'The platform will enter maintenance mode.',
      data: null,
      isRead: false,
      readAt: null,
      isBroadcast: true,
      createdAt: createdAt.toISOString(),
    });
    expect(notificationService.createAndPushBroadcast).toHaveBeenCalledWith({
      title: 'Maintenance starts at 01:00 ICT',
      body: 'The platform will enter maintenance mode.',
      data: undefined,
      senderId: auth.userId,
    });
  });

  it('POST /v1/admin/notifications/broadcast returns 400 for whitespace-only title', async () => {
    const auth = createToken();

    const res = await api()
      .post('/v1/admin/notifications/broadcast')
      .set('Authorization', `Bearer ${auth.accessToken}`)
      .send({
        title: '   ',
        body: 'The platform will enter maintenance mode.',
      });

    expect(res.status).toBe(400);
    expect(notificationService.createAndPushBroadcast).not.toHaveBeenCalled();
  });

  it('POST /v1/admin/notifications/broadcast returns 400 for whitespace-only body', async () => {
    const auth = createToken();

    const res = await api()
      .post('/v1/admin/notifications/broadcast')
      .set('Authorization', `Bearer ${auth.accessToken}`)
      .send({
        title: 'Maintenance starts at 01:00 ICT',
        body: '   ',
      });

    expect(res.status).toBe(400);
    expect(notificationService.createAndPushBroadcast).not.toHaveBeenCalled();
  });

  it.each([
    ['title', { body: 'The platform will enter maintenance mode.' }],
    ['body', { title: 'Maintenance starts at 01:00 ICT' }],
  ])(
    'POST /v1/admin/notifications/broadcast returns 400 when %s is missing',
    async (_field, payload) => {
      const auth = createToken();

      const res = await api()
        .post('/v1/admin/notifications/broadcast')
        .set('Authorization', `Bearer ${auth.accessToken}`)
        .send(payload);

      expect(res.status).toBe(400);
      expect(notificationService.createAndPushBroadcast).not.toHaveBeenCalled();
    },
  );

  it('POST /v1/admin/notifications/broadcast returns 403 for non-admin users', async () => {
    const auth = createToken(Role.USER);

    const res = await api()
      .post('/v1/admin/notifications/broadcast')
      .set('Authorization', `Bearer ${auth.accessToken}`)
      .send({
        title: 'Maintenance starts at 01:00 ICT',
        body: 'The platform will enter maintenance mode.',
      });

    expect(res.status).toBe(403);
    expect(notificationService.createAndPushBroadcast).not.toHaveBeenCalled();
  });

  it('GET /v1/admin/notifications/broadcasts returns broadcast notifications newest first', async () => {
    const auth = createToken();
    notificationService.getBroadcasts.mockResolvedValue([
      {
        id: 'newer-broadcast',
        type: NotificationType.SYSTEM_BROADCAST,
        title: 'Newer broadcast',
        body: 'Newer body',
        data: null,
        isRead: false,
        readAt: null,
        isBroadcast: true,
        createdAt: new Date('2026-04-25T02:00:00.000Z'),
      },
      {
        id: 'older-broadcast',
        type: NotificationType.SYSTEM_BROADCAST,
        title: 'Older broadcast',
        body: 'Older body',
        data: null,
        isRead: false,
        readAt: null,
        isBroadcast: true,
        createdAt: new Date('2026-04-25T01:00:00.000Z'),
      },
    ]);

    const res = await api()
      .get('/v1/admin/notifications/broadcasts')
      .set('Authorization', `Bearer ${auth.accessToken}`);
    const broadcasts = res.body as unknown as Array<{
      id: string;
      isBroadcast: boolean;
    }>;

    expect(res.status).toBe(200);
    expect(broadcasts.map((item) => item.id)).toEqual([
      'newer-broadcast',
      'older-broadcast',
    ]);
    expect(broadcasts.every((item) => item.isBroadcast)).toBe(true);
    expect(notificationService.getBroadcasts).toHaveBeenCalledTimes(1);
  });
});
