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

_BT_FALLBACK_KEYWORDS = {
    "massage trị liệu": "MASSAGE_REHABILITATION",
    "vật lý trị liệu": "MASSAGE_REHABILITATION",
    "phục hồi chức năng": "MASSAGE_REHABILITATION",
    "massage": "MASSAGE_THERAPY",
    "mát xa": "MASSAGE_THERAPY",
    "spa": "SPA_BEAUTY",
    "làm đẹp": "SPA_BEAUTY",
    "nha": "DENTAL",
    "tâm lý": "PSYCHOLOGY",
    "đông y": "TRADITIONAL_MEDICINE",
    "nhà thuốc": "PHARMACY",
}


def _strip_code_fence(text: str) -> str:
    text = text.strip()
    if text.startswith("```"):
        text = re.sub(r"^```[a-zA-Z]*", "", text).strip()
        text = re.sub(r"```$", "", text).strip()
    return text


def _guess_business_type_from_value(value: str) -> str | None:
    value_lower = value.lower().strip()
    for keyword, bt in _BT_FALLBACK_KEYWORDS.items():
        if keyword in value_lower:
            return bt
    return None


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

    # Default value comes from entity_name; for LOC prefer entity_value when present.
    if "value" not in normalized:
        entity_name = normalized.get("entity_name")
        entity_value = normalized.get("entity_value")
        if isinstance(entity_name, str) and entity_name.strip():
            normalized["value"] = entity_name.strip()
        elif isinstance(entity_value, str) and entity_value.strip():
            normalized["value"] = entity_value.strip()

    entity_type = str(normalized.get("type", "")).upper().strip()

    if entity_type == "BUSINESS_TYPE":
        # Some model variants send enum in entity_value or value instead of business_type.
        if "business_type" not in normalized:
            bt = normalized.get("entity_value") or normalized.get("value")
            if isinstance(bt, str) and bt.strip():
                normalized["business_type"] = bt.strip().upper()

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


def _sanitize_entity(entity: dict[str, Any], text: str) -> dict[str, Any] | None:
    entity_type = str(entity.get("type", "")).upper().strip()

    # Keep LOCATION compatible with current normalizer pipeline.
    if entity_type == "LOCATION":
        entity_type = "LOC"

    if entity_type not in _ALLOWED_TYPES:
        return None

    raw_value = entity.get("value", "")
    value = str(raw_value).strip()
    if not value:
        return None

    try:
        confidence = float(entity.get("confidence", 0.8))
    except (TypeError, ValueError):
        confidence = 0.8
    confidence = max(0.0, min(1.0, confidence))

    cleaned: dict[str, Any] = {
        "type": entity_type,
        "value": value,
        "confidence": confidence,
    }

    if entity_type == "BUSINESS_TYPE":
        bt = str(entity.get("business_type", "")).strip().upper()
        if bt not in _ALLOWED_BUSINESS_TYPES:
            bt = _guess_business_type_from_value(value) or ""
        if bt in _ALLOWED_BUSINESS_TYPES:
            cleaned["business_type"] = bt
        else:
            return None

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

        unit = entity.get("distance_unit")
        if isinstance(unit, str) and unit.strip():
            cleaned["distance_unit"] = unit.strip()

        proximity = entity.get("proximity_intent")
        if isinstance(proximity, bool):
            cleaned["proximity_intent"] = proximity
        elif isinstance(proximity, str) and proximity.strip().lower() in {"near_me", "nearby", "near"}:
            cleaned["proximity_intent"] = True

        if cleaned.get("proximity_intent") is True and "radius_meters" not in cleaned:
            cleaned["radius_meters"] = 5000
            cleaned.setdefault("distance_unit", "implicit")

    # Carry source query for downstream location-intent scoring.
    if entity_type == "LOC":
        cleaned["source_query"] = text

    return cleaned


async def extract_entities_with_gemini(text: str) -> list[dict] | None:
    """
    Returns:
      - list[dict]: parsed entities from Gemini (possibly empty)
      - None: Gemini unavailable/failed, caller should fallback to legacy extractor
    """
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

    prompt = (
        "Bạn là engine trích xuất NER cho truy vấn tìm dịch vụ y tế/chăm sóc sức khỏe tại Việt Nam. "
        "Trả về DUY NHẤT JSON array, không markdown, không giải thích. "
        "Mỗi phần tử là object có các key cần thiết."
        "\n\n"
        "Allowed type: LOC, ORG, PER, MISC, BUSINESS_TYPE, PRICE, RATING, DISTANCE. "
        "Nếu bạn nghĩ LOCATION thì hãy dùng LOC để tương thích hệ thống."
        "\n"
        "BUSINESS_TYPE phải là một trong: "
        "SPA_BEAUTY, FITNESS, DENTAL, MASSAGE_THERAPY, MASSAGE_REHABILITATION, "
        "PSYCHOLOGY, PSYCHIATRY, DERMATOLOGY, NUTRITION, TRADITIONAL_MEDICINE, PHARMACY."
        "\n"
        "PRICE/RATING có thể gồm operator (lte|gte|between), amount, amount_max."
        "\n"
        "DISTANCE có thể gồm radius_meters, distance_unit, proximity_intent."
        "\n\n"
        f"Query: {text}"
    )

    url = f"{settings.GEMINI_API_BASE_URL}/models/{settings.GEMINI_MODEL}:generateContent"
    timeout_sec = max(0.2, settings.GEMINI_TIMEOUT_MS / 1000.0)

    body = {
        "contents": [
            {
                "parts": [
                    {"text": prompt}
                ]
            }
        ],
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
        parsed = json.loads(raw_text)
    except Exception as exc:
        logger.warning(
            "[GeminiNER] Invalid response shape/content: %s | payload_preview=%s",
            exc,
            _preview_for_log(payload),
        )
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
        cleaned = _sanitize_entity(_canonicalize_raw_entity(item), text)
        if cleaned is not None:
            entities.append(cleaned)
        else:
            dropped += 1

    if not entities:
        logger.warning(
            "[GeminiNER] No usable entities after sanitization (dropped=%s, parsed=%s) | raw_text=%s | parsed=%s",
            dropped,
            len(parsed),
            _preview_for_log(raw_text),
            _preview_for_log(parsed),
        )

    return entities
