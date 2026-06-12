"""Generated models for partner_bookings_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


class PartnerBookingStatus(str, Enum):
    WAITING = 'Waiting'
    ONPROCESS = 'OnProcess'
    CANCELED = 'Canceled'
    FINISHED = 'Finished'


@dataclass(slots=True)
class PartnerBookingCustomerDto(DtoModel):
    id: str
    fullName: str
    age: float
    avatarUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class PartnerBookingResponseDto(DtoModel):
    id: str
    customer: PartnerBookingCustomerDto
    specialist: PartnerBookingSpecialistDto
    service: PartnerBookingServiceDto
    slot: PartnerBookingSlotDto
    status: PartnerBookingStatus


@dataclass(slots=True)
class PartnerBookingServiceDto(DtoModel):
    id: str
    name: str
    categoryName: str
    price: float
    currencyCode: str


@dataclass(slots=True)
class PartnerBookingSlotDto(DtoModel):
    start: datetime
    end: datetime


@dataclass(slots=True)
class PartnerBookingSpecialistDto(DtoModel):
    id: str
    fullName: str
    roleLabel: str
    avatarUrl: dict[str, Any] | None = None


PartnerBookingsControllerListBookingsResponseDto: TypeAlias = list[PartnerBookingResponseDto]  # GET /partner/bookings [200]


__all__ = [
    "PartnerBookingStatus",
    "PartnerBookingCustomerDto",
    "PartnerBookingResponseDto",
    "PartnerBookingServiceDto",
    "PartnerBookingSlotDto",
    "PartnerBookingSpecialistDto",
    "PartnerBookingsControllerListBookingsResponseDto",
]
