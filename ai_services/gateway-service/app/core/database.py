"""
app/core/database.py

Async SQLAlchemy engine and session factory.

Usage (FastAPI dependency injection):

    from app.core.database import get_db
    from sqlalchemy.ext.asyncio import AsyncSession

    @router.post("/example")
    async def example(db: AsyncSession = Depends(get_db)):
        ...

Note: This service only performs reads and writes.
      Table creation and migrations are owned by the NestJS backend.
"""

from collections.abc import AsyncGenerator

from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase

from app.core.config import settings

# ---------------------------------------------------------------------------
# Engine — echo=False in production; set echo=True locally for SQL debugging
# ---------------------------------------------------------------------------
engine = create_async_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,  # detect stale connections
    pool_size=5,
    max_overflow=10,
    echo=False,
)

# ---------------------------------------------------------------------------
# Session factory
# ---------------------------------------------------------------------------
async_session: async_sessionmaker[AsyncSession] = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,  # keep attributes accessible after commit
)


# ---------------------------------------------------------------------------
# Declarative base — shared by all ORM models in this service
# ---------------------------------------------------------------------------
class Base(DeclarativeBase):
    pass


# ---------------------------------------------------------------------------
# FastAPI dependency
# ---------------------------------------------------------------------------
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """Yield an async DB session; commit on success, rollback on error."""
    async with async_session() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
