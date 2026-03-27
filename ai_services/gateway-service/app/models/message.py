"""
app/models/message.py

ORM model mirroring the `messages` table created by the NestJS migration.
This service does NOT manage the schema — read/write only.

Table schema (from NestJS migration):
    id               UUID  PRIMARY KEY  DEFAULT uuid_generate_v4()
    conversation_id  UUID  FK -> conversations.id  ON DELETE CASCADE
    role             VARCHAR(20)   -- "user" | "assistant"
    content          TEXT
    created_at       TIMESTAMP  DEFAULT now()
"""

import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String, Text, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class Message(Base):
    __tablename__ = "messages"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=text("uuid_generate_v4()"),
    )
    conversation_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("conversations.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    # "user" | "assistant"
    role: Mapped[str] = mapped_column(String(20), nullable=False)
    content: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=False),
        server_default=text("now()"),
    )

    # Convenience back-reference (lazy loaded — not auto-joined)
    conversation = relationship(
        "Conversation",
        back_populates=None,
        lazy="raise",  # require explicit loading; prevent N+1
    )

    def __repr__(self) -> str:
        return (
            f"Message(id={self.id!r}, "
            f"role={self.role!r}, "
            f"conversation_id={self.conversation_id!r})"
        )
