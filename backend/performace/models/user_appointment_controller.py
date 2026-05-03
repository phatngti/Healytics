"""Generated models for user_appointment_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


class AppointmentStatus(str, Enum):
    PENDING_PAYMENT = 'pending_payment'
    UPCOMING = 'upcoming'
    COMPLETED = 'completed'
    CANCELED = 'canceled'


@dataclass(slots=True)
class AppointmentCategoryResponseDto(DtoModel):
    id: str
    name: str
    iconSlug: str


@dataclass(slots=True)
class AppointmentResponseDto(DtoModel):
    id: str
    serviceName: str
    healthPartnerName: str
    imageUrl: str
    status: AppointmentStatus
    category: str
    specialistName: str
    specialistId: str
    address: str
    date: str
    checkInTime: str
    checkOutTime: str
    duration: str
    isReviewed: bool
    distanceKm: float | None
    healthPartnerId: str | None
    serviceId: str | None
    paymentUrl: str | None
    paymentDeeplink: str | None
    paymentExpiresAt: str | None


@dataclass(slots=True)
class FacilityDto(DtoModel):
    imageUrl: str
    name: str


@dataclass(slots=True)
class ProcedureStepDto(DtoModel):
    stepNumber: float
    title: str
    description: str
    isActive: bool


@dataclass(slots=True)
class RecommendedServiceResponseDto(DtoModel):
    id: str
    name: str
    description: str
    imageUrl: str
    price: str
    duration: str


@dataclass(slots=True)
class ReviewSummaryDto(DtoModel):
    averageRating: float
    reviewerName: str
    reviewText: str
    starCount: float


@dataclass(slots=True)
class ServiceManualResponseDto(DtoModel):
    serviceName: str
    vendorName: str
    imageUrl: str
    preServiceGuidelines: list[str]
    serviceRules: list[ServiceRuleDto]
    procedureSteps: list[ProcedureStepDto]
    facilities: list[FacilityDto]
    review: ReviewSummaryDto | None = None


@dataclass(slots=True)
class ServiceRuleDto(DtoModel):
    iconSlug: str
    title: str
    description: str


UserAppointmentControllerListAppointmentsResponseDto: TypeAlias = list[AppointmentResponseDto]  # GET /user/appointments [200]


UserAppointmentControllerListCategoriesResponseDto: TypeAlias = list[AppointmentCategoryResponseDto]  # GET /user/appointments/categories [200]


UserAppointmentControllerListRecommendedServicesResponseDto: TypeAlias = list[RecommendedServiceResponseDto]  # GET /user/appointments/recommendations [200]


__all__ = [
    "AppointmentStatus",
    "AppointmentCategoryResponseDto",
    "AppointmentResponseDto",
    "FacilityDto",
    "ProcedureStepDto",
    "RecommendedServiceResponseDto",
    "ReviewSummaryDto",
    "ServiceManualResponseDto",
    "ServiceRuleDto",
    "UserAppointmentControllerListAppointmentsResponseDto",
    "UserAppointmentControllerListCategoriesResponseDto",
    "UserAppointmentControllerListRecommendedServicesResponseDto",
]
