"""Generated models for categories_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import CategorySummaryDto


@dataclass(slots=True)
class CategoryResponseDto(DtoModel):
    id: str
    name: str
    slug: str
    isActive: bool
    createdAt: datetime
    updatedAt: datetime
    description: str | None = None
    imageUrl: str | None = None
    categoryType: str | None = None
    parent: CategorySummaryDto | None = None
    children: list[CategorySummaryDto] | None = None


CategoriesControllerFindAllResponseDto: TypeAlias = list[CategoryResponseDto]  # GET /categories [200]


__all__ = [
    "CategoryResponseDto",
    "CategoriesControllerFindAllResponseDto",
]
