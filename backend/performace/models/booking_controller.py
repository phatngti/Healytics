"""Generated models for booking_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


class BookingStatus(str, Enum):
    PENDING_PAYMENT = 'PENDING_PAYMENT'
    CONFIRMED = 'CONFIRMED'
    CANCELLED = 'CANCELLED'
    COMPLETED = 'COMPLETED'
    NO_SHOW = 'NO_SHOW'


@dataclass(slots=True)
class AsyncCheckoutDto(DtoModel):
    userId: str
    staffId: str
    startTime: str
    productId: str
    idempotencyKey: str
    webhookUrl: str | None = None


@dataclass(slots=True)
class AsyncCheckoutResponseDto(DtoModel):
    ticketId: str
    status: str
    message: str


@dataclass(slots=True)
class BookingResponseDto(DtoModel):
    id: str
    userId: str
    staffId: str
    startTime: datetime
    status: BookingStatus
    createdAt: datetime
    updatedAt: datetime
    productId: str | None = None
    endTime: datetime | None = None
    paymentUrl: str | None = None
    paymentExpiresAt: datetime | None = None
    notes: str | None = None


@dataclass(slots=True)
class CheckoutTicketResponseDto(DtoModel):
    id: str
    userId: str
    staffId: str
    startTime: datetime
    status: str
    idempotencyKey: str
    createdAt: datetime
    updatedAt: datetime
    bookingId: str | None = None
    errorMessage: str | None = None


BookingControllerListMyBookingsResponseDto: TypeAlias = list[BookingResponseDto]  # GET /user/bookings [200]


__all__ = [
    "BookingStatus",
    "AsyncCheckoutDto",
    "AsyncCheckoutResponseDto",
    "BookingResponseDto",
    "CheckoutTicketResponseDto",
    "BookingControllerListMyBookingsResponseDto",
]
