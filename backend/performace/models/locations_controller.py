"""Generated models for locations_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class LocationListResponseDto(DtoModel):
    data: list[LocationResponseDto]
    total: float


@dataclass(slots=True)
class LocationResponseDto(DtoModel):
    id: str
    code: str
    name: str
    fullName: str
    level: str
    nameEn: str | None = None
    fullNameEn: str | None = None


__all__ = [
    "LocationListResponseDto",
    "LocationResponseDto",
]
