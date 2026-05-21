"""Generated models for user_employees_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import BookingServiceResponseDto, EmployeeResponseDto


@dataclass(slots=True)
class DayScheduleDto(DtoModel):
    date: str
    dayOfWeek: str
    isWorkingDay: bool
    slots: list[TimeSlotDto]


@dataclass(slots=True)
class EmployeeTimeSlotsResponseDto(DtoModel):
    employeeId: str
    employeeName: str
    slotDurationMinutes: float
    schedule: list[DayScheduleDto]
    rangeStart: str
    rangeEnd: str


@dataclass(slots=True)
class FeaturedSpecialistResponseDto(DtoModel):
    id: str
    name: str
    specialty: str
    rating: float
    soldCount: float
    clinicName: str
    avatarUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class PublicEmployeeReviewResponseDto(DtoModel):
    id: str
    reviewerName: str
    rating: float
    tags: list[str]
    wouldRecommend: bool
    createdAt: str
    avatarUrl: str | None = None
    comment: str | None = None


@dataclass(slots=True)
class TimeSlotDto(DtoModel):
    label: str
    time: str
    isBusy: str


UserEmployeesControllerFindAllResponseDto: TypeAlias = list[EmployeeResponseDto]  # GET /user/employees [200]


UserEmployeesControllerGetFeaturedSpecialistsResponseDto: TypeAlias = list[FeaturedSpecialistResponseDto]  # GET /user/employees/featured-specialists [200]


UserEmployeesControllerFindReviewsResponseDto: TypeAlias = list[PublicEmployeeReviewResponseDto]  # GET /user/employees/{id}/reviews [200]


UserEmployeesControllerFindServicesResponseDto: TypeAlias = list[BookingServiceResponseDto]  # GET /user/employees/{id}/services [200]


__all__ = [
    "DayScheduleDto",
    "EmployeeTimeSlotsResponseDto",
    "FeaturedSpecialistResponseDto",
    "PublicEmployeeReviewResponseDto",
    "TimeSlotDto",
    "UserEmployeesControllerFindAllResponseDto",
    "UserEmployeesControllerGetFeaturedSpecialistsResponseDto",
    "UserEmployeesControllerFindReviewsResponseDto",
    "UserEmployeesControllerFindServicesResponseDto",
]
