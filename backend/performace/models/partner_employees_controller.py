"""Generated models for partner_employees_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import EmployeeResponseDto, MedicalCredentialResponseDto, VerificationDocumentEntryDto, WorkHistoryEntryDto, WorkScheduleEntryDto


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
    medicalCredentials: list[str] | None = None
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
class UpdateEmployeeDto(DtoModel):
    employeeCode: str | None = None
    firstName: str | None = None
    lastName: str | None = None
    fullName: str | None = None
    email: str | None = None
    phone: str | None = None
    avatarUrl: str | None = None
    dob: str | None = None
    gender: str | None = None
    role: str | None = None
    status: str | None = None
    partnerId: str | None = None
    jobTitle: str | None = None
    startDate: str | None = None
    employmentType: str | None = None
    emergencyContactName: str | None = None
    emergencyContactPhone: str | None = None
    verificationDocuments: list[VerificationDocumentEntryDto] | None = None
    description: str | None = None
    schedule: list[WorkScheduleEntryDto] | None = None
    workHistory: list[WorkHistoryEntryDto] | None = None
    doctorProfile: CreateDoctorProfileDto | None = None
    therapistProfile: CreateTherapistProfileDto | None = None


PartnerEmployeesControllerFindAllResponseDto: TypeAlias = list[EmployeeResponseDto]  # GET /partner/employees [200]


__all__ = [
    "CreateDoctorDto",
    "CreateDoctorProfileDto",
    "CreateMassageTherapistDto",
    "CreateSpaTherapistDto",
    "CreateTherapistProfileDto",
    "UpdateEmployeeDto",
    "PartnerEmployeesControllerFindAllResponseDto",
]
