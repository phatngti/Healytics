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
from typing import List, Dict, Optional

from app.core.config import settings

logger = logging.getLogger(__name__)

# ============================================================================
# Regex patterns for explicit distance extraction
# ============================================================================

# Explicit distance pattern with various Vietnamese units
# Matches: "5km", "5 km", "500m", "500 m", "2 cây số", "1.5 dặm", etc.
EXPLICIT_DISTANCE_PATTERN = r"(\d+(?:[.,]\d+)?)\s*(?:km|m|cây\s*số|dặm)"

# Implicit proximity patterns - ordered most specific → least specific
# Only trigger when "gần" = "near [me/here]", NOT "almost" (gần xong, gần bằng, gần cuối)
IMPLICIT_PROXIMITY_PATTERNS = [
    r"gần\s+(?:đây|chỗ\s*(?:này|đó)?|nơi\s*(?:này|đó)?|tôi|mình|đó)",  # gần đây / gần chỗ / gần tôi
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
    """Extract explicit distance like '5km', '500m', '2 cây số'."""

    # Case-insensitive matching
    # Match patterns like: "5km", "5 km", "500m", "2 cây số"
    pattern = r"(\d+(?:[.,]\d+)?)\s*(km|m|cây\s*số|dặm)"
    match = re.search(pattern, text, re.IGNORECASE)

    if not match:
        return None

    distance_str = match.group(1).replace(",", ".")  # Handle comma decimal
    unit_str = match.group(2).lower().strip()

    try:
        distance_value = float(distance_str)
    except ValueError:
        return None

    # Normalize unit string
    if unit_str.startswith("cây"):
        unit_key = "cây số"
    elif unit_str.startswith("dặm"):
        unit_key = "dặm"
    elif unit_str == "km":
        unit_key = "km"
    elif unit_str == "m":
        unit_key = "m"
    else:
        return None

    # Convert to meters
    if unit_key not in UNIT_TO_METERS:
        return None

    multiplier = UNIT_TO_METERS[unit_key]
    radius_meters = int(distance_value * multiplier)

    # Sanity check: radius should be reasonable (1m - 100km)
    if radius_meters < 1 or radius_meters > 100000:
        logger.warning(f"[DistanceExtractor] Unreasonable distance: {radius_meters}m")
        return None

    logger.info(f"[DistanceExtractor] Extracted explicit distance: {distance_value}{unit_key} = {radius_meters}m")

    return {
        "type": "DISTANCE",
        "value": f"{distance_str}{unit_key}",
        "radius_meters": radius_meters,
        "distance_unit": unit_key,
        "proximity_intent": False,  # Explicit, not implicit
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
                "radius_meters": default_radius,
                "distance_unit": "implicit",
                "proximity_intent": True,  # Implicit proximity
                "confidence": 0.85,
            }

    return None
