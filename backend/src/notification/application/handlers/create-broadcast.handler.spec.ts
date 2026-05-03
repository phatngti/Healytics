import { Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationResponseDto } from '@/notification/dto/notification-response.dto';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import {
  createMockDataSource,
  createMockQueryRunner,
  MockDataSource,
  MockQueryRunner,
} from '../../../../test/mocks/mock-types';
import { CreateBroadcastHandler } from './create-broadcast.handler';

describe('CreateBroadcastHandler', () => {
  let handler: CreateBroadcastHandler;
  let dataSource: MockDataSource;
  let queryRunner: MockQueryRunner;

  beforeEach(() => {
    jest.spyOn(Logger.prototype, 'log').mockImplementation(() => undefined);
    jest.spyOn(Logger.prototype, 'error').mockImplementation(() => undefined);
    queryRunner = createMockQueryRunner();
    dataSource = createMockDataSource(queryRunner);
    handler = new CreateBroadcastHandler(dataSource as unknown as DataSource);
  });

  afterEach(() => {
    jest.restoreAllMocks();
    jest.clearAllMocks();
  });

  it('writes a single system broadcast notification row', async () => {
    const params = {
      title: 'Maintenance starts at 01:00 ICT',
      body: 'The platform will enter maintenance mode.',
      senderId: 'admin-id',
    };
    const created = createNotificationEntity(params);
    const saved = createNotificationEntity({
      ...params,
      id: 'saved-broadcast-id',
      createdAt: new Date('2026-04-25T00:00:00.000Z'),
    });
    queryRunner.manager.create.mockReturnValue(created);
    queryRunner.manager.save.mockResolvedValue(saved);

    const result = await handler.execute(params);

    expect(queryRunner.connect).toHaveBeenCalledTimes(1);
    expect(queryRunner.startTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.manager.create).toHaveBeenCalledWith(Notification, {
      recipientId: null,
      type: NotificationType.SYSTEM_BROADCAST,
      title: params.title,
      body: params.body,
      data: null,
      isRead: false,
      isBroadcast: true,
      senderId: params.senderId,
    });
    expect(queryRunner.manager.save).toHaveBeenCalledWith(
      Notification,
      created,
    );
    expect(queryRunner.manager.save).toHaveBeenCalledTimes(1);
    expect(queryRunner.commitTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.rollbackTransaction).not.toHaveBeenCalled();
    expect(queryRunner.release).toHaveBeenCalledTimes(1);
    expect(result).toEqual(NotificationResponseDto.fromEntity(saved));
  });

  it('rolls back and releases the transaction when persistence fails', async () => {
    queryRunner.manager.create.mockReturnValue(createNotificationEntity());
    queryRunner.manager.save.mockRejectedValue(
      new Error('database unavailable'),
    );

    await expect(
      handler.execute({
        title: 'Maintenance starts at 01:00 ICT',
        body: 'The platform will enter maintenance mode.',
        senderId: 'admin-id',
      }),
    ).rejects.toThrow('database unavailable');

    expect(queryRunner.rollbackTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.commitTransaction).not.toHaveBeenCalled();
    expect(queryRunner.release).toHaveBeenCalledTimes(1);
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
