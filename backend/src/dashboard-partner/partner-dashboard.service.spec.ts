import { Test, TestingModule } from '@nestjs/testing';
import { PartnerDashboardService } from './partner-dashboard.service';
import { PartnersService } from '@/partners/partners.service';
import { GetDashboardStatsHandler } from './handlers/get-dashboard-stats.handler';
import { GetRevenueDataHandler } from './handlers/get-revenue-data.handler';
import { ListUpcomingAppointmentsHandler } from './handlers/list-upcoming-appointments.handler';
import { GetServicePerformanceHandler } from './handlers/get-service-performance.handler';
import { GetEmployeeDistributionHandler } from './handlers/get-employee-distribution.handler';
import { ListRecentReviewsHandler } from './handlers/list-recent-reviews.handler';
import { GetStaffScheduleHandler } from './handlers/get-staff-schedule.handler';
import { ListDashboardNotificationsHandler } from './handlers/list-dashboard-notifications.handler';
import { GetInventoryAlertsHandler } from './handlers/get-inventory-alerts.handler';
import { DashboardTimePeriod } from './dto/query/dashboard-period-query.dto';

describe('PartnerDashboardService', () => {
  let service: PartnerDashboardService;
  let partnersService: { getPartnerProfile: jest.Mock };
  let handlers: Record<string, { execute: jest.Mock }>;

  const ACCOUNT_ID = 'account-uuid-1';
  const PARTNER_ID = 'partner-uuid-1';

  beforeEach(async () => {
    partnersService = {
      getPartnerProfile: jest.fn().mockResolvedValue({ id: PARTNER_ID }),
    };

    handlers = {
      getStats: { execute: jest.fn() },
      getRevenue: { execute: jest.fn() },
      listAppointments: { execute: jest.fn() },
      getPerformance: { execute: jest.fn() },
      getDistribution: { execute: jest.fn() },
      listReviews: { execute: jest.fn() },
      getSchedule: { execute: jest.fn() },
      listNotifications: { execute: jest.fn() },
      getAlerts: { execute: jest.fn() },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PartnerDashboardService,
        { provide: PartnersService, useValue: partnersService },
        { provide: GetDashboardStatsHandler, useValue: handlers.getStats },
        { provide: GetRevenueDataHandler, useValue: handlers.getRevenue },
        {
          provide: ListUpcomingAppointmentsHandler,
          useValue: handlers.listAppointments,
        },
        {
          provide: GetServicePerformanceHandler,
          useValue: handlers.getPerformance,
        },
        {
          provide: GetEmployeeDistributionHandler,
          useValue: handlers.getDistribution,
        },
        { provide: ListRecentReviewsHandler, useValue: handlers.listReviews },
        { provide: GetStaffScheduleHandler, useValue: handlers.getSchedule },
        {
          provide: ListDashboardNotificationsHandler,
          useValue: handlers.listNotifications,
        },
        {
          provide: GetInventoryAlertsHandler,
          useValue: handlers.getAlerts,
        },
      ],
    }).compile();

    service = module.get<PartnerDashboardService>(PartnerDashboardService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should resolve partnerId and delegate getStats', async () => {
    const expected = { totalBookings: 42 };
    handlers.getStats.execute.mockResolvedValue(expected);

    const result = await service.getStats(
      ACCOUNT_ID,
      DashboardTimePeriod.THIS_MONTH,
    );

    expect(partnersService.getPartnerProfile).toHaveBeenCalledWith(ACCOUNT_ID);
    expect(handlers.getStats.execute).toHaveBeenCalledWith(
      PARTNER_ID,
      DashboardTimePeriod.THIS_MONTH,
    );
    expect(result).toEqual(expected);
  });

  it('should default period to THIS_MONTH when not provided', async () => {
    handlers.getStats.execute.mockResolvedValue({});

    await service.getStats(ACCOUNT_ID);

    expect(handlers.getStats.execute).toHaveBeenCalledWith(
      PARTNER_ID,
      DashboardTimePeriod.THIS_MONTH,
    );
  });

  it('should delegate getRevenueData', async () => {
    const expected = [{ label: 'Jan', value: 1000000 }];
    handlers.getRevenue.execute.mockResolvedValue(expected);

    const result = await service.getRevenueData(ACCOUNT_ID);

    expect(handlers.getRevenue.execute).toHaveBeenCalledWith(
      PARTNER_ID,
      DashboardTimePeriod.THIS_MONTH,
    );
    expect(result).toEqual(expected);
  });

  it('should delegate getUpcomingAppointments', async () => {
    const expected = [{ id: 'appt-1' }];
    handlers.listAppointments.execute.mockResolvedValue(expected);

    const result = await service.getUpcomingAppointments(ACCOUNT_ID, 5);

    expect(handlers.listAppointments.execute).toHaveBeenCalledWith(
      PARTNER_ID,
      5,
    );
    expect(result).toEqual(expected);
  });

  it('should delegate getServicePerformance', async () => {
    const expected = [{ serviceName: 'Massage', bookings: 10 }];
    handlers.getPerformance.execute.mockResolvedValue(expected);

    const result = await service.getServicePerformance(ACCOUNT_ID);

    expect(handlers.getPerformance.execute).toHaveBeenCalledWith(PARTNER_ID);
    expect(result).toEqual(expected);
  });

  it('should delegate getEmployeeDistribution', async () => {
    const expected = [{ role: 'Doctor', count: 3 }];
    handlers.getDistribution.execute.mockResolvedValue(expected);

    const result = await service.getEmployeeDistribution(ACCOUNT_ID);

    expect(handlers.getDistribution.execute).toHaveBeenCalledWith(PARTNER_ID);
    expect(result).toEqual(expected);
  });

  it('should delegate getRecentReviews', async () => {
    const expected = [{ id: 'review-1', rating: 5 }];
    handlers.listReviews.execute.mockResolvedValue(expected);

    const result = await service.getRecentReviews(ACCOUNT_ID, 3);

    expect(handlers.listReviews.execute).toHaveBeenCalledWith(PARTNER_ID, 3);
    expect(result).toEqual(expected);
  });

  it('should delegate getStaffSchedule', async () => {
    const expected = [{ staffName: 'Dr. A', time: '09:00' }];
    handlers.getSchedule.execute.mockResolvedValue(expected);

    const result = await service.getStaffSchedule(ACCOUNT_ID, '2026-04-29');

    expect(handlers.getSchedule.execute).toHaveBeenCalledWith(
      PARTNER_ID,
      '2026-04-29',
    );
    expect(result).toEqual(expected);
  });

  it('should delegate getNotifications with accountId (not partnerId)', async () => {
    const expected = [{ id: 'notif-1' }];
    handlers.listNotifications.execute.mockResolvedValue(expected);

    const result = await service.getNotifications(ACCOUNT_ID, 10);

    // Notifications use accountId directly, not partnerId
    expect(handlers.listNotifications.execute).toHaveBeenCalledWith(
      ACCOUNT_ID,
      10,
    );
    expect(result).toEqual(expected);
  });

  it('should delegate getInventoryAlerts', async () => {
    const expected = [{ productName: 'Serum A', remaining: 2 }];
    handlers.getAlerts.execute.mockResolvedValue(expected);

    const result = await service.getInventoryAlerts(ACCOUNT_ID);

    expect(handlers.getAlerts.execute).toHaveBeenCalledWith(PARTNER_ID);
    expect(result).toEqual(expected);
  });
});
