import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { Partner } from '@/common/entities/partner.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import {
  AdminDashboardPeriod,
  AdminDashboardPeriodQueryDto,
  AdminDashboardRankingQueryDto,
  AdminDashboardLimitQueryDto,
} from './dto/admin-dashboard-query.dto';
import {
  AdminDashboardOverviewDto,
  AdminDashboardRevenueTrendPointDto,
  AdminDashboardBookingOutcomeSummaryDto,
  AdminOutcomeMetricDto,
  AdminDashboardTransactionHealthDto,
  AdminPartnerRankingItemDto,
  AdminPartnerRankingVerificationStatus,
  AdminServiceRankingItemDto,
  AdminDashboardNotificationItemDto,
  AdminDashboardNotificationType,
  AdminDashboardNotificationPriority,
  AdminCategoryHealthDto,
  AdminCategorySnapshotDto,
} from './dto/admin-dashboard-response.dto';

type DateRange = { from: Date; to: Date; days: number };

type TransactionAggregateRow = {
  grossRevenue?: string | number;
  refundAmount?: string | number;
  failedPaymentAmount?: string | number;
  successfulTransactions?: string | number;
  pendingTransactions?: string | number;
  refundedTransactions?: string | number;
  failedTransactions?: string | number;
  canceledTransactions?: string | number;
  totalTransactions?: string | number;
};

type BookingOutcomeRow = {
  success?: string | number;
  failed?: string | number;
  canceled?: string | number;
  total?: string | number;
};

type TrendRow = {
  date: string | Date;
  grossRevenue?: string | number;
  refundAmount?: string | number;
  transactionCount?: string | number;
  successfulBookingCount?: string | number;
};

type PartnerRankingRow = {
  partnerId: string;
  partnerName?: string | null;
  verificationStatus?: PartnerVerificationStatus | string | null;
  grossRevenue?: string | number;
  bookingCount?: string | number;
  totalTransactions?: string | number;
};

type ServiceRankingRow = {
  serviceId: string;
  serviceName?: string | null;
  categoryName?: string | null;
  partnerName?: string | null;
  grossRevenue?: string | number;
  bookingCount?: string | number;
};

type NotificationRow = {
  id: string;
  reference?: string | null;
  status: PartnerTransactionStatus | string;
  createdAt: Date | string;
};

type CategoryHealthRow = {
  id: string;
  name?: string | null;
  isActive?: boolean | string | number | null;
  serviceCount?: string | number;
};

@Injectable()
export class AdminDashboardService {
  constructor(
    @InjectRepository(PartnerLedgerTransaction)
    private readonly txRepo: Repository<PartnerLedgerTransaction>,
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
  ) {}

  private periodToDateRange(
    period: AdminDashboardPeriod = AdminDashboardPeriod.THIRTY_DAYS,
  ): DateRange {
    const days = this.periodToDays(period);
    const to = new Date();
    const from = new Date(
      Date.UTC(to.getUTCFullYear(), to.getUTCMonth(), to.getUTCDate()),
    );
    from.setUTCDate(from.getUTCDate() - (days - 1));
    return { from, to, days };
  }

  private periodToDays(period: AdminDashboardPeriod): number {
    switch (period) {
      case AdminDashboardPeriod.SEVEN_DAYS:
        return 7;
      case AdminDashboardPeriod.NINETY_DAYS:
        return 90;
      case AdminDashboardPeriod.THIRTY_DAYS:
      default:
        return 30;
    }
  }

  private manager() {
    return this.txRepo.manager;
  }

  private toNumber(value: unknown): number {
    if (typeof value === 'number') return value;
    if (typeof value === 'string') return Number(value) || 0;
    return 0;
  }

  private toInt(value: unknown): number {
    return Math.trunc(this.toNumber(value));
  }

  private percent(part: number, total: number): number {
    return total > 0 ? (part / total) * 100 : 0;
  }

  private normalizeLimit(value: unknown): number {
    const parsed = typeof value === 'number' ? value : Number(value ?? 5);
    if (!Number.isFinite(parsed)) return 5;
    return Math.min(Math.max(Math.trunc(parsed), 1), 20);
  }

  private dateKey(value: Date | string): string {
    if (value instanceof Date) {
      return value.toISOString().slice(0, 10);
    }
    return value.slice(0, 10);
  }

  private isoDayKey(date: Date): string {
    return date.toISOString().slice(0, 10);
  }

  private mapVerificationStatus(
    value?: PartnerVerificationStatus | string | null,
  ): AdminPartnerRankingVerificationStatus {
    switch (value) {
      case PartnerVerificationStatus.PENDING:
        return AdminPartnerRankingVerificationStatus.PENDING;
      case PartnerVerificationStatus.REQUIRED_RESUBMIT:
        return AdminPartnerRankingVerificationStatus.CHANGES_REQUIRED;
      case PartnerVerificationStatus.REJECTED:
        return AdminPartnerRankingVerificationStatus.REJECTED;
      case PartnerVerificationStatus.APPROVED:
      default:
        return AdminPartnerRankingVerificationStatus.APPROVED;
    }
  }

  async getOverview(
    query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardOverviewDto> {
    const range = this.periodToDateRange(query.period);
    const [txAgg, bookingAgg, totalPartners, pendingReviews] =
      await Promise.all([
        this.getTransactionAggregate(range),
        this.getBookingOutcomeAggregate(range),
        this.partnerRepo.count(),
        this.partnerRepo.count({
          where: {
            verificationStatus: In([
              PartnerVerificationStatus.PENDING,
              PartnerVerificationStatus.REQUIRED_RESUBMIT,
            ]),
          },
        }),
      ]);

    const successfulTransactions = this.toInt(txAgg.successfulTransactions);
    const failedTransactions = this.toInt(txAgg.failedTransactions);
    const canceledTransactions = this.toInt(txAgg.canceledTransactions);
    const grossRevenue = this.toNumber(txAgg.grossRevenue);
    const refundAmount = this.toNumber(txAgg.refundAmount);
    const bookingSuccess = this.toInt(bookingAgg.success);
    const bookingFailed = this.toInt(bookingAgg.failed);
    const bookingCanceled = this.toInt(bookingAgg.canceled);
    const totalBookings = this.toInt(bookingAgg.total);

    const dto = new AdminDashboardOverviewDto();
    dto.grossRevenue = grossRevenue;
    dto.netRevenue = grossRevenue - refundAmount;
    dto.refundAmount = refundAmount;
    dto.failedPaymentAmount = this.toNumber(txAgg.failedPaymentAmount);
    dto.averageBookingValue =
      successfulTransactions > 0 ? grossRevenue / successfulTransactions : 0;
    dto.successfulTransactions = successfulTransactions;
    dto.pendingTransactions = this.toInt(txAgg.pendingTransactions);
    dto.refundedTransactions = this.toInt(txAgg.refundedTransactions);
    dto.failedTransactions = failedTransactions;
    dto.canceledTransactions = canceledTransactions;
    dto.totalPartners = totalPartners;
    dto.pendingPartnerReviews = pendingReviews;
    dto.bookingSuccessRate = this.percent(bookingSuccess, totalBookings);
    dto.bookingFailedRate = this.percent(bookingFailed, totalBookings);
    dto.bookingCanceledRate = this.percent(bookingCanceled, totalBookings);
    dto.notificationVolume =
      failedTransactions + this.toInt(txAgg.refundedTransactions);
    return dto;
  }

  async getRevenueTrend(
    query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardRevenueTrendPointDto[]> {
    const range = this.periodToDateRange(query.period);
    const rows = await this.manager().query(
      `
        SELECT
          DATE(txn.created_at AT TIME ZONE 'UTC') AS "date",
          COALESCE(SUM(CASE
            WHEN txn.type = $3 AND txn.status = $4
            THEN txn.gross_amount ELSE 0 END), 0) AS "grossRevenue",
          COALESCE(SUM(CASE
            WHEN txn.type = $5 OR txn.status = $6
            THEN txn.gross_amount ELSE 0 END), 0) AS "refundAmount",
          COUNT(*) AS "transactionCount",
          COUNT(*) FILTER (
            WHERE txn.type = $3 AND txn.status = $4
          ) AS "successfulBookingCount"
        FROM partner_ledger_transactions txn
        WHERE txn.created_at BETWEEN $1 AND $2
          AND txn.deleted_at IS NULL
          AND txn.type IN ($3, $5)
        GROUP BY DATE(txn.created_at AT TIME ZONE 'UTC')
        ORDER BY "date" ASC
      `,
      [
        range.from,
        range.to,
        PartnerTransactionType.CHARGE,
        PartnerTransactionStatus.PAID,
        PartnerTransactionType.REFUND,
        PartnerTransactionStatus.REFUNDED,
      ],
    );

    const byDate = new Map<string, TrendRow>(
      (rows as TrendRow[]).map((row) => [this.dateKey(row.date), row]),
    );

    return Array.from({ length: range.days }, (_, index) => {
      const date = new Date(range.from);
      date.setUTCDate(date.getUTCDate() + index);
      const key = this.isoDayKey(date);
      const row = byDate.get(key);
      const grossRevenue = this.toNumber(row?.grossRevenue);
      const refundAmount = this.toNumber(row?.refundAmount);
      const dto = new AdminDashboardRevenueTrendPointDto();
      dto.date = key;
      dto.grossRevenue = grossRevenue;
      dto.netRevenue = grossRevenue - refundAmount;
      dto.refundAmount = refundAmount;
      dto.transactionCount = this.toInt(row?.transactionCount);
      dto.successfulBookingCount = this.toInt(row?.successfulBookingCount);
      return dto;
    });
  }

  async getBookingOutcomeSummary(
    query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardBookingOutcomeSummaryDto> {
    const range = this.periodToDateRange(query.period);
    const row = await this.getBookingOutcomeAggregate(range);
    const success = this.toInt(row.success);
    const failed = this.toInt(row.failed);
    const canceled = this.toInt(row.canceled);
    const total = this.toInt(row.total);

    const dto = new AdminDashboardBookingOutcomeSummaryDto();
    dto.totalBookings = total;
    dto.success = this.outcomeMetric(success, total);
    dto.failed = this.outcomeMetric(failed, total);
    dto.canceled = this.outcomeMetric(canceled, total);
    return dto;
  }

  async getTransactionHealth(
    query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardTransactionHealthDto> {
    const row = await this.getTransactionAggregate(
      this.periodToDateRange(query.period),
    );
    const grossRevenue = this.toNumber(row.grossRevenue);
    const refundAmount = this.toNumber(row.refundAmount);
    const dto = new AdminDashboardTransactionHealthDto();
    dto.totalTransactions = this.toInt(row.totalTransactions);
    dto.paid = this.toInt(row.successfulTransactions);
    dto.pending = this.toInt(row.pendingTransactions);
    dto.refunded = this.toInt(row.refundedTransactions);
    dto.failed = this.toInt(row.failedTransactions);
    dto.canceled = this.toInt(row.canceledTransactions);
    dto.grossRevenue = grossRevenue;
    dto.refundAmount = refundAmount;
    dto.failedAmount = this.toNumber(row.failedPaymentAmount);
    return dto;
  }

  async getTopPartners(
    query: AdminDashboardRankingQueryDto,
  ): Promise<AdminPartnerRankingItemDto[]> {
    const range = this.periodToDateRange(query.period);
    const rows = await this.manager().query(
      `
        SELECT
          partner.id AS "partnerId",
          partner.brand_name AS "partnerName",
          partner.verification_status AS "verificationStatus",
          COALESCE(SUM(CASE
            WHEN txn.status = $4 THEN txn.gross_amount ELSE 0 END), 0)
            AS "grossRevenue",
          COUNT(*) FILTER (WHERE txn.status = $4) AS "bookingCount",
          COUNT(*) AS "totalTransactions"
        FROM partner_ledger_transactions txn
        INNER JOIN health_partner_profile partner
          ON partner.id = txn.partner_id
        WHERE txn.created_at BETWEEN $1 AND $2
          AND txn.deleted_at IS NULL
          AND txn.type = $3
        GROUP BY partner.id, partner.brand_name, partner.verification_status
        ORDER BY "grossRevenue" DESC, "bookingCount" DESC
        LIMIT $5
      `,
      [
        range.from,
        range.to,
        PartnerTransactionType.CHARGE,
        PartnerTransactionStatus.PAID,
        this.normalizeLimit(query.limit),
      ],
    );

    return (rows as PartnerRankingRow[]).map((row, index) => {
      const bookingCount = this.toInt(row.bookingCount);
      const totalTransactions = this.toInt(row.totalTransactions);
      const dto = new AdminPartnerRankingItemDto();
      dto.partnerId = row.partnerId;
      dto.partnerName = row.partnerName ?? 'Unknown';
      dto.rank = index + 1;
      dto.grossRevenue = this.toNumber(row.grossRevenue);
      dto.bookingCount = bookingCount;
      dto.successfulBookingRate = this.percent(bookingCount, totalTransactions);
      dto.verificationStatus = this.mapVerificationStatus(
        row.verificationStatus,
      );
      return dto;
    });
  }

  async getTopServices(
    query: AdminDashboardRankingQueryDto,
  ): Promise<AdminServiceRankingItemDto[]> {
    const range = this.periodToDateRange(query.period);
    const rows = await this.manager().query(
      `
        SELECT
          COALESCE(product.id::text, txn.source_id::text, txn.reference)
            AS "serviceId",
          COALESCE(product.name, txn.source_title_snapshot, 'Unknown Service')
            AS "serviceName",
          COALESCE(category.name, 'General') AS "categoryName",
          COALESCE(partner.brand_name, 'Unknown') AS "partnerName",
          COALESCE(SUM(txn.gross_amount), 0) AS "grossRevenue",
          COUNT(*) AS "bookingCount"
        FROM partner_ledger_transactions txn
        LEFT JOIN bookings booking
          ON booking.id = txn.source_id
        LEFT JOIN products product
          ON product.id = booking.product_id
        LEFT JOIN categories category
          ON category.id = product.category_id
        LEFT JOIN health_partner_profile partner
          ON partner.id = txn.partner_id
        WHERE txn.created_at BETWEEN $1 AND $2
          AND txn.deleted_at IS NULL
          AND txn.type = $3
          AND txn.status = $4
        GROUP BY
          COALESCE(product.id::text, txn.source_id::text, txn.reference),
          COALESCE(product.name, txn.source_title_snapshot, 'Unknown Service'),
          COALESCE(category.name, 'General'),
          COALESCE(partner.brand_name, 'Unknown')
        ORDER BY "grossRevenue" DESC, "bookingCount" DESC
        LIMIT $5
      `,
      [
        range.from,
        range.to,
        PartnerTransactionType.CHARGE,
        PartnerTransactionStatus.PAID,
        this.normalizeLimit(query.limit),
      ],
    );

    return (rows as ServiceRankingRow[]).map((row, index) => {
      const dto = new AdminServiceRankingItemDto();
      dto.serviceId = row.serviceId;
      dto.serviceName = row.serviceName ?? 'Unknown Service';
      dto.categoryName = row.categoryName ?? 'General';
      dto.partnerName = row.partnerName ?? 'Unknown';
      dto.rank = index + 1;
      dto.grossRevenue = this.toNumber(row.grossRevenue);
      dto.bookingCount = this.toInt(row.bookingCount);
      return dto;
    });
  }

  async getNotifications(
    query: AdminDashboardLimitQueryDto,
  ): Promise<AdminDashboardNotificationItemDto[]> {
    const rows = await this.manager().query(
      `
        SELECT
          txn.id,
          txn.reference,
          txn.status,
          txn.created_at AS "createdAt"
        FROM partner_ledger_transactions txn
        WHERE txn.deleted_at IS NULL
          AND txn.status IN ($1, $2)
        ORDER BY txn.created_at DESC
        LIMIT $3
      `,
      [
        PartnerTransactionStatus.FAILED,
        PartnerTransactionStatus.REFUNDED,
        this.normalizeLimit(query.limit),
      ],
    );

    return (rows as NotificationRow[]).map((row) => {
      const failed = row.status === PartnerTransactionStatus.FAILED;
      const dto = new AdminDashboardNotificationItemDto();
      dto.id = row.id;
      dto.title = failed ? 'Payment Failed' : 'Refund Processed';
      dto.body =
        `Transaction ${row.reference ?? row.id} ` +
        `${failed ? 'failed' : 'refunded'}`;
      dto.createdAt =
        row.createdAt instanceof Date
          ? row.createdAt.toISOString()
          : row.createdAt;
      dto.type = failed
        ? AdminDashboardNotificationType.PAYMENT
        : AdminDashboardNotificationType.OPERATIONS;
      dto.priority = failed
        ? AdminDashboardNotificationPriority.HIGH
        : AdminDashboardNotificationPriority.MEDIUM;
      dto.isRead = false;
      dto.isBroadcast = false;
      return dto;
    });
  }

  async getCategoryHealth(): Promise<AdminCategoryHealthDto> {
    const rows = await this.manager().query(`
      SELECT
        category.id,
        category.name,
        category.is_active AS "isActive",
        COUNT(DISTINCT product.id) AS "serviceCount"
      FROM categories category
      LEFT JOIN products product
        ON product.category_id = category.id
        AND product.deleted_at IS NULL
      WHERE category.deleted_at IS NULL
      GROUP BY category.id, category.name, category.is_active
      ORDER BY "serviceCount" DESC, category.name ASC
    `);

    const categories = (rows as CategoryHealthRow[]).map((row) => {
      const snapshot = new AdminCategorySnapshotDto();
      snapshot.id = row.id;
      snapshot.name = row.name ?? '';
      snapshot.serviceCount = this.toInt(row.serviceCount);
      snapshot.isActive =
        row.isActive === true || row.isActive === 'true' || row.isActive === 1;
      return snapshot;
    });

    const dto = new AdminCategoryHealthDto();
    dto.totalCategories = categories.length;
    dto.activeCategories = categories.filter((item) => item.isActive).length;
    dto.inactiveCategories = dto.totalCategories - dto.activeCategories;
    dto.emptyCategories = categories.filter(
      (item) => item.serviceCount === 0,
    ).length;
    dto.totalMappedServices = categories.reduce(
      (sum, item) => sum + item.serviceCount,
      0,
    );
    dto.topCategories = categories.slice(0, 5);
    return dto;
  }

  private async getTransactionAggregate(
    range: DateRange,
  ): Promise<TransactionAggregateRow> {
    const rows = await this.manager().query(
      `
        SELECT
          COALESCE(SUM(CASE
            WHEN txn.type = $3 AND txn.status = $4
            THEN txn.gross_amount ELSE 0 END), 0) AS "grossRevenue",
          COALESCE(SUM(CASE
            WHEN txn.type = $8 OR txn.status = $6
            THEN txn.gross_amount ELSE 0 END), 0) AS "refundAmount",
          COALESCE(SUM(CASE
            WHEN txn.type = $3 AND txn.status = $7
            THEN txn.gross_amount ELSE 0 END), 0) AS "failedPaymentAmount",
          COUNT(*) FILTER (WHERE txn.status = $4)
            AS "successfulTransactions",
          COUNT(*) FILTER (WHERE txn.status = $5)
            AS "pendingTransactions",
          COUNT(*) FILTER (WHERE txn.status = $6)
            AS "refundedTransactions",
          COUNT(*) FILTER (WHERE txn.status = $7)
            AS "failedTransactions",
          COUNT(*) FILTER (WHERE txn.status = $9)
            AS "canceledTransactions",
          COUNT(*) AS "totalTransactions"
        FROM partner_ledger_transactions txn
        WHERE txn.created_at BETWEEN $1 AND $2
          AND txn.deleted_at IS NULL
          AND txn.type IN ($3, $8)
      `,
      [
        range.from,
        range.to,
        PartnerTransactionType.CHARGE,
        PartnerTransactionStatus.PAID,
        PartnerTransactionStatus.PENDING,
        PartnerTransactionStatus.REFUNDED,
        PartnerTransactionStatus.FAILED,
        PartnerTransactionType.REFUND,
        PartnerTransactionStatus.CANCELED,
      ],
    );
    return (rows[0] ?? {}) as TransactionAggregateRow;
  }

  private async getBookingOutcomeAggregate(
    range: DateRange,
  ): Promise<BookingOutcomeRow> {
    const rows = await this.manager().query(
      `
        SELECT
          COUNT(*) FILTER (WHERE booking.status = $3) AS "success",
          COUNT(*) FILTER (WHERE booking.status = $4) AS "failed",
          COUNT(*) FILTER (WHERE booking.status = $5) AS "canceled",
          COUNT(*) AS "total"
        FROM bookings booking
        WHERE booking.created_at BETWEEN $1 AND $2
          AND booking.deleted_at IS NULL
          AND booking.status IN ($3, $4, $5)
      `,
      [
        range.from,
        range.to,
        BookingStatus.COMPLETED,
        BookingStatus.NO_SHOW,
        BookingStatus.CANCELLED,
      ],
    );
    return (rows[0] ?? {}) as BookingOutcomeRow;
  }

  private outcomeMetric(count: number, total: number): AdminOutcomeMetricDto {
    const metric = new AdminOutcomeMetricDto();
    metric.count = count;
    metric.rate = this.percent(count, total);
    return metric;
  }
}
