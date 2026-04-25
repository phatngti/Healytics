"""Generated models for slots_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class CheckDuplicateSlotDto(DtoModel):
    startTime: str


@dataclass(slots=True)
class CheckDuplicateSlotResponseDto(DtoModel):
    isDuplicate: bool
    conflictingServiceName: str | None = None
    conflictingBookingId: str | None = None


@dataclass(slots=True)
class MicroLockDto(DtoModel):
    staffId: str
    startTime: str
    productId: str | None = None


@dataclass(slots=True)
class MicroLockResponseDto(DtoModel):
    locked: bool
    expiresIn: float


__all__ = [
    "CheckDuplicateSlotDto",
    "CheckDuplicateSlotResponseDto",
    "MicroLockDto",
    "MicroLockResponseDto",
]
