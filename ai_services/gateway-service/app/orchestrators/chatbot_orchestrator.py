"""
app/orchestrators/chatbot_orchestrator.py

Coordinates the full chat flow:
  1. get_or_create_conversation
  2. save user message
  3. call chatbot_client.stream_chat()
  4. stream tokens → SSE
  5. call ner_client (optional)
  6. call recommender_client (optional)
  7. collect full response
  8. save assistant message
  9. emit DONE event

Formatting helpers live here so the repositories stay
free of presentation logic.
"""

import math
import uuid
from datetime import datetime
from typing import Any

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.conversation import Conversation
from app.models.message import Message
from app.repositories import conversation_repo, message_repo


# ---------------------------------------------------------------------------
# Response formatters
# ---------------------------------------------------------------------------

# Use when returning a single message object from a route,
# e.g. after creating a message or fetching one by id.
def format_message(message: Message) -> dict[str, Any]:
    """Serialize a single Message ORM object for the API response."""
    return {
        "id": str(message.id),                    # UUID → string
        "conversationId": str(message.conversation_id),
        "role": message.role,                     # "user" | "assistant"
        "content": message.content,               # full message text
        "createdAt": (
            message.created_at.isoformat()        # ISO-8601 UTC timestamp
            if isinstance(message.created_at, datetime)
            else str(message.created_at)
        ),
    }


# Use in routes that return a paginated list of messages
# for a conversation, e.g. GET /conversations/{id}/messages?page=1.
# Unpack the tuple from message_repo.get_messages_page() and pass here.
def format_messages_page(
    messages: list[Message],
    total: int,
    page: int,
    limit: int,
) -> dict[str, Any]:
    """
    Shape the tuple from ``message_repo.get_messages_page()``
    into the paginated API response format.

    Usage::

        messages, total = await message_repo.get_messages_page(
            session, conversation_id, page, limit
        )
        return format_messages_page(messages, total, page, limit)
    """
    return {
        # Each Message ORM object is serialized via format_message()
        "messages": [format_message(m) for m in messages],
        "meta": {
            "page": page,
            "limit": limit,
            "total": total,                                     # total rows in DB
            "totalPages": math.ceil(total / limit) if limit else 0,
        },
    }


# Use when returning a single conversation object from a route,
# e.g. after creating or updating a conversation.
def format_conversation(conversation: Conversation) -> dict[str, Any]:
    """Serialize a single Conversation ORM object for the API response."""
    return {
        "id": str(conversation.id),               # UUID → string
        "userId": str(conversation.user_id) if conversation.user_id else None,
        "title": conversation.title,
        "createdAt": (
            conversation.created_at.isoformat()   # ISO-8601 UTC timestamp
            if isinstance(conversation.created_at, datetime)
            else str(conversation.created_at)
        ),
        "updatedAt": (
            conversation.updated_at.isoformat()   # reflects last message time
            if isinstance(conversation.updated_at, datetime)
            else str(conversation.updated_at)
        ),
    }


# Use in routes that return a paginated list of conversations
# for a user, e.g. GET /conversations?user_id=...&page=1.
# Unpack the tuple from conversation_repo.get_conversations_page() and pass here.
def format_conversations_page(
    conversations: list[Conversation],
    total: int,
    page: int,
    limit: int,
) -> dict[str, Any]:
    """
    Shape the tuple from ``conversation_repo.get_conversations_page()``
    into the paginated API response format.

    Usage::

        conversations, total = await conversation_repo.get_conversations_page(
            session, user_id, page, limit
        )
        return format_conversations_page(conversations, total, page, limit)
    """
    return {
        # Each Conversation ORM object is serialized via format_conversation()
        "conversations": [format_conversation(c) for c in conversations],
        "meta": {
            "page": page,
            "limit": limit,
            "total": total,                                     # total rows in DB
            "totalPages": math.ceil(total / limit) if limit else 0,
        },
    }


# ---------------------------------------------------------------------------
# Main chat flow  (to be implemented)
# ---------------------------------------------------------------------------

