import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class AdminDashboardOverviewDto {
  @ApiProperty({ type: Number })
  grossRevenue: number;

  @ApiProperty({ type: Number })
  netRevenue: number;

  @ApiProperty({ type: Number })
  refundAmount: number;

  @ApiProperty({ type: Number })
  failedPaymentAmount: number;

  @ApiProperty({ type: Number })
  averageBookingValue: number;

  @ApiProperty({ type: Number })
  successfulTransactions: number;

  @ApiProperty({ type: Number })
  pendingTransactions: number;

  @ApiProperty({ type: Number })
  refundedTransactions: number;

  @ApiProperty({ type: Number })
  failedTransactions: number;

  @ApiProperty({ type: Number })
  canceledTransactions: number;

  @ApiProperty({ type: Number })
  totalPartners: number;

  @ApiProperty({ type: Number })
  pendingPartnerReviews: number;

  @ApiProperty({ type: Number })
  bookingSuccessRate: number;

  @ApiProperty({ type: Number })
  bookingFailedRate: number;

  @ApiProperty({ type: Number })
  bookingCanceledRate: number;

  @ApiProperty({ type: Number })
  notificationVolume: number;
}

export class AdminDashboardRevenueTrendPointDto {
  @ApiProperty({ type: String, example: '2026-05-13' })
  date: string;

  @ApiProperty({ type: Number })
  grossRevenue: number;

  @ApiProperty({ type: Number })
  netRevenue: number;

  @ApiProperty({ type: Number })
  refundAmount: number;

  @ApiProperty({ type: Number })
  transactionCount: number;

  @ApiProperty({ type: Number })
  successfulBookingCount: number;
}

export class AdminOutcomeMetricDto {
  @ApiProperty({ type: Number })
  count: number;

  @ApiProperty({ type: Number })
  rate: number;
}

export class AdminDashboardBookingOutcomeSummaryDto {
  @ApiProperty({ type: Number })
  totalBookings: number;

  @ApiProperty({ type: AdminOutcomeMetricDto })
  @Type(() => AdminOutcomeMetricDto)
  success: AdminOutcomeMetricDto;

  @ApiProperty({ type: AdminOutcomeMetricDto })
  @Type(() => AdminOutcomeMetricDto)
  failed: AdminOutcomeMetricDto;

  @ApiProperty({ type: AdminOutcomeMetricDto })
  @Type(() => AdminOutcomeMetricDto)
  canceled: AdminOutcomeMetricDto;
}

export class AdminDashboardTransactionHealthDto {
  @ApiProperty({ type: Number })
  totalTransactions: number;

  @ApiProperty({ type: Number })
  paid: number;

  @ApiProperty({ type: Number })
  pending: number;

  @ApiProperty({ type: Number })
  refunded: number;

  @ApiProperty({ type: Number })
  failed: number;

  @ApiProperty({ type: Number })
  canceled: number;

  @ApiProperty({ type: Number })
  grossRevenue: number;

  @ApiProperty({ type: Number })
  refundAmount: number;

  @ApiProperty({ type: Number })
  failedAmount: number;
}

export enum AdminPartnerRankingVerificationStatus {
  PENDING = 'pending',
  CHANGES_REQUIRED = 'changesRequired',
  APPROVED = 'approved',
  REJECTED = 'rejected',
}

export class AdminPartnerRankingItemDto {
  @ApiProperty({ type: String })
  partnerId: string;

  @ApiProperty({ type: String })
  partnerName: string;

  @ApiProperty({ type: Number })
  rank: number;

  @ApiProperty({ type: Number })
  grossRevenue: number;

  @ApiProperty({ type: Number })
  bookingCount: number;

  @ApiProperty({ type: Number })
  successfulBookingRate: number;

  @ApiProperty({
    enum: AdminPartnerRankingVerificationStatus,
    enumName: 'AdminPartnerRankingVerificationStatus',
  })
  verificationStatus: AdminPartnerRankingVerificationStatus;
}

export class AdminServiceRankingItemDto {
  @ApiProperty({ type: String })
  serviceId: string;

  @ApiProperty({ type: String })
  serviceName: string;

  @ApiProperty({ type: String })
  categoryName: string;

  @ApiProperty({ type: String })
  partnerName: string;

  @ApiProperty({ type: Number })
  rank: number;

  @ApiProperty({ type: Number })
  grossRevenue: number;

  @ApiProperty({ type: Number })
  bookingCount: number;
}

export enum AdminDashboardNotificationType {
  BROADCAST = 'broadcast',
  PAYMENT = 'payment',
  REVIEW = 'review',
  CATEGORY = 'category',
  OPERATIONS = 'operations',
}

export enum AdminDashboardNotificationPriority {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
  CRITICAL = 'critical',
}

export class AdminDashboardNotificationItemDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  title: string;

  @ApiProperty({ type: String })
  body: string;

  @ApiProperty({ type: String })
  createdAt: string;

  @ApiProperty({
    enum: AdminDashboardNotificationType,
    enumName: 'AdminDashboardNotificationType',
  })
  type: AdminDashboardNotificationType;

  @ApiProperty({
    enum: AdminDashboardNotificationPriority,
    enumName: 'AdminDashboardNotificationPriority',
  })
  priority: AdminDashboardNotificationPriority;

  @ApiProperty({ type: Boolean })
  isRead: boolean;

  @ApiProperty({ type: Boolean })
  isBroadcast: boolean;
}

export class AdminCategorySnapshotDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  name: string;

  @ApiProperty({ type: Number })
  serviceCount: number;

  @ApiProperty({ type: Boolean })
  isActive: boolean;
}

export class AdminCategoryHealthDto {
  @ApiProperty({ type: Number })
  totalCategories: number;

  @ApiProperty({ type: Number })
  activeCategories: number;

  @ApiProperty({ type: Number })
  inactiveCategories: number;

  @ApiProperty({ type: Number })
  emptyCategories: number;

  @ApiProperty({ type: Number })
  totalMappedServices: number;

  @ApiProperty({ type: [AdminCategorySnapshotDto] })
  @Type(() => AdminCategorySnapshotDto)
  topCategories: AdminCategorySnapshotDto[];
}
