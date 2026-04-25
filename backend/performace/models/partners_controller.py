"""Generated models for partners_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class BusinessServiceDto(DtoModel):
    value: str
    label: str
    description: str | None = None


@dataclass(slots=True)
class BusinessServicesResponseDto(DtoModel):
    data: list[BusinessServiceDto]


__all__ = [
    "BusinessServiceDto",
    "BusinessServicesResponseDto",
]
