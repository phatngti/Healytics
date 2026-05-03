"""Generated models for partner_chat_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from .shared import ConversationResponseDto


PartnerChatControllerGetConversationsResponseDto: TypeAlias = list[ConversationResponseDto]  # GET /partner/chat/conversations [200]


__all__ = [
    "PartnerChatControllerGetConversationsResponseDto",
]
