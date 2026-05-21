"""Generated models for partner_health_service_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import HealthServiceStatus, HealthServiceType


@dataclass(slots=True)
class AnalyticsAlertDto(DtoModel):
    title: str
    detail: str
    tone: str


@dataclass(slots=True)
class AnalyticsBookingMetricsDto(DtoModel):
    totalBookings: float
    delayedBookings: float
    delayThresholdMinutes: float
    pendingBookings: float
    completedBookings: float
    statusBreakdown: list[BookingStatusBreakdownDto]
    alerts: list[AnalyticsAlertDto]


@dataclass(slots=True)
class AnalyticsCategoryPerformanceDto(DtoModel):
    categoryName: str
    bookings: float
    revenue: float
    averageRating: float


@dataclass(slots=True)
class AnalyticsOperationalMetricDto(DtoModel):
    label: str
    value: str
    detail: str
    tone: str


@dataclass(slots=True)
class AnalyticsReviewBucketDto(DtoModel):
    stars: float
    count: float


@dataclass(slots=True)
class AnalyticsServicePerformanceDto(DtoModel):
    name: str
    categoryName: str
    bookings: float
    revenue: float
    averageRating: float


@dataclass(slots=True)
class AnalyticsTrendPointDto(DtoModel):
    label: str
    bookings: float
    revenue: float


@dataclass(slots=True)
class BookingStatusBreakdownDto(DtoModel):
    statusKey: str
    label: str
    count: float


@dataclass(slots=True)
class CreatePartnerHealthServiceDefinitionDto(DtoModel):
    durationMinutes: float
    bufferMinutes: float | None = None
    maxCapacity: float | None = None
    minLeadTimeHours: float | None = None
    staffAssignmentType: str | None = None


@dataclass(slots=True)
class CreatePartnerHealthServiceDto(DtoModel):
    name: str
    type: HealthServiceType
    categoryId: str | None = None
    slug: str | None = None
    description: str | None = None
    basePrice: float | None = None
    salePrice: float | None = None
    currency: str | None = None
    status: str | None = None
    isVisibleOnline: bool | None = None
    employeeIds: list[str] | None = None
    tagIds: list[str] | None = None
    media: list[CreatePartnerHealthServiceMediaDto] | None = None
    productDefinition: CreatePartnerHealthServiceDefinitionDto | None = None
    facilityImages: list[CreatePartnerHealthServiceFacilityImageDto] | None = None
    serviceManual: ServiceManualInputDto | None = None


@dataclass(slots=True)
class CreatePartnerHealthServiceFacilityImageDto(DtoModel):
    imageUrl: str
    label: str
    sortOrder: float | None = None


@dataclass(slots=True)
class CreatePartnerHealthServiceMediaDto(DtoModel):
    url: str
    mediaType: str | None = None
    isThumbnail: bool | None = None
    sortOrder: float | None = None


@dataclass(slots=True)
class HealthServiceDetailAnalyticsResponseDto(DtoModel):
    productId: str
    bookings: float
    bookingsDelta: float
    revenue: float
    revenueDelta: float
    completionRate: float
    completionRateDelta: float
    averageRating: float
    reviewCount: float
    trendPoints: list[AnalyticsTrendPointDto]
    reviewDistribution: list[AnalyticsReviewBucketDto]
    operationalMetrics: list[AnalyticsOperationalMetricDto]
    peerRanking: list[AnalyticsServicePerformanceDto]
    alerts: list[AnalyticsAlertDto]


@dataclass(slots=True)
class HealthServiceOverviewAnalyticsResponseDto(DtoModel):
    totalProducts: float
    activeProducts: float
    bookings: float
    bookingsDelta: float
    revenue: float
    revenueDelta: float
    averageRating: float
    ratingDelta: float
    reviewCount: float
    bookingMetrics: AnalyticsBookingMetricsDto
    trendPoints: list[AnalyticsTrendPointDto]
    categoryPerformance: list[AnalyticsCategoryPerformanceDto]
    topServices: list[AnalyticsServicePerformanceDto]


@dataclass(slots=True)
class PartnerCategorySummaryDto(DtoModel):
    id: str
    name: str
    slug: str


@dataclass(slots=True)
class PartnerClinicDto(DtoModel):
    name: str
    address: str
    isVerified: bool | None = None


@dataclass(slots=True)
class PartnerDayScheduleDto(DtoModel):
    day: str
    date: str
    slots: list[PartnerTimeSlotDto]


@dataclass(slots=True)
class PartnerDetailProcedureStepDto(DtoModel):
    stepNumber: float
    title: str
    description: str


@dataclass(slots=True)
class PartnerDetailServiceManualDto(DtoModel):
    preServiceGuidelines: list[str] | None = None
    serviceRules: list[PartnerDetailServiceRuleDto] | None = None
    procedureSteps: list[PartnerDetailProcedureStepDto] | None = None


@dataclass(slots=True)
class PartnerDetailServiceRuleDto(DtoModel):
    iconSlug: str
    title: str
    description: str


@dataclass(slots=True)
class PartnerFacilityImageDto(DtoModel):
    imageUrl: str
    label: str


@dataclass(slots=True)
class PartnerFeatureTagDto(DtoModel):
    iconName: str
    label: str


@dataclass(slots=True)
class PartnerHealthServiceDefinitionDto(DtoModel):
    productId: str
    durationMinutes: float
    bufferMinutes: float | None = None
    maxCapacity: float | None = None
    minLeadTimeHours: float | None = None
    staffAssignmentType: str | None = None


@dataclass(slots=True)
class PartnerHealthServiceDetailResponseDto(DtoModel):
    id: str
    title: str
    categoryLabel: str
    images: list[str]
    rating: float
    reviewCount: float
    price: str
    isVerified: bool
    duration: float
    featureTags: list[PartnerFeatureTagDto]
    clinic: PartnerClinicDto
    specialists: list[PartnerSpecialistDto]
    daySchedules: list[PartnerDayScheduleDto]
    facilityImages: list[PartnerFacilityImageDto]
    reviews: list[PartnerReviewDto]
    recommendedServices: list[PartnerRecommendedServiceDto]
    description: str | None = None
    serviceManual: PartnerDetailServiceManualDto | None = None


@dataclass(slots=True)
class PartnerHealthServiceEmployeeEligibilityDto(DtoModel):
    productId: str
    employeeId: str
    isPrimary: bool


@dataclass(slots=True)
class PartnerHealthServiceMediaDto(DtoModel):
    id: str
    url: str
    sortOrder: float
    mediaType: str | None = None
    isThumbnail: bool | None = None


@dataclass(slots=True)
class PartnerHealthServiceResponseDto(DtoModel):
    id: str
    name: str
    slug: str
    type: HealthServiceType
    basePrice: float
    currency: str
    status: HealthServiceStatus
    isVisibleOnline: bool
    createdAt: datetime
    updatedAt: datetime
    description: str | None = None
    salePrice: float | None = None
    vendorName: str | None = None
    category: PartnerCategorySummaryDto | None = None
    media: list[PartnerHealthServiceMediaDto] | None = None
    productDefinition: PartnerHealthServiceDefinitionDto | None = None
    productEmployeeEligibilities: list[PartnerHealthServiceEmployeeEligibilityDto] | None = None
    serviceManual: PartnerServiceManualDto | None = None
    productTags: list[PartnerProductTagDto] | None = None
    tagIds: list[str] | None = None


@dataclass(slots=True)
class PartnerProcedureStepDto(DtoModel):
    stepNumber: float
    title: str
    description: str


@dataclass(slots=True)
class PartnerProductTagDetailDto(DtoModel):
    id: str
    name: str
    colorValue: str
    description: str | None = None


@dataclass(slots=True)
class PartnerProductTagDto(DtoModel):
    tagId: str
    tag: PartnerProductTagDetailDto | None = None


@dataclass(slots=True)
class PartnerRecommendedServiceDto(DtoModel):
    id: str
    title: str
    rating: float
    reviewCount: float
    price: str
    imageUrl: str | None = None


@dataclass(slots=True)
class PartnerReviewDto(DtoModel):
    id: str
    reviewerName: str
    rating: float
    status: str
    date: str
    text: str
    avatarUrl: str | None = None
    imageUrls: list[str] | None = None


@dataclass(slots=True)
class PartnerServiceManualDto(DtoModel):
    preServiceGuidelines: list[str] | None = None
    serviceRules: list[PartnerServiceRuleDto] | None = None
    procedureSteps: list[PartnerProcedureStepDto] | None = None


@dataclass(slots=True)
class PartnerServiceRuleDto(DtoModel):
    iconSlug: str
    title: str
    description: str


@dataclass(slots=True)
class PartnerSpecialistDto(DtoModel):
    id: str
    name: str
    role: str
    imageUrl: str | None = None
    degrees: str | None = None
    experience: str | None = None
    specializations: list[str] | None = None
    bio: str | None = None
    quote: str | None = None
    languages: list[str] | None = None


@dataclass(slots=True)
class PartnerTimeSlotDto(DtoModel):
    time: str
    available: bool


@dataclass(slots=True)
class ProcedureStepInputDto(DtoModel):
    stepNumber: float
    title: str
    description: str


@dataclass(slots=True)
class ServiceManualInputDto(DtoModel):
    preServiceGuidelines: list[str] | None = None
    serviceRules: list[ServiceRuleInputDto] | None = None
    procedureSteps: list[ProcedureStepInputDto] | None = None


@dataclass(slots=True)
class ServiceRuleInputDto(DtoModel):
    iconSlug: str
    title: str
    description: str


@dataclass(slots=True)
class UpdatePartnerHealthServiceDefinitionDto(DtoModel):
    durationMinutes: float | None = None
    bufferMinutes: float | None = None
    maxCapacity: float | None = None
    minLeadTimeHours: float | None = None
    staffAssignmentType: str | None = None


@dataclass(slots=True)
class UpdatePartnerHealthServiceDto(DtoModel):
    categoryId: str | None = None
    description: str | None = None
    salePrice: float | None = None
    name: str | None = None
    slug: str | None = None
    type: HealthServiceType | None = None
    basePrice: float | None = None
    currency: str | None = None
    status: str | None = None
    isVisibleOnline: bool | None = None
    employeeIds: list[str] | None = None
    tagIds: list[str] | None = None
    media: list[CreatePartnerHealthServiceMediaDto] | None = None
    productDefinition: UpdatePartnerHealthServiceDefinitionDto | None = None
    facilityImages: list[CreatePartnerHealthServiceFacilityImageDto] | None = None
    serviceManual: ServiceManualInputDto | None = None


PartnerHealthServiceControllerFindAllResponseDto: TypeAlias = list[PartnerHealthServiceResponseDto]  # GET /partner/health-services [200]


__all__ = [
    "AnalyticsAlertDto",
    "AnalyticsBookingMetricsDto",
    "AnalyticsCategoryPerformanceDto",
    "AnalyticsOperationalMetricDto",
    "AnalyticsReviewBucketDto",
    "AnalyticsServicePerformanceDto",
    "AnalyticsTrendPointDto",
    "BookingStatusBreakdownDto",
    "CreatePartnerHealthServiceDefinitionDto",
    "CreatePartnerHealthServiceDto",
    "CreatePartnerHealthServiceFacilityImageDto",
    "CreatePartnerHealthServiceMediaDto",
    "HealthServiceDetailAnalyticsResponseDto",
    "HealthServiceOverviewAnalyticsResponseDto",
    "PartnerCategorySummaryDto",
    "PartnerClinicDto",
    "PartnerDayScheduleDto",
    "PartnerDetailProcedureStepDto",
    "PartnerDetailServiceManualDto",
    "PartnerDetailServiceRuleDto",
    "PartnerFacilityImageDto",
    "PartnerFeatureTagDto",
    "PartnerHealthServiceDefinitionDto",
    "PartnerHealthServiceDetailResponseDto",
    "PartnerHealthServiceEmployeeEligibilityDto",
    "PartnerHealthServiceMediaDto",
    "PartnerHealthServiceResponseDto",
    "PartnerProcedureStepDto",
    "PartnerProductTagDetailDto",
    "PartnerProductTagDto",
    "PartnerRecommendedServiceDto",
    "PartnerReviewDto",
    "PartnerServiceManualDto",
    "PartnerServiceRuleDto",
    "PartnerSpecialistDto",
    "PartnerTimeSlotDto",
    "ProcedureStepInputDto",
    "ServiceManualInputDto",
    "ServiceRuleInputDto",
    "UpdatePartnerHealthServiceDefinitionDto",
    "UpdatePartnerHealthServiceDto",
    "PartnerHealthServiceControllerFindAllResponseDto",
]
