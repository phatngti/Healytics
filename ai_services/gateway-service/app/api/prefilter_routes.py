# ai_services/gateway-service/app/api/prefilter_routes.py
"""
Pre-Filter API endpoints.

POST /prefilter/search — gửi text → NER → query → filtered services.
"""

import logging

from fastapi import APIRouter

from app.orchestrators.prefilter_orchestrator import PreFilterOrchestrator
from app.schemas.ner_schema import PreFilterRequest, PreFilterResponse

logger = logging.getLogger(__name__)

router = APIRouter()

_orchestrator = PreFilterOrchestrator()


@router.post("/prefilter/search", response_model=PreFilterResponse)
async def prefilter_search(request: PreFilterRequest):
    """
    Gửi text tiếng Việt → trích xuất NER → build query → trả về services phù hợp.

    Input:  {"text": "Tìm spa ở Hà Nội giá dưới 500k", "limit": 50}
    Output: {text, entities, query_params, candidates, total}
    """
    result = await _orchestrator.search(
        text=request.text,
        limit=request.limit,
    )
    return result
