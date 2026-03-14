# ai_services/gateway-service/app/orchestrators/prefilter_orchestrator.py
"""
Pre-Filter Orchestrator

Pipeline: text → NER extract → query build → filter services → return candidates.
Không cần conversation_id — dùng UUID tạm cho NER call.
"""

import logging
from uuid import uuid4
from typing import Any, Dict

from app.clients.ner_client import NERClient
from app.utils.query_builder import build_backend_query, filter_mock_services

logger = logging.getLogger(__name__)


class PreFilterOrchestrator:

    def __init__(self):
        self.ner_client = NERClient()

        # Import mock data — sau thay bằng backend API call
        from app.orchestrators.recommendation_orchestrator import MOCK_SERVICES
        self.mock_services = MOCK_SERVICES

    async def search(self, text: str, limit: int = 50) -> Dict[str, Any]:
        """
        Full pipeline:
          1. Gọi NER Service → extract entities
          2. Build query params từ entities
          3. Filter mock services theo query
          4. Return kết quả
        """
        # 1. NER Extract
        ner_payload = {
            "conversation_id": str(uuid4()),
            "text": text,
        }

        try:
            ner_result = await self.ner_client.extract_entities(ner_payload)
            entities = ner_result.get("entities", [])
        except Exception as e:
            logger.warning(f"[PreFilter] NER call failed: {e}")
            entities = []

        # 2. Build query
        query_params = build_backend_query(entities, limit=limit)

        # 3. Filter services
        # TODO: Khi backend có search API, thay filter_mock_services bằng:
        #   candidates = await self.backend_client.search_services(query_params)
        candidates = filter_mock_services(query_params, self.mock_services)

        logger.info(
            f"[PreFilter] text={text[:60]}... | "
            f"entities={len(entities)} | candidates={len(candidates)}"
        )

        return {
            "text": text,
            "entities": entities,
            "query_params": query_params,
            "candidates": candidates,
            "total": len(candidates),
        }
