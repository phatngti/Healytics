"""Generated models for user_review_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class CreateSpecialistReviewDto(DtoModel):
    appointmentId: str
    specialistId: str
    rating: float
    wouldRecommend: bool
    comment: str | None = None
    tags: list[str] | None = None


@dataclass(slots=True)
class CreateTreatmentReviewDto(DtoModel):
    appointmentId: str
    rating: float
    comment: str | None = None
    tags: list[str] | None = None
    photoKeys: list[str] | None = None


@dataclass(slots=True)
class SpecialistReviewResponseDto(DtoModel):
    id: str
    appointmentId: str
    specialistId: str
    rating: float
    tags: list[str]
    wouldRecommend: bool
    createdAt: datetime
    comment: dict[str, Any] | None = None


@dataclass(slots=True)
class TreatmentReviewResponseDto(DtoModel):
    id: str
    appointmentId: str
    rating: float
    tags: list[str]
    photoUrls: list[str]
    createdAt: datetime
    comment: dict[str, Any] | None = None


__all__ = [
    "CreateSpecialistReviewDto",
    "CreateTreatmentReviewDto",
    "SpecialistReviewResponseDto",
    "TreatmentReviewResponseDto",
]
