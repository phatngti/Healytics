import { ConflictException, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingStatusLogWriterService } from '@/booking/services/booking-status-log-writer.service';
import { CancelEmployeeAppointmentHandler } from './cancel-employee-appointment.handler';

describe('CancelEmployeeAppointmentHandler', () => {
  const accountId = 'account-1';
  const bookingId = 'booking-1';
  const employeeId = 'employee-1';

  let handler: CancelEmployeeAppointmentHandler;
  let queryRunner: any;
  let dataSource: any;
  let logWriter: jest.Mocked<Pick<BookingStatusLogWriterService, 'write'>>;

  beforeEach(() => {
    queryRunner = {
      connect: jest.fn(),
      startTransaction: jest.fn(),
      commitTransaction: jest.fn(),
      rollbackTransaction: jest.fn(),
      release: jest.fn(),
      manager: {
        findOne: jest.fn(),
        save: jest.fn(async (_entity: unknown, value: unknown) => value),
      },
    };
    dataSource = {
      createQueryRunner: jest.fn(() => queryRunner),
      manager: {
        findOne: jest
          .fn()
          .mockResolvedValueOnce({
            id: bookingId,
            status: BookingStatus.CANCELLED,
            userId: 'user-1',
            startTime: new Date('2026-05-19T09:00:00.000Z'),
            endTime: new Date('2026-05-19T10:00:00.000Z'),
            product: null,
            user: { email: 'patient@example.com', userProfile: null },
          })
          .mockResolvedValueOnce({
            id: 'partner-1',
            brandName: 'Healytics Clinic',
            streetAddress: '123 Wellness St',
          }),
      },
    };
    logWriter = {
      write: jest.fn().mockResolvedValue({}),
    };

    handler = new CancelEmployeeAppointmentHandler(
      dataSource as DataSource,
      logWriter as BookingStatusLogWriterService,
    );
  });

  it('cancels appointment and writes fromStatus/toStatus with reason code', async () => {
    queryRunner.manager.findOne
      .mockResolvedValueOnce({ id: employeeId, partnerId: 'partner-1' })
      .mockResolvedValueOnce({
        id: bookingId,
        staffId: employeeId,
        status: BookingStatus.CONFIRMED,
        notes: null,
      });

    await handler.execute(accountId, bookingId, 'Specialist is unavailable');

    expect(logWriter.write).toHaveBeenCalledWith(
      queryRunner.manager,
      expect.objectContaining({
        bookingId,
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.CANCELLED,
        changedBy: accountId,
        reasonCode: BookingStatusReasonCode.EMPLOYEE_CANCELLED,
        reason: 'Specialist is unavailable',
      }),
    );
    expect(queryRunner.commitTransaction).toHaveBeenCalled();
  });

  it('uses the default employee cancellation reason when request reason is blank', async () => {
    queryRunner.manager.findOne
      .mockResolvedValueOnce({ id: employeeId, partnerId: 'partner-1' })
      .mockResolvedValueOnce({
        id: bookingId,
        staffId: employeeId,
        status: BookingStatus.IN_PROGRESS,
        notes: null,
      });

    await handler.execute(accountId, bookingId, '   ');

    expect(logWriter.write).toHaveBeenCalledWith(
      queryRunner.manager,
      expect.objectContaining({
        reasonCode: BookingStatusReasonCode.EMPLOYEE_CANCELLED,
        reason: '',
      }),
    );
  });

  it('rolls back when employee profile is missing', async () => {
    queryRunner.manager.findOne.mockResolvedValueOnce(null);

    await expect(handler.execute(accountId, bookingId)).rejects.toBeInstanceOf(
      NotFoundException,
    );
    expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
    expect(logWriter.write).not.toHaveBeenCalled();
  });

  it('rolls back on invalid cancellation status', async () => {
    queryRunner.manager.findOne
      .mockResolvedValueOnce({ id: employeeId, partnerId: 'partner-1' })
      .mockResolvedValueOnce({
        id: bookingId,
        staffId: employeeId,
        status: BookingStatus.COMPLETED,
      });

    await expect(handler.execute(accountId, bookingId)).rejects.toBeInstanceOf(
      ConflictException,
    );
    expect(queryRunner.rollbackTransaction).toHaveBeenCalled();
    expect(logWriter.write).not.toHaveBeenCalled();
  });
});
