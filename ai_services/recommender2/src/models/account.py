"""
src/models/account.py

Minimal ORM model for the `account` table (owned by NestJS backend).
Only maps the columns this service actually needs — read-only access.

This service does NOT create, alter, or drop this table.
"""

import uuid
from typing import Any

from sqlalchemy import JSON, String
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from config.database import Base


class Account(Base):
    __tablename__ = "account"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True
    )
    email: Mapped[str] = mapped_column(String, nullable=False)

    # Uses PostgreSQL JSONB in production; falls back to standard JSON
    # for SQLite in tests. JSONB is not supported by SQLite.
    survey: Mapped[dict[str, Any] | None] = mapped_column(
        JSONB().with_variant(JSON(), "sqlite"),
        nullable=True,
    )

    def __repr__(self) -> str:
        return f"Account(id={self.id!r}, email={self.email!r})"
