from typing import Any, Dict, List

from app.clients.base_client import BaseClient
from app.core.config import settings


class BackendAIClient(BaseClient):
    """
    Call Healytics backend API for full service information.

    Endpoint (provided):
      POST /backend/ai/recommendations
      Headers:
        - accept: application/json
        - X-AI-API-Key: <token>
      Body:
        {"serviceIds": ["SV002", "SV005", ...]}
    """

    def __init__(self):
        super().__init__(settings.BACKEND_BASE_URL)

    async def get_service_details(self, service_ids: List[str]) -> List[Dict[str, Any]]:
        if not service_ids:
            return []

        headers = {
            "accept": "application/json",
            settings.AI_API_KEY_HEADER: settings.AI_API_KEY,
            "Content-Type": "application/json",
        }

        async with self._client() as client:
            response = await client.post(
                "/backend/ai/recommendations",
                json={"serviceIds": service_ids},
                headers=headers,
            )
            response.raise_for_status()
            payload = response.json()

        # Be defensive about response shape:
        # - could be {"services":[...]} or direct list, depending on backend.
        if isinstance(payload, list):
            return payload
        if isinstance(payload, dict):
            for k in ("services", "data", "recommendations"):
                v = payload.get(k)
                if isinstance(v, list):
                    return v
        return []

