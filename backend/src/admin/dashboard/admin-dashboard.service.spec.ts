import { AdminDashboardService } from './admin-dashboard.service';
import { AdminDashboardPeriod } from './dto/admin-dashboard-query.dto';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { AdminPartnerRankingVerificationStatus } from './dto/admin-dashboard-response.dto';

type MockRepo = {
  manager: { query: jest.Mock };
  count: jest.Mock;
};

function createRepo(): MockRepo {
  return {
    manager: { query: jest.fn() },
    count: jest.fn(),
  };
}

function createService() {
  const txRepo = createRepo();
  const partnerRepo = createRepo();
  const service = new AdminDashboardService(txRepo as any, partnerRepo as any);
  return { service, txRepo, partnerRepo };
}

function todayKey() {
  return new Date().toISOString().slice(0, 10);
}

describe('AdminDashboardService', () => {
  afterEach(() => jest.clearAllMocks());

  it('aggregates overview with lowercase ledger statuses and percent booking rates', async () => {
    const { service, txRepo, partnerRepo } = createService();
    txRepo.manager.query.mockImplementation((sql: string) => {
      if (sql.includes('FROM partner_ledger_transactions')) {
        return Promise.resolve([
          {
            grossRevenue: '1000',
            refundAmount: '100',
            failedPaymentAmount: '50',
            successfulTransactions: '7',
            pendingTransactions: '1',
            refundedTransactions: '1',
            failedTransactions: '1',
            canceledTransactions: '0',
            totalTransactions: '10',
          },
        ]);
      }
      return Promise.resolve([
        {
          success: '7',
          failed: '1',
          canceled: '2',
          total: '10',
        },
      ]);
    });
    partnerRepo.count.mockResolvedValueOnce(12).mockResolvedValueOnce(3);

    const result = await service.getOverview({
      period: AdminDashboardPeriod.THIRTY_DAYS,
    });

    expect(result.grossRevenue).toBe(1000);
    expect(result.netRevenue).toBe(900);
    expect(result.bookingSuccessRate).toBe(70);
    expect(result.bookingFailedRate).toBe(10);
    expect(result.bookingCanceledRate).toBe(20);
    expect(result.notificationVolume).toBe(2);
    expect(txRepo.manager.query).toHaveBeenCalledWith(
      expect.stringContaining('partner_ledger_transactions'),
      expect.arrayContaining([
        PartnerTransactionType.CHARGE,
        PartnerTransactionStatus.PAID,
        PartnerTransactionStatus.PENDING,
        PartnerTransactionStatus.REFUNDED,
        PartnerTransactionStatus.FAILED,
        PartnerTransactionType.REFUND,
        PartnerTransactionStatus.CANCELED,
      ]),
    );
  });

  it('zero-fills the selected revenue trend period', async () => {
    const { service, txRepo } = createService();
    txRepo.manager.query.mockResolvedValue([
      {
        date: todayKey(),
        grossRevenue: '700',
        refundAmount: '50',
        transactionCount: '3',
        successfulBookingCount: '2',
      },
    ]);

    const result = await service.getRevenueTrend({
      period: AdminDashboardPeriod.SEVEN_DAYS,
    });

    expect(result).toHaveLength(7);
    expect(result[result.length - 1]).toMatchObject({
      date: todayKey(),
      grossRevenue: 700,
      netRevenue: 650,
      refundAmount: 50,
      transactionCount: 3,
      successfulBookingCount: 2,
    });
    expect(result.slice(0, -1).every((point) => point.grossRevenue === 0)).toBe(
      true,
    );
  });

  it('returns booking outcome totals that reconcile to 100 percent', async () => {
    const { service, txRepo } = createService();
    txRepo.manager.query.mockResolvedValue([
      {
        success: '8',
        failed: '1',
        canceled: '1',
        total: '10',
      },
    ]);

    const result = await service.getBookingOutcomeSummary({
      period: AdminDashboardPeriod.SEVEN_DAYS,
    });

    expect(result.totalBookings).toBe(10);
    expect(
      result.success.rate + result.failed.rate + result.canceled.rate,
    ).toBe(100);
  });

  it('applies ranking limits and normalizes partner verification statuses', async () => {
    const { service, txRepo } = createService();
    txRepo.manager.query.mockResolvedValue([
      {
        partnerId: 'partner-1',
        partnerName: 'Clinic One',
        verificationStatus: PartnerVerificationStatus.REQUIRED_RESUBMIT,
        grossRevenue: '1200',
        bookingCount: '3',
        totalTransactions: '4',
      },
    ]);

    const result = await service.getTopPartners({
      period: AdminDashboardPeriod.THIRTY_DAYS,
      limit: 2,
    });

    expect(txRepo.manager.query).toHaveBeenCalledWith(
      expect.any(String),
      expect.arrayContaining([2]),
    );
    expect(result[0]).toMatchObject({
      rank: 1,
      grossRevenue: 1200,
      bookingCount: 3,
      successfulBookingRate: 75,
      verificationStatus:
        AdminPartnerRankingVerificationStatus.CHANGES_REQUIRED,
    });
  });

  it('computes category health from categories and products', async () => {
    const { service, txRepo } = createService();
    txRepo.manager.query.mockResolvedValue([
      {
        id: 'cat-1',
        name: 'Massage',
        isActive: true,
        serviceCount: '2',
      },
      {
        id: 'cat-2',
        name: 'Empty',
        isActive: false,
        serviceCount: '0',
      },
    ]);

    const result = await service.getCategoryHealth();

    expect(txRepo.manager.query).toHaveBeenCalledWith(
      expect.stringContaining('LEFT JOIN products product'),
    );
    expect(result.totalCategories).toBe(2);
    expect(result.activeCategories).toBe(1);
    expect(result.inactiveCategories).toBe(1);
    expect(result.emptyCategories).toBe(1);
    expect(result.totalMappedServices).toBe(2);
  });
});
