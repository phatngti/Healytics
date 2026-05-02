"""Generated models for partner_payouts_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class RetryPayoutDto(DtoModel):
    note: str | None = None


__all__ = [
    "RetryPayoutDto",
]
