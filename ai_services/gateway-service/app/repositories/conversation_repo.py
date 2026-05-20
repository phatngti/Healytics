"""
app/repositories/conversation_repo.py

Data-access functions for the `conversations` table.

Rules:
- No business logic.
- No HTTP logic.
- Functions are small and atomic.
- Return ORM model instances; let the caller decide how to use them.
"""

import uuid
from datetime import datetime, timezone

from sqlalchemy import delete, func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.conversation import Conversation


async def get_conversation_by_id(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
) -> Conversation | None:
    """Return the Conversation with the given id, or None if not found."""
    result = await session.execute(
        select(Conversation).where(
            Conversation.id == conversation_id
        )
    )
    return result.scalar_one_or_none()


async def create_conversation(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
    user_id: str | uuid.UUID | None,
    title: str = "New conversation",
) -> Conversation:
    """
    Insert a new Conversation row and return it.

    The caller supplies the conversation_id so that the
    gateway can use the UUID already agreed on with the client.

    Note: refresh() is intentionally omitted — all fields are
    set explicitly on the Python object, so an extra SELECT
    after flush() would be redundant.
    """
    conversation = Conversation(
        id=conversation_id,
        user_id=str(user_id) if user_id is not None else None,
        title=title,
        created_at=datetime.now(tz=timezone.utc),
        updated_at=datetime.now(tz=timezone.utc),
    )
    session.add(conversation)
    await session.flush()
    return conversation


async def get_or_create_conversation(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
    user_id: str | uuid.UUID | None,
    title: str = "New conversation",
) -> Conversation:
    """
    Return existing Conversation or create a new one.

    Race-condition safe: uses a SAVEPOINT (begin_nested) so that if
    two concurrent requests both pass the initial get() check and
    attempt to insert the same UUID, the loser catches the
    IntegrityError, rolls back only the savepoint, and re-fetches
    the row that the winner just committed — leaving the outer
    session intact.
    """
    existing = await get_conversation_by_id(session, conversation_id)
    if existing is not None:
        return existing

    try:
        async with session.begin_nested():  # SAVEPOINT
            return await create_conversation(
                session, conversation_id, user_id, title
            )
    except IntegrityError as exc:
        # Lost the race — another request inserted first; fetch it.
        # Under REPEATABLE READ / SERIALIZABLE, the row may exist but still be
        # invisible to this snapshot after savepoint rollback; refetch after a
        # full rollback gets a fresh snapshot (READ COMMITTED default also
        # benefits from clearing a session left "inactive" after the error).
        existing = await get_conversation_by_id(session, conversation_id)
        if existing is not None:
            return existing
        await session.rollback()
        existing = await get_conversation_by_id(session, conversation_id)
        if existing is not None:
            return existing
        raise exc


async def delete_conversation(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
) -> bool:
    """
    Hard-delete a conversation by id.

    Associated messages are removed automatically by the
    ON DELETE CASCADE foreign key in the `messages` table.

    Returns True if a row was deleted, False if not found.
    """
    result = await session.execute(
        delete(Conversation).where(
            Conversation.id == conversation_id
        )
    )
    await session.flush()
    return result.rowcount > 0


async def update_conversation_title(
    session: AsyncSession,
    conversation_id: str | uuid.UUID,
    new_title: str,
) -> Conversation | None:
    """
    Rename a conversation.

    Returns the updated Conversation, or None if not found.
    Commonly used when the AI generates a contextual title
    after the first message in a new chat.
    """
    conversation = await get_conversation_by_id(
        session, conversation_id
    )
    if conversation is None:
        return None
    conversation.title = new_title
    conversation.updated_at = datetime.now(tz=timezone.utc)
    await session.flush()
    return conversation


async def get_conversations_page(
    session: AsyncSession,
    user_id: str | uuid.UUID,
    page: int = 1,
    limit: int = 10,
) -> tuple[list[Conversation], int]:
    """
    Return a paginated slice of conversations for a user plus
    the total count.

    Returning a plain tuple keeps the repo free of presentation
    logic. Call ``chatbot_orchestrator.format_conversations_page``
    to shape the result into an API response dict.

    Args:
        session: Active async DB session.
        user_id: Filter conversations by this user.
        page:    1-based page number.
        limit:   Max conversations per page.

    Returns:
        (conversations, total) — ordered by updated_at DESC.
    """
    offset = (page - 1) * limit
    user_id_value = str(user_id)

    base_q = (
        select(Conversation)
        .where(Conversation.user_id == user_id_value)
        .order_by(Conversation.updated_at.desc())
    )

    # Direct count — no ORDER BY so the DB skips the sort step.
    total: int = (
        await session.execute(
            select(func.count(Conversation.id))
            .where(Conversation.user_id == user_id_value)
        )
    ).scalar_one()

    rows = (
        await session.execute(base_q.offset(offset).limit(limit))
    ).scalars().all()

    return list(rows), total
