"""Generated models for partner_dashboard_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class DashboardNotificationDto(DtoModel):
    id: str
    title: str
    message: str
    type: str
    createdAt: str
    isRead: bool


@dataclass(slots=True)
class DashboardReviewDto(DtoModel):
    reviewerName: str
    rating: float
    status: str
    date: str
    text: str
    imageUrls: list[str]
    avatarUrl: str | None = None


@dataclass(slots=True)
class DashboardStatsResponseDto(DtoModel):
    totalAppointments: float
    completedAppointments: float
    cancelledAppointments: float
    pendingAppointments: float
    totalRevenue: float
    revenueGrowthPercent: float
    totalServices: float
    activeServices: float
    totalEmployees: float
    activeEmployees: float
    averageRating: float
    totalReviews: float


@dataclass(slots=True)
class EmployeeDistributionDto(DtoModel):
    role: str
    count: float
    status: str


@dataclass(slots=True)
class InventoryAlertDto(DtoModel):
    id: str
    productName: str
    alertType: str
    message: str
    createdAt: str
    severity: str


@dataclass(slots=True)
class RevenueDataPointDto(DtoModel):
    date: str
    revenue: float


@dataclass(slots=True)
class ServicePerformanceDto(DtoModel):
    serviceName: str
    bookingCount: float
    revenue: float
    averageRating: float


@dataclass(slots=True)
class StaffScheduleEntryDto(DtoModel):
    employeeId: str
    employeeName: str
    role: str
    startTime: str
    endTime: str
    serviceName: str
    patientName: str | None = None


@dataclass(slots=True)
class UpcomingAppointmentDto(DtoModel):
    id: str
    patientName: str
    serviceName: str
    employeeName: str
    scheduledAt: str
    status: str


PartnerDashboardControllerGetUpcomingAppointmentsResponseDto: TypeAlias = list[UpcomingAppointmentDto]  # GET /partner/dashboard/appointments/upcoming [200]


PartnerDashboardControllerGetEmployeeDistributionResponseDto: TypeAlias = list[EmployeeDistributionDto]  # GET /partner/dashboard/employees/distribution [200]


PartnerDashboardControllerGetInventoryAlertsResponseDto: TypeAlias = list[InventoryAlertDto]  # GET /partner/dashboard/inventory/alerts [200]


PartnerDashboardControllerGetNotificationsResponseDto: TypeAlias = list[DashboardNotificationDto]  # GET /partner/dashboard/notifications [200]


PartnerDashboardControllerGetRevenueResponseDto: TypeAlias = list[RevenueDataPointDto]  # GET /partner/dashboard/revenue [200]


PartnerDashboardControllerGetRecentReviewsResponseDto: TypeAlias = list[DashboardReviewDto]  # GET /partner/dashboard/reviews/recent [200]


PartnerDashboardControllerGetServicePerformanceResponseDto: TypeAlias = list[ServicePerformanceDto]  # GET /partner/dashboard/services/performance [200]


PartnerDashboardControllerGetStaffScheduleResponseDto: TypeAlias = list[StaffScheduleEntryDto]  # GET /partner/dashboard/staff/schedule [200]


__all__ = [
    "DashboardNotificationDto",
    "DashboardReviewDto",
    "DashboardStatsResponseDto",
    "EmployeeDistributionDto",
    "InventoryAlertDto",
    "RevenueDataPointDto",
    "ServicePerformanceDto",
    "StaffScheduleEntryDto",
    "UpcomingAppointmentDto",
    "PartnerDashboardControllerGetUpcomingAppointmentsResponseDto",
    "PartnerDashboardControllerGetEmployeeDistributionResponseDto",
    "PartnerDashboardControllerGetInventoryAlertsResponseDto",
    "PartnerDashboardControllerGetNotificationsResponseDto",
    "PartnerDashboardControllerGetRevenueResponseDto",
    "PartnerDashboardControllerGetRecentReviewsResponseDto",
    "PartnerDashboardControllerGetServicePerformanceResponseDto",
    "PartnerDashboardControllerGetStaffScheduleResponseDto",
]
