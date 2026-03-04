"""
tests/conftest.py

Isolated async test database fixtures for recommender2.

How it works:
    1. A single SQLite engine is created for the test session.
    2. Each test gets its own session inside a SAVEPOINT.
       Roll back the savepoint at the end → DB is clean for next test.

Run tests:
    python -m pytest tests/test_user_repositories.py -v
"""

# ---------------------------------------------------------------------------
# Set DATABASE_URL before any app imports — config.settings reads it at
# module load time via Pydantic Settings.
# ---------------------------------------------------------------------------
import os
import uuid
os.environ.setdefault(
    "DATABASE_URL",
    "sqlite+aiosqlite:///./test_recommender.db",
)

from collections.abc import AsyncGenerator

import pytest
import pytest_asyncio
from sqlalchemy import event
from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)

from config.database import Base

TEST_DATABASE_URL = "sqlite+aiosqlite:///./test_recommender.db"

test_engine = create_async_engine(
    TEST_DATABASE_URL,
    echo=False,
    connect_args={"check_same_thread": False},
)


@event.listens_for(test_engine.sync_engine, "connect")
def set_sqlite_pragma(dbapi_connection, connection_record):
    # Enforce FK constraints (including ON DELETE CASCADE)
    cursor = dbapi_connection.cursor()
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.close()

    # Polyfill uuid_generate_v4() used in ORM server_defaults
    dbapi_connection.create_function(
        "uuid_generate_v4", 0, lambda: str(uuid.uuid4())
    )


TestSessionFactory = async_sessionmaker(
    test_engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


@pytest_asyncio.fixture(scope="session", autouse=True)
async def create_tables():
    """Create all tables once before the session, drop after."""
    async with test_engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    async with test_engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


@pytest_asyncio.fixture
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    """Yield a session wrapped in a SAVEPOINT; roll back after each test."""
    async with TestSessionFactory() as session:
        async with session.begin_nested() as savepoint:
            yield session
            await savepoint.rollback()
