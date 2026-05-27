"""Generated models for account_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class AccountAddressDto(DtoModel):
    street: str
    ward: str
    district: str
    cityOrProvince: str
    provinceId: dict[str, Any] | None = None
    districtId: dict[str, Any] | None = None
    wardId: dict[str, Any] | None = None
    latitude: dict[str, Any] | None = None
    longitude: dict[str, Any] | None = None


@dataclass(slots=True)
class AccountMeResponseDto(DtoModel):
    id: str
    email: str
    role: str
    isActive: bool
    createdAt: datetime
    updatedAt: datetime
    userProfile: UserProfileDto | None = None


@dataclass(slots=True)
class SurveyDto(DtoModel):
    survey: dict[str, Any]


@dataclass(slots=True)
class SurveyResponseDto(DtoModel):
    survey: dict[str, Any] | None = None


@dataclass(slots=True)
class UpdateAccountAddressDto(DtoModel):
    streetAddress: str
    provinceId: str
    districtId: str
    wardId: str


@dataclass(slots=True)
class UpdateAccountProfileDto(DtoModel):
    firstName: dict[str, Any] | None = None
    lastName: dict[str, Any] | None = None
    phone: dict[str, Any] | None = None


@dataclass(slots=True)
class UpdateAvatarDto(DtoModel):
    avatarUrl: str


@dataclass(slots=True)
class UserProfileDto(DtoModel):
    id: str
    profileCompleted: bool
    firstName: dict[str, Any] | None = None
    lastName: dict[str, Any] | None = None
    phone: dict[str, Any] | None = None
    bio: dict[str, Any] | None = None
    dateOfBirth: str | None = None
    avatarUrl: dict[str, Any] | None = None
    address: AccountAddressDto | None = None


__all__ = [
    "AccountAddressDto",
    "AccountMeResponseDto",
    "SurveyDto",
    "SurveyResponseDto",
    "UpdateAccountAddressDto",
    "UpdateAccountProfileDto",
    "UpdateAvatarDto",
    "UserProfileDto",
]
