# app/clients/chatbot_client.py

from typing import AsyncGenerator, Dict, Any
import httpx

from app.clients.base_client import BaseClient
from app.core.config import settings


class ChatbotClient(BaseClient):
    """
    Gọi chatbot-service (LLM streaming).
    """

    def __init__(self):
        super().__init__(settings.CHATBOT_SERVICE_URL)

    async def stream_chat(self, payload: Dict[str, Any],) -> AsyncGenerator[str, None]:
        """
        Stream raw token từ chatbot-service.

        Yield:
            từng chunk text từ downstream service
        """

        # async with = dùng xong tự đóng
        async with self._client() as client:
            async with client.stream("POST", "/chat/stream", json=payload,) as response:

                # nếu status != 200 thì crash ngay
                response.raise_for_status()

                async for chunk in response.aiter_text():
                    if chunk:
                        yield chunk # Gửi lên oschestrator