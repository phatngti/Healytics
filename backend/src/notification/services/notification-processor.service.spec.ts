import { Test, TestingModule } from '@nestjs/testing';
import { NotificationProcessorService } from './notification-processor.service';
import { NotificationService } from '@/notification/notification.service';

describe('NotificationProcessorService', () => {
  let service: NotificationProcessorService;
  let notificationService: {
    createAndPushBroadcast: jest.Mock;
    createAndPushNotification: jest.Mock;
  };

  const createMockRmqContext = () => ({
    getChannelRef: jest.fn().mockReturnValue({
      ack: jest.fn(),
      nack: jest.fn(),
    }),
    getMessage: jest.fn().mockReturnValue({}),
  });

  beforeEach(async () => {
    notificationService = {
      createAndPushBroadcast: jest.fn().mockResolvedValue(undefined),
      createAndPushNotification: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [NotificationProcessorService],
      providers: [
        {
          provide: NotificationService,
          useValue: notificationService,
        },
      ],
    }).compile();

    service = module.get<NotificationProcessorService>(
      NotificationProcessorService,
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should process broadcast notification and ACK', async () => {
    const ctx = createMockRmqContext();
    const payload = {
      type: 'system_announcement',
      isBroadcast: true,
      title: 'New Feature',
      body: 'Check it out',
      senderId: 'admin-1',
    };

    await service.handleNotificationEvent(payload as any, ctx as any);

    expect(notificationService.createAndPushBroadcast).toHaveBeenCalledWith({
      title: 'New Feature',
      body: 'Check it out',
      data: undefined,
      senderId: 'admin-1',
    });
    expect(ctx.getChannelRef().ack).toHaveBeenCalled();
  });

  it('should process user-targeted notification and ACK', async () => {
    const ctx = createMockRmqContext();
    const payload = {
      type: 'booking_confirmed',
      recipientId: 'user-1',
      title: 'Booking Confirmed',
      body: 'Your booking is confirmed',
      data: { bookingId: 'booking-1' },
    };

    await service.handleNotificationEvent(payload as any, ctx as any);

    expect(notificationService.createAndPushNotification).toHaveBeenCalledWith({
      recipientId: 'user-1',
      type: 'booking_confirmed',
      title: 'Booking Confirmed',
      body: 'Your booking is confirmed',
      data: { bookingId: 'booking-1' },
    });
    expect(ctx.getChannelRef().ack).toHaveBeenCalled();
  });

  it('should skip events with no recipient and no broadcast flag', async () => {
    const ctx = createMockRmqContext();
    const payload = {
      type: 'unknown_event',
      title: 'No Target',
      body: 'Should be skipped',
    };

    await service.handleNotificationEvent(payload as any, ctx as any);

    expect(notificationService.createAndPushNotification).not.toHaveBeenCalled();
    expect(notificationService.createAndPushBroadcast).not.toHaveBeenCalled();
    expect(ctx.getChannelRef().ack).toHaveBeenCalled();
  });

  it('should NACK message on processing error', async () => {
    const ctx = createMockRmqContext();
    notificationService.createAndPushNotification.mockRejectedValue(
      new Error('DB connection lost'),
    );

    const payload = {
      type: 'booking_confirmed',
      recipientId: 'user-1',
      title: 'Test',
      body: 'Fail',
    };

    await service.handleNotificationEvent(payload as any, ctx as any);

    expect(ctx.getChannelRef().nack).toHaveBeenCalledWith({}, false, true);
  });
});
