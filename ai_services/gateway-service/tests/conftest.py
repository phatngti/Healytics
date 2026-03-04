"""
tests/conftest.py

pytest fixtures that create an isolated async test database session.

How it works:
    1. A single async engine is created for the test run pointing at
       the test DATABASE_URL (or a temporary async SQLite file).
    2. Each test gets its own session wrapped in a SAVEPOINT.
       When the test finishes the savepoint is rolled back, leaving
       the DB clean for the next test — no manual teardown needed.

Requires:
    pip install pytest pytest-asyncio sqlalchemy[asyncio] aiosqlite

Run all repo tests:
    pytest tests/test_repositories.py -v

Run a single test:
    pytest tests/test_repositories.py::test_get_messages_page -v
"""

# ---------------------------------------------------------------------------
# IMPORTANT: set DATABASE_URL *before* any app imports.
# app/core/config.py calls Settings() at module level, which reads this var.
# Without it, Pydantic raises a ValidationError even for SQLite tests.
# ---------------------------------------------------------------------------
import os
import uuid
os.environ.setdefault(
    "DATABASE_URL",
    "sqlite+aiosqlite:///./test_gateway.db",  # overridden below anyway
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

from app.core.database import Base

# ---------------------------------------------------------------------------
# Test DB URL — swap for a real Postgres URL if you prefer:
#   "postgresql+asyncpg://user:pass@localhost/test_db"
# ---------------------------------------------------------------------------
TEST_DATABASE_URL = "sqlite+aiosqlite:///./test_gateway.db"

# ---------------------------------------------------------------------------
# Engine — created once per test session
# ---------------------------------------------------------------------------
test_engine = create_async_engine(
    TEST_DATABASE_URL,
    echo=False,
    connect_args={"check_same_thread": False},  # SQLite only
)

# Force SQLite to enforce foreign key constraints (including ON DELETE CASCADE).
# Without this, FK rules are silently ignored by SQLite.
@event.listens_for(test_engine.sync_engine, "connect")
def set_sqlite_pragma(dbapi_connection, connection_record):
    # Enforce FK constraints (incl. ON DELETE CASCADE)
    cursor = dbapi_connection.cursor()
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.close()

    # Polyfill uuid_generate_v4() so SQLite handles ORM server_defaults
    # that reference this Postgres function.
    dbapi_connection.create_function(
        "uuid_generate_v4", 0, lambda: str(uuid.uuid4())
    )

TestSessionFactory = async_sessionmaker(
    test_engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


# ---------------------------------------------------------------------------
# Session-scoped fixture: create all tables once, drop after test run
# ---------------------------------------------------------------------------
@pytest_asyncio.fixture(scope="session", autouse=True)
async def create_tables():
    """Create all ORM tables before the test session, drop them after."""
    async with test_engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    async with test_engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


# ---------------------------------------------------------------------------
# Function-scoped fixture: each test gets a rolled-back session
# ---------------------------------------------------------------------------
@pytest_asyncio.fixture
async def db_session(create_tables) -> AsyncGenerator[AsyncSession, None]:
    """
    Yield an async session inside a SAVEPOINT.

    After each test the savepoint is rolled back, so the DB is
    always empty at the start of the next test — no manual cleanup.

    Usage in tests::

        async def test_something(db_session: AsyncSession):
            await create_conversation(db_session, ...)
    """
    async with TestSessionFactory() as session:
        # Open a savepoint — the test works inside this nested tx
        async with session.begin_nested() as savepoint:
            yield session
            # Roll back everything the test wrote
            await savepoint.rollback()

