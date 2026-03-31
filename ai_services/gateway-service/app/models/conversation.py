"""
app/models/conversation.py

ORM model mirroring the `conversations` table created by the NestJS migration.
This service does NOT manage the schema — read/write only.

Table schema (from NestJS migration):
    id           UUID  PRIMARY KEY  DEFAULT uuid_generate_v4()
    user_id      VARCHAR  NULLABLE
    title        VARCHAR(255)
    created_at   TIMESTAMPTZ  DEFAULT now()
    updated_at   TIMESTAMPTZ  DEFAULT now()
"""

import uuid
from datetime import datetime, timezone

from sqlalchemy import DateTime, String, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class Conversation(Base):
    __tablename__ = "conversations"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=text("uuid_generate_v4()"),
    )
    user_id: Mapped[str | None] = mapped_column(
        String,
        nullable=True,
        index=True,
    )
    title: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        default="New conversation",
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=text("now()"),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=text("now()"),
        onupdate=lambda: datetime.now(tz=timezone.utc),
    )

    def __repr__(self) -> str:
        return (
            f"Conversation(id={self.id!r}, "
            f"user_id={self.user_id!r}, "
            f"title={self.title!r})"
        )
