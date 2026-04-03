import { Test, TestingModule } from '@nestjs/testing';
import { AppointmentService } from './appointment.service';
import { ListAppointmentsHandler } from './application/handlers/list-appointments.handler';
import { GetAppointmentHandler } from './application/handlers/get-appointment.handler';
import { ListAppointmentCategoriesHandler } from './application/handlers/list-appointment-categories.handler';
import { ListRecommendedServicesHandler } from './application/handlers/list-recommended-services.handler';
import { GetServiceManualHandler } from './application/handlers/get-service-manual.handler';
import { ListAppointmentsQueryDto } from './dto/list-appointments-query.dto';
import { MockHandler, createMockHandler } from '../../test/mocks/mock-types';

describe('AppointmentService', () => {
  let service: AppointmentService;
  let listAppointmentsHandler: MockHandler;
  let getAppointmentHandler: MockHandler;
  let listAppointmentCategoriesHandler: MockHandler;
  let listRecommendedServicesHandler: MockHandler;
  let getServiceManualHandler: MockHandler;

  beforeEach(async () => {
    listAppointmentsHandler = createMockHandler();
    getAppointmentHandler = createMockHandler();
    listAppointmentCategoriesHandler = createMockHandler();
    listRecommendedServicesHandler = createMockHandler();
    getServiceManualHandler = createMockHandler();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AppointmentService,
        { provide: ListAppointmentsHandler, useValue: listAppointmentsHandler },
        { provide: GetAppointmentHandler, useValue: getAppointmentHandler },
        {
          provide: ListAppointmentCategoriesHandler,
          useValue: listAppointmentCategoriesHandler,
        },
        {
          provide: ListRecommendedServicesHandler,
          useValue: listRecommendedServicesHandler,
        },
        { provide: GetServiceManualHandler, useValue: getServiceManualHandler },
      ],
    }).compile();

    service = module.get<AppointmentService>(AppointmentService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('listAppointments', () => {
    it('should delegate to ListAppointmentsHandler with userId', async () => {
      const userId = 'user-1';
      const expected = [{ id: 'appt-1' }];
      listAppointmentsHandler.execute.mockResolvedValue(expected);

      const result = await service.listAppointments(userId);

      expect(result).toEqual(expected);
      expect(listAppointmentsHandler.execute).toHaveBeenCalledWith(
        userId,
        undefined,
      );
      expect(listAppointmentsHandler.execute).toHaveBeenCalledTimes(1);
    });

    it('should forward query DTO with coordinates to handler', async () => {
      const userId = 'user-1';
      const query = new ListAppointmentsQueryDto();
      query.latitude = 10.7769;
      query.longitude = 106.7009;
      const expected = [{ id: 'appt-1', distanceKm: 2.5 }];
      listAppointmentsHandler.execute.mockResolvedValue(expected);

      const result = await service.listAppointments(userId, query);

      expect(result).toEqual(expected);
      expect(listAppointmentsHandler.execute).toHaveBeenCalledWith(
        userId,
        query,
      );
      expect(listAppointmentsHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('getAppointment', () => {
    it('should delegate to GetAppointmentHandler', async () => {
      const id = 'appt-1';
      const expected = { id, serviceName: 'Massage' };
      getAppointmentHandler.execute.mockResolvedValue(expected);

      const result = await service.getAppointment(id);

      expect(result).toEqual(expected);
      expect(getAppointmentHandler.execute).toHaveBeenCalledWith(id);
      expect(getAppointmentHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('listCategories', () => {
    it('should delegate to ListAppointmentCategoriesHandler', async () => {
      const userId = 'user-1';
      const expected = [{ id: 'cat-1', name: 'Spa' }];
      listAppointmentCategoriesHandler.execute.mockResolvedValue(expected);

      const result = await service.listCategories(userId);

      expect(result).toEqual(expected);
      expect(listAppointmentCategoriesHandler.execute).toHaveBeenCalledWith(
        userId,
      );
      expect(listAppointmentCategoriesHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('listRecommendedServices', () => {
    it('should delegate to ListRecommendedServicesHandler', async () => {
      const expected = [{ id: 'svc-1', name: 'Deep Tissue' }];
      listRecommendedServicesHandler.execute.mockResolvedValue(expected);

      const result = await service.listRecommendedServices();

      expect(result).toEqual(expected);
      expect(listRecommendedServicesHandler.execute).toHaveBeenCalledTimes(1);
    });
  });

  describe('getServiceManual', () => {
    it('should delegate to GetServiceManualHandler', async () => {
      const appointmentId = 'appt-1';
      const expected = { serviceName: 'Massage', vendorName: 'Healytics' };
      getServiceManualHandler.execute.mockResolvedValue(expected);

      const result = await service.getServiceManual(appointmentId);

      expect(result).toEqual(expected);
      expect(getServiceManualHandler.execute).toHaveBeenCalledWith(
        appointmentId,
      );
      expect(getServiceManualHandler.execute).toHaveBeenCalledTimes(1);
    });
  });
});
