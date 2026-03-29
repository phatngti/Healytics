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

try:
    import ahocorasick  # type: ignore
except ImportError:
    ahocorasick = None


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
_BT_KEYWORD_PATTERNS = {
    keyword: re.compile(rf"(?<!\\w){re.escape(keyword)}(?!\\w)", re.IGNORECASE)
    for keyword in _SORTED_BT_KEYWORDS
}

# Thêm domain-specific wellness keywords mà underthesea hay miss
_EXTRA_DOMAIN_KEYWORDS: set[str] = {
    "trị mụn", "giảm cân", "nắn xương khớp", "chăm sóc da mặt",
    "vật lý trị liệu", "phục hồi chức năng", "bấm huyệt", "châm cứu",
    "khám", "nha khoa", "nha sĩ", "phòng khám nha sĩ", "niềng răng",
    "tâm lý", "đông y", "hiệu thuốc", "nhà thuốc", "phòng tập", "yoga", "pilates",
    "spa", "làm đẹp", "massage", "mát xa"
}


# Optional Aho-Corasick location index (lazy-built on first use)
_location_automaton = None
_location_automaton_fingerprint: tuple[int, int, int] | None = None


# ============================================================================
# Price Regex — tách riêng để dễ mở rộng slang VN
# ============================================================================
# Bắt: "dưới 500k", "trên 300k", "từ 200k đến 1 triệu", "tối đa 1tr"
# Negative lookahead (?!\s*(sao|điểm|★|\*|km)) để KHÔNG bắt Rating, Distance
_PRICE_SINGLE_PATTERN = re.compile(
    r"(dưới|trên|tối đa|tối thiểu|khoảng|cỡ|tầm|<=?|>=?)\s*"
    r"([\d.,]+)\s*"
    r"(k|nghìn|ngàn|triệu|tr|đồng|đ|vnđ)?\b"
    r"(?!\s*(?:"
    r"sao|điểm|★|\*|km\b|m\b|cây\s*số|dặm"
    r"|(?:đến|tới|-|–|—)\s*[\d.,]+\s*(?:km\b|m\b|cây\s*số|dặm)"
    r"))",
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
    try:
        asyncio.get_running_loop()
    except RuntimeError:
        pass
    else:
        raise RuntimeError(
            "extract_entities() cannot run inside an active event loop. "
            "Use 'await extract_entities_with_source(text)' in async contexts."
        )

    entities, _ = asyncio.run(extract_entities_with_source(text))
    return entities


async def extract_entities_with_source(text: str) -> tuple[list[dict], str]:
    """
    Trích xuất entity thô từ text. Có LRU caching.
    Returns list[dict] — mỗi dict có ít nhất {type, value, confidence}.
    """
    if not text or not text.strip():
        return [], "none"

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

    llm_entities = await extract_entities_with_gemini(text)
    if llm_entities:
        entities.extend(llm_entities)
        extraction_source = "gemini"
        t_llm = time.perf_counter()
        logger.info(f"[Perf] Gemini NER: {(t_llm-t0)*1000:.2f}ms | entities={len(llm_entities)}")
    elif llm_entities == []:
        extraction_source = "fallback_local" if settings.LLM_NER_ENABLED else "local"
        logger.warning("[Extractor] Gemini returned empty entities, fallback to local extractor")
    else:
        extraction_source = "fallback_local" if settings.LLM_NER_ENABLED else "local"

    ner_entities = await asyncio.to_thread(_extract_with_underthesea, text)
    entities.extend(ner_entities)
    t1 = time.perf_counter()
    logger.info(f"[Perf] Underthesea NER: {(t1-t0)*1000:.2f}ms")

    keyword_entities, keyword_ranges = _keyword_scan(text)
    entities.extend(keyword_entities)
    t2 = time.perf_counter()
    logger.info(f"[Perf] Keyword Scan: {(t2-t1)*1000:.2f}ms")

    location_entities = await asyncio.to_thread(
        _location_fallback_scan,
        text,
        excluded_ranges=keyword_ranges,
    )
    entities.extend(location_entities)
    t3 = time.perf_counter()
    logger.info(f"[Perf] Location Scan: {(t3-t2)*1000:.2f}ms")

    distance_entities = extract_distance_entities(text)
    entities.extend(distance_entities)
    t3_dist = time.perf_counter()
    logger.info(f"[Perf] Distance Extraction: {(t3_dist-t3)*1000:.2f}ms")

    has_business_type = any(e["type"] == "BUSINESS_TYPE" for e in entities)
    if not has_business_type:
        try:
            from app.ner.semantic_matcher import get_matcher

            matcher = get_matcher()
            matched_bt = await asyncio.to_thread(matcher.match_business_type, text, 0.35)
            if matched_bt:
                entities.append(
                    {
                        "type": "BUSINESS_TYPE",
                        "value": text.strip(),
                        "confidence": 0.75,
                        "business_type": matched_bt,
                            "business_evidence": text.strip(),
                    }
                )
                logger.info(f"[Extractor] Semantic Fallback: '{text[:60]}' -> {matched_bt}")
        except Exception as exc:
            logger.warning("[Extractor] Semantic fallback unavailable: %s", exc)

    # Deterministic numeric extraction is strictly superior for VN queries.
    # We strip LLM's naive attempts at PRICE/RATING/DISTANCE to let local regex handle rules & overlaps properly.
    entities = [e for e in entities if e.get("type") not in {"PRICE", "RATING", "DISTANCE"}]

    entities.extend(distance_entities)
    entities.extend(_parse_price(text))
    entities.extend(_parse_rating(text))

    t4 = time.perf_counter()
    logger.info(f"[Perf] Post-process (Distance/Price/Rating): {(t4-t0)*1000:.2f}ms")

    entities = _deduplicate(entities)
    entities = _resolve_distance_priority(entities)

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
    already_matched_ranges: list[tuple[int, int]] = []

    for keyword in _SORTED_BT_KEYWORDS:
        pattern = _BT_KEYWORD_PATTERNS[keyword]
        for m in pattern.finditer(text):
            start, end = m.start(), m.end()
            overlap = any(
                not (end <= ms or start >= me)
                for ms, me in already_matched_ranges
            )
            if overlap:
                continue

            already_matched_ranges.append((start, end))
            found.append({
                "type": "BUSINESS_TYPE",
                "value": text[start:end],
                "confidence": 0.90,
                "business_type": BUSINESS_TYPE_ALIASES[keyword],
                    "business_evidence": text[start:end],
            })

    return found, already_matched_ranges


def _location_fallback_scan(text: str, excluded_ranges: list[tuple[int, int]] | None = None) -> list[dict]:
    """
    Quét dictionary O(1) qua N-grams để bắt location.
    Cực nhanh (vài mili-giây) do không loop qua 37,000 DB records.

    excluded_ranges: char ranges already matched by keyword scan — skip to avoid
    matching sub-words like "hiệu" (from "hiệu thuốc") as ward names.
    """
    if not settings.LOCATION_MATCHER_USE_AHO or ahocorasick is None:
        return _location_fallback_scan_ngram(text, excluded_ranges=excluded_ranges)

    from app.ner.cache import _location_cache, to_canonical, PROVINCE_MAP, _DISTRICT_FALLBACK

    token_spans = [(m.group(0), m.start(), m.end()) for m in re.finditer(r"\w+", text)]
    if not token_spans:
        return []

    # Build canonical token stream and index map: canonical char range -> original token span.
    canonical_tokens: list[str] = []
    canonical_to_token_idx: list[int] = []
    for idx, (tok, _, _) in enumerate(token_spans):
        can_tok = to_canonical(tok)
        if not can_tok:
            continue
        canonical_tokens.append(can_tok)
        canonical_to_token_idx.append(idx)

    if not canonical_tokens:
        return []

    canonical_text = " ".join(canonical_tokens)
    if len(canonical_text.replace(" ", "")) < 3:
        return []

    auto = _get_location_automaton(_location_cache, PROVINCE_MAP, _DISTRICT_FALLBACK)
    if auto is None:
        return _location_fallback_scan_ngram(text, excluded_ranges=excluded_ranges)

    # Precompute canonical token character offsets
    canonical_token_starts: list[int] = []
    pos = 0
    for tok in canonical_tokens:
        canonical_token_starts.append(pos)
        pos += len(tok) + 1

    matches: list[tuple[int, int]] = []
    for end_idx, matched_phrase in auto.iter(canonical_text):
        start_idx = end_idx - len(matched_phrase) + 1

        # Require token boundaries in canonical stream
        left_ok = start_idx == 0 or canonical_text[start_idx - 1] == " "
        right_ok = end_idx == len(canonical_text) - 1 or canonical_text[end_idx + 1] == " "
        if not (left_ok and right_ok):
            continue

        # Map canonical char range -> token range
        start_tok = None
        end_tok = None
        for i, c_start in enumerate(canonical_token_starts):
            c_end = c_start + len(canonical_tokens[i])
            if start_tok is None and c_start == start_idx:
                start_tok = i
            if c_end - 1 == end_idx:
                end_tok = i
                break

        if start_tok is None or end_tok is None:
            continue

        orig_start = token_spans[canonical_to_token_idx[start_tok]][1]
        orig_end = token_spans[canonical_to_token_idx[end_tok]][2]
        matches.append((orig_start, orig_end))

    if not matches:
        return []

    # Longest-first overlap resolution to keep most specific span.
    matches.sort(key=lambda s: (-(s[1] - s[0]), s[0]))
    found: list[dict] = []
    already_matched_ranges: list[tuple[int, int]] = []
    for start_idx, end_idx in matches:
        if excluded_ranges and any(not (end_idx <= ms or start_idx >= me) for ms, me in excluded_ranges):
            continue
        overlap = any(not (end_idx <= ms or start_idx >= me) for ms, me in already_matched_ranges)
        if overlap:
            continue
        already_matched_ranges.append((start_idx, end_idx))
        found.append({
            "type": "LOC",
            "value": text[start_idx:end_idx],
            "confidence": 0.85,
        })

    return found


def _location_fallback_scan_ngram(text: str, excluded_ranges: list[tuple[int, int]] | None = None) -> list[dict]:
    """Compatibility fallback when Aho-Corasick library is unavailable."""
    found: list[dict] = []
    text_lower = text.lower()

    if len(text_lower.replace(" ", "")) < 3:
        return found

    from app.ner.cache import _location_cache, to_canonical, PROVINCE_MAP, _DISTRICT_FALLBACK

    already_matched_ranges: list[tuple[int, int]] = []
    tokens = [(m.group(0), m.start(), m.end()) for m in re.finditer(r'\w+', text_lower)]

    for n in range(5, 0, -1):
        for i in range(len(tokens) - n + 1):
            start_idx = tokens[i][1]
            end_idx = tokens[i + n - 1][2]

            if excluded_ranges and any(
                not (end_idx <= ms or start_idx >= me)
                for ms, me in excluded_ranges
            ):
                continue

            overlap = any(not (end_idx <= ms or start_idx >= me) for ms, me in already_matched_ranges)
            if overlap:
                continue

            ngram_text = text_lower[start_idx:end_idx]
            can_ngram = to_canonical(ngram_text)
            matched = can_ngram in _location_cache

            if not matched:
                matched = ngram_text in PROVINCE_MAP or ngram_text in _DISTRICT_FALLBACK

            if matched:
                already_matched_ranges.append((start_idx, end_idx))
                found.append({
                    "type": "LOC",
                    "value": text[start_idx:end_idx],
                    "confidence": 0.85,
                })

    return found


def _get_location_automaton(_location_cache: dict, province_map: dict, district_fallback: dict):
    """Build or reuse a location phrase automaton keyed by canonical phrases."""
    global _location_automaton, _location_automaton_fingerprint

    if ahocorasick is None:
        return None

    fingerprint = (len(_location_cache), len(province_map), len(district_fallback))
    if _location_automaton is not None and _location_automaton_fingerprint == fingerprint:
        return _location_automaton

    from app.ner.cache import to_canonical

    keys: set[str] = set(_location_cache.keys())
    keys.update(to_canonical(k) for k in province_map.keys())
    keys.update(to_canonical(k) for k in district_fallback.keys())

    auto = ahocorasick.Automaton()
    for key in keys:
        if not key:
            continue
        auto.add_word(key, key)

    auto.make_automaton()
    _location_automaton = auto
    _location_automaton_fingerprint = fingerprint
    logger.info("[Extractor] Built Aho-Corasick location index: %d phrases", len(keys))
    return _location_automaton


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

    def _merge_entity(primary: dict, secondary: dict) -> dict:
        merged = dict(primary)

        # Fill missing normalized fields from the secondary candidate.
        for fld in (
            "business_type",
            "business_evidence",
            "business_phrase",
            "operator",
            "amount",
            "amount_max",
            "radius_meters",
            "distance_unit",
            "proximity_intent",
            "source_query",
        ):
            if merged.get(fld) is None and secondary.get(fld) is not None:
                merged[fld] = secondary.get(fld)

        # Distance-specific precedence: explicit extraction must override implicit intent.
        if merged.get("type") == "DISTANCE":
            if secondary.get("radius_meters") is not None and merged.get("radius_meters") is None:
                merged["radius_meters"] = secondary.get("radius_meters")

            # If either candidate says explicit distance, keep proximity_intent=False.
            if secondary.get("proximity_intent") is False:
                merged["proximity_intent"] = False

            # Prefer non-implicit unit when available.
            unit = merged.get("distance_unit")
            secondary_unit = secondary.get("distance_unit")
            if (not unit or unit == "implicit") and secondary_unit and secondary_unit != "implicit":
                merged["distance_unit"] = secondary_unit

        return merged

    for e in entities:
        key = f"{e['type']}::{e['value'].lower()}"
        if key not in seen:
            seen[key] = dict(e)
            continue

        current = seen[key]
        if e.get("confidence", 0) > current.get("confidence", 0):
            seen[key] = _merge_entity(dict(e), current)
        else:
            seen[key] = _merge_entity(current, e)

    return list(seen.values())


def _resolve_distance_priority(entities: list[dict]) -> list[dict]:
    """
    Keep at most one DISTANCE entity.

    If multiple explicit DISTANCE constraints exist (e.g., "trên 2km" + "dưới 5km"),
    merge them into a single range entity instead of dropping one side.
    """
    distances = [e for e in entities if e.get("type") == "DISTANCE"]
    if len(distances) <= 1:
        return entities

    explicit = [
        e for e in distances
        if e.get("radius_meters") is not None and e.get("proximity_intent") is False
    ]
    if explicit:
        merged = _merge_distance_constraints(explicit)
        chosen = merged if merged else max(explicit, key=lambda x: float(x.get("confidence", 0)))
    else:
        # Fall back to any distance with meters, then highest confidence.
        with_radius = [e for e in distances if e.get("radius_meters") is not None]
        pool = with_radius if with_radius else distances
        chosen = max(pool, key=lambda x: float(x.get("confidence", 0)))

    kept: list[dict] = []
    used_distance = False
    for e in entities:
        if e.get("type") != "DISTANCE":
            kept.append(e)
            continue
        if not used_distance:
            kept.append(chosen)
            used_distance = True

    return kept


def _merge_distance_constraints(distances: list[dict]) -> Optional[dict]:
    """Merge multiple DISTANCE entities into one coherent bound if possible."""
    if not distances:
        return None

    lowers: list[float] = []
    uppers: list[float] = []
    has_explicit = False

    for e in distances:
        op = str(e.get("operator") or "").lower().strip()
        amount = e.get("amount")
        amount_max = e.get("amount_max")
        radius = e.get("radius_meters")

        try:
            amount_f = float(amount) if amount is not None else None
        except (TypeError, ValueError):
            amount_f = None

        try:
            amount_max_f = float(amount_max) if amount_max is not None else None
        except (TypeError, ValueError):
            amount_max_f = None

        try:
            radius_f = float(radius) if radius is not None else None
        except (TypeError, ValueError):
            radius_f = None

        if e.get("proximity_intent") is False:
            has_explicit = True

        if op == "between":
            if amount_f is not None:
                lowers.append(amount_f)
            if amount_max_f is not None:
                uppers.append(amount_max_f)
            continue

        if op == "gte":
            if amount_f is not None:
                lowers.append(amount_f)
            if amount_max_f is not None:
                uppers.append(amount_max_f)
            continue

        if op == "lte":
            if amount_f is not None:
                uppers.append(amount_f)
            continue

        # Legacy fallback without operator: treat radius as upper bound.
        if radius_f is not None:
            uppers.append(radius_f)

    lower = max(lowers) if lowers else None
    upper = min(uppers) if uppers else None

    if lower is not None and upper is not None and lower > upper:
        return None

    chosen = dict(max(distances, key=lambda x: float(x.get("confidence", 0))))
    chosen["type"] = "DISTANCE"
    chosen["proximity_intent"] = False if has_explicit else chosen.get("proximity_intent")

    if lower is not None and upper is not None:
        chosen["operator"] = "between"
        chosen["amount"] = float(lower)
        chosen["amount_max"] = float(upper)
        chosen["radius_meters"] = int(upper)
        return chosen

    if upper is not None:
        chosen["operator"] = "lte"
        chosen["amount"] = float(upper)
        chosen["amount_max"] = None
        chosen["radius_meters"] = int(upper)
        return chosen

    if lower is not None:
        chosen["operator"] = "gte"
        chosen["amount"] = float(lower)
        chosen["amount_max"] = float(settings.MAX_PROXIMITY_RADIUS_M)
        # Keep compatibility for callers still reading radius_meters.
        chosen["radius_meters"] = int(lower)
        return chosen

    return chosen
