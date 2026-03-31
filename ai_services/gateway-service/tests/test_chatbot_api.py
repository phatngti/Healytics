"""
tests/test_chatbot_api.py

Integration tests for the Chatbot API endpoints.
Uses the test database defined in conftest.py.
"""

import pytest
import pytest_asyncio
import uuid
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession

from app.main import app
from app.core.database import get_db
from app.repositories import conversation_repo, message_repo

@pytest_asyncio.fixture
async def client(db_session: AsyncSession):
    """
    Override get_db with the test session and return an AsyncClient.
    """
    async def _get_db_override():
        yield db_session

    app.dependency_overrides[get_db] = _get_db_override
    # Use ASGITransport for testing FastAPI apps with httpx
    async with AsyncClient(
        transport=ASGITransport(app=app), base_url="http://test"
    ) as ac:
        yield ac
    app.dependency_overrides.clear()


@pytest.mark.asyncio
async def test_get_conversations_api(client: AsyncClient, db_session: AsyncSession):
    # Arrange: Seed 12 conversations for a test user
    user_id = f"user_api_{uuid.uuid4().hex[:6]}"
    for i in range(12):
        await conversation_repo.create_conversation(
            db_session, uuid.uuid4(), user_id=user_id, title=f"Chat {i}"
        )
    await db_session.flush()

    # Act: Get page 1
    response = await client.get(f"/chatbot/conversations?user_id={user_id}&page=1&limit=10")

    # Assert
    assert response.status_code == 200
    data = response.json()
    assert data["meta"]["total"] == 12
    assert len(data["conversations"]) == 10
    assert data["meta"]["page"] == 1
    assert data["meta"]["limit"] == 10
    assert data["meta"]["totalPages"] == 2
    assert "conversations" in data
    assert "meta" in data


@pytest.mark.asyncio
async def test_get_messages_api(client: AsyncClient, db_session: AsyncSession):
    # Arrange: Seed a conversation and 25 messages
    conv_id = uuid.uuid4()
    user_id = "user_msg_api"
    await conversation_repo.create_conversation(db_session, conv_id, user_id=user_id)
    
    for i in range(25):
        await message_repo.create_message(
            db_session, conv_id, role="user", content=f"Message {i}"
        )
    await db_session.flush()

    # Act: Get page 2
    response = await client.get(f"/chatbot/conversations/{conv_id}/messages?page=2&limit=10")

    # Assert
    assert response.status_code == 200
    data = response.json()
    assert data["meta"]["total"] == 25
    assert len(data["messages"]) == 10
    assert data["meta"]["page"] == 2
    assert data["meta"]["limit"] == 10
    assert data["meta"]["totalPages"] == 3
    # Our repo returns oldest-first (ASC). Page 2 (offset 10) starting from "Message 0"
    # will start with "Message 10".
    assert data["messages"][0]["content"] == "Message 10"


@pytest.mark.asyncio
async def test_get_messages_api_not_found(client: AsyncClient):
    # Act: Request messages for a non-existent conversation
    non_existent_id = uuid.uuid4()
    response = await client.get(f"/chatbot/conversations/{non_existent_id}/messages")

    # Assert: Should return 200 with empty items (since it's a list query)
    assert response.status_code == 200
    data = response.json()
    assert data["meta"]["total"] == 0
    assert data["messages"] == []


@pytest.mark.asyncio
async def test_get_messages_api_with_owner_user_id(
    client: AsyncClient, db_session: AsyncSession
):
    conv_id = uuid.uuid4()
    user_id = f"user_owner_{uuid.uuid4().hex[:6]}"

    await conversation_repo.create_conversation(
        db_session,
        conv_id,
        user_id=user_id,
    )
    await message_repo.create_message(
        db_session,
        conv_id,
        role="user",
        content="hello",
    )
    await db_session.flush()

    response = await client.get(
        f"/chatbot/conversations/{conv_id}/messages?user_id={user_id}"
    )

    assert response.status_code == 200
    data = response.json()
    assert data["meta"]["total"] == 1
    assert data["messages"][0]["content"] == "hello"


@pytest.mark.asyncio
async def test_get_messages_api_with_wrong_user_id_returns_404(
    client: AsyncClient, db_session: AsyncSession
):
    conv_id = uuid.uuid4()

    await conversation_repo.create_conversation(
        db_session,
        conv_id,
        user_id="user_a",
    )
    await message_repo.create_message(
        db_session,
        conv_id,
        role="user",
        content="private message",
    )
    await db_session.flush()

    response = await client.get(
        f"/chatbot/conversations/{conv_id}/messages?user_id=user_b"
    )

    assert response.status_code == 404
    assert response.json()["detail"] == "Conversation not found"
