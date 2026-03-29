"""
ai_services/ner-service/app/ner/normalizer.py

Entity Linking: chuyển raw entities từ extractor → normalized NerEntity.

Strategy:
    - LOC → O(1) lookup trong location RAM cache (province + district/ward)
    - ORG/MISC/BUSINESS_TYPE → exact alias match + semantic business-type match
  - PRICE/RATING → đã parse sẵn operator+amount từ extractor
  - Không map được → normalized_id=None, log warning (không crash)
"""

import logging

from app.ner import cache
from app.ner.extractor import BUSINESS_TYPE_ALIASES
from app.ner.semantic_matcher import get_matcher
from app.schemas.ner_schema import NerEntity

logger = logging.getLogger(__name__)


# ============================================================================
# PUBLIC API
# ============================================================================

def normalize_entities(raw_entities: list[dict]) -> list[NerEntity]:
    """
    Chuyển raw entities từ extractor → normalized NerEntity.
    Mỗi entity được enrich với các trường normalized phù hợp.
    Entity không map được → trường tương ứng = None (graceful degradation).
    """
    results: list[NerEntity] = []

    for raw in raw_entities:
        entity_type = raw.get("type", "")
        value = raw.get("value", "")
        confidence = raw.get("confidence", 0.0)

        if entity_type == "LOC":
            entity = _normalize_location(value, confidence, raw)

        elif entity_type == "BUSINESS_TYPE":
            entity = _normalize_business_type(value, confidence, raw)

        elif entity_type in ("ORG", "MISC"):
            entity = _normalize_org_misc(value, confidence)

        elif entity_type == "PRICE":
            entity = _normalize_price(value, confidence, raw)

        elif entity_type == "RATING":
            entity = _normalize_rating(value, confidence, raw)

        elif entity_type == "DISTANCE":
            entity = _normalize_distance(value, confidence, raw)

        else:
            # PER hoặc tag không xác định → skip
            logger.debug(f"[Normalizer] Skipping entity type={entity_type!r}")
            continue

        results.append(entity)

    # Combine hierarchical locations (xã+huyện+tỉnh → chỉ giữ cụ thể nhất)
    results = _combine_location_entities(results)

    # Final canonical dedup after normalization.
    # Example: "massage" and "MASSAGE_THERAPY" can both normalize to the same business_type.
    results = _deduplicate_normalized_entities(results)

    return results


# ============================================================================
# PRIVATE — Location combine (xã → huyện → tỉnh)
# ============================================================================

_LEVEL_PRIORITY: dict[str, int] = {"WARD": 3, "DISTRICT": 2, "PROVINCE": 1}


def _combine_location_entities(entities: list[NerEntity]) -> list[NerEntity]:
    """
    Nếu nhiều LOCATION entity thuộc cùng cụm địa lý (xã+huyện+tỉnh),
    chỉ giữ level cụ thể nhất (WARD > DISTRICT > PROVINCE).

    Nếu có nhiều entity ở cùng level (2 quận khác nhau) → giữ nguyên hết.
    Nếu chỉ có 1 level → không combine (không đủ cơ sở foldable).
    """
    non_loc = [e for e in entities if e.type != "LOCATION"]
    loc_entities = [e for e in entities if e.type == "LOCATION"]

    if len(loc_entities) <= 1:
        return entities

    mapped = [e for e in loc_entities if e.location_code]
    unmapped = [e for e in loc_entities if not e.location_code]

    if len(mapped) <= 1:
        return entities

    # Nhóm theo level
    by_level: dict[str, list[NerEntity]] = {}
    for e in mapped:
        lv = e.location_level or "PROVINCE"
        by_level.setdefault(lv, []).append(e)

    # Chỉ 1 level → 2 địa điểm khác nhau, giữ tất cả
    if len(by_level) == 1:
        return entities

    # Nhiều level → cụm địa lý → giữ level chi tiết nhất
    best_level = max(by_level.keys(), key=lambda lv: _LEVEL_PRIORITY.get(lv, 0))
    kept = by_level[best_level]
    dropped = sum(len(v) for lv, v in by_level.items() if lv != best_level)
    logger.info(
        f"[Normalizer] Location combine: kept {len(kept)}×{best_level}, "
        f"dropped {dropped} coarser level(s)"
    )
    return non_loc + kept + unmapped


# ============================================================================
# PRIVATE — Location
# ============================================================================

def _normalize_location(value: str, confidence: float, _raw: dict) -> NerEntity:
    """Tra location cache O(1). Province hardcoded, district/ward từ backend."""
    loc_info = cache.find_location(value)

    if loc_info:
        return NerEntity(
            type="LOCATION",
            value=value,
            confidence=confidence,
            location_code=loc_info["code"],
            location_level=loc_info["level"],
        )

    # Không tìm thấy → graceful degradation
    logger.warning(f"[Normalizer] Unknown location: {value!r}")
    return NerEntity(
        type="LOCATION",
        value=value,
        confidence=max(confidence * 0.5, 0.1),   # Giảm confidence
    )


# ============================================================================
# PRIVATE — BusinessType (from keyword scan → đã có business_type sẵn)
# ============================================================================

def _normalize_business_type(
    value: str, confidence: float, raw: dict
) -> NerEntity:
    """Entity từ keyword scan đã có business_type sẵn, nhưng có thể tinh chỉnh bằng Semantic matching."""
    bt = raw.get("business_type")

    # Disambiguate common overlap: "massage trị liệu" should map to rehabilitation.
    evidence_text = " ".join(
        [
            str(value or ""),
            str(raw.get("business_evidence") or ""),
            str(raw.get("business_phrase") or ""),
        ]
    ).lower()
    rehab_cues = (
        "massage trị liệu",
        "trị liệu",
        "vật lý trị liệu",
        "phục hồi chức năng",
        "nắn xương",
        "bấm huyệt",
    )
    if any(cue in evidence_text for cue in rehab_cues):
        bt = "MASSAGE_REHABILITATION"
    
    # Nếu chưa có bt hoặc muốn kiểm chứng lại bằng model
    if not bt:
        matcher = get_matcher()
        bt = matcher.match_business_type(value)

    evidence = raw.get("business_evidence") or raw.get("business_phrase") or value

    return NerEntity(
        type="BUSINESS_TYPE",
        value=value,
        confidence=confidence,
        business_type=bt,
        business_evidence=evidence,
        business_phrase=evidence,
    )


# ============================================================================
# PRIVATE — ORG/MISC → thử BusinessType alias + semantic business type
# ============================================================================

def _normalize_org_misc(value: str, confidence: float) -> NerEntity:
    """
    ORG/MISC từ underthesea → thử:
    1. Exact match trong BUSINESS_TYPE_ALIASES
    2. Semantic match (model) trong business type
    3. Không map → trả về type CATEGORY với slug=None
    """
    value_lower = value.lower().strip()

    # 1. Exact match → BusinessType
    if value_lower in BUSINESS_TYPE_ALIASES:
        return NerEntity(
            type="BUSINESS_TYPE",
            value=value,
            confidence=confidence,
            business_type=BUSINESS_TYPE_ALIASES[value_lower],
            business_evidence=value,
            business_phrase=value,
        )

    # 2. Semantic match (Model-based) → BusinessType
    matcher = get_matcher()
    bt_match = matcher.match_business_type(value_lower)
    if bt_match:
        return NerEntity(
            type="BUSINESS_TYPE",
            value=value,
            confidence=confidence * 0.95,   # Model confidence cao
            business_type=bt_match,
            business_evidence=value,
            business_phrase=value,
        )

    # 3. Không map được
    logger.warning(f"[Normalizer] Cannot map ORG/MISC: {value!r}")
    return NerEntity(
        type="CATEGORY",
        value=value,
        confidence=max(confidence * 0.4, 0.1),
    )


# ============================================================================
# PRIVATE — Price
# ============================================================================

def _normalize_price(value: str, confidence: float, raw: dict) -> NerEntity:
    """PRICE đã được extractor Parse sẵn operator + amount."""
    return NerEntity(
        type="PRICE",
        value=value,
        confidence=confidence,
        operator=raw.get("operator"),
        amount=raw.get("amount"),
        amount_max=raw.get("amount_max"),
    )


# ============================================================================
# PRIVATE — Rating
# ============================================================================

def _normalize_rating(value: str, confidence: float, raw: dict) -> NerEntity:
    """RATING đã được extractor parse sẵn operator + score."""
    return NerEntity(
        type="RATING",
        value=value,
        confidence=confidence,
        operator=raw.get("operator"),
        amount=raw.get("amount"),
        amount_max=raw.get("amount_max"),
    )


# ============================================================================
# PRIVATE — Distance
# ============================================================================

def _normalize_distance(value: str, confidence: float, raw: dict) -> NerEntity:
    """Distance supports both legacy radius and range fields (operator/amount/amount_max)."""
    return NerEntity(
        type="DISTANCE",
        value=value,
        confidence=confidence,
        operator=raw.get("operator"),
        amount=raw.get("amount"),
        amount_max=raw.get("amount_max"),
        radius_meters=raw.get("radius_meters"),
        distance_unit=raw.get("distance_unit"),
        proximity_intent=raw.get("proximity_intent"),
    )


def _deduplicate_normalized_entities(entities: list[NerEntity]) -> list[NerEntity]:
    """Deduplicate entities by normalized semantic keys instead of raw value."""
    seen: dict[str, NerEntity] = {}

    for e in entities:
        key = _canonical_entity_key(e)
        current = seen.get(key)
        if current is None or e.confidence > current.confidence:
            seen[key] = e

    return list(seen.values())


def _canonical_entity_key(e: NerEntity) -> str:
    if e.type == "BUSINESS_TYPE" and e.business_type:
        return f"BUSINESS_TYPE::{e.business_type}"
    if e.type == "LOCATION" and e.location_code:
        return f"LOCATION::{e.location_code}"

    return f"{e.type}::{e.value.lower()}"
