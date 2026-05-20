"""Generated models for account_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field


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
class UserProfileDto(DtoModel):
    id: str
    profileCompleted: bool
    firstName: str | None = None
    lastName: str | None = None
    phone: str | None = None
    bio: dict[str, Any] | None = None
    dateOfBirth: str | None = None


__all__ = [
    "AccountMeResponseDto",
    "SurveyDto",
    "SurveyResponseDto",
    "UserProfileDto",
]
