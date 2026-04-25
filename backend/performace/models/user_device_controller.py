"""Generated models for user_device_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class RegisterDeviceDto(DtoModel):
    token: str
    platform: str


__all__ = [
    "RegisterDeviceDto",
]
