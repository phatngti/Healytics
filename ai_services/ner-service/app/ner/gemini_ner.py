import json
import logging
import re
import asyncio
import time
from typing import Any

import httpx

from app.core.config import settings

logger = logging.getLogger(__name__)

# In-memory cooldown is process-local. In multi-worker deployments,
# use a shared store (e.g. Redis) for cross-worker rate-limit coordination.
_cooldown_until_ts: float = 0.0

_ALLOWED_TYPES = {
    "LOC",
    "ORG",
    "PER",
    "MISC",
    "BUSINESS_TYPE",
    "PRICE",
    "RATING",
    "DISTANCE",
}

_LOG_PREVIEW_MAX_CHARS = 1200

_ALLOWED_BUSINESS_TYPES = {
    "SPA_BEAUTY",
    "FITNESS",
    "DENTAL",
    "MASSAGE_THERAPY",
    "MASSAGE_REHABILITATION",
    "PSYCHOLOGY",
    "PSYCHIATRY",
    "DERMATOLOGY",
    "NUTRITION",
    "TRADITIONAL_MEDICINE",
    "PHARMACY",
}

# ============================================================================
# Validation constants and functions
# ============================================================================

VALID_LOCATION_CODES = {
    # Provinces
    "01", "79", "48",  # HN, HCM, DN
    # HCM Districts
    "760", "769", "770", "771", "773", "774", "775", "776", "777", "778",
    "761", "762", "763", "764", "765", "766", "767", "768",
    # HN Districts  
    "001", "002", "003", "005", "006", "007", "008", "009",
    "016", "017", "018", "019", "020", "021",
    # DN Districts
    "490", "491", "492", "493",
}

GENERIC_WORDS = {
    "dịch vụ", "service", "ở", "tìm", "find", "cần", "need",
    "gần", "near", "khu vực", "area", "tại", "at", "trong", "in",
    "cao cấp", "premium", "chất lượng", "quality", "tốt", "good"
}


def _validate_location_code(entity: dict) -> bool:
    """
    Validate location code is in whitelist.
    Returns True if valid or no location_code, False if invalid.
    """
    loc_code = entity.get("location_code")
    if not loc_code:
        return True
    
    loc_code_str = str(loc_code).strip()
    
    if loc_code_str not in VALID_LOCATION_CODES:
        logger.warning(
            "[ValidationPenalty] Invalid location_code rejected: %s (entity: %s)",
            loc_code_str,
            entity.get("value", "")
        )
        return False
    
    return True


def _validate_business_evidence(entity: dict, query_text: str) -> bool:
    """
    Validate BUSINESS_TYPE has legitimate evidence.
    Returns True if valid, False if should reject.
    """
    if entity.get("type") != "BUSINESS_TYPE":
        return True
    
    evidence = entity.get("business_evidence", "").strip().lower()
    
    # Must have evidence
    if not evidence:
        logger.warning(
            "[ValidationPenalty] BUSINESS_TYPE without evidence rejected: %s",
            entity.get("business_type", "")
        )
        return False
    
    # Evidence must be in query
    if evidence not in query_text.lower():
        logger.warning(
            "[ValidationPenalty] BUSINESS_TYPE evidence not in query: '%s' | query: '%s'",
            evidence,
            query_text[:50]
        )
        return False
    
    # Evidence must not be generic word ONLY
    evidence_words = set(evidence.split())
    if evidence_words.issubset(GENERIC_WORDS):
        logger.warning(
            "[ValidationPenalty] BUSINESS_TYPE with generic evidence rejected: '%s'",
            evidence
        )
        return False
    
    return True


def _strip_code_fence(text: str) -> str:
    text = text.strip()
    if text.startswith("```"):
        text = re.sub(r"^```[a-zA-Z]*", "", text).strip()
        text = re.sub(r"```$", "", text).strip()
    return text


def _extract_outermost_json_block(text: str) -> str:
    """
    Extract the outermost JSON object/array from a possibly padded LLM response.

    This intentionally avoids regex-based extraction to prevent greedy/ambiguous
    captures when the model includes conversational text before/after JSON.
    """
    if not text:
        return text

    first_brace, last_brace = text.find("{"), text.rfind("}")
    first_bracket, last_bracket = text.find("["), text.rfind("]")

    candidates: list[tuple[int, int]] = []
    if first_brace != -1 and last_brace > first_brace:
        candidates.append((first_brace, last_brace + 1))
    if first_bracket != -1 and last_bracket > first_bracket:
        candidates.append((first_bracket, last_bracket + 1))

    if not candidates:
        return text

    for start, end in sorted(candidates, key=lambda item: item[0]):
        candidate = text[start:end]
        try:
            json.loads(candidate)
            return candidate
        except Exception:
            continue

    # Fallback to the earliest bounds if both parse checks fail.
    start, end = min(candidates, key=lambda item: item[0])
    return text[start:end]


def _preview_for_log(value: Any, max_chars: int = _LOG_PREVIEW_MAX_CHARS) -> str:
    """Render a compact JSON-ish preview for logs to help debugging bad model outputs."""
    try:
        text = value if isinstance(value, str) else json.dumps(value, ensure_ascii=False)
    except Exception:
        text = str(value)
    text = text.replace("\n", " ").replace("\r", " ").strip()
    if len(text) > max_chars:
        return f"{text[:max_chars]}...<truncated {len(text) - max_chars} chars>"
    return text


def _canonicalize_raw_entity(entity: dict[str, Any]) -> dict[str, Any]:
    """Normalize variant Gemini field names to the schema expected by _sanitize_entity."""
    normalized = dict(entity)

    if "type" not in normalized and "entity_type" in normalized:
        normalized["type"] = normalized.get("entity_type")

    # Accept common field aliases from different Gemini prompt versions.
    if "value" not in normalized:
        entity_name = normalized.get("entity_name")
        entity_value = normalized.get("entity_value")
        legacy_entity = normalized.get("entity")
        if isinstance(entity_name, str) and entity_name.strip():
            normalized["value"] = entity_name.strip()
        elif isinstance(entity_value, str) and entity_value.strip():
            normalized["value"] = entity_value.strip()
        elif isinstance(legacy_entity, str) and legacy_entity.strip():
            normalized["value"] = legacy_entity.strip()

    entity_type = str(normalized.get("type", "")).upper().strip()

    if entity_type == "BUSINESS_TYPE":
        # Some model variants send enum in entity_value or value instead of business_type.
        if "business_type" not in normalized:
            bt = normalized.get("entity_value") or normalized.get("value")
            if isinstance(bt, str) and bt.strip():
                normalized["business_type"] = bt.strip().upper()
            elif isinstance(bt, list):
                bt_list = [str(item).strip().upper() for item in bt if str(item).strip()]
                if bt_list:
                    normalized["business_type"] = bt_list

        # Keep optional evidence text for downstream semantic disambiguation.
        if "business_evidence" not in normalized:
            evidence = (
                normalized.get("business_phrase")
                or normalized.get("matched_phrase")
                or normalized.get("evidence_phrase")
                or normalized.get("evidence")
                or normalized.get("keyword")
                or normalized.get("span")
                or normalized.get("excerpt")
            )
            if isinstance(evidence, str) and evidence.strip():
                normalized["business_evidence"] = evidence.strip()

        # Keep the human-readable phrase as value when available.
        entity_name = normalized.get("entity_name")
        if isinstance(entity_name, str) and entity_name.strip():
            normalized["value"] = entity_name.strip()

    if entity_type in {"LOC", "LOCATION"}:
        # Prefer canonical location phrase if model provided it separately.
        loc_value = normalized.get("entity_value")
        if isinstance(loc_value, str) and loc_value.strip():
            normalized["value"] = loc_value.strip()

    return normalized


def _sanitize_entities(entity: dict[str, Any], text: str) -> list[dict[str, Any]]:
    entity_type = str(entity.get("type", "")).upper().strip()

    # Keep LOCATION compatible with current normalizer pipeline.
    if entity_type == "LOCATION":
        entity_type = "LOC"

    if entity_type not in _ALLOWED_TYPES:
        return []

    raw_value = entity.get("value", "")
    value = str(raw_value).strip()
    if not value:
        return []

    # Extract confidence from Gemini response
    confidence_raw = entity.get("confidence")
    if confidence_raw is None:
        confidence = 0.85  # Default to high confidence if not provided
        logger.debug(
            "[Confidence] Entity missing confidence field, using default 0.85: %s",
            entity.get("type")
        )
    else:
        try:
            confidence = float(confidence_raw)
        except (TypeError, ValueError):
            logger.warning(
                "[Confidence] Invalid confidence value '%s', using default 0.85: %s",
                confidence_raw,
                entity.get("type")
            )
            confidence = 0.85
    
    confidence = max(0.0, min(1.0, confidence))

    cleaned: dict[str, Any] = {
        "type": entity_type,
        "value": value,
        "confidence": confidence,
    }

    # Validate location code (only for LOCATION entities)
    if entity_type == "LOC" and not _validate_location_code(entity):
        logger.warning(
            "[ValidationPenalty] Entity rejected due to invalid location_code"
        )
        return []

    # ============================================================================
    # BUSINESS_TYPE SPECIFIC PROCESSING
    # ============================================================================
    if entity_type == "BUSINESS_TYPE":
        # Apply confidence threshold filter ONLY for BUSINESS_TYPE
        # Based on evaluation: FP cluster at 0.75, TP cluster at 0.9
        # Threshold 0.8 filters all FP while losing only 5/103 TP
        if confidence < settings.NER_MIN_CONFIDENCE:
            logger.info(
                "[ConfidenceFilter] Rejected BUSINESS_TYPE with low confidence %.2f < %.2f threshold",
                confidence,
                settings.NER_MIN_CONFIDENCE
            )
            return []
        
        # Validate business evidence
        if not _validate_business_evidence(entity, text):
            logger.warning(
                "[ValidationPenalty] BUSINESS_TYPE rejected due to invalid evidence"
            )
            return []
        raw_bt = entity.get("business_type")
        bt_candidates: list[str] = []
        if isinstance(raw_bt, str):
            bt = raw_bt.strip().upper()
            if bt:
                bt_candidates.append(bt)
        elif isinstance(raw_bt, list):
            for item in raw_bt:
                bt = str(item).strip().upper()
                if bt:
                    bt_candidates.append(bt)

        # Preserve order while deduplicating.
        bt_candidates = list(dict.fromkeys(bt_candidates))
        valid_bts = [bt for bt in bt_candidates if bt in _ALLOWED_BUSINESS_TYPES]

        if not valid_bts:
            return []

        evidence = str(entity.get("business_evidence") or entity.get("business_phrase") or "").strip()
        if evidence:
            cleaned["business_evidence"] = evidence
            cleaned["business_phrase"] = evidence
        else:
            cleaned["business_evidence"] = value
            cleaned["business_phrase"] = value

        exploded: list[dict[str, Any]] = []
        for bt in valid_bts:
            item = dict(cleaned)
            item["business_type"] = bt
            exploded.append(item)
        return exploded

    if entity_type in {"PRICE", "RATING"}:
        operator = entity.get("operator")
        if operator in {"lte", "gte", "between"}:
            cleaned["operator"] = operator

        amount = entity.get("amount")
        if amount is not None:
            try:
                cleaned["amount"] = float(amount)
            except (ValueError, TypeError):
                pass

        amount_max = entity.get("amount_max")
        if amount_max is not None:
            try:
                cleaned["amount_max"] = float(amount_max)
            except (ValueError, TypeError):
                pass

    if entity_type == "DISTANCE":
        if isinstance(raw_value, dict):
            # Some model outputs pack distance signals inside `value` object.
            if "proximity_intent" in raw_value and "proximity_intent" not in entity:
                entity["proximity_intent"] = raw_value.get("proximity_intent")
            if "radius_meters" in raw_value and "radius_meters" not in entity:
                entity["radius_meters"] = raw_value.get("radius_meters")
            if "distance_unit" in raw_value and "distance_unit" not in entity:
                entity["distance_unit"] = raw_value.get("distance_unit")
            value = "gần tôi" if str(raw_value.get("proximity_intent", "")).lower() in {"near_me", "nearby", "near"} else value
            cleaned["value"] = value

        radius = entity.get("radius_meters")
        if radius is not None:
            try:
                cleaned["radius_meters"] = int(max(1, min(50000, float(radius))))
            except (ValueError, TypeError):
                pass

        operator = entity.get("operator")
        if isinstance(operator, str):
            operator = operator.strip().lower()
            if operator in {"lte", "gte", "between"}:
                cleaned["operator"] = operator

        amount = entity.get("amount")
        if amount is not None:
            try:
                cleaned["amount"] = float(amount)
            except (ValueError, TypeError):
                pass

        amount_max = entity.get("amount_max")
        if amount_max is not None:
            try:
                cleaned["amount_max"] = float(amount_max)
            except (ValueError, TypeError):
                pass

        unit = entity.get("distance_unit")
        if isinstance(unit, str) and unit.strip():
            cleaned["distance_unit"] = unit.strip()

        proximity = entity.get("proximity_intent")
        if isinstance(proximity, bool):
            cleaned["proximity_intent"] = proximity
        elif isinstance(proximity, str) and proximity.strip().lower() in {"near_me", "nearby", "near"}:
            cleaned["proximity_intent"] = True

        if cleaned.get("proximity_intent") is True and "radius_meters" not in cleaned:
            cleaned["radius_meters"] = settings.DEFAULT_PROXIMITY_RADIUS_M
            cleaned.setdefault("operator", "lte")
            cleaned.setdefault("amount", float(settings.DEFAULT_PROXIMITY_RADIUS_M))
            cleaned.setdefault("distance_unit", "implicit")

    # Carry source query for downstream location-intent scoring.
    if entity_type == "LOC":
        cleaned["source_query"] = text

    return [cleaned]


async def _request_gemini_json(prompt: str) -> Any | None:
    """Call Gemini once and return parsed JSON body (list/dict) or None on failure."""
    if not settings.LLM_NER_ENABLED:
        return None

    global _cooldown_until_ts

    api_key = settings.GEMINI_API_KEY.strip()
    if not api_key:
        logger.warning("[GeminiNER] LLM_NER_ENABLED=true but GEMINI_API_KEY is empty")
        return None

    now = time.time()
    if now < _cooldown_until_ts:
        remaining = int(max(1, _cooldown_until_ts - now))
        logger.warning("[GeminiNER] Cooldown active after rate-limit, skip Gemini call for %ss", remaining)
        return None

    url = f"{settings.GEMINI_API_BASE_URL}/models/{settings.GEMINI_MODEL}:generateContent"
    timeout_sec = max(0.2, settings.GEMINI_TIMEOUT_MS / 1000.0)
    body = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "temperature": 0.0,
            "response_mime_type": "application/json",
        },
    }

    max_retries = max(0, settings.GEMINI_MAX_RETRIES)
    backoff_ms = max(50, settings.GEMINI_RETRY_BACKOFF_MS)

    payload = None
    for attempt in range(max_retries + 1):
        try:
            async with httpx.AsyncClient(timeout=timeout_sec) as client:
                response = await client.post(url, params={"key": api_key}, json=body)
                response.raise_for_status()
                payload = response.json()
                break
        except httpx.HTTPStatusError as exc:
            status_code = exc.response.status_code

            if status_code == 429:
                cooldown = max(1, settings.GEMINI_COOLDOWN_SECONDS)
                _cooldown_until_ts = max(_cooldown_until_ts, time.time() + cooldown)
                logger.warning("[GeminiNER] Rate limited (429). Enter cooldown for %ss", cooldown)
                return None

            if 500 <= status_code < 600 and attempt < max_retries:
                sleep_sec = (backoff_ms * (2 ** attempt)) / 1000.0
                await asyncio.sleep(sleep_sec)
                continue

            logger.warning("[GeminiNER] API call failed with HTTP %s", status_code)
            return None
        except (httpx.TimeoutException, httpx.TransportError) as exc:
            if attempt < max_retries:
                sleep_sec = (backoff_ms * (2 ** attempt)) / 1000.0
                logger.warning(
                    "[GeminiNER] transient error on attempt %s/%s: %s (retry in %.2fs)",
                    attempt + 1,
                    max_retries + 1,
                    exc,
                    sleep_sec,
                )
                await asyncio.sleep(sleep_sec)
                continue
            logger.warning("[GeminiNER] API call failed after retries: %s", exc)
            return None
        except Exception as exc:
            logger.warning("[GeminiNER] API call failed: %s", exc)
            return None

    if payload is None:
        return None

    try:
        raw_text = payload["candidates"][0]["content"]["parts"][0]["text"]
        raw_text = _strip_code_fence(raw_text)
        raw_text = _extract_outermost_json_block(raw_text)
        return json.loads(raw_text)
    except Exception as exc:
        logger.warning(
            "[GeminiNER] Invalid response shape/content: %s | payload_preview=%s",
            exc,
            _preview_for_log(payload),
        )
        return None


async def select_requested_location_with_gemini(
    text: str,
    location_candidates: list[dict[str, Any]],
) -> dict[str, Any] | None:
    """
    Ask Gemini which location is truly requested in query.

    Returns dict with keys:
      - selected_location_code: str | None
      - apply_filter: bool
      - confidence: float
      - excluded_location_codes: list[str]
      - reason: str
    """
    if not text or not location_candidates:
        return None

    normalized_candidates: list[dict[str, Any]] = []
    seen_codes: set[str] = set()
    for c in location_candidates:
        code = str(c.get("location_code") or "").strip()
        value = str(c.get("value") or "").strip()
        if not code or not value or code in seen_codes:
            continue
        seen_codes.add(code)
        normalized_candidates.append(
            {
                "location_code": code,
                "value": value,
                "location_level": str(c.get("location_level") or "").upper() or None,
                "confidence": float(c.get("confidence") or 0.0),
            }
        )

    if not normalized_candidates:
        return None

    prompt = (
        "Bạn là bộ chọn vị trí thật sự được yêu cầu trong truy vấn tìm dịch vụ. "
        "Từ danh sách candidates, chọn DUY NHẤT một vị trí user muốn lọc kết quả, "
        "các vị trí còn lại coi là nhiễu nếu không phải ý định lọc. "
        "Trả về DUY NHẤT 1 JSON object với keys chính xác: "
        "selected_location_code, apply_filter, confidence, excluded_location_codes, reason. "
        "Không markdown, không giải thích ngoài reason.\n"
        "Ràng buộc: selected_location_code phải thuộc candidates hoặc null nếu không có ý định lọc vị trí.\n"
        "Nếu apply_filter=true thì selected_location_code phải khác null.\n"
        "excluded_location_codes là mảng code thuộc candidates nhưng không được chọn.\n\n"
        f"Query: {text}\n"
        f"Location candidates: {json.dumps(normalized_candidates, ensure_ascii=False)}"
    )

    parsed = await _request_gemini_json(prompt)
    if parsed is None or not isinstance(parsed, dict):
        return None

    allowed_codes = {c["location_code"] for c in normalized_candidates}
    selected_code_raw = parsed.get("selected_location_code")
    selected_code = str(selected_code_raw).strip() if selected_code_raw is not None else None
    if selected_code and selected_code not in allowed_codes:
        logger.warning("[GeminiLocSelect] selected_location_code not in candidates: %s", selected_code)
        return None

    apply_filter_raw = parsed.get("apply_filter")
    if isinstance(apply_filter_raw, bool):
        apply_filter = apply_filter_raw
    elif isinstance(apply_filter_raw, str):
        apply_filter = apply_filter_raw.strip().lower() in {"1", "true", "yes", "y"}
    else:
        apply_filter = bool(selected_code)

    if apply_filter and not selected_code:
        apply_filter = False

    confidence_raw = parsed.get("confidence")
    try:
        confidence = float(confidence_raw)
    except (TypeError, ValueError):
        confidence = 0.7
    confidence = max(0.0, min(1.0, confidence))

    excluded: list[str] = []
    excluded_raw = parsed.get("excluded_location_codes")
    if isinstance(excluded_raw, list):
        for code in excluded_raw:
            code_str = str(code).strip()
            if code_str in allowed_codes and code_str != selected_code and code_str not in excluded:
                excluded.append(code_str)

    if selected_code:
        for code in allowed_codes:
            if code != selected_code and code not in excluded:
                excluded.append(code)
    else:
        excluded = sorted(list(allowed_codes))

    return {
        "selected_location_code": selected_code,
        "apply_filter": apply_filter,
        "confidence": confidence,
        "excluded_location_codes": excluded,
        "reason": str(parsed.get("reason") or "").strip(),
    }


async def extract_entities_with_gemini(text: str) -> list[dict] | None:
    """
    Returns:
      - list[dict]: parsed entities from Gemini (possibly empty)
      - None: Gemini unavailable/failed, caller should fallback to legacy extractor
    """
    prompt = (
        "Bạn là bộ trích xuất NER cho truy vấn dịch vụ y tế/chăm sóc sức khỏe tại Việt Nam. "
        "Trả về DUY NHẤT một JSON array, không markdown, không giải thích. "
        "Mỗi phần tử phải có các key: 'type', 'value', 'confidence'. "
        "BẮT BUỘC dùng key 'type' và 'value' (không dùng entity/entity_name/entity_value)."
        "\n\n"
        "Các type hợp lệ: LOC, ORG, PER, MISC, BUSINESS_TYPE, PRICE, RATING, DISTANCE. "
        "Nếu là vị trí thì luôn dùng LOC (không dùng LOCATION)."
        "\n"
        "BUSINESS_TYPE chỉ được chọn trong đúng 11 loại sau: "
        "SPA_BEAUTY, FITNESS, DENTAL, MASSAGE_THERAPY, MASSAGE_REHABILITATION, "
        "PSYCHOLOGY, PSYCHIATRY, DERMATOLOGY, NUTRITION, TRADITIONAL_MEDICINE, PHARMACY."
        "\n"
        "Quy tắc BUSINESS_TYPE (STRICT MODE - BẮT BUỘC TUÂN THỦ): "
        "(1) CHỈ trả BUSINESS_TYPE khi có BẮT BUỘC cụm từ RÕ RÀNG về loại hình dịch vụ. "
        "(2) NGHIÊM CẤM suy diễn BUSINESS_TYPE từ context chung chung như 'dịch vụ', 'ở', 'tìm'. "
        "(3) NGHIÊM CẤM trả BUSINESS_TYPE nếu query CHỈ có location/price/distance. "
        "(4) Nếu KHÔNG CHẮC hoặc không thuộc 11 loại → KHÔNG trả BUSINESS_TYPE (trả MISC hoặc bỏ qua). "
        "(5) Với mỗi BUSINESS_TYPE, BẮT BUỘC phải có 'business_evidence' chứa EXACT substring từ query. "
        "(6) Evidence PHẢI là keyword RÕ RÀNG, KHÔNG được là từ chung chung ('dịch vụ', 'ở', 'tìm', 'gần'). "
        "(7) Nếu query thể hiện rõ NHIỀU loại hình, cho phép trả 'business_type' dưới dạng array enum, "
        "ví dụ ['SPA_BEAUTY','FITNESS']; nếu chỉ 1 loại thì dùng string như bình thường."
        "\n"
        "Quy tắc LOC: nếu query có địa danh rõ ràng (tỉnh/thành/quận/huyện/phường), luôn trả LOC với value là cụm địa danh gốc trong query."
        "\n"
        "Query có thể là tiếng Việt hoặc tiếng Anh, nhưng output luôn phải theo schema và enum ở trên."
        "\n"
        "PRICE/RATING có thể gồm operator (lte|gte|between), amount, amount_max."
        "\n"
        "DISTANCE có thể gồm operator (lte|gte|between), amount, amount_max, radius_meters, distance_unit, proximity_intent."
        "\n\n"
        "Ví dụ 1 (POSITIVE - có keyword rõ ràng): "
        "query='tìm spa và phòng gym ở hồ chí minh' => "
        "[{\"type\":\"BUSINESS_TYPE\",\"value\":\"spa và phòng gym\",\"confidence\":0.9,\"business_type\":[\"SPA_BEAUTY\",\"FITNESS\"],\"business_evidence\":\"spa và phòng gym\"},"
        "{\"type\":\"LOC\",\"value\":\"hồ chí minh\",\"confidence\":0.9}]"
        "\n"
        "Ví dụ 2 (POSITIVE - keyword rõ nhưng không thuộc 11 loại): "
        "query='dịch vụ chăm sóc toàn diện cho người cao tuổi' => "
        "[{\"type\":\"MISC\",\"value\":\"chăm sóc toàn diện\",\"confidence\":0.6}]"
        "\n"
        "Ví dụ 3 (NEGATIVE - CHỈ có location): "
        "query='Ở quận một' => [{\"type\":\"LOC\",\"value\":\"quận một\",\"confidence\":0.9}]"
        "\n"
        "Ví dụ 4 (NEGATIVE - CHỈ có price): "
        "query='Giá 2 triệu' => [{\"type\":\"PRICE\",\"value\":\"2 triệu\",\"confidence\":0.9,\"operator\":\"between\",\"amount\":1700000,\"amount_max\":2300000}]"
        "\n"
        "Ví dụ 5 (NEGATIVE - location + price, KHÔNG có business keyword): "
        "query='Dịch vụ ở Q1 giá 500k' => "
        "[{\"type\":\"LOC\",\"value\":\"Q1\",\"confidence\":0.9},"
        "{\"type\":\"PRICE\",\"value\":\"500k\",\"confidence\":0.9,\"operator\":\"between\",\"amount\":425000,\"amount_max\":575000}]"
        "\n"
        "Ví dụ 6 (NEGATIVE - từ chung chung): "
        "query='Dịch vụ y tế' => [{\"type\":\"MISC\",\"value\":\"dịch vụ y tế\",\"confidence\":0.5}]"
        "\n"
        "Ví dụ 7 (NEGATIVE - không thuộc 11 loại): "
        "query='bệnh viện' => [{\"type\":\"MISC\",\"value\":\"bệnh viện\",\"confidence\":0.6}]"
        "\n\n"
        "⚠️ PENALTY: Nếu trả BUSINESS_TYPE không đúng quy tắc strict trên, output sẽ bị REJECT. "
        "Vì vậy, khi KHÔNG CHẮC → đừng trả BUSINESS_TYPE. Better safe than sorry!"
        "\n\n"
        f"Query: {text}"
    )

    parsed = await _request_gemini_json(prompt)
    if parsed is None:
        return None

    if not isinstance(parsed, list):
        logger.warning("[GeminiNER] Response is not a JSON array")
        return None

    if not parsed:
        logger.warning("[GeminiNER] Model returned an empty entity array")
        return []

    entities: list[dict] = []
    dropped = 0
    for item in parsed:
        if not isinstance(item, dict):
            dropped += 1
            continue
        cleaned_list = _sanitize_entities(_canonicalize_raw_entity(item), text)
        if cleaned_list:
            entities.extend(cleaned_list)
        else:
            dropped += 1

    if not entities:
        logger.warning(
            "[GeminiNER] No usable entities after sanitization (dropped=%s, parsed=%s) | payload=%s",
            dropped,
            len(parsed),
            _preview_for_log(parsed),
        )

    return entities
