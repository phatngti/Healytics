"""
seed.py

Populates the local development database with realistic dummy data
so you can test pagination, SSE streaming, and the Swagger UI
without starting from a blank slate.

Usage:
    python seed.py

Run from the gateway-service root directory. Requires the service's
.env (or env vars) to be present so the DATABASE_URL is available.
The script is idempotent for the seeded user — re-running it adds a
fresh conversation and messages without wiping existing data.
"""

import asyncio
import uuid

from app.core.database import async_session
from app.repositories import conversation_repo, message_repo

# ---------------------------------------------------------------------------
# Config — tweak these to suit your local testing needs
# ---------------------------------------------------------------------------

SEED_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000001")

CONVERSATIONS = [
    {
        "title": "Pagination stress test",
        "messages": 55,       # enough to span multiple pages
    },
    {
        "title": "Short conversation",
        "messages": 4,
    },
    {
        "title": "Empty conversation",
        "messages": 0,
    },
]

# ---------------------------------------------------------------------------
# Seeder
# ---------------------------------------------------------------------------

async def seed_database() -> None:
    print("🌱  Seeding gateway-service database …")

    async with async_session() as session:
        for spec in CONVERSATIONS:
            conv_id = uuid.uuid4()
            await conversation_repo.create_conversation(
                session,
                conversation_id=conv_id,
                user_id=SEED_USER_ID,
                title=spec["title"],
            )

            for i in range(1, spec["messages"] + 1):
                role = "user" if i % 2 != 0 else "assistant"
                await message_repo.create_message(
                    session,
                    conversation_id=conv_id,
                    role=role,
                    content=f"[{spec['title']}] Message {i}",
                )

            print(
                f"  ✔  '{spec['title']}'"
                f" — {spec['messages']} messages"
                f" (conv_id={conv_id})"
            )

        await session.commit()

    print(
        f"\n✅  Done. user_id for manual testing: {SEED_USER_ID!s}\n"
        f"    Hit http://localhost:8000/docs to explore the API."
    )


if __name__ == "__main__":
    asyncio.run(seed_database())
