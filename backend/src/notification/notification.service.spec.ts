import { BadRequestException, Logger } from '@nestjs/common';
import type { Repository } from 'typeorm';
import type { Account } from '@/common/entities/account.entity';
import type { DeviceToken } from '@/common/entities/device-token.entity';
import { Notification } from '@/common/entities/notification.entity';
import type { NotificationRead } from '@/common/entities/notification-read.entity';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { NotificationResponseDto } from '@/notification/dto/notification-response.dto';
import type { CreateBroadcastHandler } from './application/handlers/create-broadcast.handler';
import type { CreateNotificationHandler } from './application/handlers/create-notification.handler';
import type { MarkAllReadHandler } from './application/handlers/mark-all-read.handler';
import type { MarkNotificationReadHandler } from './application/handlers/mark-notification-read.handler';
import { NotificationService } from './notification.service';
import type { PushNotificationService } from './push/push-notification.service';
import type { NotificationGateway } from './ws/notification.gateway';

const flushAsyncPush = () =>
  new Promise<void>((resolve) => {
    setImmediate(resolve);
  });

describe('NotificationService', () => {
  let service: NotificationService;
  let notificationRepo: { find: jest.Mock };
  let createBroadcastHandler: { execute: jest.Mock };
  let markReadHandler: { execute: jest.Mock };
  let markAllReadHandler: { execute: jest.Mock };
  let notificationGateway: {
    pushBroadcast: jest.Mock;
    pushUnreadCount: jest.Mock;
  };
  let pushService: { sendBroadcast: jest.Mock };

  const createdAt = new Date('2026-04-25T00:00:00.000Z');
  const broadcastDto: NotificationResponseDto = {
    id: 'broadcast-id',
    type: NotificationType.SYSTEM_BROADCAST,
    title: 'Maintenance starts at 01:00 ICT',
    body: 'The platform will enter maintenance mode.',
    data: null,
    isRead: false,
    readAt: null,
    isBroadcast: true,
    createdAt,
  };

  beforeEach(() => {
    notificationRepo = { find: jest.fn() };
    createBroadcastHandler = {
      execute: jest.fn().mockResolvedValue(broadcastDto),
    };
    markReadHandler = { execute: jest.fn().mockResolvedValue(undefined) };
    markAllReadHandler = {
      execute: jest.fn().mockResolvedValue({ markedCount: 3 }),
    };
    notificationGateway = {
      pushBroadcast: jest.fn(),
      pushUnreadCount: jest.fn(),
    };
    pushService = { sendBroadcast: jest.fn().mockResolvedValue(undefined) };

    service = new NotificationService(
      notificationRepo as unknown as Repository<Notification>,
      {} as unknown as Repository<NotificationRead>,
      {} as unknown as Repository<DeviceToken>,
      {} as unknown as Repository<Account>,
      {} as unknown as CreateNotificationHandler,
      createBroadcastHandler as unknown as CreateBroadcastHandler,
      markReadHandler as unknown as MarkNotificationReadHandler,
      markAllReadHandler as unknown as MarkAllReadHandler,
      notificationGateway as unknown as NotificationGateway,
      pushService as unknown as PushNotificationService,
    );
  });

  afterEach(() => {
    jest.restoreAllMocks();
    jest.clearAllMocks();
  });

  describe('createAndPushBroadcast', () => {
    it('trims content, persists one broadcast, pushes websocket, and schedules device push', async () => {
      const data = { action: 'open_announcements' };

      const result = await service.createAndPushBroadcast({
        title: '  Maintenance starts at 01:00 ICT  ',
        body: '  The platform will enter maintenance mode.  ',
        data,
        senderId: 'admin-id',
      });
      await flushAsyncPush();

      expect(result).toBe(broadcastDto);
      expect(createBroadcastHandler.execute).toHaveBeenCalledWith({
        title: 'Maintenance starts at 01:00 ICT',
        body: 'The platform will enter maintenance mode.',
        data,
        senderId: 'admin-id',
      });
      expect(createBroadcastHandler.execute).toHaveBeenCalledTimes(1);
      expect(notificationGateway.pushBroadcast).toHaveBeenCalledWith(
        broadcastDto,
      );
      expect(pushService.sendBroadcast).toHaveBeenCalledWith({
        title: 'Maintenance starts at 01:00 ICT',
        body: 'The platform will enter maintenance mode.',
        data: {
          ...data,
          notificationId: broadcastDto.id,
          notificationType: broadcastDto.type,
          type: broadcastDto.type,
        },
      });
    });

    it('rejects whitespace-only title before persistence', async () => {
      await expect(
        service.createAndPushBroadcast({
          title: '   ',
          body: 'The platform will enter maintenance mode.',
          senderId: 'admin-id',
        }),
      ).rejects.toThrow(BadRequestException);

      expect(createBroadcastHandler.execute).not.toHaveBeenCalled();
      expect(notificationGateway.pushBroadcast).not.toHaveBeenCalled();
      expect(pushService.sendBroadcast).not.toHaveBeenCalled();
    });

    it('rejects whitespace-only body before persistence', async () => {
      await expect(
        service.createAndPushBroadcast({
          title: 'Maintenance starts at 01:00 ICT',
          body: '   ',
          senderId: 'admin-id',
        }),
      ).rejects.toThrow(BadRequestException);

      expect(createBroadcastHandler.execute).not.toHaveBeenCalled();
      expect(notificationGateway.pushBroadcast).not.toHaveBeenCalled();
      expect(pushService.sendBroadcast).not.toHaveBeenCalled();
    });

    it('logs push broadcast errors without failing the request', async () => {
      pushService.sendBroadcast.mockRejectedValue(
        new Error('push provider unavailable'),
      );
      const loggerError = jest
        .spyOn(Logger.prototype, 'error')
        .mockImplementation(() => undefined);

      await expect(
        service.createAndPushBroadcast({
          title: 'Maintenance starts at 01:00 ICT',
          body: 'The platform will enter maintenance mode.',
          senderId: 'admin-id',
        }),
      ).resolves.toBe(broadcastDto);
      await flushAsyncPush();

      expect(loggerError).toHaveBeenCalledWith(
        'Broadcast push failed: push provider unavailable',
      );
    });
  });

  describe('getBroadcasts', () => {
    it('queries broadcast rows sorted by newest first and maps response DTOs', async () => {
      const newer = createNotificationEntity({
        id: 'newer-broadcast',
        createdAt: new Date('2026-04-25T02:00:00.000Z'),
      });
      const older = createNotificationEntity({
        id: 'older-broadcast',
        createdAt: new Date('2026-04-25T01:00:00.000Z'),
      });
      notificationRepo.find.mockResolvedValue([newer, older]);

      const result = await service.getBroadcasts();

      expect(notificationRepo.find).toHaveBeenCalledWith({
        where: { isBroadcast: true },
        order: { createdAt: 'DESC' },
        take: 50,
      });
      expect(result).toEqual(
        NotificationResponseDto.fromEntities([newer, older]),
      );
    });
  });

  describe('markRead', () => {
    it('marks a notification as read and pushes the refreshed unread count', async () => {
      jest.spyOn(service, 'getUnreadCount').mockResolvedValue(4);

      await service.markRead('notification-id', 'user-id');

      expect(markReadHandler.execute).toHaveBeenCalledWith(
        'notification-id',
        'user-id',
      );
      expect(notificationGateway.pushUnreadCount).toHaveBeenCalledWith(
        'user-id',
        4,
      );
    });
  });

  describe('markAllRead', () => {
    it('marks all notifications as read and pushes the refreshed unread count', async () => {
      jest.spyOn(service, 'getUnreadCount').mockResolvedValue(0);

      const result = await service.markAllRead('user-id');

      expect(result).toEqual({ markedCount: 3 });
      expect(markAllReadHandler.execute).toHaveBeenCalledWith('user-id');
      expect(notificationGateway.pushUnreadCount).toHaveBeenCalledWith(
        'user-id',
        0,
      );
    });
  });
});

function createNotificationEntity(
  overrides: Partial<Notification> = {},
): Notification {
  return {
    id: 'broadcast-id',
    recipientId: null,
    type: NotificationType.SYSTEM_BROADCAST,
    title: 'Maintenance starts at 01:00 ICT',
    body: 'The platform will enter maintenance mode.',
    data: null,
    isRead: false,
    readAt: null,
    isBroadcast: true,
    senderId: 'admin-id',
    createdAt: new Date('2026-04-25T00:00:00.000Z'),
    deletedAt: null,
    recipient: null,
    sender: null,
    ...overrides,
  };
}
