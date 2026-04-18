from typing import Any, Dict, List
import json
import logging

from app.clients.base_client import BaseClient
from app.core.config import settings


logger = logging.getLogger(__name__)


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

        # Log response shape (1 sample only) to diagnose contract mismatches.
        try:
            if isinstance(payload, list):
                sample = payload[0] if payload else None
                logger.info(
                    "[BackendAIClient] response_shape status=%s payload_type=list item0_type=%s item0_sample=%s",
                    response.status_code,
                    type(sample).__name__ if sample is not None else None,
                    (str(sample)[:300] if sample is not None else None),
                )
            else:
                logger.info(
                    "[BackendAIClient] response_shape status=%s payload_type=%s keys=%s sample=%s",
                    response.status_code,
                    type(payload).__name__,
                    sorted(list(payload.keys()))[:20] if isinstance(payload, dict) else None,
                    (str(payload)[:300] if payload is not None else None),
                )
        except Exception:
            # Never break the pipeline due to logging.
            pass

        # Be defensive about response shape:
        # - could be {"services":[...]} or direct list, depending on backend.
        raw_list: list[Any] = []
        if isinstance(payload, list):
            raw_list = payload
        elif isinstance(payload, dict):
            for k in ("services", "data", "recommendations"):
                v = payload.get(k)
                if isinstance(v, list):
                    raw_list = v
                    break
            # Nested shapes: {"data": {"services": [...]}}
            if not raw_list:
                data = payload.get("data")
                if isinstance(data, dict):
                    for k in ("services", "recommendations", "items"):
                        v = data.get(k)
                        if isinstance(v, list):
                            raw_list = v
                            break

        if not raw_list:
            return []

        # Normalize list items into dicts so downstream formatter never crashes.
        normalized: list[Dict[str, Any]] = []
        for item in raw_list:
            if isinstance(item, dict):
                normalized.append(item)
                continue
            if isinstance(item, str):
                s = item.strip()
                # Case: backend returns JSON strings
                if (s.startswith("{") and s.endswith("}")) or (s.startswith("[") and s.endswith("]")):
                    try:
                        parsed = json.loads(s)
                        if isinstance(parsed, dict):
                            normalized.append(parsed)
                            continue
                    except Exception:
                        pass
                # Case: backend returns bare service_id strings
                normalized.append({"service_id": s, "name": "", "description": ""})
                continue

            # Unknown shape: coerce to string representation.
            try:
                normalized.append({"service_id": str(item), "name": "", "description": ""})
            except Exception:
                continue

        return normalized

