"""Generated models for admin_categories_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import CategorySummaryDto


@dataclass(slots=True)
class AdminCategoryResponseDto(DtoModel):
    id: str
    name: str
    slug: str
    isActive: bool
    sortOrder: float
    serviceCount: float
    createdAt: datetime
    updatedAt: datetime
    description: str | None = None
    imageUrl: str | None = None
    iconName: str | None = None
    colorValue: str | None = None
    parent: CategorySummaryDto | None = None
    children: list[CategorySummaryDto] | None = None


@dataclass(slots=True)
class CreateCategoryDto(DtoModel):
    name: str
    slug: str
    parentId: str | None = None
    description: str | None = None
    imageUrl: str | None = None
    isActive: bool | None = None
    iconName: str | None = None
    colorValue: str | None = None
    sortOrder: float | None = None


@dataclass(slots=True)
class UpdateCategoryDto(DtoModel):
    parentId: str | None = None
    name: str | None = None
    slug: str | None = None
    description: str | None = None
    imageUrl: str | None = None
    isActive: bool | None = None
    iconName: str | None = None
    colorValue: str | None = None
    sortOrder: float | None = None


AdminCategoriesControllerFindAllResponseDto: TypeAlias = list[AdminCategoryResponseDto]  # GET /admin/categories [200]


__all__ = [
    "AdminCategoryResponseDto",
    "CreateCategoryDto",
    "UpdateCategoryDto",
    "AdminCategoriesControllerFindAllResponseDto",
]
