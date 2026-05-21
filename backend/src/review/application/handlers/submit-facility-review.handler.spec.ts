import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { Booking } from '@/common/entities/booking.entity';
import { FacilityReview } from '@/common/entities/facility-review.entity';
import { S3Service } from '@/s3/s3.service';
import { SubmitFacilityReviewHandler } from './submit-facility-review.handler';

describe('SubmitFacilityReviewHandler', () => {
  const userId = 'user-1';
  const appointmentId = 'appointment-1';
  const facilityId = 'facility-1';

  let handler: SubmitFacilityReviewHandler;
  let dataSource: { createQueryRunner: jest.Mock };
  let queryRunner: {
    connect: jest.Mock;
    startTransaction: jest.Mock;
    commitTransaction: jest.Mock;
    rollbackTransaction: jest.Mock;
    release: jest.Mock;
    manager: {
      findOne: jest.Mock;
      create: jest.Mock;
      save: jest.Mock;
    };
  };
  let s3Service: { getFileUrl: jest.Mock };

  beforeEach(() => {
    queryRunner = {
      connect: jest.fn().mockResolvedValue(undefined),
      startTransaction: jest.fn().mockResolvedValue(undefined),
      commitTransaction: jest.fn().mockResolvedValue(undefined),
      rollbackTransaction: jest.fn().mockResolvedValue(undefined),
      release: jest.fn().mockResolvedValue(undefined),
      manager: {
        findOne: jest.fn(),
        create: jest.fn(),
        save: jest.fn(),
      },
    };
    dataSource = {
      createQueryRunner: jest.fn().mockReturnValue(queryRunner),
    };
    s3Service = {
      getFileUrl: jest.fn(),
    };
    handler = new SubmitFacilityReviewHandler(
      dataSource as unknown as DataSource,
      s3Service as unknown as S3Service,
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('creates a facility review for the appointment facility', async () => {
    const booking = completedBooking();
    const saved = {
      id: 'review-1',
      appointmentId,
      facilityId,
      rating: 5,
      comment: 'Clean',
      tags: ['Clean'],
      photoUrls: ['https://cdn.example/photo.jpg'],
      createdAt: new Date('2026-05-19T00:00:00.000Z'),
    };

    queryRunner.manager.findOne
      .mockResolvedValueOnce(booking)
      .mockResolvedValueOnce(null);
    s3Service.getFileUrl.mockResolvedValueOnce(saved.photoUrls[0]);
    queryRunner.manager.create.mockReturnValue(saved);
    queryRunner.manager.save.mockResolvedValue(saved);

    const result = await handler.execute(userId, {
      appointmentId,
      facilityId,
      rating: 5,
      comment: ' Clean ',
      tags: ['Clean'],
      photoKeys: ['review/photo.jpg'],
    });

    expect(queryRunner.manager.findOne).toHaveBeenNthCalledWith(1, Booking, {
      where: { id: appointmentId },
      relations: { product: { partner: true } },
    });
    expect(queryRunner.manager.findOne).toHaveBeenNthCalledWith(
      2,
      FacilityReview,
      { where: { appointmentId } },
    );
    expect(queryRunner.manager.create).toHaveBeenCalledWith(FacilityReview, {
      appointmentId,
      facilityId,
      userId,
      rating: 5,
      comment: 'Clean',
      tags: ['Clean'],
      photoUrls: saved.photoUrls,
    });
    expect(queryRunner.commitTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.rollbackTransaction).not.toHaveBeenCalled();
    expect(result).toMatchObject({
      id: saved.id,
      appointmentId,
      facilityId,
      rating: 5,
      comment: 'Clean',
      tags: ['Clean'],
      photoUrls: saved.photoUrls,
    });
  });

  it('accepts the facility account id and stores the canonical facility id', async () => {
    const booking = completedBooking();
    const saved = {
      id: 'review-1',
      appointmentId,
      facilityId,
      rating: 5,
      comment: null,
      tags: [],
      photoUrls: [],
      createdAt: new Date('2026-05-19T00:00:00.000Z'),
    };

    queryRunner.manager.findOne
      .mockResolvedValueOnce(booking)
      .mockResolvedValueOnce(null);
    queryRunner.manager.create.mockReturnValue(saved);
    queryRunner.manager.save.mockResolvedValue(saved);

    await handler.execute(userId, {
      appointmentId,
      facilityId: 'facility-account-1',
      rating: 5,
    });

    expect(queryRunner.manager.create).toHaveBeenCalledWith(FacilityReview, {
      appointmentId,
      facilityId,
      userId,
      rating: 5,
      comment: null,
      tags: [],
      photoUrls: [],
    });
    expect(queryRunner.commitTransaction).toHaveBeenCalledTimes(1);
  });

  it('rejects reviews for another user appointment', async () => {
    queryRunner.manager.findOne.mockResolvedValueOnce({
      ...completedBooking(),
      userId: 'other-user',
    });

    await expect(
      handler.execute(userId, {
        appointmentId,
        facilityId,
        rating: 5,
      }),
    ).rejects.toBeInstanceOf(ForbiddenException);

    expect(queryRunner.rollbackTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.commitTransaction).not.toHaveBeenCalled();
  });

  it('rejects reviews for a facility outside the appointment', async () => {
    queryRunner.manager.findOne.mockResolvedValueOnce(completedBooking());

    await expect(
      handler.execute(userId, {
        appointmentId,
        facilityId: 'other-facility',
        rating: 5,
      }),
    ).rejects.toBeInstanceOf(BadRequestException);

    expect(queryRunner.rollbackTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.commitTransaction).not.toHaveBeenCalled();
  });

  it('rejects duplicate facility reviews', async () => {
    queryRunner.manager.findOne
      .mockResolvedValueOnce(completedBooking())
      .mockResolvedValueOnce({ id: 'existing-review' });

    await expect(
      handler.execute(userId, {
        appointmentId,
        facilityId,
        rating: 5,
      }),
    ).rejects.toBeInstanceOf(ConflictException);

    expect(queryRunner.rollbackTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.commitTransaction).not.toHaveBeenCalled();
  });

  it('rejects missing appointments', async () => {
    queryRunner.manager.findOne.mockResolvedValueOnce(null);

    await expect(
      handler.execute(userId, {
        appointmentId,
        facilityId,
        rating: 5,
      }),
    ).rejects.toBeInstanceOf(NotFoundException);

    expect(queryRunner.rollbackTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.commitTransaction).not.toHaveBeenCalled();
  });

  function completedBooking(options?: { partnerAccountId?: string }) {
    return {
      id: appointmentId,
      userId,
      status: BookingStatus.COMPLETED,
      product: {
        partnerId: facilityId,
        partner: {
          accountId: 'facility-account-1',
        },
      },
    };
  }
});
