"""Generated models for employee_appointments_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from dataclasses import dataclass
from .base import DtoModel, dto_field


class EmployeeBookingStatusFilter(str, Enum):
    UPCOMING = 'upcoming'
    INPROGRESS = 'inProgress'
    COMPLETED = 'completed'
    CANCELED = 'canceled'


@dataclass(slots=True)
class CancelEmployeeAppointmentDto(DtoModel):
    reason: str | None = None


@dataclass(slots=True)
class EmployeeAppointmentResponseDto(DtoModel):
    id: str
    serviceName: str
    customerName: str
    customerId: str
    status: EmployeeBookingStatusFilter
    category: str
    clinicName: str
    address: str
    date: datetime
    checkInTime: str
    checkOutTime: str
    duration: str
    imageUrl: str | None = None
    price: float | None = None
    notes: str | None = None


__all__ = [
    "EmployeeBookingStatusFilter",
    "CancelEmployeeAppointmentDto",
    "EmployeeAppointmentResponseDto",
]
