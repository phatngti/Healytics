"""Generated models for admin_notification_controller. Do not edit manually."""

from __future__ import annotations

from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class CreateBroadcastDto(DtoModel):
    title: str
    body: str
    data: dict[str, Any] | None = None


@dataclass(slots=True)
class NotificationResponseDto(DtoModel):
    id: str
    type: str
    title: str
    body: str
    isRead: bool
    isBroadcast: bool
    createdAt: datetime
    data: dict[str, Any] | None = None
    readAt: dict[str, Any] | None = None


AdminNotificationControllerGetBroadcastsResponseDto: TypeAlias = list[NotificationResponseDto]  # GET /admin/notifications/broadcasts [200]


__all__ = [
    "CreateBroadcastDto",
    "NotificationResponseDto",
    "AdminNotificationControllerGetBroadcastsResponseDto",
]
