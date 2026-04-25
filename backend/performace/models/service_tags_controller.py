"""Generated models for service_tags_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class AttachTagResponseDto(DtoModel):
    tagId: str
    productId: str
    createdAt: datetime


@dataclass(slots=True)
class CreateServiceTagDto(DtoModel):
    name: str
    description: str | None = None
    colorValue: str | None = None
    isActive: bool | None = None
    sortOrder: float | None = None


@dataclass(slots=True)
class ServiceTagResponseDto(DtoModel):
    id: str
    userId: str
    name: str
    colorValue: str
    usage: float
    isActive: bool
    sortOrder: float
    createdAt: datetime
    updatedAt: datetime
    description: dict[str, Any] | None = None


@dataclass(slots=True)
class UpdateServiceTagDto(DtoModel):
    name: str | None = None
    description: str | None = None
    colorValue: str | None = None
    isActive: bool | None = None
    sortOrder: float | None = None


ServiceTagsControllerFindAllResponseDto: TypeAlias = list[ServiceTagResponseDto]  # GET /partner/service-tags [200]


ServiceTagsControllerFindActiveResponseDto: TypeAlias = list[ServiceTagResponseDto]  # GET /partner/service-tags/active [200]


ServiceTagsControllerGetTagsForProductResponseDto: TypeAlias = list[ServiceTagResponseDto]  # GET /partner/service-tags/products/{productId} [200]


__all__ = [
    "AttachTagResponseDto",
    "CreateServiceTagDto",
    "ServiceTagResponseDto",
    "UpdateServiceTagDto",
    "ServiceTagsControllerFindAllResponseDto",
    "ServiceTagsControllerFindActiveResponseDto",
    "ServiceTagsControllerGetTagsForProductResponseDto",
]
