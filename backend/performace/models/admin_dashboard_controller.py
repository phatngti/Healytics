"""Generated models for admin_dashboard_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


class AdminDashboardNotificationPriority(str, Enum):
    LOW = 'low'
    MEDIUM = 'medium'
    HIGH = 'high'
    CRITICAL = 'critical'


class AdminDashboardNotificationType(str, Enum):
    BROADCAST = 'broadcast'
    PAYMENT = 'payment'
    REVIEW = 'review'
    CATEGORY = 'category'
    OPERATIONS = 'operations'


class AdminPartnerRankingVerificationStatus(str, Enum):
    PENDING = 'pending'
    CHANGESREQUIRED = 'changesRequired'
    APPROVED = 'approved'
    REJECTED = 'rejected'


@dataclass(slots=True)
class AdminCategoryHealthDto(DtoModel):
    totalCategories: float
    activeCategories: float
    inactiveCategories: float
    emptyCategories: float
    totalMappedServices: float
    topCategories: list[AdminCategorySnapshotDto]


@dataclass(slots=True)
class AdminCategorySnapshotDto(DtoModel):
    id: str
    name: str
    serviceCount: float
    isActive: bool


@dataclass(slots=True)
class AdminDashboardBookingOutcomeSummaryDto(DtoModel):
    totalBookings: float
    success: AdminOutcomeMetricDto
    failed: AdminOutcomeMetricDto
    canceled: AdminOutcomeMetricDto


@dataclass(slots=True)
class AdminDashboardNotificationItemDto(DtoModel):
    id: str
    title: str
    body: str
    createdAt: str
    type: AdminDashboardNotificationType
    priority: AdminDashboardNotificationPriority
    isRead: bool
    isBroadcast: bool


@dataclass(slots=True)
class AdminDashboardOverviewDto(DtoModel):
    grossRevenue: float
    netRevenue: float
    refundAmount: float
    failedPaymentAmount: float
    averageBookingValue: float
    successfulTransactions: float
    pendingTransactions: float
    refundedTransactions: float
    failedTransactions: float
    canceledTransactions: float
    totalPartners: float
    pendingPartnerReviews: float
    bookingSuccessRate: float
    bookingFailedRate: float
    bookingCanceledRate: float
    notificationVolume: float


@dataclass(slots=True)
class AdminDashboardRevenueTrendPointDto(DtoModel):
    date: str
    grossRevenue: float
    netRevenue: float
    refundAmount: float
    transactionCount: float
    successfulBookingCount: float


@dataclass(slots=True)
class AdminDashboardTransactionHealthDto(DtoModel):
    totalTransactions: float
    paid: float
    pending: float
    refunded: float
    failed: float
    canceled: float
    grossRevenue: float
    refundAmount: float
    failedAmount: float


@dataclass(slots=True)
class AdminOutcomeMetricDto(DtoModel):
    count: float
    rate: float


@dataclass(slots=True)
class AdminPartnerRankingItemDto(DtoModel):
    partnerId: str
    partnerName: str
    rank: float
    grossRevenue: float
    bookingCount: float
    successfulBookingRate: float
    verificationStatus: AdminPartnerRankingVerificationStatus


@dataclass(slots=True)
class AdminServiceRankingItemDto(DtoModel):
    serviceId: str
    serviceName: str
    categoryName: str
    partnerName: str
    rank: float
    grossRevenue: float
    bookingCount: float


AdminDashboardControllerGetNotificationsResponseDto: TypeAlias = list[AdminDashboardNotificationItemDto]  # GET /admin/dashboard/notifications [200]


AdminDashboardControllerGetRevenueTrendResponseDto: TypeAlias = list[AdminDashboardRevenueTrendPointDto]  # GET /admin/dashboard/revenue-trend [200]


AdminDashboardControllerGetTopPartnersResponseDto: TypeAlias = list[AdminPartnerRankingItemDto]  # GET /admin/dashboard/top-partners [200]


AdminDashboardControllerGetTopServicesResponseDto: TypeAlias = list[AdminServiceRankingItemDto]  # GET /admin/dashboard/top-services [200]


__all__ = [
    "AdminDashboardNotificationPriority",
    "AdminDashboardNotificationType",
    "AdminPartnerRankingVerificationStatus",
    "AdminCategoryHealthDto",
    "AdminCategorySnapshotDto",
    "AdminDashboardBookingOutcomeSummaryDto",
    "AdminDashboardNotificationItemDto",
    "AdminDashboardOverviewDto",
    "AdminDashboardRevenueTrendPointDto",
    "AdminDashboardTransactionHealthDto",
    "AdminOutcomeMetricDto",
    "AdminPartnerRankingItemDto",
    "AdminServiceRankingItemDto",
    "AdminDashboardControllerGetNotificationsResponseDto",
    "AdminDashboardControllerGetRevenueTrendResponseDto",
    "AdminDashboardControllerGetTopPartnersResponseDto",
    "AdminDashboardControllerGetTopServicesResponseDto",
]
