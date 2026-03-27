# ai_services/gateway-service/app/clients/chatbot_client.py

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

    # Ta cần cung cấp (history, current_user_message, recommendation)
    async def stream_chat(self, payload: Dict[str, Any],) -> AsyncGenerator[str, None]:
        """
        Stream raw token từ chatbot-service.

        Yield:
            từng chunk text từ downstream service
        """

        try:
            # async with = dùng xong tự đóng
            async with self._client() as client:
                async with client.stream("POST", "/chat/stream", json=payload) as response:
                    # nếu status != 200 thì crash ngay
                    response.raise_for_status()

                    async for chunk in response.aiter_text():
                        if chunk:
                            yield chunk  # Gửi lên orchestrator
        except httpx.TimeoutException as e:
            raise RuntimeError(
                f"Chatbot service timeout at {self.base_url}/chat/stream"
            ) from e
        except httpx.HTTPError as e:
            raise RuntimeError(
                f"Chatbot service HTTP error at {self.base_url}/chat/stream: {e!r}"
            ) from e