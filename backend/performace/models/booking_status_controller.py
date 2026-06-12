"""Generated models for booking_status_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import BookingStatus


class BookingStatusUpdate(str, Enum):
    PROCESSING = 'PROCESSING'
    COMPLETED = 'COMPLETED'


class PublicBookingStatus(str, Enum):
    PROCESSING = 'PROCESSING'
    COMPLETED = 'COMPLETED'


@dataclass(slots=True)
class BookingStatusChangeEventDto(DtoModel):
    eventId: str
    bookingId: str
    status: PublicBookingStatus
    persistedStatus: BookingStatus
    previousStatus: BookingStatus
    userId: str
    specialistId: str
    changedBy: BookingStatusChangedByDto
    occurredAt: datetime
    partnerId: str | None = None


@dataclass(slots=True)
class BookingStatusChangedByDto(DtoModel):
    accountId: str
    role: str


@dataclass(slots=True)
class UpdateBookingStatusDto(DtoModel):
    status: BookingStatusUpdate


__all__ = [
    "BookingStatusUpdate",
    "PublicBookingStatus",
    "BookingStatusChangeEventDto",
    "BookingStatusChangedByDto",
    "UpdateBookingStatusDto",
]
