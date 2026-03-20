"""
ai_services/ner-service/app/ner/extractor.py

Trích xuất entity thô từ text tiếng Việt.

Pipeline:
  1a. underthesea.ner() → LOC, ORG, PER, MISC spans
  1b. Keyword scan (song song) → bắt domain wellness terms mà underthesea miss
  1c. Location fallback scan → N-gram lookup trên DB cache
  1d. Distance & Proximity extraction
  1e. Semantic Fallback → feed cả câu vào SemanticMatcher nếu chưa có BUSINESS_TYPE
  2.  Price/Rating regex → PRICE, RATING
  3.  LRU query cache → tránh xử lý lại câu truy vấn giống nhau

Kết quả trả về: list[dict] dạng:
  [
    {"type": "LOC", "value": "Hà Nội", "confidence": 0.95},
    {"type": "BUSINESS_TYPE", "value": "spa", "confidence": 0.90},
    {"type": "PRICE", "value": "dưới 500k", "confidence": 1.0,
     "operator": "lte", "amount": 500000.0},
  ]
"""

import logging
import re
import time
import asyncio
from typing import Optional

from cachetools import LRUCache

from app.core.config import settings
from app.ner.distance_extractor import extract_distance_entities
from app.ner.gemini_ner import extract_entities_with_gemini

logger = logging.getLogger(__name__)

try:
    from underthesea import ner as underthesea_ner
except ImportError:
    underthesea_ner = None


# ============================================================================
# LRU Query Cache
# ============================================================================
_query_cache: LRUCache = LRUCache(maxsize=settings.QUERY_CACHE_MAXSIZE)


# ============================================================================
# BusinessType aliases — dùng cho keyword scan
# Map nhiều alias tiếng Việt → enum value backend
# ============================================================================
BUSINESS_TYPE_ALIASES: dict[str, str] = {
    "spa": "SPA_BEAUTY",
    "làm đẹp": "SPA_BEAUTY",
    "chăm sóc da": "SPA_BEAUTY",
    "gym": "FITNESS",
    "phòng tập": "FITNESS",
    "yoga": "FITNESS",
    "pilates": "FITNESS",
    "nha khoa": "DENTAL",
    "nha sĩ": "DENTAL",
    "phòng khám nha sĩ": "DENTAL",
    "massage trị liệu": "MASSAGE_REHABILITATION",
    "massage": "MASSAGE_THERAPY",
    "mát xa": "MASSAGE_THERAPY",
    "nắn xương khớp": "MASSAGE_REHABILITATION",
    "bấm huyệt": "MASSAGE_REHABILITATION",
    "vật lý trị liệu": "MASSAGE_REHABILITATION",
    "phục hồi chức năng": "MASSAGE_REHABILITATION",
    "tâm lý": "PSYCHOLOGY",
    "tâm thần": "PSYCHIATRY",
    "da liễu": "DERMATOLOGY",
    "dinh dưỡng": "NUTRITION",
    "đông y": "TRADITIONAL_MEDICINE",
    "nhà thuốc": "PHARMACY",
    "hiệu thuốc": "PHARMACY",
}

# Sắp xếp by length desc → ưu tiên match cụm dài trước (VD: "massage trị liệu" > "massage")
_SORTED_BT_KEYWORDS = sorted(BUSINESS_TYPE_ALIASES.keys(), key=len, reverse=True)

# Thêm domain-specific wellness keywords mà underthesea hay miss
_EXTRA_DOMAIN_KEYWORDS: set[str] = {
    "trị mụn", "giảm cân", "nắn xương khớp", "chăm sóc da mặt",
    "vật lý trị liệu", "phục hồi chức năng", "bấm huyệt", "châm cứu",
    "khám", "nha khoa", "nha sĩ", "phòng khám nha sĩ", "niềng răng",
    "tâm lý", "đông y", "hiệu thuốc", "nhà thuốc", "phòng tập", "yoga", "pilates",
    "spa", "làm đẹp", "massage", "mát xa"
}


# ============================================================================
# Price Regex — tách riêng để dễ mở rộng slang VN
# ============================================================================
# Bắt: "dưới 500k", "trên 300k", "từ 200k đến 1 triệu", "tối đa 1tr"
# Negative lookahead (?!\s*(sao|điểm|★|\*|km)) để KHÔNG bắt Rating, Distance
_PRICE_SINGLE_PATTERN = re.compile(
    r"(dưới|trên|tối đa|tối thiểu|khoảng|cỡ|tầm|<=?|>=?)\s*"
    r"([\d.,]+)\s*"
    r"(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)?\b"
    r"(?!\s*(?:sao|điểm|★|\*|km\b|m\b|cây\s*số|dặm))",
    re.IGNORECASE,
)

# Bắt: "giá 500k", "chi phí 400k", "phí 300k" — không có modifier nhưng có context từ giá
# Dùng khi user không dùng "dưới/trên/khoảng"
_PRICE_NO_MODIFIER_PATTERN = re.compile(
    r"(?:giá(?:\s+tiền)?|chi\s*phí|học\s*phí|phí)\s+"
    r"([\d.,]+)\s*"
    r"(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)\b",
    re.IGNORECASE,
)

_PRICE_RANGE_PATTERN = re.compile(
    r"từ\s*([\d.,]+)\s*(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)?\s*"
    r"(?:đến|tới|->?|-)\s*"
    r"([\d.,]+)\s*(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)?\b"
    r"(?!\s*(?:sao|điểm|★|\*))",
    re.IGNORECASE,
)

# ============================================================================
# Rating Regex
# ============================================================================
_RATING_PATTERN = re.compile(
    r"(trên|từ|dưới|tối thiểu|ít nhất|>=?|<=?)\s*"
    r"([\d.]+)\s*"
    r"(sao|điểm|★|\*)"  # unit is REQUIRED to avoid false match on "trên 3km", "dưới 5km"
    ,
    re.IGNORECASE,
)


# ============================================================================
# PUBLIC API
# ============================================================================

def extract_entities(text: str) -> list[dict]:
    entities, _ = asyncio.run(extract_entities_with_source(text))
    return entities


async def extract_entities_with_source(text: str) -> tuple[list[dict], str]:
    """
    Trích xuất entity thô từ text. Có LRU caching.
    Returns list[dict] — mỗi dict có ít nhất {type, value, confidence}.
    """
    if not text or not text.strip():
        return [], "none"
        
    # Giới hạn text quá dài để tránh treo CPU (DDoS bảo vệ)
    if len(text) > 2000:
        text = text[:2000]
        
    cache_key = text.strip().lower()
    if cache_key in _query_cache:
        logger.debug(f"[Extractor] Cache HIT: {cache_key[:50]}...")
        cached = _query_cache[cache_key]
        if isinstance(cached, tuple) and len(cached) == 2:
            return cached
        return cached, "cache"

    entities: list[dict] = []
    t0 = time.perf_counter()
    extraction_source = "local"

    # LLM-first mode: replace legacy NER extraction when enabled.
    llm_entities = await extract_entities_with_gemini(text)
    if llm_entities:
        entities.extend(llm_entities)
        extraction_source = "gemini"
        t1 = time.perf_counter()
        logger.info(f"[Perf] Gemini NER: {(t1-t0)*1000:.2f}ms | entities={len(llm_entities)}")
    else:
        extraction_source = "fallback_local" if settings.LLM_NER_ENABLED else "local"
        if llm_entities == []:
            logger.warning("[Extractor] Gemini returned empty entities, fallback to local extractor")
        # 1a. underthesea NER
        ner_entities = _extract_with_underthesea(text)
        entities.extend(ner_entities)
        t1 = time.perf_counter()
        logger.info(f"[Perf] Underthesea NER: {(t1-t0)*1000:.2f}ms")

        # 1b. Keyword scan (song song — bắt domain wellness terms)
        keyword_entities, keyword_ranges = _keyword_scan(text)
        entities.extend(keyword_entities)
        t2 = time.perf_counter()
        logger.info(f"[Perf] Keyword Scan: {(t2-t1)*1000:.2f}ms")

        # 1c. Location fallback scan — skip char ranges already matched by keyword scan
        location_entities = _location_fallback_scan(text, excluded_ranges=keyword_ranges)
        entities.extend(location_entities)
        t3 = time.perf_counter()
        logger.info(f"[Perf] Location Scan: {(t3-t2)*1000:.2f}ms")

        # 1d. Distance & Proximity extraction
        distance_entities = extract_distance_entities(text)
        entities.extend(distance_entities)
        t3_dist = time.perf_counter()
        logger.info(f"[Perf] Distance Extraction: {(t3_dist-t3)*1000:.2f}ms")

        # 1e. Semantic Fallback — chỉ chạy khi keyword scan + underthesea KHÔNG tìm ra BUSINESS_TYPE
        # Feed toàn bộ câu cho AI để hiểu ý định ngầm ("nhổ răng", "đau lưng", "mất ngủ", ...)
        has_business_type = any(e["type"] == "BUSINESS_TYPE" for e in entities)
        if not has_business_type:
            try:
                from app.ner.semantic_matcher import get_matcher

                matcher = get_matcher()
                matched_bt = matcher.match_business_type(text, threshold=0.35)
                if matched_bt:
                    entities.append({
                        "type": "BUSINESS_TYPE",
                        "value": text.strip(),
                        "confidence": 0.75,
                        "business_type": matched_bt,
                    })
                    logger.info(f"[Extractor] Semantic Fallback: '{text[:60]}' -> {matched_bt}")
            except Exception as exc:
                logger.warning("[Extractor] Semantic fallback unavailable: %s", exc)

    # Deterministic numeric extraction remains as safety net.
    if not any(e.get("type") == "DISTANCE" for e in entities):
        entities.extend(extract_distance_entities(text))

    if not any(e.get("type") == "PRICE" for e in entities):
        entities.extend(_parse_price(text))

    if not any(e.get("type") == "RATING" for e in entities):
        entities.extend(_parse_rating(text))

    t4 = time.perf_counter()
    logger.info(f"[Perf] Post-process (Distance/Price/Rating): {(t4-t0)*1000:.2f}ms")

    # deduplicate
    entities = _deduplicate(entities)

    # 3. Post-Filter LOC: Chỉ giữ lại các địa điểm có thật trong DB (cần code để build query)
    from app.ner.cache import find_location
    valid_entities = []
    for e in entities:
        if e["type"] == "LOC":
            loc_info = find_location(e["value"])
            if loc_info:
                e["source_query"] = text
                valid_entities.append(e)
            else:
                logger.debug(f"[Extractor] Discarding non-DB location: {e['value']}")
        else:
            valid_entities.append(e)

    _query_cache[cache_key] = (valid_entities, extraction_source)
    return valid_entities, extraction_source


def clear_query_cache():
    """Xóa query cache. Gọi từ /internal/clear-cache."""
    _query_cache.clear()
    logger.info("[Extractor] Query cache cleared")


# ============================================================================
# PRIVATE — underthesea NER
# ============================================================================

def _extract_with_underthesea(text: str) -> list[dict]:
# ... (rest of _extract_with_underthesea remains unchanged) ...
    try:
        if underthesea_ner is None:
            raise ImportError("underthesea is not installed")
        tagged = underthesea_ner(text)
    except ImportError:
        logger.warning("[Extractor] underthesea not installed, skipping NER")
        return []
    except Exception as e:
        logger.warning(f"[Extractor] underthesea.ner() failed: {e}")
        return []

    return _merge_ner_tags(tagged)


def _merge_ner_tags(tagged: list) -> list[dict]:
# ... (rest of _merge_ner_tags unchanged) ...
    entities: list[dict] = []
    current_type: Optional[str] = None
    current_tokens: list[str] = []

    for item in tagged:
        word = item[0]
        ner_tag = item[3] if len(item) > 3 else "O"

        if ner_tag.startswith("B-"):
            if current_type and current_tokens:
                entities.append({
                    "type": _map_ner_tag(current_type),
                    "value": " ".join(current_tokens),
                    "confidence": 0.85,
                })
            current_type = ner_tag[2:]
            current_tokens = [word]

        elif ner_tag.startswith("I-") and current_type == ner_tag[2:]:
            current_tokens.append(word)

        else:
            if current_type and current_tokens:
                entities.append({
                    "type": _map_ner_tag(current_type),
                    "value": " ".join(current_tokens),
                    "confidence": 0.85,
                })
            current_type = None
            current_tokens = []

    if current_type and current_tokens:
        entities.append({
            "type": _map_ner_tag(current_type),
            "value": " ".join(current_tokens),
            "confidence": 0.85,
        })

    return entities


def _map_ner_tag(tag: str) -> str:
    mapping = {
        "LOC": "LOC",
        "ORG": "ORG",
        "PER": "PER",
        "MISC": "MISC",
    }
    return mapping.get(tag, "MISC")


# ============================================================================
# PRIVATE — Keyword Scan (song song với underthesea)
# ============================================================================

def _keyword_scan(text: str) -> tuple[list[dict], list[tuple[int, int]]]:
    """Returns (entities, matched_char_ranges) to allow downstream steps to skip matched spans."""
    found: list[dict] = []
    text_lower = text.lower()
    already_matched_ranges: list[tuple[int, int]] = []

    for keyword in _SORTED_BT_KEYWORDS:
        start = text_lower.find(keyword)
        if start == -1:
            continue

        end = start + len(keyword)
        overlap = any(
            not (end <= ms or start >= me)
            for ms, me in already_matched_ranges
        )
        if overlap:
            continue

        already_matched_ranges.append((start, end))
        found.append({
            "type": "BUSINESS_TYPE",
            "value": keyword,
            "confidence": 0.90,
            "business_type": BUSINESS_TYPE_ALIASES[keyword],
        })

    return found, already_matched_ranges


def _location_fallback_scan(text: str, excluded_ranges: list[tuple[int, int]] | None = None) -> list[dict]:
    """
    Quét dictionary O(1) qua N-grams để bắt location.
    Cực nhanh (vài mili-giây) do không loop qua 37,000 DB records.

    excluded_ranges: char ranges already matched by keyword scan — skip to avoid
    matching sub-words like "hiệu" (from "hiệu thuốc") as ward names.
    """
    found: list[dict] = []
    text_lower = text.lower()

    # Early out nếu text quá ngắn
    if len(text_lower.replace(" ", "")) < 3:
        return found

    from app.ner.cache import _location_cache, to_canonical, PROVINCE_MAP, _DISTRICT_FALLBACK

    already_matched_ranges: list[tuple[int, int]] = []

    # Tách từ để tạo N-grams (max 5 từ cho 1 location: vd "thành phố hồ chí minh")
    tokens = [(m.group(0), m.start(), m.end()) for m in re.finditer(r'\w+', text_lower)]

    # Duyệt N-grams từ n=5 xuống 1 để ưu tiên match cụm dài trước
    for n in range(5, 0, -1):
        for i in range(len(tokens) - n + 1):
            start_idx = tokens[i][1]
            end_idx = tokens[i + n - 1][2]

            # Bỏ qua nếu n-gram nằm trong vùng đã match bởi keyword scan
            if excluded_ranges and any(
                not (end_idx <= ms or start_idx >= me)
                for ms, me in excluded_ranges
            ):
                continue

            # Kiểm tra xem khoảng này đã bị match bởi N-gram dài hơn chưa
            overlap = any(not (end_idx <= ms or start_idx >= me) for ms, me in already_matched_ranges)
            if overlap:
                continue

            # Lấy chuỗi substring thật từ text lower
            ngram_text = text_lower[start_idx:end_idx]

            # 1. Canonical lookup → DB cache (works for most locations)
            can_ngram = to_canonical(ngram_text)
            matched = can_ngram in _location_cache

            # 2. Direct lowercase lookup → PROVINCE_MAP and _DISTRICT_FALLBACK
            # Needed for "quận 1", "quận 2"... where to_canonical strips the number leaving "1"
            if not matched:
                matched = ngram_text in PROVINCE_MAP or ngram_text in _DISTRICT_FALLBACK

            if matched:
                already_matched_ranges.append((start_idx, end_idx))
                found.append({
                    "type": "LOC",
                    "value": text[start_idx:end_idx], # Giữ đúng case gốc
                    "confidence": 0.85,
                })

    return found


# ============================================================================
# PRIVATE — Price Parser (tách riêng, dễ mở rộng slang sau)
# ============================================================================

def _normalize_amount(raw: str, unit: Optional[str]) -> float:
    """Chuyển text số + đơn vị → số thực.

    Handles:
      - "500"      → 500
      - "1.5"      → 1.5  (decimal dot)
      - "1,5"      → 1.5  (decimal comma — Vietnamese style)
    """
    # Normalize comma decimal separator to dot ("1,5" → "1.5")
    # Do NOT strip dots — they are decimal points, not thousand separators
    # (prices like "1.000" are uncommon in user queries; "1.5 triệu" is normal)
    raw = raw.replace(",", ".")
    try:
        value = float(raw)
    except ValueError:
        return 0.0

    if unit:
        unit_lower = unit.lower()
        if unit_lower in ("k", "nghìn", "ngàn"):
            value *= 1_000
        elif unit_lower in ("triệu", "tr"):
            value *= 1_000_000
    else:
        # User requested: nếu không có đơn vị thì đơn vị là ĐỒNG (1:1)
        pass

    return value


def _parse_price(text: str) -> list[dict]:
    """
    Trích xuất PRICE entities từ text bằng regex.
    Xử lý: dưới, trên, khoảng, cỡ, tầm,...
    """
    results: list[dict] = []

    # 1. Kiểm tra "từ X đến Y" trước (range)
    range_match = _PRICE_RANGE_PATTERN.search(text)
    if range_match:
        amount_min = _normalize_amount(range_match.group(1), range_match.group(2))
        amount_max = _normalize_amount(range_match.group(3), range_match.group(4))
        results.append({
            "type": "PRICE",
            "value": range_match.group(0).strip(),
            "confidence": 1.0,
            "operator": "between",
            "amount": amount_min,
            "amount_max": amount_max,
        })
        return results

    # 2. Single bound
    for match in _PRICE_SINGLE_PATTERN.finditer(text):
        modifier = match.group(1).lower()
        amount = _normalize_amount(match.group(2), match.group(3))
        if amount <= 0:
            continue

        if modifier in ("dưới", "tối đa", "<", "<="):
            operator = "lte"
            res_entry = {"type": "PRICE", "value": match.group(0).strip(), "confidence": 1.0, "operator": operator, "amount": amount}
        elif modifier in ("trên", "tối thiểu", ">", ">="):
            operator = "gte"
            res_entry = {"type": "PRICE", "value": match.group(0).strip(), "confidence": 1.0, "operator": operator, "amount": amount}
        elif modifier in ("khoảng", "cỡ", "tầm"):
            # "Khoảng 300k" -> Search từ 255k đến 345k (85% - 115%)
            res_entry = {
                "type": "PRICE",
                "value": match.group(0).strip(),
                "confidence": 1.0,
                "operator": "between",
                "amount": amount * 0.85,
                "amount_max": amount * 1.15,
            }
        else:
            operator = "lte"
            res_entry = {"type": "PRICE", "value": match.group(0).strip(), "confidence": 1.0, "operator": operator, "amount": amount}

        results.append(res_entry)

    # 3. No-modifier price: "giá 500k", "chi phí 400k" → around ±15%
    if not results:
        for match in _PRICE_NO_MODIFIER_PATTERN.finditer(text):
            amount = _normalize_amount(match.group(1), match.group(2))
            if amount <= 0:
                continue
            results.append({
                "type": "PRICE",
                "value": match.group(0).strip(),
                "confidence": 0.9,
                "operator": "between",
                "amount": amount * 0.85,
                "amount_max": amount * 1.15,
            })

    return results


# ============================================================================
# PRIVATE — Rating Parser
# ============================================================================

def _parse_rating(text: str) -> list[dict]:
    """Trích xuất RATING entities từ text bằng regex."""
    results: list[dict] = []

    for match in _RATING_PATTERN.finditer(text):
        modifier = match.group(1).lower()
        try:
            score = float(match.group(2))
        except ValueError:
            continue

        if score < 0 or score > 5:
            continue

        if modifier in ("trên", "từ", "tối thiểu", "ít nhất", ">", ">="):
            operator = "gte"
        elif modifier in ("dưới", "<", "<="):
            operator = "lte"
        else:
            operator = "gte"

        results.append({
            "type": "RATING",
            "value": match.group(0).strip(),
            "confidence": 1.0,
            "operator": operator,
            "amount": score,
        })

    return results


# ============================================================================
# PRIVATE — Deduplication
# ============================================================================

def _deduplicate(entities: list[dict]) -> list[dict]:
    """
    Nếu cùng value (lowercase) + type thì giữ entity có confidence cao nhất.
    Nếu type khác nhau thì giữ cả hai.
    """
    seen: dict[str, dict] = {}

    for e in entities:
        key = f"{e['type']}::{e['value'].lower()}"
        if key not in seen or e.get("confidence", 0) > seen[key].get("confidence", 0):
            seen[key] = e

    return list(seen.values())
