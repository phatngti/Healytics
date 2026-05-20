from fastapi import APIRouter
import json
import logging
from typing import List
from datetime import datetime, timezone
from pathlib import Path

from app.core.config import settings
from app.schemas.ner_schema import PreFilterRequest, NerEntity, NerResponse, PreFilterResponse
from app.ner import extractor, normalizer
from app.ner.gemini_ner import select_requested_location_with_gemini
from app.ner.semantic_matcher import get_matcher
from app.ner.spatial_context import resolve_spatial_context
from app.utils import db_fetcher
from app.utils.query_builder import build_backend_query

logger = logging.getLogger(__name__)

router = APIRouter()


def _extract_candidate_ids(candidates: list) -> list[str]:
    return [
        service_id
        for service_id in (
            c.get("service_id") if isinstance(c, dict) else getattr(c, "service_id", None)
            for c in candidates
        )
        if service_id
    ]


async def _keep_only_requested_locations(text: str, entities: list[NerEntity]) -> None:
    """
    Use Gemini to keep only location(s) truly requested by user and drop incidental mentions.
    """
    location_entities = [e for e in entities if e.type == "LOCATION" and e.location_code]
    if not location_entities:
        return

    by_code: dict[str, dict] = {}
    for e in location_entities:
        code = str(e.location_code)
        current = by_code.get(code)
        if current is None or float(e.confidence) > float(current["confidence"]):
            by_code[code] = {
                "location_code": code,
                "value": e.value,
                "location_level": e.location_level,
                "confidence": e.confidence,
            }

    selection = await select_requested_location_with_gemini(text, list(by_code.values()))
    if not selection:
        return

    selected_code = selection.get("selected_location_code")
    apply_filter = bool(selection.get("apply_filter"))

    if not selected_code or not apply_filter:
        entities[:] = [
            e for e in entities
            if not (e.type == "LOCATION" and e.location_code)
        ]
        logger.info(
            "[PreFilter] Gemini location select: no filter applied, removed all mapped LOCATION entities"
        )
        return

    selected_code = str(selected_code)
    entities[:] = [
        e for e in entities
        if not (e.type == "LOCATION" and e.location_code and str(e.location_code) != selected_code)
    ]

    for e in entities:
        if e.type == "LOCATION" and e.location_code and str(e.location_code) == selected_code:
            e.location_intent = True

    logger.info(
        "[PreFilter] Gemini location select: selected=%s excluded=%s confidence=%s",
        selected_code,
        selection.get("excluded_location_codes", []),
        selection.get("confidence"),
    )


def _log_location_intent_samples(text: str, entities: list[NerEntity], query_params: dict) -> None:
    if not settings.LOCATION_INTENT_LOG_ENABLED:
        return

    location_entities = [e for e in entities if e.type == "LOCATION" and e.location_code]
    if not location_entities:
        return

    applied_code = query_params.get("locationCode")

    log_path = Path(settings.LOCATION_INTENT_LOG_PATH)
    if not log_path.is_absolute():
        log_path = Path.cwd() / log_path

    try:
        log_path.parent.mkdir(parents=True, exist_ok=True)

        with log_path.open("a", encoding="utf-8") as f:
            for e in location_entities:
                record = {
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                    "text": text,
                    "location_value": e.value,
                    "location_code": e.location_code,
                    "location_level": e.location_level,
                    "intent_decision": e.location_intent,
                    "applied_filter": bool(applied_code and applied_code == e.location_code),
                    "label": None,
                }
                f.write(json.dumps(record, ensure_ascii=False) + "\n")
    except Exception as exc:
        logger.warning("[IntentLogging] Failed to write location-intent sample: %s", exc)


async def _run_prefilter_pipeline(
    request: PreFilterRequest,
    entities: list[NerEntity],
) -> tuple[dict, list, list[str], bool]:
    text = request.text
    limit = request.limit

    await _keep_only_requested_locations(text, entities)

    # 3. Resolve spatial context
    spatial_context = None
    if any(e.type == "DISTANCE" for e in entities):
        spatial_context = resolve_spatial_context(
            entities=entities,
            current_lat=request.current_lat,
            current_lng=request.current_lng,
            user_registered_address=request.user_registered_address,
        )
        if spatial_context:
            logger.info(
                f"[PreFilter] Spatial context resolved: "
                f"({spatial_context.center_lat}, {spatial_context.center_lng}), "
                f"radius={spatial_context.radius_meters}m, "
                f"fallback_used={spatial_context.fallback_used}"
            )

    # 4. Build query params
    query_params = build_backend_query(entities, limit=limit, spatial_context=spatial_context)

    # 5. Fetch services
    use_postgis = bool(spatial_context)

    _log_location_intent_samples(text, entities, query_params)

    candidates = await db_fetcher.fetch_candidates_from_db(query_params, use_postgis=use_postgis)

    candidate_ids = _extract_candidate_ids(candidates)

    logger.info(
        f"[PreFilter] entities={len(entities)} | candidates={len(candidates)} | spatial={use_postgis}"
    )

    return query_params, candidates, candidate_ids, use_postgis

@router.post("/prefilter/search", response_model=List[str])
async def prefilter_search(request: PreFilterRequest):
    """
    Full pipeline natively within NER service:
      1. Extract raw entities
      2. Normalize entities (Entity Linking)
      3. Resolve spatial context if DISTANCE entity found
            4. Build query params từ entities + spatial context
      5. Filter services từ DB (with PostGIS if spatial)
      6. Return kết quả
    """
    text = request.text

    logger.info(f"[PreFilter] Processing: {text[:60]}...")

    # 1. & 2.
    raw_entities, _ = await extractor.extract_entities_with_source(text)
    entities = normalizer.normalize_entities(raw_entities)

    _, _, candidate_ids, _ = await _run_prefilter_pipeline(request, entities)

    return candidate_ids


@router.post("/prefilter/search/debug", response_model=PreFilterResponse)
async def prefilter_search_debug(request: PreFilterRequest):
    """
    Debug route for search pipeline.
    Returns full PreFilterResponse using the existing NER response structure.
    """
    text = request.text
    logger.info(f"[PreFilterDebug] Processing: {text[:60]}...")

    raw_entities, extraction_source = await extractor.extract_entities_with_source(text)
    ner_response = NerResponse(
        entities=normalizer.normalize_entities(raw_entities),
        extraction_source=extraction_source,
    )

    query_params, candidates, _, _ = await _run_prefilter_pipeline(request, ner_response.entities)

    return PreFilterResponse(
        text=text,
        entities=ner_response.entities,
        query_params=query_params,
        candidates=candidates,
        total=len(candidates),
    )
