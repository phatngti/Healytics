"""Generated models for user_categories_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import BookingServiceResponseDto


@dataclass(slots=True)
class BookingSpecialistResponseDto(DtoModel):
    id: str
    eligibilityId: str
    name: str
    specialty: str
    avatarUrl: dict[str, Any] | None = None


UserCategoriesControllerFindServicesByCategoryResponseDto: TypeAlias = list[BookingServiceResponseDto]  # GET /user/categories/{categoryId}/services [200]


UserCategoriesControllerFindSpecialistsByCategoryResponseDto: TypeAlias = list[BookingSpecialistResponseDto]  # GET /user/categories/{categoryId}/specialists [200]


__all__ = [
    "BookingSpecialistResponseDto",
    "UserCategoriesControllerFindServicesByCategoryResponseDto",
    "UserCategoriesControllerFindSpecialistsByCategoryResponseDto",
]
