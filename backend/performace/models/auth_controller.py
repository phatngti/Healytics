"""Generated models for auth_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import BusinessType


@dataclass(slots=True)
class AccountRequestDto(DtoModel):
    username: str
    password: str
    email: str


@dataclass(slots=True)
class AdminLoginDto(DtoModel):
    email: str
    password: str


@dataclass(slots=True)
class AuthTokensDto(DtoModel):
    access_token: str
    refresh_token: str
    access_expires_in: str
    refresh_expires_in: str


@dataclass(slots=True)
class LegalRepresentativeRequestDto(DtoModel):
    fullName: str
    idType: str
    idNumber: str
    idIssueDate: str
    documents: list[PartnerDocumentVerificationDto]
    position: str | None = None
    phoneNumber: str | None = None


@dataclass(slots=True)
class LoginDto(DtoModel):
    email: str
    password: str


@dataclass(slots=True)
class LogoutResponseDto(DtoModel):
    message: str


@dataclass(slots=True)
class PartnerDocumentVerificationDto(DtoModel):
    fileType: str
    type: str
    documentKey: str
    urls: list[str]


@dataclass(slots=True)
class PartnerLoginDto(DtoModel):
    email: str
    password: str


@dataclass(slots=True)
class PartnerRequestDto(DtoModel):
    taxCode: str
    legalName: str
    brandName: str
    businessType: list[BusinessType]
    provinceId: str
    districtId: str
    wardId: str
    streetAddress: str
    phoneNumber: str | None = None


@dataclass(slots=True)
class RefreshTokenRequestDto(DtoModel):
    refresh_token: str


@dataclass(slots=True)
class RegisterDto(DtoModel):
    email: str
    password: str
    profile: RegisterProfileDto | None = None


@dataclass(slots=True)
class RegisterPartnerDto(DtoModel):
    account: AccountRequestDto
    partner: PartnerRequestDto
    legalRepresentative: LegalRepresentativeRequestDto


@dataclass(slots=True)
class RegisterPartnerResponseDto(DtoModel):
    accountId: str
    businessEntityId: str
    status: str
    message: str
    access_token: str
    access_expires_in: str
    refresh_token: str
    refresh_expires_in: str


@dataclass(slots=True)
class RegisterProfileDto(DtoModel):
    firstName: str | None = None
    lastName: str | None = None
    phone: str | None = None
    bio: str | None = None
    dateOfBirth: str | None = None


__all__ = [
    "AccountRequestDto",
    "AdminLoginDto",
    "AuthTokensDto",
    "LegalRepresentativeRequestDto",
    "LoginDto",
    "LogoutResponseDto",
    "PartnerDocumentVerificationDto",
    "PartnerLoginDto",
    "PartnerRequestDto",
    "RefreshTokenRequestDto",
    "RegisterDto",
    "RegisterPartnerDto",
    "RegisterPartnerResponseDto",
    "RegisterProfileDto",
]
