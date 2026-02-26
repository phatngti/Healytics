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

    def __init__(self, event: str, data: Any):
        """
        Args:
            event: tên event (token, ner_location, done, error...)
            data: payload JSON serializable
        """
        self.event = event
        self.data = data

    def to_dict(self) -> dict:
        """
        Convert event thành dict chuẩn nội bộ.
        """
        pass

class SSEFormatter:
    """
    Chịu trách nhiệm encode SSE protocol.

    Convert:
        SSEEvent -> text/event-stream string

    SSE format chuẩn:
        event: <event_name>
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
        pass


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
    pass


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
    pass


def token_event(data: Any) -> SSEEvent:
    """
    Helper tạo token event.

    Giúp orchestrator không phải hardcode string 'token'.
    """
    pass


def ner_event(data: Any) -> SSEEvent:
    """
    Helper tạo NER event.
    """
    pass


def recommendation_event(data: Any) -> SSEEvent:
    """
    Helper tạo recommendation event.
    """
    pass


def done_event(data: Any) -> SSEEvent:
    """
    Helper tạo done event.
    """
    pass


def error_event(data: Any) -> SSEEvent:
    """
    Helper tạo error event.
    """
    pass