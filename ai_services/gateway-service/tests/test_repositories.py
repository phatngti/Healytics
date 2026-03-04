"""
tests/test_repositories.py

Integration tests for conversation_repo and message_repo.
Each test runs inside a rolled-back SAVEPOINT (see conftest.py),
so the DB is always clean at test start.

Run:
    pytest tests/test_repositories.py -v
"""

import uuid

import pytest
from sqlalchemy.ext.asyncio import AsyncSession

from app.repositories.conversation_repo import (
    create_conversation,
    delete_conversation,
    get_conversation_by_id,
    get_conversations_page,
    get_or_create_conversation,
    update_conversation_title,
)
from app.repositories.message_repo import (
    create_message,
    get_messages_by_conversation,
    get_messages_page,
)


# ===========================================================================
# conversation_repo tests
# ===========================================================================

@pytest.mark.asyncio
async def test_create_and_get_conversation(db_session: AsyncSession):
    # Arrange
    conv_id = uuid.uuid4()

    # Act
    created = await create_conversation(
        db_session, conv_id, user_id="user_1", title="Test Chat"
    )
    fetched = await get_conversation_by_id(db_session, conv_id)

    # Assert
    assert fetched is not None
    assert fetched.id == created.id
    assert fetched.title == "Test Chat"


@pytest.mark.asyncio
async def test_get_conversation_by_id_returns_none_when_not_found(
    db_session: AsyncSession,
):
    result = await get_conversation_by_id(db_session, uuid.uuid4())
    assert result is None


@pytest.mark.asyncio
async def test_get_or_create_returns_existing(db_session: AsyncSession):
    # Arrange — create once
    conv_id = uuid.uuid4()
    original = await create_conversation(
        db_session, conv_id, user_id="user_1"
    )

    # Act — get_or_create with same id should NOT insert a new row
    fetched = await get_or_create_conversation(
        db_session, conv_id, user_id="user_1"
    )

    # Assert — same object, not a duplicate
    assert fetched.id == original.id


@pytest.mark.asyncio
async def test_update_conversation_title(db_session: AsyncSession):
    # Arrange
    conv_id = uuid.uuid4()
    await create_conversation(
        db_session, conv_id, user_id="user_1", title="Old Title"
    )

    # Act
    updated = await update_conversation_title(
        db_session, conv_id, "New Title"
    )

    # Assert
    assert updated is not None
    assert updated.title == "New Title"


@pytest.mark.asyncio
async def test_update_conversation_title_not_found(db_session: AsyncSession):
    result = await update_conversation_title(
        db_session, uuid.uuid4(), "Should Not Exist"
    )
    assert result is None


@pytest.mark.asyncio
async def test_delete_conversation(db_session: AsyncSession):
    # Arrange
    conv_id = uuid.uuid4()
    await create_conversation(db_session, conv_id, user_id="user_1")

    # Act
    deleted = await delete_conversation(db_session, conv_id)
    fetched = await get_conversation_by_id(db_session, conv_id)

    # Assert
    assert deleted is True
    assert fetched is None


@pytest.mark.asyncio
async def test_delete_conversation_not_found(db_session: AsyncSession):
    result = await delete_conversation(db_session, uuid.uuid4())
    assert result is False


@pytest.mark.asyncio
async def test_get_conversations_page(db_session: AsyncSession):
    # Arrange — 15 conversations for user_page_test
    user_id = f"user_page_{uuid.uuid4().hex[:6]}"
    for i in range(15):
        await create_conversation(
            db_session, uuid.uuid4(), user_id=user_id, title=f"Chat {i}"
        )

    # Act — page 2 with limit 5 → should return 5 rows
    conversations, total = await get_conversations_page(
        db_session, user_id=user_id, page=2, limit=5
    )

    # Assert
    assert total == 15
    assert len(conversations) == 5


# ===========================================================================
# message_repo tests
# ===========================================================================

@pytest.mark.asyncio
async def test_create_and_list_messages(db_session: AsyncSession):
    # Arrange
    conv_id = uuid.uuid4()
    await create_conversation(db_session, conv_id, user_id="user_1")

    # Act
    await create_message(db_session, conv_id, role="user", content="Hello")
    await create_message(db_session, conv_id, role="assistant", content="Hi")
    messages = await get_messages_by_conversation(db_session, conv_id)

    # Assert
    assert len(messages) == 2
    assert messages[0].role == "user"
    assert messages[1].role == "assistant"


@pytest.mark.asyncio
async def test_get_messages_page_pagination(db_session: AsyncSession):
    # Arrange — 25 messages
    conv_id = uuid.uuid4()
    await create_conversation(db_session, conv_id, user_id="user_1")
    for i in range(1, 26):
        await create_message(
            db_session, conv_id, role="user", content=f"Message {i}"
        )

    # Act — page 2, limit 10 → rows 11-20
    messages, total = await get_messages_page(
        db_session, conversation_id=conv_id, page=2, limit=10
    )

    # Assert
    assert total == 25
    assert len(messages) == 10
    assert messages[0].content == "Message 11"  # oldest-first, offset 10


@pytest.mark.asyncio
async def test_get_messages_page_last_page(db_session: AsyncSession):
    # Arrange — 25 messages, last page of 10 has only 5
    conv_id = uuid.uuid4()
    await create_conversation(db_session, conv_id, user_id="user_1")
    for i in range(1, 26):
        await create_message(
            db_session, conv_id, role="user", content=f"Message {i}"
        )

    # Act — page 3
    messages, total = await get_messages_page(
        db_session, conversation_id=conv_id, page=3, limit=10
    )

    # Assert
    assert total == 25
    assert len(messages) == 5
    assert messages[-1].content == "Message 25"


@pytest.mark.asyncio
async def test_get_messages_empty_conversation(db_session: AsyncSession):
    conv_id = uuid.uuid4()
    await create_conversation(db_session, conv_id, user_id="user_1")

    messages, total = await get_messages_page(
        db_session, conversation_id=conv_id
    )

    assert total == 0
    assert messages == []
