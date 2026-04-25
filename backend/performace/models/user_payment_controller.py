"""Generated models for user_payment_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class CreateMoMoPaymentDto(DtoModel):
    requestType: str | None = None


@dataclass(slots=True)
class CreateMoMoRefundDto(DtoModel):
    transId: float


@dataclass(slots=True)
class StripePaymentResponseDto(DtoModel):
    paymentIntentId: str
    clientSecret: str
    amount: float
    currency: str
    status: str


@dataclass(slots=True)
class StripeRefundResponseDto(DtoModel):
    refundId: str
    amount: float
    currency: str
    status: str
    paymentIntentId: str | None = None


CreateStripePaymentDto: TypeAlias = dict[str, Any]


MoMoPaymentResponseDto: TypeAlias = dict[str, Any]


MoMoRefundResponseDto: TypeAlias = dict[str, Any]


__all__ = [
    "CreateMoMoPaymentDto",
    "CreateMoMoRefundDto",
    "StripePaymentResponseDto",
    "StripeRefundResponseDto",
    "CreateStripePaymentDto",
    "MoMoPaymentResponseDto",
    "MoMoRefundResponseDto",
]
