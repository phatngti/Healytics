"""Generated models for user_categories_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from .shared import BookingServiceResponseDto, BookingSpecialistResponseDto


UserCategoriesControllerFindServicesByCategoryResponseDto: TypeAlias = list[BookingServiceResponseDto]  # GET /user/categories/{categoryId}/services [200]


UserCategoriesControllerFindSpecialistsByCategoryResponseDto: TypeAlias = list[BookingSpecialistResponseDto]  # GET /user/categories/{categoryId}/specialists [200]


__all__ = [
    "UserCategoriesControllerFindServicesByCategoryResponseDto",
    "UserCategoriesControllerFindSpecialistsByCategoryResponseDto",
]
