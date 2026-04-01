import { Test, TestingModule } from '@nestjs/testing';
import { UserAppointmentController } from './user-appointment.controller';
import { AppointmentService } from './appointment.service';
import { ListAppointmentsQueryDto } from './dto/list-appointments-query.dto';

describe('UserAppointmentController', () => {
  let controller: UserAppointmentController;
  let appointmentService: { [key: string]: jest.Mock };

  beforeEach(async () => {
    appointmentService = {
      listAppointments: jest.fn(),
      getAppointment: jest.fn(),
      listCategories: jest.fn(),
      listRecommendedServices: jest.fn(),
      getServiceManual: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserAppointmentController],
      providers: [
        { provide: AppointmentService, useValue: appointmentService },
      ],
    }).compile();

    controller = module.get<UserAppointmentController>(
      UserAppointmentController,
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('listAppointments', () => {
    it('should call appointmentService.listAppointments with userId and empty query', async () => {
      const userId = 'user-1';
      const query = new ListAppointmentsQueryDto();
      const expected = [{ id: 'appt-1', serviceName: 'Massage' }];
      appointmentService.listAppointments.mockResolvedValue(expected);

      const result = await controller.listAppointments(userId, query);

      expect(result).toEqual(expected);
      expect(appointmentService.listAppointments).toHaveBeenCalledWith(
        userId,
        query,
      );
    });

    it('should forward latitude and longitude from query', async () => {
      const userId = 'user-1';
      const query = new ListAppointmentsQueryDto();
      query.latitude = 10.7769;
      query.longitude = 106.7009;
      const expected = [
        { id: 'appt-1', serviceName: 'Massage', distanceKm: 2.5 },
      ];
      appointmentService.listAppointments.mockResolvedValue(expected);

      const result = await controller.listAppointments(userId, query);

      expect(result).toEqual(expected);
      expect(appointmentService.listAppointments).toHaveBeenCalledWith(
        userId,
        query,
      );
    });
  });

  describe('listCategories', () => {
    it('should call appointmentService.listCategories with userId', async () => {
      const userId = 'user-1';
      const expected = [{ id: 'cat-1', name: 'Spa', iconSlug: 'spa' }];
      appointmentService.listCategories.mockResolvedValue(expected);

      const result = await controller.listCategories(userId);

      expect(result).toEqual(expected);
      expect(appointmentService.listCategories).toHaveBeenCalledWith(userId);
    });
  });

  describe('listRecommendedServices', () => {
    it('should call appointmentService.listRecommendedServices', async () => {
      const expected = [{ id: 'svc-1', name: 'Deep Tissue Massage' }];
      appointmentService.listRecommendedServices.mockResolvedValue(expected);

      const result = await controller.listRecommendedServices();

      expect(result).toEqual(expected);
      expect(appointmentService.listRecommendedServices).toHaveBeenCalled();
    });
  });

  describe('getAppointment', () => {
    it('should call appointmentService.getAppointment with UUID', async () => {
      const appointmentId = '550e8400-e29b-41d4-a716-446655440000';
      const expected = { id: appointmentId, serviceName: 'Massage' };
      appointmentService.getAppointment.mockResolvedValue(expected);

      const result = await controller.getAppointment(appointmentId);

      expect(result).toEqual(expected);
      expect(appointmentService.getAppointment).toHaveBeenCalledWith(
        appointmentId,
      );
    });
  });

  describe('getServiceManual', () => {
    it('should call appointmentService.getServiceManual with appointmentId', async () => {
      const appointmentId = '550e8400-e29b-41d4-a716-446655440000';
      const expected = { serviceName: 'Massage', vendorName: 'Healytics' };
      appointmentService.getServiceManual.mockResolvedValue(expected);

      const result = await controller.getServiceManual(appointmentId);

      expect(result).toEqual(expected);
      expect(appointmentService.getServiceManual).toHaveBeenCalledWith(
        appointmentId,
      );
    });
  });
});
