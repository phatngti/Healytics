import { Test, TestingModule } from '@nestjs/testing';
import { NotificationEventService } from './notification-event.service';

describe('NotificationEventService', () => {
  let service: NotificationEventService;
  let rmqClient: { emit: jest.Mock };

  beforeEach(async () => {
    rmqClient = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NotificationEventService,
        { provide: 'RABBITMQ_CLIENT', useValue: rmqClient },
      ],
    }).compile();

    service = module.get<NotificationEventService>(NotificationEventService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should emit notification event to RabbitMQ', () => {
    const payload = {
      type: 'booking_confirmed',
      recipientId: 'user-1',
      title: 'Booking Confirmed',
      body: 'Your booking has been confirmed',
      data: { bookingId: 'booking-1' },
    };

    service.emit(payload as any);

    expect(rmqClient.emit).toHaveBeenCalledWith('notification.event', payload);
  });

  it('should not throw when RabbitMQ emit fails', () => {
    rmqClient.emit.mockImplementation(() => {
      throw new Error('RabbitMQ connection lost');
    });

    const payload = {
      type: 'booking_confirmed',
      recipientId: 'user-1',
      title: 'Test',
      body: 'Test body',
    };

    // Should not throw — fire-and-forget semantics
    expect(() => service.emit(payload as any)).not.toThrow();
  });

  it('should handle broadcast events without recipientId', () => {
    const payload = {
      type: 'system_announcement',
      isBroadcast: true,
      title: 'New Feature',
      body: 'Check out our new features',
      senderId: 'admin-1',
    };

    service.emit(payload as any);

    expect(rmqClient.emit).toHaveBeenCalledWith('notification.event', payload);
  });
});
