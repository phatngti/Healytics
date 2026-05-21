"""Generated models for partner_employees_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import EmployeeResponseDto, EmployeeRole, EmployeeStatus, HealthServiceStatus, MedicalCredentialResponseDto, VerificationDocumentEntryDto, WorkHistoryEntryDto, WorkScheduleEntryDto


@dataclass(slots=True)
class CreateDoctorDto(DtoModel):
    firstName: str
    lastName: str
    email: str
    emergencyContactName: str
    emergencyContactPhone: str
    employeeId: str
    startDate: str
    schedule: list[WorkScheduleEntryDto]
    description: str
    phone: str | None = None
    dateOfBirth: str | None = None
    gender: str | None = None
    employmentType: str | None = None
    workHistory: list[WorkHistoryEntryDto] | None = None
    avatar: str | None = None
    verificationDocuments: list[VerificationDocumentEntryDto] | None = None
    status: str | None = None
    jobTitle: str | None = None
    medicalCredentials: list[MedicalCredentialResponseDto] | None = None
    experienceYears: float | None = None
    consultationFee: float | None = None
    specializations: list[str] | None = None
    education: list[str] | None = None
    certifications: list[str] | None = None
    partnerId: str | None = None


@dataclass(slots=True)
class CreateDoctorProfileDto(DtoModel):
    title: str | None = None
    medicalCredentials: list[MedicalCredentialResponseDto] | None = None
    experienceYears: float | None = None
    consultationFee: float | None = None
    specializations: list[str] | None = None
    education: list[str] | None = None
    certifications: list[str] | None = None


@dataclass(slots=True)
class CreateMassageTherapistDto(DtoModel):
    firstName: str
    lastName: str
    email: str
    emergencyContactName: str
    emergencyContactPhone: str
    employeeId: str
    startDate: str
    schedule: list[WorkScheduleEntryDto]
    description: str
    phone: str | None = None
    dateOfBirth: str | None = None
    gender: str | None = None
    employmentType: str | None = None
    workHistory: list[WorkHistoryEntryDto] | None = None
    avatar: str | None = None
    verificationDocuments: list[VerificationDocumentEntryDto] | None = None
    status: str | None = None
    jobTitle: str | None = None
    therapistLevel: str | None = None
    strengthLevel: str | None = None
    commissionRate: float | None = None
    healthCheckDate: str | None = None
    skills: list[str] | None = None
    partnerId: str | None = None


@dataclass(slots=True)
class CreateSkillDto(DtoModel):
    name: str


@dataclass(slots=True)
class CreateSpaTherapistDto(DtoModel):
    firstName: str
    lastName: str
    email: str
    emergencyContactName: str
    emergencyContactPhone: str
    employeeId: str
    startDate: str
    schedule: list[WorkScheduleEntryDto]
    description: str
    phone: str | None = None
    dateOfBirth: str | None = None
    gender: str | None = None
    employmentType: str | None = None
    workHistory: list[WorkHistoryEntryDto] | None = None
    avatar: str | None = None
    verificationDocuments: list[VerificationDocumentEntryDto] | None = None
    status: str | None = None
    jobTitle: str | None = None
    therapistLevel: str | None = None
    commissionRate: float | None = None
    healthCheckDate: str | None = None
    skills: list[str] | None = None
    deviceProficiency: list[str] | None = None
    partnerId: str | None = None


@dataclass(slots=True)
class CreateTherapistProfileDto(DtoModel):
    level: str | None = None
    type: str | None = None
    strengthLevel: str | None = None
    commissionRate: float | None = None
    healthCheckDate: str | None = None
    skills: list[str] | None = None
    deviceProficiency: list[str] | None = None


@dataclass(slots=True)
class EmployeeAssignedServiceDto(DtoModel):
    id: str
    name: str
    status: HealthServiceStatus
    basePrice: float
    currency: str
    isPrimary: bool
    salePrice: float | None = None
    durationMinutes: float | None = None
    categoryName: str | None = None
    imageUrl: str | None = None


@dataclass(slots=True)
class EmployeeComplianceItemDto(DtoModel):
    title: str
    detail: str
    tone: str


@dataclass(slots=True)
class EmployeeDetailAnalyticsResponseDto(DtoModel):
    employeeId: str
    completedSessions: float
    sessionsDelta: float
    contributionValue: float
    contributionDelta: float
    utilizationRate: float
    utilizationDelta: float
    averageRating: float
    reviewCount: float
    trendPoints: list[EmployeeTrendPointDto]
    mixMetrics: list[EmployeeMixMetricDto]
    scheduleLoad: list[EmployeeScheduleLoadDto]
    qualityMetrics: list[EmployeeQualityMetricDto]
    complianceItems: list[EmployeeComplianceItemDto]


@dataclass(slots=True)
class EmployeeMixMetricDto(DtoModel):
    label: str
    value: float
    share: float


@dataclass(slots=True)
class EmployeeOverviewAnalyticsResponseDto(DtoModel):
    totalEmployees: float
    activeEmployees: float
    onLeaveEmployees: float
    inactiveEmployees: float
    utilizationRate: float
    utilizationDelta: float
    averageRating: float
    ratingDelta: float
    reviewCount: float
    trendPoints: list[EmployeeTrendPointDto]
    roleDistribution: list[EmployeeRoleDistributionDto]
    topPerformers: list[EmployeePerformanceSummaryDto]
    complianceItems: list[EmployeeComplianceItemDto]


@dataclass(slots=True)
class EmployeePerformanceSummaryDto(DtoModel):
    employeeName: str
    roleLabel: str
    rating: float
    utilizationRate: float
    contributionValue: float


@dataclass(slots=True)
class EmployeeQualityMetricDto(DtoModel):
    label: str
    value: str
    detail: str
    tone: str


@dataclass(slots=True)
class EmployeeRoleDistributionDto(DtoModel):
    role: str
    count: float


@dataclass(slots=True)
class EmployeeScheduleLoadDto(DtoModel):
    label: str
    availableHours: float
    bookedHours: float


@dataclass(slots=True)
class EmployeeTrendPointDto(DtoModel):
    label: str
    sessions: float
    contributionValue: float


@dataclass(slots=True)
class SkillCatalogResponseDto(DtoModel):
    key: str
    label: str


@dataclass(slots=True)
class UpdateEmployeeDto(DtoModel):
    employeeCode: str | None = None
    fullName: str | None = None
    email: str | None = None
    role: EmployeeRole | None = None
    status: EmployeeStatus | None = None
    firstName: str | None = None
    lastName: str | None = None
    phone: str | None = None
    avatarUrl: str | None = None
    dob: str | None = None
    gender: str | None = None
    partnerId: str | None = None
    jobTitle: str | None = None
    startDate: str | None = None
    employmentType: str | None = None
    emergencyContactName: str | None = None
    emergencyContactPhone: str | None = None
    description: str | None = None
    verificationDocuments: list[VerificationDocumentEntryDto] | None = None
    schedule: list[WorkScheduleEntryDto] | None = None
    workHistory: list[WorkHistoryEntryDto] | None = None
    doctorProfile: CreateDoctorProfileDto | None = None
    therapistProfile: CreateTherapistProfileDto | None = None


PartnerEmployeesControllerFindAllResponseDto: TypeAlias = list[EmployeeResponseDto]  # GET /partner/employees [200]


PartnerEmployeesControllerGetMassageSkillsResponseDto: TypeAlias = list[SkillCatalogResponseDto]  # GET /partner/employees/massage-skills [200]


PartnerEmployeesControllerGetSpaSkillsResponseDto: TypeAlias = list[SkillCatalogResponseDto]  # GET /partner/employees/spa-skills [200]


PartnerEmployeesControllerFindAssignedServicesResponseDto: TypeAlias = list[EmployeeAssignedServiceDto]  # GET /partner/employees/{id}/services [200]


__all__ = [
    "CreateDoctorDto",
    "CreateDoctorProfileDto",
    "CreateMassageTherapistDto",
    "CreateSkillDto",
    "CreateSpaTherapistDto",
    "CreateTherapistProfileDto",
    "EmployeeAssignedServiceDto",
    "EmployeeComplianceItemDto",
    "EmployeeDetailAnalyticsResponseDto",
    "EmployeeMixMetricDto",
    "EmployeeOverviewAnalyticsResponseDto",
    "EmployeePerformanceSummaryDto",
    "EmployeeQualityMetricDto",
    "EmployeeRoleDistributionDto",
    "EmployeeScheduleLoadDto",
    "EmployeeTrendPointDto",
    "SkillCatalogResponseDto",
    "UpdateEmployeeDto",
    "PartnerEmployeesControllerFindAllResponseDto",
    "PartnerEmployeesControllerGetMassageSkillsResponseDto",
    "PartnerEmployeesControllerGetSpaSkillsResponseDto",
    "PartnerEmployeesControllerFindAssignedServicesResponseDto",
]
