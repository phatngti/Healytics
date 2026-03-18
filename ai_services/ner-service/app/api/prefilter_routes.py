from fastapi import APIRouter
import logging
from app.schemas.ner_schema import PreFilterRequest, PreFilterResponse, NerEntity
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
      4b. Semantic feature tag matching → tagFilters (AND/OR) + FEATURE_TAG entities
      4c. Semantic category matching (fallback) → categorySlug + CATEGORY entity
      5. Filter services từ DB (with PostGIS if spatial)
      6. Return kết quả
    """
    text = request.text
    limit = request.limit

    logger.info(f"[PreFilter] Processing: {text[:60]}...")

    # 1. & 2.
    raw_entities = extractor.extract_entities(text)
    entities = normalizer.normalize_entities(raw_entities)

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

    from app.ner.cache import get_feature_tags, get_category_list
    from app.ner.semantic_matcher import get_matcher, group_tag_filters

    matcher = get_matcher()

    # 4b. Feature tag matching → tagFilters + FEATURE_TAG entities
    feature_tags = get_feature_tags()
    if feature_tags:
        tag_matches = matcher.match_feature_tags(text, feature_tags, threshold=0.50, top_k=5)
        if tag_matches:
            tag_filters = group_tag_filters(text, tag_matches)
            if tag_filters:
                query_params["tagFilters"] = tag_filters

                # tag_id → op map để gán tag_op vào entity
                tag_id_to_op = {
                    tid: group["op"]
                    for group in tag_filters
                    for tid in group["ids"]
                }

                for m in tag_matches:
                    entities.append(NerEntity(
                        type="FEATURE_TAG",
                        value=m["tag_name"],
                        confidence=m["score"],
                        tag_id=m["tag_id"],
                        tag_name=m["tag_name"],
                        tag_op=tag_id_to_op.get(m["tag_id"], "OR"),
                    ))

                logger.info(
                    f"[PreFilter] tagFilters={tag_filters} "
                    f"(from {[m['tag_name'] for m in tag_matches]})"
                )

    # 4c. Semantic category matching — fallback nếu NER chưa phát hiện được category
    # Dùng hard AND (categorySlug) — category PHẢI match, tags là OR riêng bên trong.
    # Logic: WHERE businessType=X AND c.slug=Y AND (tag_A OR tag_B)
    if not query_params.get("categorySlug"):
        categories = get_category_list()
        if categories:
            cat_match = matcher.match_category(text, categories, threshold=0.45)
            if cat_match:
                query_params["categorySlug"] = cat_match["slug"]
                entities.append(NerEntity(
                    type="CATEGORY",
                    value=cat_match["name"],
                    confidence=cat_match["score"],
                    category_slug=cat_match["slug"],
                ))
                logger.info(
                    f"[PreFilter] Semantic category (AND): '{text[:40]}' → "
                    f"{cat_match['slug']} (score={cat_match['score']})"
                )

    # 5. Fetch services
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
