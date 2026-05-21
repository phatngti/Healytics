"""Generated models for user_wishlist_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class WishlistItemResponseDto(DtoModel):
    id: str
    productId: str
    title: str
    price: str
    createdAt: datetime
    imageUrl: str | None = None


UserWishlistControllerListWishlistResponseDto: TypeAlias = list[WishlistItemResponseDto]  # GET /user/wishlist [200]


__all__ = [
    "WishlistItemResponseDto",
    "UserWishlistControllerListWishlistResponseDto",
]
