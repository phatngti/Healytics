"""WebSocket payload models derived from ws-contract.json. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from typing import Any
from dataclasses import dataclass
from .base import DtoModel, dto_field


class WsMessageType(str, Enum):
    TEXT = 'text'
    IMAGE = 'image'
    FILE = 'file'
    SYSTEM = 'system'


class WsNotificationType(str, Enum):
    BOOKING_CONFIRMED = 'booking_confirmed'
    BOOKING_CANCELLED = 'booking_cancelled'
    BOOKING_COMPLETED = 'booking_completed'
    APPOINTMENT_REMINDER = 'appointment_reminder'
    APPOINTMENT_UPDATED = 'appointment_updated'
    NEW_CHAT_MESSAGE = 'new_chat_message'
    PAYMENT_SUCCESS = 'payment_success'
    PAYMENT_FAILED = 'payment_failed'
    SYSTEM_BROADCAST = 'system_broadcast'
    SYSTEM_MAINTENANCE = 'system_maintenance'
    PARTNER_VERIFIED = 'partner_verified'
    PARTNER_REJECTED = 'partner_rejected'


# ── Client → Server payloads ─────────────────────────────────────────────────

@dataclass(slots=True)
class WsSendMessagePayload(DtoModel):
    """Payload for sending a message via WebSocket."""
    conversationId: str
    receiverId: str
    content: str
    messageType: WsMessageType | None = None
    clientMessageId: str | None = None


@dataclass(slots=True)
class WsTypingPayload(DtoModel):
    """Payload for typing / stop_typing events."""
    conversationId: str
    receiverId: str


@dataclass(slots=True)
class WsMarkReadPayload(DtoModel):
    """Payload for mark_read events."""
    conversationId: str
    receiverId: str


@dataclass(slots=True)
class WsJoinConversationPayload(DtoModel):
    """Payload for join_conversation events."""
    conversationId: str


# ── Server → Client events ──────────────────────────────────────────────────

@dataclass(slots=True)
class WsNewNotificationEvent(DtoModel):
    """Server event: a new notification pushed to the user."""
    id: str
    type: WsNotificationType
    title: str
    body: str
    isRead: bool
    isBroadcast: bool
    createdAt: datetime
    data: dict[str, Any] | None = None
    readAt: datetime | None = None


@dataclass(slots=True)
class WsUnreadCountEvent(DtoModel):
    """Server event: updated unread notification count."""
    count: float


@dataclass(slots=True)
class WsBroadcastSentEvent(DtoModel):
    """Server event: a system-wide broadcast was sent."""
    id: str
    title: str
    body: str
    createdAt: datetime


@dataclass(slots=True)
class WsMessageSentAck(DtoModel):
    """Server acknowledgement after persisting a message."""
    id: str
    clientMessageId: str | None = None


@dataclass(slots=True)
class WsNewMessageEvent(DtoModel):
    """Server event: a new message in a conversation."""
    id: str
    conversationId: str
    senderId: str
    receiverId: str
    content: str
    messageType: WsMessageType
    createdAt: datetime
    senderName: str | None = None
    senderAvatar: str | None = None
    clientMessageId: str | None = None


@dataclass(slots=True)
class WsMessagesReadEvent(DtoModel):
    """Server event: messages were read by the other party."""
    conversationId: str
    readerId: str
    receiverId: str
    readAt: datetime


@dataclass(slots=True)
class WsTypingEvent(DtoModel):
    """Server event: the other party is typing."""
    conversationId: str
    userId: str
    receiverId: str
    userName: str


@dataclass(slots=True)
class WsStopTypingEvent(DtoModel):
    """Server event: the other party stopped typing."""
    conversationId: str
    userId: str
    receiverId: str


@dataclass(slots=True)
class WsErrorEvent(DtoModel):
    """Server error event."""
    message: str


@dataclass(slots=True)
class WsNewMessageNotification(DtoModel):
    """Global notification event: popup for new chat messages."""
    conversationId: str
    messageId: str
    senderId: str
    senderName: str
    messagePreview: str
    messageType: WsMessageType
    createdAt: datetime
    senderAvatar: str | None = None


__all__ = [
    "WsMessageType",
    "WsNotificationType",
    # Client → Server
    "WsSendMessagePayload",
    "WsTypingPayload",
    "WsMarkReadPayload",
    "WsJoinConversationPayload",
    # Server → Client
    "WsNewNotificationEvent",
    "WsUnreadCountEvent",
    "WsBroadcastSentEvent",
    "WsMessageSentAck",
    "WsNewMessageEvent",
    "WsMessagesReadEvent",
    "WsTypingEvent",
    "WsStopTypingEvent",
    "WsErrorEvent",
    "WsNewMessageNotification",
]
