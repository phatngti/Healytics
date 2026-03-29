"""
tests/test_distance_extractor.py

Unit tests cho distance_extractor module:
- Explicit distance extraction (km, m, cây số, dặm)
- Implicit proximity intent detection (gần đây, quanh đây, ...)
- Unit conversions to meters
- Sanity bounds (< 1m or > 100km rejected)
- Explicit overrides implicit
- False positive prevention (price "300k" ≠ distance)
"""

import pytest
from app.core.config import settings
from app.ner.distance_extractor import (
    extract_distance_entities,
    _extract_explicit_distance,
    _extract_implicit_proximity,
    UNIT_TO_METERS,
)


# ============================================================================
# Explicit Distance — km
# ============================================================================

class TestExplicitKm:

    def test_5km(self):
        result = _extract_explicit_distance("spa cách 5km")
        assert result is not None
        assert result["radius_meters"] == 5000
        assert result["distance_unit"] == "km"
        assert result["proximity_intent"] is False

    def test_2_km_space(self):
        """'2 km' (space between digit and unit) still matches."""
        result = _extract_explicit_distance("trong vòng 2 km từ đây")
        assert result is not None
        assert result["radius_meters"] == 2000

    def test_decimal_15km(self):
        """'1.5km' → 1500m (decimal preserved)."""
        result = _extract_explicit_distance("cách 1.5km")
        assert result is not None
        assert result["radius_meters"] == 1500

    def test_decimal_comma_25km(self):
        """'2,5km' (comma decimal) → 2500m."""
        result = _extract_explicit_distance("spa cách 2,5km")
        assert result is not None
        assert result["radius_meters"] == 2500


# ============================================================================
# Explicit Distance — meters
# ============================================================================

class TestExplicitMeters:

    def test_500m(self):
        result = _extract_explicit_distance("cách đây 500m")
        assert result is not None
        assert result["radius_meters"] == 500
        assert result["distance_unit"] == "m"

    def test_100m(self):
        result = _extract_explicit_distance("spa cách 100m")
        assert result is not None
        assert result["radius_meters"] == 100

    def test_1000m_equals_1km(self):
        result = _extract_explicit_distance("trong vòng 1000m")
        assert result is not None
        assert result["radius_meters"] == 1000


# ============================================================================
# Explicit Distance — cây số (kilometre)
# ============================================================================

class TestExplicitCaySo:

    def test_2_cay_so(self):
        """'2 cây số' = 2km = 2000m (NOT 500m)."""
        result = _extract_explicit_distance("cách đây 2 cây số")
        assert result is not None
        assert result["radius_meters"] == 2000
        assert result["distance_unit"] == "cây số"

    def test_3_cay_so(self):
        result = _extract_explicit_distance("spa cách 3 cây số")
        assert result is not None
        assert result["radius_meters"] == 3000


# ============================================================================
# Explicit Distance — dặm (statute mile)
# ============================================================================

class TestExplicitDam:

    def test_1_dam(self):
        """1 dặm ≈ 1609m."""
        result = _extract_explicit_distance("cách 1 dặm")
        assert result is not None
        assert result["radius_meters"] == 1609

    def test_2_dam(self):
        result = _extract_explicit_distance("trong vòng 2 dặm")
        assert result is not None
        assert result["radius_meters"] == 2 * 1609


# ============================================================================
# Sanity Bounds
# ============================================================================

class TestSanityBounds:

    def test_too_small_0m_rejected(self):
        """0m (distance_str='0') → radius_meters=0 < 1 → None."""
        result = _extract_explicit_distance("cách 0m")
        assert result is None

    def test_too_large_200km_rejected(self):
        """Any value above configured MAX_PROXIMITY_RADIUS_M is rejected."""
        too_large = settings.MAX_PROXIMITY_RADIUS_M + 1
        result = _extract_explicit_distance(f"cách {too_large}m")
        assert result is None

    def test_max_boundary_100km_accepted(self):
        """Configured MAX_PROXIMITY_RADIUS_M is accepted at boundary."""
        result = _extract_explicit_distance(f"trong vòng {settings.MAX_PROXIMITY_RADIUS_M}m")
        assert result is not None
        assert result["radius_meters"] == settings.MAX_PROXIMITY_RADIUS_M


# ============================================================================
# Implicit Proximity Patterns
# ============================================================================

class TestImplicitProximity:

    def test_gan_day(self):
        result = _extract_implicit_proximity("tìm spa gần đây")
        assert result is not None
        assert result["proximity_intent"] is True
        assert result["distance_unit"] == "implicit"
        assert result["radius_meters"] > 0

    def test_xung_quanh(self):
        result = _extract_implicit_proximity("spa xung quanh đây")
        assert result is not None
        assert result["proximity_intent"] is True

    def test_quanh_day(self):
        result = _extract_implicit_proximity("quanh đây có spa không")
        assert result is not None
        assert result["proximity_intent"] is True

    def test_o_gan(self):
        result = _extract_implicit_proximity("spa ở gần đây")
        assert result is not None
        assert result["proximity_intent"] is True

    def test_lan_can(self):
        result = _extract_implicit_proximity("tìm trong khu vực lân cận")
        assert result is not None
        assert result["proximity_intent"] is True

    def test_gan_toi(self):
        result = _extract_implicit_proximity("spa gần tôi")
        assert result is not None
        assert result["proximity_intent"] is True

    def test_no_proximity_text(self):
        """Text without any proximity term → None."""
        result = _extract_implicit_proximity("tìm spa ở Hà Nội")
        assert result is None

    def test_gan_xong_not_matched(self):
        """'gần xong' is not a proximity phrase — must NOT match."""
        result = _extract_implicit_proximity("gần xong rồi")
        assert result is None


# ============================================================================
# Full Pipeline — extract_distance_entities
# ============================================================================

class TestExtractDistanceEntities:

    def test_explicit_5km_returned(self):
        results = extract_distance_entities("spa cách đây 5km")
        assert len(results) == 1
        assert results[0]["type"] == "DISTANCE"
        assert results[0]["radius_meters"] == 5000

    def test_implicit_gan_day_returned(self):
        results = extract_distance_entities("tìm spa gần đây")
        assert len(results) == 1
        assert results[0]["proximity_intent"] is True

    def test_explicit_overrides_implicit(self):
        """Both '5km' and 'gần đây' present → explicit 5km wins, list has 1 item."""
        results = extract_distance_entities("tìm spa gần đây trong vòng 5km")
        assert len(results) == 1
        assert results[0]["radius_meters"] == 5000
        assert results[0]["proximity_intent"] is False

    def test_no_distance_text_returns_empty(self):
        results = extract_distance_entities("tìm spa ở Hà Nội giá rẻ")
        assert results == []

    def test_price_k_not_matched(self):
        """'300k' must NOT be matched as a distance entity."""
        results = extract_distance_entities("giá dưới 300k")
        assert results == []

    def test_tren_3km_returns_distance(self):
        """'trên 3km' — '3km' is extracted as explicit distance."""
        results = extract_distance_entities("Tìm spa trên 3km")
        assert len(results) == 1
        assert results[0]["operator"] == "gte"
        assert results[0]["amount"] == 3000.0
        assert results[0]["radius_meters"] == 3000

    def test_distance_range_tu_den(self):
        results = extract_distance_entities("Tìm spa từ 2km đến 5km")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == 2000.0
        assert results[0]["amount_max"] == 5000.0
        assert results[0]["radius_meters"] == 5000

    def test_distance_mixed_bounds_combined(self):
        results = extract_distance_entities("Tìm spa trên 2km và dưới 5km")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == 2000.0
        assert results[0]["amount_max"] == 5000.0
        assert results[0]["radius_meters"] == 5000

    def test_distance_range_khoang_toi(self):
        results = extract_distance_entities("gợi ý spa cách đây khoảng 2 tới 5km")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == 2000.0
        assert results[0]["amount_max"] == 5000.0
        assert results[0]["radius_meters"] == 5000

    def test_returns_list_always(self):
        """Always returns a list, even for empty input."""
        assert extract_distance_entities("") == []
        assert extract_distance_entities("   ") == []

    def test_max_one_entity_returned(self):
        """Pipeline always returns at most 1 DISTANCE entity."""
        results = extract_distance_entities("tìm spa gần đây trong vòng 2 cây số")
        assert len(results) <= 1

    def test_confidence_explicit_is_1(self):
        """Explicit distance → confidence=1.0."""
        results = extract_distance_entities("cách 5km")
        if results:
            assert results[0]["confidence"] == 1.0

    def test_confidence_implicit_below_1(self):
        """Implicit proximity → confidence < 1.0 (0.85)."""
        results = extract_distance_entities("gần đây")
        if results:
            assert results[0]["confidence"] < 1.0


# ============================================================================
# UNIT_TO_METERS mapping sanity
# ============================================================================

class TestUnitToMeters:

    def test_km_is_1000(self):
        assert UNIT_TO_METERS["km"] == 1000

    def test_m_is_1(self):
        assert UNIT_TO_METERS["m"] == 1

    def test_cay_so_is_1000(self):
        """cây số = kilometre (NOT 500m)."""
        assert UNIT_TO_METERS["cây số"] == 1000

    def test_dam_is_1609(self):
        """1 dặm ≈ 1609m (statute mile)."""
        assert UNIT_TO_METERS["dặm"] == 1609
