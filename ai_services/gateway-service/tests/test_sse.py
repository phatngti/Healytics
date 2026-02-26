# tests/test_sse.py
import asyncio
from fastapi import APIRouter
from app.core.sse import SSEEvent, sse_stream
from app.core.enums import SSEEventType

sse_router = APIRouter()


async def fake_orchestrator():
    for word in ["Xin", " chào", " bạn"]:
        yield SSEEvent(SSEEventType.TOKEN, {"text": word})
        await asyncio.sleep(1)

    yield SSEEvent(SSEEventType.DONE, {"status": "completed"})


@sse_router.get("/test-stream")
async def test_stream():
    return sse_stream(fake_orchestrator())