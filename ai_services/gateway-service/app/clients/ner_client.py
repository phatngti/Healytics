# ai_services/gateway-service/app/clients/ner_client.py

from typing import Dict, Any

from app.clients.base_client import BaseClient
from app.core.config import settings


class NERClient(BaseClient):
    """
    Gọi ner-service.
    """

    def __init__(self):
        super().__init__(settings.NER_SERVICE_URL)

    async def extract_entities(
        self,
        payload: Dict[str, Any],
    ) -> Dict[str, Any]:

        async with self._client() as client:
            response = await client.post(
                "/ner/extract",
                json=payload,
            )

            response.raise_for_status()
            return response.json()