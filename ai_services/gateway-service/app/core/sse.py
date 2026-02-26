# app/core/sse.py
"""
SSE (Server-Sent Events) Infrastructure Layer

Responsibility separation:

1. SSEEvent
   → Data object (event representation)
   → KHÔNG phụ thuộc FastAPI / HTTP

2. SSEFormatter
   → Convert SSEEvent -> text/event-stream format

3. sse_stream()
   → Adapter giữa async generator và FastAPI StreamingResponse

Architecture Flow:

Orchestrator
    ↓ yield SSEEvent
SSE Formatter
    ↓ format
StreamingResponse
    ↓
Browser EventSource

"""

from typing import Any, AsyncGenerator
from fastapi.responses import StreamingResponse
import json 
from app.core.enums import SSEEventType

class SSEEvent:
    """
    Pure data object đại diện cho 1 SSE event.

    Không biết:
        - FastAPI
        - HTTP
        - StreamingResponse

    Chỉ giữ:
        - event name
        - payload data
    """

    def __init__(self, event: SSEEventType, data: Any):
        """
        Args:
            event: tên event (token, ner_location, done, error...)
            data: payload JSON serializable
        """
        self.event_type = event
        self.data = data

class SSEFormatter:
    """
    Chịu trách nhiệm encode SSE protocol.

    Convert:
        SSEEvent -> text/event-stream string

    SSE format chuẩn:
        event: <event_type>
        data: <json_string>

        (blank line)
    """

    @staticmethod
    def format(event: SSEEvent) -> str:
        """
        Format SSEEvent thành string đúng chuẩn SSE.

        Returns:
            str: formatted SSE message
        """
        string_format = json.dumps(event.data, ensure_ascii=False)
        return (
            f"event: {event.event_type.value}\n"
            f"data: {string_format}\n\n"
        )


async def sse_event_generator(source: AsyncGenerator[SSEEvent, None]) -> AsyncGenerator[str, None]:
    """
    Adapter layer.

    Nhận async generator trả SSEEvent từ orchestrator,
    sau đó:

        1. format event bằng SSEFormatter
        2. yield string cho StreamingResponse

    Đây là bridge giữa:
        Business Layer  <->  HTTP Layer
    """
    async for event in source:
        yield SSEFormatter.format(event)


def sse_stream(source: AsyncGenerator[SSEEvent, None]) -> StreamingResponse:
    """
    Tạo StreamingResponse chuẩn SSE.

    Orchestrator KHÔNG gọi StreamingResponse trực tiếp.
    Route layer sẽ gọi function này.

    Args:
        source: async generator yield SSEEvent

    Returns:
        StreamingResponse (media_type='text/event-stream')
    """
    return StreamingResponse(
        sse_event_generator(source), 
        media_type="text/event-stream; charset=utf-8", 
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
        },
    )
    


