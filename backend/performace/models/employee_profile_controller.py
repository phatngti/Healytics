"""Generated models for employee_profile_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import WorkScheduleEntryDto


@dataclass(slots=True)
class UpdateEmployeeProfileDto(DtoModel):
    phone: str | None = None
    avatarUrl: str | None = None
    description: str | None = None
    emergencyContactName: str | None = None
    emergencyContactPhone: str | None = None
    schedule: list[WorkScheduleEntryDto] | None = None


__all__ = [
    "UpdateEmployeeProfileDto",
]
