"""
ai_services/ner-service/app/ner/extractor.py

Trích xuất entity thô từ text tiếng Việt.

Pipeline:
  1a. underthesea.ner() → LOC, ORG, PER, MISC spans
  1b. Keyword scan (song song) → bắt domain wellness terms mà underthesea miss
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
from typing import Optional

from cachetools import LRUCache

from app.core.config import settings

logger = logging.getLogger(__name__)


# ============================================================================
# LRU Query Cache
# ============================================================================
_query_cache: LRUCache = LRUCache(maxsize=settings.QUERY_CACHE_MAXSIZE)


# ============================================================================
# BusinessType aliases — dùng cho keyword scan
# Map nhiều alias tiếng Việt → enum value backend
# ============================================================================
BUSINESS_TYPE_ALIASES: dict[str, str] = {
    # SPA_BEAUTY
    "spa": "SPA_BEAUTY",
    "làm đẹp": "SPA_BEAUTY",
    "chăm sóc da": "SPA_BEAUTY",
    # FITNESS
    "gym": "FITNESS",
    "yoga": "FITNESS",
    "thể hình": "FITNESS",
    "pilates": "FITNESS",
    "fitness": "FITNESS",
    "tập gym": "FITNESS",
    # DENTAL
    "nha khoa": "DENTAL",
    "răng": "DENTAL",
    "niềng răng": "DENTAL",
    # MASSAGE_THERAPY
    "massage": "MASSAGE_THERAPY",
    "mát xa": "MASSAGE_THERAPY",
    "massage thư giãn": "MASSAGE_THERAPY",
    # MASSAGE_REHABILITATION
    "massage trị liệu": "MASSAGE_REHABILITATION",
    "phục hồi chức năng": "MASSAGE_REHABILITATION",
    "vật lý trị liệu": "MASSAGE_REHABILITATION",
    "nắn xương khớp": "MASSAGE_REHABILITATION",
    # PSYCHOLOGY
    "tâm lý": "PSYCHOLOGY",
    "tâm lý trị liệu": "PSYCHOLOGY",
    "tư vấn tâm lý": "PSYCHOLOGY",
    # PSYCHIATRY
    "tâm thần": "PSYCHIATRY",
    "tâm thần học": "PSYCHIATRY",
    # DERMATOLOGY
    "da liễu": "DERMATOLOGY",
    "thẩm mỹ": "DERMATOLOGY",
    "trị mụn": "DERMATOLOGY",
    "chăm sóc da mặt": "DERMATOLOGY",
    # NUTRITION
    "dinh dưỡng": "NUTRITION",
    "ăn kiêng": "NUTRITION",
    "giảm cân": "NUTRITION",
    # TRADITIONAL_MEDICINE
    "đông y": "TRADITIONAL_MEDICINE",
    "y học cổ truyền": "TRADITIONAL_MEDICINE",
    "châm cứu": "TRADITIONAL_MEDICINE",
    "bấm huyệt": "TRADITIONAL_MEDICINE",
    # PHARMACY
    "dược phẩm": "PHARMACY",
    "thuốc": "PHARMACY",
    "nhà thuốc": "PHARMACY",
}

# Sắp xếp by length desc → ưu tiên match cụm dài trước (VD: "massage trị liệu" > "massage")
_SORTED_BT_KEYWORDS = sorted(BUSINESS_TYPE_ALIASES.keys(), key=len, reverse=True)

# Thêm domain-specific wellness keywords mà underthesea hay miss
_EXTRA_DOMAIN_KEYWORDS: set[str] = {
    "trị mụn", "giảm cân", "nắn xương khớp", "chăm sóc da mặt",
    "vật lý trị liệu", "phục hồi chức năng", "bấm huyệt", "châm cứu",
    "niềng răng", "tập gym", "pilates", "massage trị liệu",
}


# ============================================================================
# Price Regex — tách riêng để dễ mở rộng slang VN
# ============================================================================
# Bắt: "dưới 500k", "trên 300k", "từ 200k đến 1 triệu", "tối đa 1tr"
_PRICE_SINGLE_PATTERN = re.compile(
    r"(dưới|trên|tối đa|tối thiểu|khoảng|<=?|>=?)\s*"
    r"([\d.,]+)\s*"
    r"(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)?",
    re.IGNORECASE,
)

_PRICE_RANGE_PATTERN = re.compile(
    r"từ\s*([\d.,]+)\s*(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)?\s*"
    r"(?:đến|tới|->?|-)\s*"
    r"([\d.,]+)\s*(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)?",
    re.IGNORECASE,
)

# ============================================================================
# Rating Regex
# ============================================================================
_RATING_PATTERN = re.compile(
    r"(trên|từ|dưới|tối thiểu|ít nhất|>=?|<=?)\s*"
    r"([\d.]+)\s*"
    r"(sao|điểm|★|\*)?",
    re.IGNORECASE,
)


# ============================================================================
# PUBLIC API
# ============================================================================

def extract_entities(text: str) -> list[dict]:
    """
    Trích xuất entity thô từ text. Có LRU caching.
    Returns list[dict] — mỗi dict có ít nhất {type, value, confidence}.
    """
    cache_key = text.strip().lower()
    if cache_key in _query_cache:
        logger.debug(f"[Extractor] Cache HIT: {cache_key[:50]}...")
        return _query_cache[cache_key]

    entities: list[dict] = []

    # 1a. underthesea NER
    ner_entities = _extract_with_underthesea(text)
    entities.extend(ner_entities)

    # 1b. Keyword scan (song song — bắt domain wellness terms)
    keyword_entities = _keyword_scan(text)
    entities.extend(keyword_entities)

    # 2. Price + Rating regex
    price_entities = _parse_price(text)
    entities.extend(price_entities)

    rating_entities = _parse_rating(text)
    entities.extend(rating_entities)

    # Deduplicate: nếu cùng value + type thì giữ entity có confidence cao hơn
    entities = _deduplicate(entities)

    _query_cache[cache_key] = entities
    return entities


def clear_query_cache():
    """Xóa query cache. Gọi từ /internal/clear-cache."""
    _query_cache.clear()
    logger.info("[Extractor] Query cache cleared")


# ============================================================================
# PRIVATE — underthesea NER
# ============================================================================

def _extract_with_underthesea(text: str) -> list[dict]:
    """
    Gọi underthesea.ner(text) → merge B-/I- tags thành spans.
    Returns dạng: [{"type": "LOC", "value": "Hà Nội", "confidence": 0.95}]
    """
    try:
        from underthesea import ner
        tagged = ner(text)
    except ImportError:
        logger.warning("[Extractor] underthesea not installed, skipping NER")
        return []
    except Exception as e:
        logger.warning(f"[Extractor] underthesea.ner() failed: {e}")
        return []

    return _merge_ner_tags(tagged)


def _merge_ner_tags(tagged: list) -> list[dict]:
    """
    Gộp B-LOC/I-LOC, B-ORG/I-ORG thành spans liền mạch.
    underthesea trả về: [(word, pos, chunk, ner_tag), ...]
    ner_tag format: "O", "B-LOC", "I-LOC", "B-ORG", "I-ORG", "B-PER", "I-PER", etc.
    """
    entities: list[dict] = []
    current_type: Optional[str] = None
    current_tokens: list[str] = []

    for item in tagged:
        word = item[0]
        ner_tag = item[3] if len(item) > 3 else "O"

        if ner_tag.startswith("B-"):
            # Flush previous entity
            if current_type and current_tokens:
                entities.append({
                    "type": _map_ner_tag(current_type),
                    "value": " ".join(current_tokens),
                    "confidence": 0.85,
                })
            current_type = ner_tag[2:]   # "B-LOC" → "LOC"
            current_tokens = [word]

        elif ner_tag.startswith("I-") and current_type == ner_tag[2:]:
            current_tokens.append(word)

        else:
            # O tag — flush
            if current_type and current_tokens:
                entities.append({
                    "type": _map_ner_tag(current_type),
                    "value": " ".join(current_tokens),
                    "confidence": 0.85,
                })
            current_type = None
            current_tokens = []

    # Flush last entity
    if current_type and current_tokens:
        entities.append({
            "type": _map_ner_tag(current_type),
            "value": " ".join(current_tokens),
            "confidence": 0.85,
        })

    return entities


def _map_ner_tag(tag: str) -> str:
    """Map underthesea NER tag → our entity types."""
    mapping = {
        "LOC": "LOC",
        "ORG": "ORG",
        "PER": "PER",
        "MISC": "MISC",
    }
    return mapping.get(tag, "MISC")


# ============================================================================
# PRIVATE — Keyword Scan (song song với underthesea)
# Bắt domain-specific wellness terms mà underthesea hay miss
# ============================================================================

def _keyword_scan(text: str) -> list[dict]:
    """
    Quét text tìm BUSINESS_TYPE_ALIASES keys.
    Ưu tiên match cụm dài trước (VD: "massage trị liệu" > "massage").
    """
    found: list[dict] = []
    text_lower = text.lower()
    already_matched_ranges: list[tuple[int, int]] = []

    for keyword in _SORTED_BT_KEYWORDS:
        start = text_lower.find(keyword)
        if start == -1:
            continue

        end = start + len(keyword)

        # Kiểm tra overlap với entity đã match
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

    return found


# ============================================================================
# PRIVATE — Price Parser (tách riêng, dễ mở rộng slang sau)
# ============================================================================

def _normalize_amount(raw: str, unit: Optional[str]) -> float:
    """Chuyển text số + đơn vị → số thực."""
    raw = raw.replace(",", "").replace(".", "")
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

    return value


def _parse_price(text: str) -> list[dict]:
    """
    Trích xuất PRICE entities từ text bằng regex.
    Tách riêng hàm để dễ thêm Vietnamese slang patterns sau.
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

    # 2. Single bound: "dưới X", "trên X"
    for match in _PRICE_SINGLE_PATTERN.finditer(text):
        modifier = match.group(1).lower()
        amount = _normalize_amount(match.group(2), match.group(3))
        if amount <= 0:
            continue

        if modifier in ("dưới", "tối đa", "<", "<="):
            operator = "lte"
        elif modifier in ("trên", "tối thiểu", ">", ">="):
            operator = "gte"
        elif modifier == "khoảng":
            operator = "gte"     # "khoảng 500k" → treat as minimum hint
        else:
            operator = "lte"

        results.append({
            "type": "PRICE",
            "value": match.group(0).strip(),
            "confidence": 1.0,
            "operator": operator,
            "amount": amount,
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
