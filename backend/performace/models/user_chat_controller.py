"""Generated models for user_chat_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias
from .shared import ConversationResponseDto


UserChatControllerGetConversationsResponseDto: TypeAlias = list[ConversationResponseDto]  # GET /user/chat/conversations [200]


__all__ = [
    "UserChatControllerGetConversationsResponseDto",
]
