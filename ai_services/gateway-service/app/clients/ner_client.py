# ai_services/gateway-service/app/clients/recommender_client.py

from typing import Dict, Any

from app.clients.base_client import BaseClient
from app.core.config import settings


class NERClient(BaseClient):
    """
    Gọi NER-service
    """

    def __init__(self):
        super().__init__(settings.NER_SERVICE_URL)

    async def get_service_ids(
        self,
        payload: Dict[str, Any],
    ) -> list:

        async with self._client() as client:
            response = await client.post(
                "/prefilter/search",
                json=payload,
            )

            response.raise_for_status()
            return response.json()

