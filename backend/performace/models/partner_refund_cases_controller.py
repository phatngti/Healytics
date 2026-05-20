"""Generated models for partner_refund_cases_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class RefundCaseActionDto(DtoModel):
    note: str | None = None


__all__ = [
    "RefundCaseActionDto",
]
