"""Generated models for ai_service_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class AiRecommendationItemDto(DtoModel):
    id: str
    name: str
    slug: str
    category: str
    duration: str
    price: str
    rating: str
    vendorName: str
    location: str
    staffAvatars: list[str]
    type: str
    imageUrl: dict[str, Any] | None = None


@dataclass(slots=True)
class AiRecommendationsRequestDto(DtoModel):
    serviceIds: list[str]


@dataclass(slots=True)
class AiRecommendationsResponseDto(DtoModel):
    total: float
    recommendations: list[AiRecommendationItemDto]


__all__ = [
    "AiRecommendationItemDto",
    "AiRecommendationsRequestDto",
    "AiRecommendationsResponseDto",
]
