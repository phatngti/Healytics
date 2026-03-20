"""
ai_services/ner-service/app/ner/normalizer.py

Entity Linking: chuyển raw entities từ extractor → normalized NerEntity.

Strategy:
  - LOC → O(1) lookup trong location RAM cache (province + district/ward)
  - ORG/MISC/BUSINESS_TYPE → exact alias match + RapidFuzz fuzzy match
  - PRICE/RATING → đã parse sẵn operator+amount từ extractor
  - Không map được → normalized_id=None, log warning (không crash)
"""

import logging
import re
from typing import Optional

from rapidfuzz import fuzz

from app.core.config import settings
from app.ner import cache
from app.ner.extractor import BUSINESS_TYPE_ALIASES
from app.ner.semantic_matcher import get_matcher
from app.schemas.ner_schema import NerEntity

logger = logging.getLogger(__name__)


# Fuzzy matching threshold (0–100). Dưới ngưỡng → không map.
FUZZY_THRESHOLD = 75


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

def _normalize_location(value: str, confidence: float, raw: dict) -> NerEntity:
    """Tra location cache O(1). Province hardcoded, district/ward từ backend."""
    loc_info = cache.find_location(value)

    location_intent = None
    location_intent_score = None

    source_query = raw.get("source_query")
    if source_query:
        intent_result = get_matcher().score_location_filter_intent(
            source_query,
            value,
            threshold=settings.LOCATION_INTENT_THRESHOLD,
        )
        location_intent = intent_result["intent"]
        location_intent_score = intent_result["score"]

    if loc_info:
        return NerEntity(
            type="LOCATION",
            value=value,
            confidence=confidence,
            location_code=loc_info["code"],
            location_level=loc_info["level"],
            location_intent=location_intent,
            location_intent_score=location_intent_score,
        )

    # Không tìm thấy → graceful degradation
    logger.warning(f"[Normalizer] Unknown location: {value!r}")
    return NerEntity(
        type="LOCATION",
        value=value,
        confidence=max(confidence * 0.5, 0.1),   # Giảm confidence
        location_intent=location_intent,
        location_intent_score=location_intent_score,
    )


# ============================================================================
# PRIVATE — BusinessType (from keyword scan → đã có business_type sẵn)
# ============================================================================

def _normalize_business_type(
    value: str, confidence: float, raw: dict
) -> NerEntity:
    """Entity từ keyword scan đã có business_type sẵn, nhưng có thể tinh chỉnh bằng Semantic matching."""
    bt = raw.get("business_type")
    
    # Nếu chưa có bt hoặc muốn kiểm chứng lại bằng model
    if not bt:
        matcher = get_matcher()
        bt = matcher.match_business_type(value)

    return NerEntity(
        type="BUSINESS_TYPE",
        value=value,
        confidence=confidence,
        business_type=bt,
    )


# ============================================================================
# PRIVATE — ORG/MISC → thử BusinessType alias + Category fuzzy
# ============================================================================

def _normalize_org_misc(value: str, confidence: float) -> NerEntity:
    """
    ORG/MISC từ underthesea → thử:
    1. Exact match trong BUSINESS_TYPE_ALIASES
    2. Fuzzy match trong BUSINESS_TYPE_ALIASES
    3. Semantic category match
    4. Fuzzy match trong category cache
    5. Không map → trả về type CATEGORY với slug=None
    """
    value_lower = value.lower().strip()

    # 1. Exact match → BusinessType
    if value_lower in BUSINESS_TYPE_ALIASES:
        return NerEntity(
            type="BUSINESS_TYPE",
            value=value,
            confidence=confidence,
            business_type=BUSINESS_TYPE_ALIASES[value_lower],
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
        )

    # 3. Semantic category match → Category
    categories = cache.get_category_list()
    if categories:
        cat_match = matcher.match_category(
            value_lower,
            categories,
            threshold=settings.SEMANTIC_CATEGORY_MEDIUM_THRESHOLD,
        )
        if cat_match:
            return NerEntity(
                type="CATEGORY",
                value=value,
                confidence=confidence * 0.9,
                category_slug=cat_match["slug"],
            )

    # 4. Fuzzy match → Category
    cat_slug = _fuzzy_match_category(value_lower)
    if cat_slug:
        return NerEntity(
            type="CATEGORY",
            value=value,
            confidence=confidence * 0.85,
            category_slug=cat_slug,
        )

    # 5. Không map được
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
    """Distance đã được distance_extractor parse sẵn radius_meters + unit."""
    return NerEntity(
        type="DISTANCE",
        value=value,
        confidence=confidence,
        radius_meters=raw.get("radius_meters"),
        distance_unit=raw.get("distance_unit"),
        proximity_intent=raw.get("proximity_intent"),
    )


def _fuzzy_match_category(text: str) -> Optional[str]:
    """RapidFuzz match text against category cache names."""
    categories = cache.get_category_list()
    if not categories:
        return None

    best_slug: Optional[str] = None
    best_score = 0.0
    text_len = max(len(text.strip()), 1)
    text_phonetic = _phonetic_normalize_vi(text)

    for c in categories:
        name = c["name"]
        name_phonetic = _phonetic_normalize_vi(name)

        base_score = float(fuzz.token_sort_ratio(text, name))
        phonetic_score = float(fuzz.token_sort_ratio(text_phonetic, name_phonetic))
        raw_score = max(base_score, phonetic_score - 2.0)

        name_len = max(len(name.strip()), 1)
        len_ratio = min(text_len, name_len) / max(text_len, name_len)

        # Penalize extreme length mismatch to avoid snapping short generic queries.
        if len_ratio < 0.5:
            raw_score -= (0.5 - len_ratio) * 30.0

        if raw_score > best_score:
            best_score = raw_score
            best_slug = c["slug"]

    if best_slug and best_score >= FUZZY_THRESHOLD:
        return best_slug

    return None


def _phonetic_normalize_vi(text: str) -> str:
    """Normalize common Vietnamese spelling confusions for fuzzy comparison only."""
    if not text:
        return ""

    s = cache.remove_accents(text.lower())
    # Longer patterns first to avoid partial rewrite artifacts.
    replacements = (
        ("ngh", "ng"),
        ("gh", "g"),
        ("kh", "k"),
        ("ph", "f"),
        ("th", "t"),
        ("tr", "ch"),
        ("gi", "d"),
        ("qu", "q"),
    )
    for old, new in replacements:
        s = s.replace(old, new)

    # Single-char confusions.
    s = s.replace("x", "s").replace("r", "d")
    s = re.sub(r"\s+", " ", s).strip()
    return s
