"""Generated models for shared. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


class BookingStatus(str, Enum):
    PENDING_PAYMENT = 'PENDING_PAYMENT'
    CONFIRMED = 'CONFIRMED'
    IN_PROGRESS = 'IN_PROGRESS'
    CANCELLED = 'CANCELLED'
    COMPLETED = 'COMPLETED'
    NO_SHOW = 'NO_SHOW'


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


class EmployeeRole(str, Enum):
    DOCTOR = 'DOCTOR'
    THERAPIST = 'THERAPIST'
    RECEPTIONIST = 'RECEPTIONIST'
    MANAGER = 'MANAGER'


class EmployeeStatus(str, Enum):
    ACTIVE = 'ACTIVE'
    INACTIVE = 'INACTIVE'
    ON_LEAVE = 'ON_LEAVE'


class Gender(str, Enum):
    MALE = 'MALE'
    FEMALE = 'FEMALE'
    OTHER = 'OTHER'


class HealthServiceStatus(str, Enum):
    DRAFT = 'draft'
    ACTIVE = 'active'
    ARCHIVED = 'archived'


class HealthServiceType(str, Enum):
    SERVICE = 'service'


class PartnerCommerceSourceType(str, Enum):
    SERVICEBOOKING = 'serviceBooking'
    PRODUCTORDER = 'productOrder'


class PartnerPayoutStatus(str, Enum):
    NOTASSIGNED = 'notAssigned'
    INPAYOUT = 'inPayout'
    PAIDOUT = 'paidOut'
    FAILED = 'failed'
    HELD = 'held'


class PartnerRefundCaseStatus(str, Enum):
    PENDING = 'pending'
    UNDERREVIEW = 'underReview'
    APPROVED = 'approved'
    REJECTED = 'rejected'


class PartnerRefundCaseType(str, Enum):
    REFUND = 'refund'
    DISPUTE = 'dispute'


class PartnerSettlementStatus(str, Enum):
    UNSETTLED = 'unsettled'
    SCHEDULED = 'scheduled'
    SETTLED = 'settled'
    HELD = 'held'


class PartnerTransactionStatus(str, Enum):
    PENDING = 'pending'
    PAID = 'paid'
    REFUNDED = 'refunded'
    FAILED = 'failed'
    CANCELED = 'canceled'


class PartnerTransactionType(str, Enum):
    CHARGE = 'charge'
    REFUND = 'refund'
    ADJUSTMENT = 'adjustment'
    PAYOUT = 'payout'
    FEE = 'fee'


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
class BookingSpecialistResponseDto(DtoModel):
    id: str
    eligibilityId: str
    name: str
    specialty: str
    avatarUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class BusinessInfoDto(DtoModel):
    brandName: VerifiedField
    businessType: VerifiedField
    legalName: VerifiedField | None = None
    taxRegistrationCode: VerifiedField | None = None
    address: AddressInfoDto | None = None
    email: VerifiedField | None = None
    phoneNumber: VerifiedField | None = None


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
    certifications: list[str] | None = None


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
    role: EmployeeRole
    status: EmployeeStatus
    rating: float
    reviewCount: float
    createdAt: datetime
    updatedAt: datetime
    firstName: str | None = None
    lastName: str | None = None
    phone: str | None = None
    avatarUrl: str | None = None
    jobTitle: str | None = None
    startDate: datetime | None = None
    employmentType: str | None = None
    description: str | None = None
    emergencyContactName: str | None = None
    emergencyContactPhone: str | None = None
    verificationDocuments: list[VerificationDocumentEntryDto] | None = None
    schedule: list[WorkScheduleEntryDto] | None = None
    workHistory: list[WorkHistoryEntryDto] | None = None
    dob: datetime | None = None
    gender: Gender | None = None
    partnerId: str | None = None
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


MoMoIPNDto: TypeAlias = dict[str, Any]


__all__ = [
    "BookingStatus",
    "BusinessType",
    "ConversationStatus",
    "EmployeeRole",
    "EmployeeStatus",
    "Gender",
    "HealthServiceStatus",
    "HealthServiceType",
    "PartnerCommerceSourceType",
    "PartnerPayoutStatus",
    "PartnerRefundCaseStatus",
    "PartnerRefundCaseType",
    "PartnerSettlementStatus",
    "PartnerTransactionStatus",
    "PartnerTransactionType",
    "PartnerVerificationStatus",
    "AddressInfoDto",
    "BookingServiceResponseDto",
    "BookingSpecialistResponseDto",
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
    "MoMoIPNDto",
]
