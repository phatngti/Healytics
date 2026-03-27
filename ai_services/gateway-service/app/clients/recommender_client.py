# ai_services/gateway-service/app/clients/recommender_client.py

from typing import Dict, Any

from app.clients.base_client import BaseClient
from app.core.config import settings


class RecommenderClient(BaseClient):
    """
    Gọi recommender-service.
    """

    def __init__(self):
        super().__init__(settings.RECOMMENDER_SERVICE_URL)

    async def recommend_home(
        self,
        payload: Dict[str, Any],
    ) -> Dict[str, Any]:

        async with self._client() as client:
            response = await client.post(
                "/recommender/home",
                json=payload,
            )

            response.raise_for_status()
            return response.json()

    async def recommend_chatbot(
        self,
        payload: Dict[str, Any],
    ) -> Dict[str, Any]:

        async with self._client() as client:
            response = await client.post(
                "/recommender/chatbot",
                json=payload,
            )

            response.raise_for_status()
            return response.json()