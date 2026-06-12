"""Generated models for user_clinic_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class ClinicCertificationDto(DtoModel):
    title: str
    iconName: str
    subtitle: str | None = None


@dataclass(slots=True)
class ClinicInfoResponseDto(DtoModel):
    id: str
    name: str
    gallery: list[str]
    followersLabel: str
    followerCount: float
    isFollowing: bool
    reviewsLabel: str
    trustMetrics: ClinicTrustMetricsDto
    certifications: list[ClinicCertificationDto]
    specialists: list[ClinicSpecialistPreviewDto]
    businessTypes: list[str]
    coverImageUrl: str | None = None
    logoImageUrl: str | None = None
    chatPartnerId: str | None = None
    description: str | None = None
    address: str | None = None
    phoneNumber: str | None = None


@dataclass(slots=True)
class ClinicProductCategoryDto(DtoModel):
    id: str
    label: str


@dataclass(slots=True)
class ClinicProductDto(DtoModel):
    id: str
    title: str
    price: str
    priceAmount: float
    categoryId: str
    soldCount: float
    createdAtMs: float
    imageUrl: str | None = None
    originalPrice: str | None = None
    discountLabel: str | None = None
    badgeLabel: str | None = None
    durationLabel: str | None = None
    specialistLabel: str | None = None


@dataclass(slots=True)
class ClinicProductsResponseDto(DtoModel):
    categories: list[ClinicProductCategoryDto]
    products: list[ClinicProductDto]
    totalCount: float
    hasMore: bool


@dataclass(slots=True)
class ClinicReviewDto(DtoModel):
    id: str
    reviewerName: str
    reviewerInitial: str
    starCount: float
    dateLabel: str
    reviewText: str
    mediaUrls: list[str]
    memberBadge: str | None = None
    serviceName: str | None = None
    serviceIcon: str | None = None
    clinicResponse: ClinicReviewResponseSubDto | None = None


@dataclass(slots=True)
class ClinicReviewFilterDto(DtoModel):
    id: str
    label: str
    requiresMedia: bool
    starCount: float | None = None


@dataclass(slots=True)
class ClinicReviewResponseSubDto(DtoModel):
    responseText: str | None = None


@dataclass(slots=True)
class ClinicReviewSummaryDto(DtoModel):
    averageRating: float
    totalReviewCount: float
    ratingLabel: str
    starDistribution: dict[str, Any]


@dataclass(slots=True)
class ClinicReviewsResponseDto(DtoModel):
    summary: ClinicReviewSummaryDto
    filters: list[ClinicReviewFilterDto]
    reviews: list[ClinicReviewDto]
    totalCount: float
    hasMore: bool


@dataclass(slots=True)
class ClinicSpecialistPreviewDto(DtoModel):
    id: str
    name: str
    role: str
    imageUrl: str | None = None
    experienceLabel: str | None = None


@dataclass(slots=True)
class ClinicTrustMetricsDto(DtoModel):
    rating: float
    reviewCount: float
    experienceLabel: str
    clientsLabel: str


__all__ = [
    "ClinicCertificationDto",
    "ClinicInfoResponseDto",
    "ClinicProductCategoryDto",
    "ClinicProductDto",
    "ClinicProductsResponseDto",
    "ClinicReviewDto",
    "ClinicReviewFilterDto",
    "ClinicReviewResponseSubDto",
    "ClinicReviewSummaryDto",
    "ClinicReviewsResponseDto",
    "ClinicSpecialistPreviewDto",
    "ClinicTrustMetricsDto",
]
