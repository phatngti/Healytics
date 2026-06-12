"""Generated models for admin_partners_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import BusinessInfoDto, BusinessType, LegalRepresentativeDto, PartnerVerificationStatus, VerifiedField


class PartnerPriority(str, Enum):
    LOW = 'low'
    NORMAL = 'normal'
    HIGH = 'high'
    URGENT = 'urgent'


@dataclass(slots=True)
class AdminPartnerDetailResponseDto(DtoModel):
    id: str
    businessInfo: BusinessInfoDto
    kycDocuments: list[VerifiedField]
    status: PartnerVerificationStatus
    priority: PartnerPriority
    submittedAt: datetime
    legalRepresentative: LegalRepresentativeDto | None = None
    reviewNote: str | None = None


@dataclass(slots=True)
class AdminPartnerItemDto(DtoModel):
    id: str
    taxCode: str
    legalName: str
    brandName: str
    email: str
    businessType: list[BusinessType]
    verificationStatus: PartnerVerificationStatus
    priority: PartnerPriority
    createdAt: datetime
    isAccountActive: bool
    verificationCompletedAt: dict[str, Any] | None = None


@dataclass(slots=True)
class AdminPartnerStatsResponseDto(DtoModel):
    pendingReview: float
    highPriority: float
    activeToday: float
    avgWaitSeconds: float
    avgWaitTime: str
    totalProviders: float
    requiredResubmit: float
    approved: float
    rejected: float


@dataclass(slots=True)
class AdminPartnersResponseDto(DtoModel):
    data: list[AdminPartnerItemDto]
    total: float
    page: float
    limit: float


@dataclass(slots=True)
class ReviewItemDto(DtoModel):
    fieldKey: str | None = None
    feedback: str | None = None


@dataclass(slots=True)
class ReviewPartnerProfileDto(DtoModel):
    decision: str
    generalComment: str | None = None
    items: list[ReviewItemDto] | None = None


@dataclass(slots=True)
class ReviewPartnerResponseDto(DtoModel):
    message: str


@dataclass(slots=True)
class TotalPartnersResponseDto(DtoModel):
    total: float


__all__ = [
    "PartnerPriority",
    "AdminPartnerDetailResponseDto",
    "AdminPartnerItemDto",
    "AdminPartnerStatsResponseDto",
    "AdminPartnersResponseDto",
    "ReviewItemDto",
    "ReviewPartnerProfileDto",
    "ReviewPartnerResponseDto",
    "TotalPartnersResponseDto",
]
