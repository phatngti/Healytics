"""
src/models/user_profile.py

Minimal read-only ORM model for the `user_profile` table (owned by
the NestJS backend). Only maps the columns the recommender service
needs for building a user profile.

This service does NOT create, alter, or drop this table.

DB columns used:
    id             UUID PRIMARY KEY
    account_id     UUID FK → account.id
    first_name     VARCHAR nullable
    last_name      VARCHAR nullable
    date_of_birth  DATE nullable
"""

import uuid
from datetime import date

from sqlalchemy import Date, ForeignKey, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from config.database import Base
from src.models.account import Account


class UserProfile(Base):
    __tablename__ = "user_profile"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True
    )
    account_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("account.id", ondelete="CASCADE"),
        nullable=True,
        index=True,
    )
    first_name: Mapped[str | None] = mapped_column(
        String, nullable=True
    )
    last_name: Mapped[str | None] = mapped_column(
        String, nullable=True
    )
    phone: Mapped[str | None] = mapped_column(
        String, nullable=True
    )
    bio: Mapped[str | None] = mapped_column(
        String, nullable=True
    )
    date_of_birth: Mapped[date | None] = mapped_column(
        Date, nullable=True
    )

    # Read-only back-reference to Account (for email access in build_user_profile)
    account: Mapped["Account"] = relationship(
        "Account",
        foreign_keys=[account_id],
        lazy="raise",   # must be explicitly loaded (joinedload)
    )

    def __repr__(self) -> str:
        return (
            f"UserProfile(id={self.id!r}, "
            f"account_id={self.account_id!r}, "
            f"first_name={self.first_name!r})"
        )
