import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { PushNotificationService } from './push-notification.service';
import { DeviceToken } from '@/common/entities/device-token.entity';
import { DevicePlatform } from '@/notification/enums/device-platform.enum';
import {
  MockRepository,
  createMockRepository,
} from '../../../test/mocks/mock-types';

describe('PushNotificationService', () => {
  let service: PushNotificationService;
  let deviceTokenRepo: MockRepository<DeviceToken>;

  beforeEach(async () => {
    deviceTokenRepo = createMockRepository<DeviceToken>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PushNotificationService,
        {
          provide: getRepositoryToken(DeviceToken),
          useValue: deviceTokenRepo,
        },
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn().mockReturnValue({
              projectId: 'mock-project-id',
              keyId: 'mock-key-id',
            }),
          },
        },
      ],
    }).compile();

    service = module.get<PushNotificationService>(PushNotificationService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  // ── sendToUser ─────────────────────────────────────────────

  describe('sendToUser', () => {
    it('should skip when no active tokens exist', async () => {
      deviceTokenRepo.find.mockResolvedValue([]);

      await service.sendToUser('user-1', {
        title: 'Test',
        body: 'Hello',
      });

      // No error thrown, graceful skip
      expect(deviceTokenRepo.find).toHaveBeenCalledWith({
        where: { userId: 'user-1', isActive: true },
      });
    });

    it('should send to all active tokens in mock mode', async () => {
      const tokens = [
        {
          id: 'token-1',
          token: 'fcm-token-abcdef123456789',
          platform: DevicePlatform.ANDROID,
          isActive: true,
        },
        {
          id: 'token-2',
          token: 'apns-token-xyz987654321abc',
          platform: DevicePlatform.IOS,
          isActive: true,
        },
      ];
      deviceTokenRepo.find.mockResolvedValue(tokens);

      // In mock mode, this should log but not throw
      await service.sendToUser('user-1', {
        title: 'Appointment Reminder',
        body: 'Your appointment is in 30 minutes',
        data: { bookingId: 'booking-1' },
      });

      expect(deviceTokenRepo.find).toHaveBeenCalledTimes(1);
    });

    it('should deactivate synthetic mock tokens without sending them', async () => {
      const sendFcmSpy = jest.spyOn(service as any, 'sendFcm');
      deviceTokenRepo.find.mockResolvedValue([
        {
          id: 'token-1',
          token: 'mock-fcm-token-17789',
          platform: DevicePlatform.ANDROID,
          isActive: true,
        },
      ]);

      await service.sendToUser('user-1', {
        title: 'Booking Confirmed!',
        body: 'Your booking is confirmed',
      });

      expect(deviceTokenRepo.update).toHaveBeenCalledWith('token-1', {
        isActive: false,
      });
      expect(sendFcmSpy).not.toHaveBeenCalled();
    });

    it('should deactivate invalid FCM registration tokens without error spam', async () => {
      jest.spyOn(service as any, 'shouldSkipToken').mockResolvedValue(false);
      jest
        .spyOn(service as any, 'sendFcm')
        .mockRejectedValue(
          Object.assign(
            new Error(
              'The registration token is not a valid FCM registration token',
            ),
            { code: 'messaging/invalid-argument' },
          ),
        );
      deviceTokenRepo.find.mockResolvedValue([
        {
          id: 'token-1',
          token: 'real-looking-fcm-token',
          platform: DevicePlatform.ANDROID,
          isActive: true,
        },
      ]);

      await service.sendToUser('user-1', {
        title: 'Booking Confirmed!',
        body: 'Your booking is confirmed',
      });

      expect(deviceTokenRepo.update).toHaveBeenCalledWith('token-1', {
        isActive: false,
      });
    });
  });

  // ── sendBroadcast ──────────────────────────────────────────

  describe('sendBroadcast', () => {
    it('should process tokens in batches', async () => {
      deviceTokenRepo.count.mockResolvedValue(2);
      deviceTokenRepo.find.mockResolvedValue([
        {
          id: 'token-1',
          token: 'fcm-token-abcdef123456789',
          platform: DevicePlatform.ANDROID,
        },
        {
          id: 'token-2',
          token: 'apns-token-xyz987654321abc',
          platform: DevicePlatform.IOS,
        },
      ]);

      await service.sendBroadcast({
        title: 'System Announcement',
        body: 'We have new features!',
      });

      expect(deviceTokenRepo.count).toHaveBeenCalled();
      expect(deviceTokenRepo.find).toHaveBeenCalled();
    });

    it('should handle empty token list gracefully', async () => {
      deviceTokenRepo.count.mockResolvedValue(0);

      await service.sendBroadcast({
        title: 'System Announcement',
        body: 'No devices to send to',
      });

      expect(deviceTokenRepo.find).not.toHaveBeenCalled();
    });
  });
});
