"""Generated models for cart_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class AddToCartDto(DtoModel):
    serviceId: str
    employeeId: str
    timeSlot: str


@dataclass(slots=True)
class CartItemResponseDto(DtoModel):
    id: str
    serviceId: str
    serviceName: str
    serviceImageUrl: str
    price: str
    priceAmount: float
    clinicId: str
    clinicName: str
    clinicAddress: str
    employeeId: str
    employeeName: str
    employeeRole: str
    timeSlot: datetime
    isTimeSlotAvailable: bool
    status: str
    createdAt: datetime
    clinicImageUrl: dict[str, Any] | None = None
    employeeAvatarUrl: dict[str, Any] | None = None


CartControllerGetItemsResponseDto: TypeAlias = list[CartItemResponseDto]  # GET /cart [200]


__all__ = [
    "AddToCartDto",
    "CartItemResponseDto",
    "CartControllerGetItemsResponseDto",
]
