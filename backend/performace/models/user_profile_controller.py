"""Generated models for user_profile_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class UserProfileSummaryResponseDto(DtoModel):
    ordersCount: float
    wishlistCount: float
    points: float
    pointsLabel: str


__all__ = [
    "UserProfileSummaryResponseDto",
]
