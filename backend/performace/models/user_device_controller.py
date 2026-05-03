"""Generated models for user_device_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from dataclasses import dataclass
from .base import DtoModel, dto_field


class DevicePlatform(str, Enum):
    IOS = 'ios'
    ANDROID = 'android'


@dataclass(slots=True)
class RegisterDeviceDto(DtoModel):
    token: str
    platform: DevicePlatform


__all__ = [
    "DevicePlatform",
    "RegisterDeviceDto",
]
