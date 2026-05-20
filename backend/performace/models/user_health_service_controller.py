"""Generated models for user_health_service_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import HealthServiceStatus, HealthServiceType


@dataclass(slots=True)
class BookingScheduleDto(DtoModel):
    date: dict[str, Any] | None = None
    timeSlotLabel: dict[str, Any] | None = None


@dataclass(slots=True)
class CategoryInfoDto(DtoModel):
    id: str
    name: str


@dataclass(slots=True)
class LocationInfoDto(DtoModel):
    name: str
    address: str
    mapUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class PriceBreakdownDto(DtoModel):
    subTotal: float
    discount: float
    totalAmount: float
    currency: str


@dataclass(slots=True)
class PublicCategoryDto(DtoModel):
    id: str
    name: str
    slug: str
    imageUrl: str | None = None


@dataclass(slots=True)
class PublicCategorySummaryDto(DtoModel):
    id: str
    name: str
    slug: str


@dataclass(slots=True)
class PublicClinicCertificationDto(DtoModel):
    title: str
    subtitle: str
    iconName: str


@dataclass(slots=True)
class PublicClinicDto(DtoModel):
    id: str
    name: str
    address: str
    avatarUrl: str | None = None


@dataclass(slots=True)
class PublicClinicFacilityImageDto(DtoModel):
    imageUrl: str
    label: str


@dataclass(slots=True)
class PublicClinicFeaturedServiceDto(DtoModel):
    id: str
    title: str
    price: str
    rating: float
    bookedLabel: str
    imageUrl: str | None = None


@dataclass(slots=True)
class PublicClinicInfoResponseDto(DtoModel):
    id: str
    name: str
    address: str
    isVerified: bool
    gallery: list[str]
    rating: float
    reviewCount: float
    followersLabel: str
    trustMetrics: PublicClinicTrustMetricsDto
    certifications: list[PublicClinicCertificationDto]
    specialists: list[PublicClinicSpecialistPreviewDto]
    facilityImages: list[PublicClinicFacilityImageDto]
    featuredServices: list[PublicClinicFeaturedServiceDto]
    coverImageUrl: str | None = None
    logoImageUrl: str | None = None
    phone: str | None = None
    coordinates: str | None = None
    chatPartnerId: str | None = None
    description: str | None = None


@dataclass(slots=True)
class PublicClinicSpecialistPreviewDto(DtoModel):
    id: str
    name: str
    role: str
    imageUrl: str | None = None
    experienceLabel: str | None = None


@dataclass(slots=True)
class PublicClinicTrustMetricsDto(DtoModel):
    experienceLabel: str
    specialistsCount: float
    certifiedLabel: str
    clientsLabel: str


@dataclass(slots=True)
class PublicEmployeeTimeSlotDto(DtoModel):
    label: str
    isAvailable: bool


@dataclass(slots=True)
class PublicFacilityImageDto(DtoModel):
    imageUrl: str
    label: str


@dataclass(slots=True)
class PublicFeatureTagDto(DtoModel):
    iconName: str
    label: str


@dataclass(slots=True)
class PublicHealthServiceCardResponseDto(DtoModel):
    id: str
    name: str
    slug: str
    category: str
    duration: str
    price: str
    rating: str
    vendorName: str
    location: str
    staffAvatars: list[str]
    type: str
    imageUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class PublicHealthServiceDefinitionDto(DtoModel):
    productId: str
    durationMinutes: float
    bufferMinutes: float | None = None
    maxCapacity: float | None = None
    minLeadTimeHours: float | None = None
    staffAssignmentType: str | None = None


@dataclass(slots=True)
class PublicHealthServiceEmployeeDayScheduleDto(DtoModel):
    date: str
    isAvailable: bool
    timeSlots: list[PublicEmployeeTimeSlotDto]


@dataclass(slots=True)
class PublicHealthServiceEmployeeEligibilityDto(DtoModel):
    productId: str
    employeeId: str
    isPrimary: bool


@dataclass(slots=True)
class PublicHealthServiceEmployeeResponseDto(DtoModel):
    id: str
    eligibilityId: str
    name: str
    role: str
    isSelected: bool
    daySchedules: list[PublicHealthServiceEmployeeDayScheduleDto]
    imageUrl: str | None = None
    quote: str | None = None
    degrees: str | None = None
    languages: str | None = None
    experience: str | None = None
    specializations: list[str] | None = None
    bio: str | None = None


@dataclass(slots=True)
class PublicHealthServiceInfoResponseDto(DtoModel):
    id: str
    title: str
    category: PublicCategoryDto
    images: list[str]
    rating: float
    reviewCount: float
    price: str
    isVerified: bool
    featureTags: list[PublicFeatureTagDto]
    clinic: PublicClinicDto
    facilityImages: list[PublicFacilityImageDto]
    serviceTags: list[PublicServiceTagDto]
    description: str | None = None


@dataclass(slots=True)
class PublicHealthServiceMediaDto(DtoModel):
    id: str
    url: str
    sortOrder: float
    mediaType: str | None = None
    isThumbnail: bool | None = None


@dataclass(slots=True)
class PublicHealthServiceRecommendedResponseDto(DtoModel):
    id: str
    title: str
    rating: float
    reviewLabel: str
    bookedLabel: str
    price: str
    imageUrl: str | None = None


@dataclass(slots=True)
class PublicHealthServiceResponseDto(DtoModel):
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
    category: PublicCategorySummaryDto | None = None
    media: list[PublicHealthServiceMediaDto] | None = None
    productDefinition: PublicHealthServiceDefinitionDto | None = None
    productEmployeeEligibilities: list[PublicHealthServiceEmployeeEligibilityDto] | None = None


@dataclass(slots=True)
class PublicHealthServiceReviewResponseDto(DtoModel):
    id: str
    reviewerName: str
    rating: float
    tags: list[str]
    photoUrls: list[str]
    createdAt: str
    avatarUrl: dict[str, Any] | None = None
    comment: dict[str, Any] | None = None


@dataclass(slots=True)
class PublicServiceTagDto(DtoModel):
    id: str
    name: str
    colorValue: str
    description: str | None = None


@dataclass(slots=True)
class ServiceInfoDto(DtoModel):
    id: str
    title: str
    duration: str
    subtitle: dict[str, Any] | None = None
    imageUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class SpecialistInfoDto(DtoModel):
    id: str
    name: str
    specialty: dict[str, Any] | None = None
    avatarUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class UserEligibilityDetailResponseDto(DtoModel):
    isCompletedStep: bool
    specialist: SpecialistInfoDto
    service: ServiceInfoDto
    category: CategoryInfoDto
    location: LocationInfoDto
    priceBreakdown: PriceBreakdownDto
    bookingSchedule: BookingScheduleDto | None = None


UserHealthServiceControllerGetHomeRecommendResponseDto: TypeAlias = list[PublicHealthServiceCardResponseDto]  # GET /user/health-services/home-recommend [200]


UserHealthServiceControllerGetPremiumTreatmentsResponseDto: TypeAlias = list[PublicHealthServiceCardResponseDto]  # GET /user/health-services/premium-treatments [200]


UserHealthServiceControllerGetProductEmployeesResponseDto: TypeAlias = list[PublicHealthServiceEmployeeResponseDto]  # GET /user/health-services/{id}/employees [200]


UserHealthServiceControllerGetRecommendedProductsResponseDto: TypeAlias = list[PublicHealthServiceRecommendedResponseDto]  # GET /user/health-services/{id}/recommended [200]


UserHealthServiceControllerGetProductReviewsResponseDto: TypeAlias = list[PublicHealthServiceReviewResponseDto]  # GET /user/health-services/{id}/reviews [200]


__all__ = [
    "BookingScheduleDto",
    "CategoryInfoDto",
    "LocationInfoDto",
    "PriceBreakdownDto",
    "PublicCategoryDto",
    "PublicCategorySummaryDto",
    "PublicClinicCertificationDto",
    "PublicClinicDto",
    "PublicClinicFacilityImageDto",
    "PublicClinicFeaturedServiceDto",
    "PublicClinicInfoResponseDto",
    "PublicClinicSpecialistPreviewDto",
    "PublicClinicTrustMetricsDto",
    "PublicEmployeeTimeSlotDto",
    "PublicFacilityImageDto",
    "PublicFeatureTagDto",
    "PublicHealthServiceCardResponseDto",
    "PublicHealthServiceDefinitionDto",
    "PublicHealthServiceEmployeeDayScheduleDto",
    "PublicHealthServiceEmployeeEligibilityDto",
    "PublicHealthServiceEmployeeResponseDto",
    "PublicHealthServiceInfoResponseDto",
    "PublicHealthServiceMediaDto",
    "PublicHealthServiceRecommendedResponseDto",
    "PublicHealthServiceResponseDto",
    "PublicHealthServiceReviewResponseDto",
    "PublicServiceTagDto",
    "ServiceInfoDto",
    "SpecialistInfoDto",
    "UserEligibilityDetailResponseDto",
    "UserHealthServiceControllerGetHomeRecommendResponseDto",
    "UserHealthServiceControllerGetPremiumTreatmentsResponseDto",
    "UserHealthServiceControllerGetProductEmployeesResponseDto",
    "UserHealthServiceControllerGetRecommendedProductsResponseDto",
    "UserHealthServiceControllerGetProductReviewsResponseDto",
]
