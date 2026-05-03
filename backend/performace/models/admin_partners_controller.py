"""Generated models for admin_partners_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
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
class PartnerItemDto(DtoModel):
    id: str
    taxCode: str
    brandName: str
    legalName: str
    email: str
    businessType: list[BusinessType]
    verificationStatus: PartnerVerificationStatus
    createdAt: datetime


@dataclass(slots=True)
class PartnersResponseDto(DtoModel):
    data: list[PartnerItemDto]
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
    "PartnerItemDto",
    "PartnersResponseDto",
    "ReviewItemDto",
    "ReviewPartnerProfileDto",
    "ReviewPartnerResponseDto",
    "TotalPartnersResponseDto",
]
