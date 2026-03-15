from fastapi import APIRouter
import logging
from app.schemas.ner_schema import PreFilterRequest, PreFilterResponse
from app.ner import extractor, normalizer
from app.ner.spatial_context import resolve_spatial_context
from app.utils.query_builder import build_backend_query

logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/prefilter/search", response_model=PreFilterResponse)
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
    limit = request.limit

    logger.info(f"[PreFilter] Processing: {text[:60]}...")

    # 1. & 2. Tự gọi nội bộ NER (không tốn HTTP hop nào cả)
    raw_entities = extractor.extract_entities(text)
    entities = normalizer.normalize_entities(raw_entities)

    # 3. Resolve spatial context if DISTANCE entity found
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

    # 4. Build query with spatial context
    query_params = build_backend_query(entities, limit=limit, spatial_context=spatial_context)

    # 5. Fetch services from DB (with PostGIS if spatial context available)
    from app.utils.db_fetcher import fetch_candidates_from_db
    use_postgis = bool(spatial_context)
    candidates = await fetch_candidates_from_db(query_params, use_postgis=use_postgis)

    logger.info(
        f"[PreFilter] entities={len(entities)} | candidates={len(candidates)} | spatial={use_postgis}"
    )

    return PreFilterResponse(
        text=text,
        entities=entities,
        query_params=query_params,
        candidates=candidates,
        total=len(candidates),
    )
