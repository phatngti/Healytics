"""
Distance/Proximity entity extraction for Vietnamese text.

Pipeline:
  1. Extract explicit distances (e.g., "5km", "500m", "2 cây số")
  2. Detect implicit proximity intents (e.g., "gần đây", "quanh đây")
  3. Normalize units to meters
  4. Priority: explicit distance overrides implicit

Returns: List[dict] with:
  - radius_meters: extracted distance in meters
  - distance_unit: original unit string (km, m, cây số, dặm)
  - proximity_intent: bool (True if implicit like "gần đây")
  - confidence: float (0.0-1.0)
"""

import re
import logging
from typing import List, Dict, Optional, Tuple

from app.core.config import settings

logger = logging.getLogger(__name__)

# ============================================================================
# Regex patterns for explicit distance extraction
# ============================================================================

# Explicit distance patterns with Vietnamese units.
_NUM_PATTERN = r"\d+(?:[.,]\d+)?"
_UNIT_PATTERN = r"(?:km|m|cây\s*số|dặm)"

EXPLICIT_DISTANCE_PATTERN = rf"({_NUM_PATTERN})\s*({_UNIT_PATTERN})"
_EXPLICIT_SINGLE_RE = re.compile(EXPLICIT_DISTANCE_PATTERN, re.IGNORECASE)

# Range: "từ 2km đến 5km", "khoảng 2 tới 5km", "tầm 1.5km - 3km"
_DISTANCE_RANGE_RE = re.compile(
    rf"(?:từ|trong\s+khoảng|khoảng|tầm|cỡ)\s*({_NUM_PATTERN})\s*({_UNIT_PATTERN})?\s*(?:đến|tới|-|–|—)\s*({_NUM_PATTERN})\s*({_UNIT_PATTERN})?",
    re.IGNORECASE,
)

# Single-sided bounds
_DISTANCE_LOWER_RE = re.compile(
    rf"(?:trên|hơn|xa\s+hơn|tối\s+thiểu|ít\s+nhất|>=|>)\s*({_NUM_PATTERN})\s*({_UNIT_PATTERN})",
    re.IGNORECASE,
)
_DISTANCE_UPPER_RE = re.compile(
    rf"(?:dưới|trong\s+vòng|không\s+quá|tối\s+đa|<=|<)\s*({_NUM_PATTERN})\s*({_UNIT_PATTERN})",
    re.IGNORECASE,
)

# Implicit proximity patterns - ordered most specific → least specific
# Only trigger when "gần" = "near [me/here]", NOT "almost" (gần xong, gần bằng, gần cuối)
IMPLICIT_PROXIMITY_PATTERNS = [
    r"gần\s+(?:đây|chỗ\s*(?:này|đó)?|nơi\s*(?:này|đó)?|tôi|mình|đó|nhà)",  # gần đây / gần chỗ / gần tôi / gần nhà
    r"gần\s+khu\s+vực",            # gần khu vực
    r"quanh\s+(?:đây|chỗ|nơi)",    # quanh đây / quanh chỗ
    r"xung\s+quanh",               # xung quanh
    r"ở\s+gần",                    # ở gần
    r"lân\s+cận",                  # lân cận
]

# ============================================================================
# Unit conversion to meters
# ============================================================================
UNIT_TO_METERS = {
    "km": 1000,
    "m": 1,
    "cây số": 1000,  # Vietnamese: "cây số" = kilometre (from French poteau kilométrique) = 1000m
    "dặm": 1609,     # Vietnamese: 1 dặm ≈ 1609m (statute mile)
}

# ============================================================================
# Extract Distance Entities
# ============================================================================

def extract_distance_entities(text: str) -> List[Dict]:
    """
    Extract distance/proximity entities from Vietnamese text.

    Returns:
      - Empty list if no distance found
      - List with single DISTANCE entity if explicit distance found
      - List with single DISTANCE entity (proximity_intent=True) if only implicit found
      - Explicit distances take priority over implicit
    """

    text_lower = text.lower()

    # Priority 1: Extract explicit distances (5km, 500m, 2 cây số)
    explicit_match = _extract_explicit_distance(text_lower)
    if explicit_match:
        return [explicit_match]

    # Priority 2: Check for implicit proximity intents (gần đây, quanh đây)
    implicit_match = _extract_implicit_proximity(text_lower)
    if implicit_match:
        return [implicit_match]

    # No distance found
    return []


def _extract_explicit_distance(text: str) -> Optional[Dict]:
    """Extract explicit distance with optional range semantics (lte/gte/between)."""
    max_radius_m = max(settings.MAX_PROXIMITY_RADIUS_M, settings.DEFAULT_PROXIMITY_RADIUS_M)

    def _norm_unit(unit: Optional[str]) -> Optional[str]:
        if not unit:
            return None
        unit_str = unit.lower().strip()
        if unit_str.startswith("cây"):
            return "cây số"
        if unit_str.startswith("dặm"):
            return "dặm"
        if unit_str == "km":
            return "km"
        if unit_str == "m":
            return "m"
        return None

    def _to_meters(num_raw: str, unit_raw: Optional[str]) -> Optional[Tuple[int, str]]:
        unit_key = _norm_unit(unit_raw)
        if not unit_key:
            return None
        try:
            value = float(num_raw.replace(",", "."))
        except ValueError:
            return None
        meters = int(value * UNIT_TO_METERS[unit_key])
        if meters < 1 or meters > max_radius_m:
            return None
        return meters, unit_key

    # 1) Explicit range: from X to Y
    range_match = _DISTANCE_RANGE_RE.search(text)
    if range_match:
        left_num, left_unit_raw, right_num, right_unit_raw = range_match.groups()
        left_unit = _norm_unit(left_unit_raw) or _norm_unit(right_unit_raw)
        right_unit = _norm_unit(right_unit_raw) or _norm_unit(left_unit_raw)
        if left_unit and right_unit:
            left = _to_meters(left_num, left_unit)
            right = _to_meters(right_num, right_unit)
            if left and right:
                lo_m = min(left[0], right[0])
                hi_m = max(left[0], right[0])
                return {
                    "type": "DISTANCE",
                    "value": range_match.group(0).strip(),
                    "operator": "between",
                    "amount": float(lo_m),
                    "amount_max": float(hi_m),
                    "radius_meters": hi_m,
                    "distance_unit": right[1],
                    "proximity_intent": False,
                    "confidence": 1.0,
                }

    # 2) Combined lower/upper bounds in one query, e.g., "trên 2km dưới 5km"
    lower_bounds: list[Tuple[int, str, str]] = []
    upper_bounds: list[Tuple[int, str, str]] = []

    for m in _DISTANCE_LOWER_RE.finditer(text):
        parsed = _to_meters(m.group(1), m.group(2))
        if parsed:
            lower_bounds.append((parsed[0], parsed[1], m.group(0).strip()))

    for m in _DISTANCE_UPPER_RE.finditer(text):
        parsed = _to_meters(m.group(1), m.group(2))
        if parsed:
            upper_bounds.append((parsed[0], parsed[1], m.group(0).strip()))

    if lower_bounds or upper_bounds:
        lo = max(lower_bounds, key=lambda x: x[0]) if lower_bounds else None
        hi = min(upper_bounds, key=lambda x: x[0]) if upper_bounds else None

        if lo and hi:
            if lo[0] > hi[0]:
                logger.warning("[DistanceExtractor] Invalid distance bounds: min=%s > max=%s", lo[0], hi[0])
                return None
            return {
                "type": "DISTANCE",
                "value": f"{lo[2]} ... {hi[2]}",
                "operator": "between",
                "amount": float(lo[0]),
                "amount_max": float(hi[0]),
                "radius_meters": hi[0],
                "distance_unit": hi[1],
                "proximity_intent": False,
                "confidence": 1.0,
            }

        if hi:
            return {
                "type": "DISTANCE",
                "value": hi[2],
                "operator": "lte",
                "amount": float(hi[0]),
                "radius_meters": hi[0],
                "distance_unit": hi[1],
                "proximity_intent": False,
                "confidence": 1.0,
            }

        if lo:
            return {
                "type": "DISTANCE",
                "value": lo[2],
                "operator": "gte",
                "amount": float(lo[0]),
                "amount_max": float(max_radius_m),
                # Keep backward compatibility for existing tests/consumers.
                "radius_meters": lo[0],
                "distance_unit": lo[1],
                "proximity_intent": False,
                "confidence": 1.0,
            }

    # 3) Fallback plain explicit distance: "5km" -> interpreted as lte radius
    match = _EXPLICIT_SINGLE_RE.search(text)
    if not match:
        return None

    parsed = _to_meters(match.group(1), match.group(2))
    if not parsed:
        logger.warning(
            "[DistanceExtractor] Unreasonable distance: %s%s (allowed: 1-%sm)",
            match.group(1),
            match.group(2),
            max_radius_m,
        )
        return None

    radius_meters, unit_key = parsed
    return {
        "type": "DISTANCE",
        "value": match.group(0).strip(),
        "operator": "lte",
        "amount": float(radius_meters),
        "radius_meters": radius_meters,
        "distance_unit": unit_key,
        "proximity_intent": False,
        "confidence": 1.0,
    }


def _extract_implicit_proximity(text: str) -> Optional[Dict]:
    """
    Detect implicit proximity intent like 'gần đây', 'gần chỗ', 'quanh đây', 'xung quanh'.

    Uses flexible regex patterns to match various Vietnamese proximity phrases.

    Returns default radius from settings (DEFAULT_PROXIMITY_RADIUS_M) for proximity without explicit distance.
    """

    text_lower = text.lower()

    for pattern in IMPLICIT_PROXIMITY_PATTERNS:
        match = re.search(pattern, text_lower)
        if match:
            matched_text = match.group(0)
            default_radius = settings.DEFAULT_PROXIMITY_RADIUS_M
            logger.info(f"[DistanceExtractor] Detected implicit proximity intent: '{matched_text}'")

            return {
                "type": "DISTANCE",
                "value": matched_text,
                "operator": "lte",
                "amount": float(default_radius),
                "radius_meters": default_radius,
                "distance_unit": "implicit",
                "proximity_intent": True,  # Implicit proximity
                "confidence": 0.85,
            }

    return None
