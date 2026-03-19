from fastapi import APIRouter
import json
import logging
from datetime import datetime, timezone
from pathlib import Path

from app.core.config import settings
from app.schemas.ner_schema import PreFilterRequest, PreFilterResponse, NerEntity
from app.ner import extractor, normalizer
from app.ner.cache import get_feature_tags, get_category_list
from app.ner.semantic_matcher import get_matcher, group_tag_filters, SemanticAdjudicator
from app.ner.spatial_context import resolve_spatial_context
from app.utils import db_fetcher
from app.utils.query_builder import build_backend_query

logger = logging.getLogger(__name__)

router = APIRouter()


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
                    "intent_score": e.location_intent_score,
                    "intent_decision": e.location_intent,
                    "applied_filter": bool(applied_code and applied_code == e.location_code),
                    "label": None,
                }
                f.write(json.dumps(record, ensure_ascii=False) + "\n")
    except Exception as exc:
        logger.warning("[IntentLogging] Failed to write location-intent sample: %s", exc)

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

    matcher = get_matcher()
    adjudicator = SemanticAdjudicator()
    semantic_ctx = matcher.extract_semantic_context(text)

    # 4a. Unified semantic adjudication — BUSINESS_TYPE
    bt_candidates = list({e.business_type for e in entities if e.type == "BUSINESS_TYPE" and e.business_type})
    if not bt_candidates:
        bt_candidates = matcher.bt_keys
    bt_decision = adjudicator.adjudicate_business_type(text, matcher, bt_candidates, semantic_ctx=semantic_ctx)
    if bt_decision and bt_decision.policy in ("hard", "soft"):
        query_params["businessType"] = bt_decision.value
        entities.append(NerEntity(
            type="BUSINESS_TYPE",
            value=bt_decision.value,
            confidence=bt_decision.score,
            business_type=bt_decision.value,
        ))
        logger.info(
            f"[PreFilter] BT decision={bt_decision.policy} value={bt_decision.value} "
            f"score={bt_decision.score}"
        )

    # 4b. Unified semantic adjudication — FEATURE_TAG
    feature_tags = get_feature_tags()
    if feature_tags:
        tag_matches = matcher.match_feature_tags(
            text,
            feature_tags,
            threshold=settings.SEMANTIC_TAG_MEDIUM_THRESHOLD,
            top_k=5,
            query_emb=semantic_ctx.get("query_emb"),
        )
        if tag_matches:
            tag_decisions = adjudicator.adjudicate_tags(tag_matches)
            hard_only = [d for d in tag_decisions if d.policy == "hard"]
            selected_matches = [d.payload for d in hard_only if d.payload]

            tag_filters = group_tag_filters(text, selected_matches)
            if tag_filters:
                query_params["tagFilters"] = tag_filters

                # tag_id → op map để gán tag_op vào entity
                tag_id_to_op = {
                    tid: group["op"]
                    for group in tag_filters
                    for tid in group["ids"]
                }

                for m in selected_matches:
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
                    f"(from {[m['tag_name'] for m in selected_matches]})"
                )

            soft_tag_names = [d.payload["tag_name"] for d in tag_decisions if d.policy == "soft" and d.payload]
            if soft_tag_names:
                logger.info("[PreFilter] Soft tag signals only (not hard filters): %s", soft_tag_names)

            # Keep soft signals for future reranking layer.
            soft_signals = [
                {
                    "slot": d.slot,
                    "value": d.value,
                    "score": d.score,
                    "uncertainty": d.uncertainty,
                    "rationale": d.rationale,
                }
                for d in tag_decisions if d.policy == "soft"
            ]
            if soft_signals:
                query_params.setdefault("semanticSoftSignals", []).extend(soft_signals)

    # 4c. Unified semantic adjudication — CATEGORY
    if not query_params.get("categorySlug"):
        categories = get_category_list()
        if categories:
            cat_decision = adjudicator.adjudicate_category(text, matcher, categories, semantic_ctx=semantic_ctx)
            if cat_decision and cat_decision.policy in ("hard", "soft"):
                cat_payload = cat_decision.payload or {}
                query_params["categorySlug"] = cat_decision.value
                entities.append(NerEntity(
                    type="CATEGORY",
                    value=cat_payload.get("name", cat_decision.value),
                    confidence=cat_decision.score,
                    category_slug=cat_decision.value,
                ))
                logger.info(
                    f"[PreFilter] Category decision={cat_decision.policy}: "
                    f"{cat_decision.value} (score={cat_decision.score})"
                )

    # 5. Fetch services
    use_postgis = bool(spatial_context)

    _log_location_intent_samples(text, entities, query_params)

    candidates = await db_fetcher.fetch_candidates_from_db(query_params, use_postgis=use_postgis)

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
