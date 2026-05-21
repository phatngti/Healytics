"""Generated models for user_payment_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class ConfirmStripeSetupIntentDto(DtoModel):
    setDefault: bool | None = None


@dataclass(slots=True)
class CreateMoMoPaymentDto(DtoModel):
    requestType: str | None = None


@dataclass(slots=True)
class CreateMoMoRefundDto(DtoModel):
    transId: float


@dataclass(slots=True)
class CreateStripePaymentDto(DtoModel):
    cardId: str | None = None


@dataclass(slots=True)
class CreateStripeSetupIntentResponseDto(DtoModel):
    setupIntentId: str
    clientSecret: str


@dataclass(slots=True)
class SavedPaymentCardDto(DtoModel):
    id: str
    brand: str
    last4: str
    expMonth: float
    expYear: float
    isDefault: bool
    funding: str | None = None
    country: str | None = None


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


MoMoPaymentResponseDto: TypeAlias = dict[str, Any]


MoMoRefundResponseDto: TypeAlias = dict[str, Any]


UserPaymentControllerListCardsResponseDto: TypeAlias = list[SavedPaymentCardDto]  # GET /user/payments/cards [200]


UserPaymentControllerDeleteCardResponseDto: TypeAlias = list[SavedPaymentCardDto]  # DELETE /user/payments/cards/{cardId} [200]


__all__ = [
    "ConfirmStripeSetupIntentDto",
    "CreateMoMoPaymentDto",
    "CreateMoMoRefundDto",
    "CreateStripePaymentDto",
    "CreateStripeSetupIntentResponseDto",
    "SavedPaymentCardDto",
    "StripePaymentResponseDto",
    "StripeRefundResponseDto",
    "MoMoPaymentResponseDto",
    "MoMoRefundResponseDto",
    "UserPaymentControllerListCardsResponseDto",
    "UserPaymentControllerDeleteCardResponseDto",
]
