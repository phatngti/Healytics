"""
ai_services/ner-service/app/api/ner_routes.py

Endpoints:
  POST /ner/extract          — trích xuất + normalize entities từ text
  POST /internal/clear-cache — force refresh location cache
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
      1. await extractor.extract_entities_with_source(text) → raw entities (Gemini-first, fallback local extractor)
      2. normalizer.normalize_entities(raw) → normalized NerEntity list
      3. Return NerResponse

    Note: spatial context resolution happens downstream in /prefilter/search.
    """
    logger.info(f"[NER] Processing: {request.text[:100]}...")

    raw_entities, extraction_source = await extractor.extract_entities_with_source(request.text)
    entities = normalizer.normalize_entities(raw_entities)

    logger.info(f"[NER] Found {len(entities)} entities | source={extraction_source}")
    return NerResponse(entities=entities, extraction_source=extraction_source)


@router.post("/internal/clear-cache")
async def clear_cache():
    """
    Force refresh location cache.
    Gọi endpoint này khi location data thay đổi.
    """
    logger.info("[NER] Force refreshing location cache...")

    # Clear query cache
    extractor.clear_query_cache()

    # Reload location cache
    result = await cache.force_refresh()

    return {
        "status": "ok",
        "message": "Location cache refreshed",
        "details": result,
    }
