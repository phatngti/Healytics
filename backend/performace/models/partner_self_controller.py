"""Generated models for partner_self_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import BusinessInfoDto, LegalRepresentativeDto, PartnerVerificationStatus, VerifiedField


@dataclass(slots=True)
class AddressDto(DtoModel):
    streetAddress: UpdatedField | None = None
    ward: UpdatedField | None = None
    district: UpdatedField | None = None
    city: UpdatedField | None = None


@dataclass(slots=True)
class BusinessInfo(DtoModel):
    brandName: UpdatedField | None = None
    taxRegistrationCode: UpdatedField | None = None
    serviceTags: UpdatedField | None = None
    address: AddressDto | None = None
    username: UpdatedField | None = None
    email: UpdatedField | None = None
    phoneNumber: UpdatedField | None = None


@dataclass(slots=True)
class CompletionChecklistItemDto(DtoModel):
    key: str
    label: str
    required: bool
    completed: bool


@dataclass(slots=True)
class KycDocumentDto(DtoModel):
    fileUrl: UpdatedField | None = None
    fileType: UpdatedField | None = None


@dataclass(slots=True)
class MyProfileCompletionResponseDto(DtoModel):
    id: str
    clinicIdentity: PartnerProfileCompletionIdentityDto
    gallery: list[str]
    certifications: list[PartnerProfileCompletionCertificationDto]
    checklist: list[CompletionChecklistItemDto]
    completionPercent: float
    isCompleted: bool
    coverImageUrl: dict[str, Any] | None = None
    logoImageUrl: dict[str, Any] | None = None
    description: dict[str, Any] | None = None


@dataclass(slots=True)
class MyProfileResponseDto(DtoModel):
    id: str
    businessInfo: BusinessInfoDto
    kycDocuments: list[VerifiedField]
    verificationStatus: PartnerVerificationStatus
    createdAt: datetime
    legalRepresentative: LegalRepresentativeDto | None = None
    verificationCompletedAt: datetime | None = None


@dataclass(slots=True)
class PartnerProfileCompletionCertificationDto(DtoModel):
    id: str
    title: str
    iconName: str
    sortOrder: float
    subtitle: dict[str, Any] | None = None


@dataclass(slots=True)
class PartnerProfileCompletionIdentityDto(DtoModel):
    brandName: str
    legalName: str
    businessType: list[str]
    phoneNumber: dict[str, Any] | None = None
    address: dict[str, Any] | None = None


@dataclass(slots=True)
class PartnerPublicProfileResponseDto(DtoModel):
    id: str
    businessInfo: PublicProfileBusinessInfoDto
    address: PublicProfileAddressDto
    verificationStatus: str
    publicProfile: PublicProfileStorefrontDto
    completionSummary: PublicProfileCompletionSummaryDto
    readOnlyLegalSummary: PublicProfileLegalSummaryDto | None = None


@dataclass(slots=True)
class PublicProfileAddressDto(DtoModel):
    streetAddress: str
    ward: dict[str, Any] | None = None
    district: dict[str, Any] | None = None
    province: dict[str, Any] | None = None
    latitude: float | None = None
    longitude: float | None = None
    formattedAddress: dict[str, Any] | None = None


@dataclass(slots=True)
class PublicProfileBusinessInfoDto(DtoModel):
    brandName: str
    legalName: str
    taxCode: str
    businessType: list[str]
    phoneNumber: dict[str, Any] | None = None
    email: dict[str, Any] | None = None
    username: dict[str, Any] | None = None


@dataclass(slots=True)
class PublicProfileCertificationDto(DtoModel):
    id: str
    title: str
    iconName: str
    sortOrder: float
    subtitle: dict[str, Any] | None = None


@dataclass(slots=True)
class PublicProfileChecklistItemDto(DtoModel):
    key: str
    label: str
    required: bool
    completed: bool


@dataclass(slots=True)
class PublicProfileCompletionSummaryDto(DtoModel):
    checklist: list[PublicProfileChecklistItemDto]
    completionPercent: float
    isCompleted: bool


@dataclass(slots=True)
class PublicProfileLegalSummaryDto(DtoModel):
    fullName: str
    position: str
    idType: str
    idNumber: str


@dataclass(slots=True)
class PublicProfileStorefrontDto(DtoModel):
    gallery: list[str]
    certifications: list[PublicProfileCertificationDto]
    coverImageUrl: dict[str, Any] | None = None
    logoImageUrl: dict[str, Any] | None = None
    description: dict[str, Any] | None = None


@dataclass(slots=True)
class UpdatePartnerCertificationDto(DtoModel):
    id: str | None = None
    title: str | None = None
    subtitle: dict[str, Any] | None = None
    iconName: str | None = None
    sortOrder: float | None = None


@dataclass(slots=True)
class UpdatePartnerDto(DtoModel):
    bussinessInfo: BusinessInfo | None = None
    legalRepresentative: LegalRepresentativeDto | None = None
    kycDocuments: list[KycDocumentDto] | None = None


@dataclass(slots=True)
class UpdatePartnerProfileCompletionDto(DtoModel):
    coverImageUrl: str | None = None
    logoImageUrl: str | None = None
    description: str | None = None
    gallery: list[str] | None = None
    certifications: list[UpdatePartnerCertificationDto] | None = None


@dataclass(slots=True)
class UpdatePartnerPublicProfileDto(DtoModel):
    coverImageUrl: str | None = None
    logoImageUrl: str | None = None
    description: str | None = None
    gallery: list[str] | None = None
    certifications: list[UpdatePartnerCertificationDto] | None = None


UpdatedField: TypeAlias = dict[str, Any]


__all__ = [
    "AddressDto",
    "BusinessInfo",
    "CompletionChecklistItemDto",
    "KycDocumentDto",
    "MyProfileCompletionResponseDto",
    "MyProfileResponseDto",
    "PartnerProfileCompletionCertificationDto",
    "PartnerProfileCompletionIdentityDto",
    "PartnerPublicProfileResponseDto",
    "PublicProfileAddressDto",
    "PublicProfileBusinessInfoDto",
    "PublicProfileCertificationDto",
    "PublicProfileChecklistItemDto",
    "PublicProfileCompletionSummaryDto",
    "PublicProfileLegalSummaryDto",
    "PublicProfileStorefrontDto",
    "UpdatePartnerCertificationDto",
    "UpdatePartnerDto",
    "UpdatePartnerProfileCompletionDto",
    "UpdatePartnerPublicProfileDto",
    "UpdatedField",
]
