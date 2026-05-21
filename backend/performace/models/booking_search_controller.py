"""Generated models for booking_search_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import BookingServiceResponseDto, BookingSpecialistResponseDto


@dataclass(slots=True)
class BookingSearchResponseDto(DtoModel):
    services: list[BookingServiceResponseDto]
    specialists: list[BookingSpecialistResponseDto]


__all__ = [
    "BookingSearchResponseDto",
]
