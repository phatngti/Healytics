"""
app/repositories/message_repo.py

Data-access functions for the `messages` table.

Rules:
- No business logic.
- No HTTP logic.
- Functions are small and atomic.
- Return ORM model instances; let the caller decide how to use them.
"""

import uuid
from datetime import datetime, timezone

from sqlalchemy import func, select
from typing import Any
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.message import Message


async def create_message(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
    role: str,
    content: str,
) -> Message:
    """
    Insert a new Message row and return it.

    Args:
        session:         Active async DB session.
        conversation_id: UUID of the parent conversation.
        role:            "user" | "assistant"
        content:         Full text of the message.
    """
    message = Message(
        conversation_id=conversation_id,
        role=role,
        content=content,
        created_at=datetime.utcnow(),
    )
    session.add(message)
    await session.flush()  # SQLAlchemy backfills DB-generated values on flush
    return message


async def get_messages_by_conversation(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
    limit: int | None = None,
) -> list[Message]:
    """
    Return messages for a conversation ordered by created_at ASC.

    Args:
        session:         Active async DB session.
        conversation_id: UUID of the parent conversation.
        limit:           Optional cap on number of rows returned.
    """
    query = (
        select(Message)
        .where(Message.conversation_id == conversation_id)
        .order_by(Message.created_at.asc())
    )
    if limit is not None:
        query = query.limit(limit)

    result = await session.execute(query)
    return list(result.scalars().all())


async def get_messages_page(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
    page: int = 1,
    limit: int = 20,
) -> tuple[list[Message], int]:
    """
    Return a paginated slice of messages plus the total count.

    Returning a plain tuple keeps the repo free of presentation
    logic. The caller (route/orchestrator) is responsible for
    shaping the response dict and computing ``totalPages``.

    Args:
        session:         Active async DB session.
        conversation_id: UUID of the parent conversation.
        page:            1-based page number.
        limit:           Max messages per page.

    Returns:
        (messages, total) — messages ordered oldest-first (ASC).
    """
    offset = (page - 1) * limit

    # Direct count — no ORDER BY so the DB skips the sort step.
    total: int = (
        await session.execute(
            select(func.count(Message.id))
            .where(Message.conversation_id == conversation_id)
        )
    ).scalar_one()

    rows = (
        await session.execute(
            select(Message)
            .where(Message.conversation_id == conversation_id)
            .order_by(Message.created_at.asc())
            .offset(offset)
            .limit(limit)
        )
    ).scalars().all()

    return list(rows), total
