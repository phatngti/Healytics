"""
tests/test_orchestrators.py

Unit tests for the formatting helpers in chatbot_orchestrator.py.

These tests are pure Python — no database, no async, no fixtures.
They run instantly and prove the pagination math and serialization
logic is correct independently of any SQL query.

Run:
    python -m pytest tests/test_orchestrators.py -v
"""

import uuid
from datetime import datetime, timezone

from app.models.conversation import Conversation
from app.models.message import Message
from app.utils.formatters import (
    format_conversation,
    format_conversations_page,
    format_message,
    format_messages_page,
)


# ---------------------------------------------------------------------------
# Helpers — build fake ORM objects without touching the DB
# ---------------------------------------------------------------------------

def make_message(**kwargs) -> Message:
    """Return a Message instance with sensible defaults."""
    return Message(
        id=kwargs.get("id", uuid.uuid4()),
        conversation_id=kwargs.get("conversation_id", uuid.uuid4()),
        role=kwargs.get("role", "user"),
        content=kwargs.get("content", "Hello"),
        created_at=kwargs.get("created_at", datetime.now(tz=timezone.utc)),
    )


def make_conversation(**kwargs) -> Conversation:
    """Return a Conversation instance with sensible defaults."""
    now = datetime.now(tz=timezone.utc)
    return Conversation(
        id=kwargs.get("id", uuid.uuid4()),
        user_id=kwargs.get("user_id", "user_test"),
        title=kwargs.get("title", "Test Chat"),
        created_at=kwargs.get("created_at", now),
        updated_at=kwargs.get("updated_at", now),
    )


# ===========================================================================
# format_message
# ===========================================================================

def test_format_message_fields():
    msg_id = uuid.uuid4()
    conv_id = uuid.uuid4()
    ts = datetime(2024, 1, 15, 10, 30, 0, tzinfo=timezone.utc)

    msg = make_message(id=msg_id, conversation_id=conv_id,
                       role="assistant", content="Hi there", created_at=ts)
    result = format_message(msg)

    assert result["id"] == str(msg_id)
    assert result["conversationId"] == str(conv_id)
    assert result["role"] == "assistant"
    assert result["content"] == "Hi there"
    assert result["createdAt"] == "2024-01-15T10:30:00+00:00"


def test_format_message_uuid_is_string():
    """id and conversationId must be strings, not UUID objects."""
    result = format_message(make_message())
    assert isinstance(result["id"], str)
    assert isinstance(result["conversationId"], str)


# ===========================================================================
# format_messages_page — pagination math
# ===========================================================================

def test_format_messages_page_total_pages_math():
    # 25 total, limit 10 → ceil(25/10) = 3 pages
    result = format_messages_page([make_message()], total=25, page=2, limit=10)

    assert result["meta"]["total"] == 25
    assert result["meta"]["page"] == 2
    assert result["meta"]["limit"] == 10
    assert result["meta"]["totalPages"] == 3


def test_format_messages_page_exact_division():
    # 20 total, limit 10 → exactly 2 pages
    result = format_messages_page([], total=20, page=1, limit=10)
    assert result["meta"]["totalPages"] == 2


def test_format_messages_page_zero_limit():
    # Safety net — must not raise ZeroDivisionError
    result = format_messages_page([], total=25, page=1, limit=0)
    assert result["meta"]["totalPages"] == 0


def test_format_messages_page_empty():
    result = format_messages_page([], total=0, page=1, limit=20)
    assert result["messages"] == []
    assert result["meta"]["total"] == 0
    assert result["meta"]["totalPages"] == 0


def test_format_messages_page_serializes_messages():
    msgs = [make_message(content=f"Msg {i}") for i in range(3)]
    result = format_messages_page(msgs, total=3, page=1, limit=20)

    assert len(result["messages"]) == 3
    assert result["messages"][0]["content"] == "Msg 0"
    assert result["messages"][2]["content"] == "Msg 2"


# ===========================================================================
# format_conversation
# ===========================================================================

def test_format_conversation_fields():
    conv_id = uuid.uuid4()
    ts = datetime(2024, 6, 1, 8, 0, 0, tzinfo=timezone.utc)

    conv = make_conversation(id=conv_id, user_id="user_42",
                             title="My Chat", created_at=ts, updated_at=ts)
    result = format_conversation(conv)

    assert result["id"] == str(conv_id)
    assert result["userId"] == "user_42"
    assert result["title"] == "My Chat"
    assert result["createdAt"] == "2024-06-01T08:00:00+00:00"
    assert result["updatedAt"] == "2024-06-01T08:00:00+00:00"


def test_format_conversation_null_user_id():
    conv = make_conversation(user_id=None)
    result = format_conversation(conv)
    assert result["userId"] is None


# ===========================================================================
# format_conversations_page — pagination math
# ===========================================================================

def test_format_conversations_page_total_pages_math():
    # 15 convs, limit 5 → 3 pages
    convs = [make_conversation() for _ in range(5)]
    result = format_conversations_page(convs, total=15, page=1, limit=5)

    assert result["meta"]["total"] == 15
    assert result["meta"]["totalPages"] == 3
    assert len(result["conversations"]) == 5


def test_format_conversations_page_zero_limit():
    result = format_conversations_page([], total=10, page=1, limit=0)
    assert result["meta"]["totalPages"] == 0


def test_format_conversations_page_partial_last_page():
    # 11 convs, limit 5 → ceil(11/5) = 3 pages
    result = format_conversations_page([], total=11, page=3, limit=5)
    assert result["meta"]["totalPages"] == 3
