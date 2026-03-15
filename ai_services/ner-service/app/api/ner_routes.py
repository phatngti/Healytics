"""
ai_services/ner-service/app/api/ner_routes.py

Endpoints:
  POST /ner/extract          — trích xuất + normalize entities từ text
  POST /internal/clear-cache — force refresh location + category caches
"""

import logging

from fastapi import APIRouter

from app.ner import cache, extractor, normalizer
from app.schemas.ner_schema import NerRequest, NerResponse

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/ner/extract", response_model=NerResponse)
async def extract_entities(request: NerRequest):
    """
    Pipeline:
      1. extractor.extract_entities(text) → raw entities (underthesea + regex + keyword scan)
      2. normalizer.normalize_entities(raw) → normalized NerEntity list
      3. Return NerResponse

    Note: spatial context resolution happens downstream in /prefilter/search.
    """
    logger.info(f"[NER] Processing: {request.text[:100]}...")

    raw_entities = extractor.extract_entities(request.text)
    entities = normalizer.normalize_entities(raw_entities)

    logger.info(f"[NER] Found {len(entities)} entities")
    return NerResponse(entities=entities)


@router.post("/internal/clear-cache")
async def clear_cache():
    """
    Force refresh all caches.
    Gọi endpoint này khi admin thêm category mới hoặc location data thay đổi.
    """
    logger.info("[NER] Force clearing all caches...")

    # Clear query cache
    extractor.clear_query_cache()

    # Reload location + category caches
    result = await cache.force_refresh()

    return {
        "status": "ok",
        "message": "All caches cleared and reloaded",
        "details": result,
    }
