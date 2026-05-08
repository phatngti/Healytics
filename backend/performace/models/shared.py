"""Generated models for shared. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field


class BusinessType(str, Enum):
    MASSAGE_THERAPY = 'MASSAGE_THERAPY'
    MASSAGE_REHABILITATION = 'MASSAGE_REHABILITATION'
    SPA_BEAUTY = 'SPA_BEAUTY'
    FITNESS = 'FITNESS'
    PHARMACY = 'PHARMACY'
    DENTAL = 'DENTAL'
    TRADITIONAL_MEDICINE = 'TRADITIONAL_MEDICINE'
    PSYCHOLOGY = 'PSYCHOLOGY'
    DERMATOLOGY = 'DERMATOLOGY'
    NUTRITION = 'NUTRITION'
    PSYCHIATRY = 'PSYCHIATRY'


class ConversationStatus(str, Enum):
    ACTIVE = 'active'
    ARCHIVED = 'archived'
    CLOSED = 'closed'


class HealthServiceStatus(str, Enum):
    DRAFT = 'draft'
    ACTIVE = 'active'
    ARCHIVED = 'archived'


class HealthServiceType(str, Enum):
    SERVICE = 'service'


class PartnerPayoutStatus(str, Enum):
    NOTASSIGNED = 'notAssigned'
    INPAYOUT = 'inPayout'
    PAIDOUT = 'paidOut'
    FAILED = 'failed'


class PartnerRefundCaseStatus(str, Enum):
    PENDING = 'pending'
    UNDERREVIEW = 'underReview'
    APPROVED = 'approved'
    REJECTED = 'rejected'


class PartnerRefundCaseType(str, Enum):
    REFUND = 'refund'
    DISPUTE = 'dispute'


class PartnerVerificationStatus(str, Enum):
    PENDING = 'PENDING'
    APPROVED = 'APPROVED'
    REJECTED = 'REJECTED'
    REQUIRED_RESUBMIT = 'REQUIRED_RESUBMIT'


@dataclass(slots=True)
class AddressInfoDto(DtoModel):
    streetAddress: VerifiedField
    ward: VerifiedField | None = None
    district: VerifiedField | None = None
    city: VerifiedField | None = None
    country: str | None = None
    latitude: float | None = None
    longitude: float | None = None


@dataclass(slots=True)
class BookingServiceResponseDto(DtoModel):
    id: str
    title: str
    duration: str
    price: str
    imageUrl: dict[str, Any] | None = None
    clinicName: dict[str, Any] | None = None
    clinicAddress: dict[str, Any] | None = None
    distance: dict[str, Any] | None = None
    durationMinutes: dict[str, Any] | None = None
    priceVnd: dict[str, Any] | None = None


@dataclass(slots=True)
class BusinessInfoDto(DtoModel):
    brandName: VerifiedField
    businessType: VerifiedField
    legalName: VerifiedField | None = None
    taxRegistrationCode: VerifiedField | None = None
    address: AddressInfoDto | None = None
    email: VerifiedField | None = None
    phoneNumber: VerifiedField | None = None
    username: VerifiedField | None = None


@dataclass(slots=True)
class CategorySummaryDto(DtoModel):
    id: str
    name: str
    slug: str


@dataclass(slots=True)
class ConversationResponseDto(DtoModel):
    id: str
    status: ConversationStatus
    otherParticipant: ParticipantInfoDto
    lastMessage: LastMessageDto
    unreadCount: float
    createdAt: datetime
    bookingId: str | None = None


@dataclass(slots=True)
class CreateConversationDto(DtoModel):
    healthPartnerId: str
    bookingId: str | None = None
    initialMessage: str | None = None


@dataclass(slots=True)
class DoctorProfileResponseDto(DtoModel):
    employeeId: str | None = None
    title: str | None = None
    medicalCredentials: list[MedicalCredentialResponseDto] | None = None
    experienceYears: float | None = None
    consultationFee: float | None = None
    specializations: list[str] | None = None
    education: list[str] | None = None


@dataclass(slots=True)
class DocumentEntryDto(DtoModel):
    name: str
    url: str
    updatedTime: str | None = None


@dataclass(slots=True)
class EmployeeResponseDto(DtoModel):
    id: str
    employeeCode: str
    fullName: str
    email: str
    role: str
    status: str
    rating: float
    reviewCount: float
    createdAt: datetime
    updatedAt: datetime
    firstName: dict[str, Any] | None = None
    lastName: dict[str, Any] | None = None
    phone: dict[str, Any] | None = None
    avatarUrl: dict[str, Any] | None = None
    jobTitle: dict[str, Any] | None = None
    startDate: dict[str, Any] | None = None
    employmentType: dict[str, Any] | None = None
    description: dict[str, Any] | None = None
    emergencyContactName: dict[str, Any] | None = None
    emergencyContactPhone: dict[str, Any] | None = None
    verificationDocuments: list[VerificationDocumentEntryDto] | None = None
    schedule: list[WorkScheduleEntryDto] | None = None
    workHistory: list[WorkHistoryEntryDto] | None = None
    dob: dict[str, Any] | None = None
    gender: str | None = None
    partnerId: dict[str, Any] | None = None
    doctorProfile: DoctorProfileResponseDto | None = None
    therapistProfile: TherapistProfileResponseDto | None = None


@dataclass(slots=True)
class LastMessageDto(DtoModel):
    text: str | None = None
    timestamp: datetime | None = None
    senderId: str | None = None


@dataclass(slots=True)
class LegalRepresentativeDto(DtoModel):
    fullName: VerifiedField
    position: VerifiedField | None = None
    phoneNumber: VerifiedField | None = None
    idType: VerifiedField | None = None
    idNumber: VerifiedField | None = None
    idIssueDate: VerifiedField | None = None


@dataclass(slots=True)
class MedicalCredentialResponseDto(DtoModel):
    title: str | None = None
    license: str | None = None


@dataclass(slots=True)
class ParticipantInfoDto(DtoModel):
    id: str
    name: str
    role: str
    avatar: str | None = None


@dataclass(slots=True)
class PartnerPayoutRecordDto(DtoModel):
    id: str
    periodLabel: str
    includedVolume: float
    feesAdjustments: float
    netPayout: float
    scheduledDate: str
    method: str
    status: PartnerPayoutStatus
    currency: str
    includedTransactionIds: list[str]


@dataclass(slots=True)
class PartnerRefundCaseRecordDto(DtoModel):
    id: str
    transactionId: str
    caseType: PartnerRefundCaseType
    requestedAt: str
    amount: float
    currency: str
    reason: str
    owner: str
    status: PartnerRefundCaseStatus
    slaHours: float


@dataclass(slots=True)
class TherapistProfileResponseDto(DtoModel):
    employeeId: str | None = None
    level: str | None = None
    type: str | None = None
    strengthLevel: str | None = None
    commissionRate: float | None = None
    healthCheckDate: datetime | None = None
    skills: list[str] | None = None
    deviceProficiency: list[str] | None = None


@dataclass(slots=True)
class VerificationDocumentEntryDto(DtoModel):
    fieldKey: str
    documents: list[DocumentEntryDto] | None = None


@dataclass(slots=True)
class VerifiedField(DtoModel):
    fieldKey: str
    value: dict[str, Any]
    isVerified: bool
    feedback: str | None = None


@dataclass(slots=True)
class WorkHistoryEntryDto(DtoModel):
    facility: str
    position: str
    period: str
    isCurrent: bool


@dataclass(slots=True)
class WorkScheduleEntryDto(DtoModel):
    day: str
    isWorking: bool
    start: str | None = None
    end: str | None = None


__all__ = [
    "BusinessType",
    "ConversationStatus",
    "HealthServiceStatus",
    "HealthServiceType",
    "PartnerPayoutStatus",
    "PartnerRefundCaseStatus",
    "PartnerRefundCaseType",
    "PartnerVerificationStatus",
    "AddressInfoDto",
    "BookingServiceResponseDto",
    "BusinessInfoDto",
    "CategorySummaryDto",
    "ConversationResponseDto",
    "CreateConversationDto",
    "DoctorProfileResponseDto",
    "DocumentEntryDto",
    "EmployeeResponseDto",
    "LastMessageDto",
    "LegalRepresentativeDto",
    "MedicalCredentialResponseDto",
    "ParticipantInfoDto",
    "PartnerPayoutRecordDto",
    "PartnerRefundCaseRecordDto",
    "TherapistProfileResponseDto",
    "VerificationDocumentEntryDto",
    "VerifiedField",
    "WorkHistoryEntryDto",
    "WorkScheduleEntryDto",
]
