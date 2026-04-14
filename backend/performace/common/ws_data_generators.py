"""
Faker-based data generators for WebSocket payloads.
Produces payloads matching the ws-contract.json models.
"""

from __future__ import annotations

import os
import uuid
import random
from faker import Faker

fake = Faker("vi_VN")

# ── Configurable test IDs ────────────────────────────────────────────────────
# These can be overridden via environment variables for testing against
# real conversations in the database. Defaults to random UUIDs.
WS_CONVERSATION_ID = os.getenv("WS_CONVERSATION_ID", str(uuid.uuid4()))
WS_RECEIVER_ID = os.getenv("WS_RECEIVER_ID", str(uuid.uuid4()))

# Additional conversation IDs for variety (comma-separated env var)
_extra_convos = os.getenv("WS_EXTRA_CONVERSATION_IDS", "")
WS_CONVERSATION_IDS = (
    [WS_CONVERSATION_ID] + [c.strip() for c in _extra_convos.split(",") if c.strip()]
)

_extra_receivers = os.getenv("WS_EXTRA_RECEIVER_IDS", "")
WS_RECEIVER_IDS = (
    [WS_RECEIVER_ID] + [r.strip() for r in _extra_receivers.split(",") if r.strip()]
)


def _pick_conversation_id() -> str:
    """Pick a random conversation ID from the configured pool."""
    return random.choice(WS_CONVERSATION_IDS)


def _pick_receiver_id() -> str:
    """Pick a random receiver ID from the configured pool."""
    return random.choice(WS_RECEIVER_IDS)


# ── WsSendMessagePayload ─────────────────────────────────────────────────────

MESSAGE_TYPES = ["text", "image", "file", "system"]


def generate_send_message(
    conversation_id: str | None = None,
    receiver_id: str | None = None,
) -> dict:
    """
    Generate a WsSendMessagePayload.

    Matches ws-contract.json:
      - conversationId (required)
      - receiverId (required)
      - content (required, max 5000 chars)
      - messageType (optional, default "text")
      - clientMessageId (optional, UUID for idempotent delivery)
    """
    return {
        "conversationId": conversation_id or _pick_conversation_id(),
        "receiverId": receiver_id or _pick_receiver_id(),
        "content": fake.paragraph(nb_sentences=random.randint(1, 3))[:500],
        "messageType": random.choices(
            MESSAGE_TYPES, weights=[80, 10, 8, 2], k=1
        )[0],
        "clientMessageId": str(uuid.uuid4()),
    }


# ── WsTypingPayload ──────────────────────────────────────────────────────────

def generate_typing(
    conversation_id: str | None = None,
    receiver_id: str | None = None,
) -> dict:
    """
    Generate a WsTypingPayload.

    Matches ws-contract.json:
      - conversationId (required)
      - receiverId (required)
    """
    return {
        "conversationId": conversation_id or _pick_conversation_id(),
        "receiverId": receiver_id or _pick_receiver_id(),
    }


# ── WsMarkReadPayload ────────────────────────────────────────────────────────

def generate_mark_read(
    conversation_id: str | None = None,
    receiver_id: str | None = None,
) -> dict:
    """
    Generate a WsMarkReadPayload.

    Matches ws-contract.json:
      - conversationId (required)
      - receiverId (required)
    """
    return {
        "conversationId": conversation_id or _pick_conversation_id(),
        "receiverId": receiver_id or _pick_receiver_id(),
    }


# ── WsJoinConversationPayload ────────────────────────────────────────────────

def generate_join_conversation(
    conversation_id: str | None = None,
) -> dict:
    """
    Generate a WsJoinConversationPayload.

    Matches ws-contract.json:
      - conversationId (required)
    """
    return {
        "conversationId": conversation_id or _pick_conversation_id(),
    }
