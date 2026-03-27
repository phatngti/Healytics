"""
tests/test_postgis_query_builder.py

Unit tests cho postgis_query_builder module:
- calculate_distance_meters (Haversine): known pairs, same point, reciprocity
- st_make_point_geography, st_dwithin_clause, st_distance_expression: SQL string format
- distance_order_by: tiebreaker flag
- build_postgis_query: with/without spatial context, fallback_used passthrough
"""

import math
import pytest
from app.utils.postgis_query_builder import (
    calculate_distance_meters,
    st_make_point_geography,
    st_dwithin_clause,
    st_distance_expression,
    distance_order_by,
    build_postgis_query,
)
from app.ner.spatial_context import SpatialContext


# ============================================================================
# calculate_distance_meters (Haversine)
# ============================================================================

class TestHaversine:

    # Approx coords:
    #   Hanoi   = 21.0285, 105.8542
    #   HCM     = 10.7769, 106.7009
    #   Da Nang = 16.0544, 108.2022
    #   ~1724 km Hanoi-HCM   (≈ 1_724_000 m ±20 km)
    #   ~964  km Hanoi-DaNang(≈ 964_000 m ±20 km)

    def test_same_point_is_zero(self):
        d = calculate_distance_meters(10.7769, 106.7009, 10.7769, 106.7009)
        assert d == pytest.approx(0, abs=1)

    def test_hanoi_to_hcm_approx(self):
        d = calculate_distance_meters(21.0285, 105.8542, 10.7769, 106.7009)
        assert 1_700_000 < d < 1_760_000, f"Hanoi–HCM expected ~1730km, got {d/1000:.1f}km"

    def test_symmetry(self):
        """d(A→B) == d(B→A)."""
        d_ab = calculate_distance_meters(21.0285, 105.8542, 10.7769, 106.7009)
        d_ba = calculate_distance_meters(10.7769, 106.7009, 21.0285, 105.8542)
        assert d_ab == pytest.approx(d_ba, rel=1e-6)

    def test_short_distance_500m(self):
        """Two points ~500m apart along same latitude."""
        # 1 degree latitude ≈ 111_000m; 500m ≈ 0.0045 deg
        lat, lng = 10.7769, 106.7009
        d = calculate_distance_meters(lat, lng, lat + 0.0045, lng)
        assert 450 < d < 560, f"Expected ~500m, got {d:.1f}m"

    def test_returns_float(self):
        result = calculate_distance_meters(10.0, 106.0, 10.0, 106.0)
        assert isinstance(result, float)

    def test_north_pole_to_south_pole_approx(self):
        """Maximum distance ≈ π × R ≈ 20_015 km."""
        d = calculate_distance_meters(90.0, 0.0, -90.0, 0.0)
        assert 19_900_000 < d < 20_100_000, f"Expected ~20015km, got {d/1000:.1f}km"


# ============================================================================
# st_make_point_geography
# ============================================================================

class TestStMakePointGeography:

    def test_contains_lng_and_lat(self):
        result = st_make_point_geography(106.7009, 10.7769)
        assert "106.7009" in result
        assert "10.7769" in result

    def test_contains_srid_4326(self):
        result = st_make_point_geography(106.7009, 10.7769)
        assert "4326" in result

    def test_contains_st_makepoint(self):
        result = st_make_point_geography(106.0, 21.0)
        assert "ST_MakePoint" in result

    def test_returns_string(self):
        assert isinstance(st_make_point_geography(106.0, 21.0), str)

    def test_geography_cast(self):
        result = st_make_point_geography(106.0, 21.0)
        assert "geography" in result.lower()


# ============================================================================
# st_dwithin_clause
# ============================================================================

class TestStDWithinClause:

    def test_contains_st_dwithin(self):
        result = st_dwithin_clause(106.7009, 10.7769, 5000)
        assert "ST_DWithin" in result

    def test_contains_radius(self):
        result = st_dwithin_clause(106.7009, 10.7769, 5000)
        assert "5000" in result

    def test_contains_hpp_location(self):
        result = st_dwithin_clause(106.7009, 10.7769, 5000)
        assert "hpp.location" in result

    def test_contains_coords(self):
        result = st_dwithin_clause(106.7009, 10.7769, 5000)
        assert "106.7009" in result
        assert "10.7769" in result

    def test_different_radii(self):
        r1 = st_dwithin_clause(106.0, 21.0, 1000)
        r2 = st_dwithin_clause(106.0, 21.0, 10000)
        assert "1000" in r1
        assert "10000" in r2


# ============================================================================
# st_distance_expression
# ============================================================================

class TestStDistanceExpression:

    def test_contains_st_distance(self):
        result = st_distance_expression(106.7009, 10.7769)
        assert "ST_Distance" in result

    def test_contains_distance_meters_alias(self):
        result = st_distance_expression(106.7009, 10.7769)
        assert "distance_meters" in result

    def test_contains_hpp_location(self):
        result = st_distance_expression(106.7009, 10.7769)
        assert "hpp.location" in result


# ============================================================================
# distance_order_by
# ============================================================================

class TestDistanceOrderBy:

    def test_contains_order_by(self):
        result = distance_order_by(106.0, 21.0)
        assert result.upper().startswith("ORDER BY")

    def test_with_rating_tiebreaker(self):
        result = distance_order_by(106.0, 21.0, with_rating_tiebreaker=True)
        assert "avg_rating" in result or "rating" in result.lower()

    def test_without_rating_tiebreaker(self):
        result = distance_order_by(106.0, 21.0, with_rating_tiebreaker=False)
        assert "rating" not in result.lower()

    def test_distance_asc(self):
        result = distance_order_by(106.0, 21.0)
        assert "ASC" in result.upper() or "distance_meters" in result


# ============================================================================
# build_postgis_query
# ============================================================================

class TestBuildPostgisQuery:

    def _ctx(self, fallback_used=False, location_level=None):
        return SpatialContext(
            center_lat=10.7769,
            center_lng=106.7009,
            radius_meters=5000,
            fallback_used=fallback_used,
            location_level=location_level,
        )

    def test_no_spatial_context_returns_basic_query(self):
        result = build_postgis_query([], spatial_context=None)
        assert result["use_postgis"] is False
        assert result["distance_sort"] is False
        assert "spatial_params" not in result

    def test_with_context_use_postgis_true(self):
        result = build_postgis_query([], spatial_context=self._ctx())
        assert result["use_postgis"] is True

    def test_with_context_distance_sort_true(self):
        result = build_postgis_query([], spatial_context=self._ctx())
        assert result["distance_sort"] is True

    def test_spatial_params_coords(self):
        result = build_postgis_query([], spatial_context=self._ctx())
        sp = result["spatial_params"]
        assert sp["center_lat"] == pytest.approx(10.7769)
        assert sp["center_lng"] == pytest.approx(106.7009)
        assert sp["radius_meters"] == 5000

    def test_fallback_used_false_passthrough(self):
        result = build_postgis_query([], spatial_context=self._ctx(fallback_used=False))
        assert result["fallback_used"] is False

    def test_fallback_used_true_passthrough(self):
        result = build_postgis_query([], spatial_context=self._ctx(fallback_used=True))
        assert result["fallback_used"] is True

    def test_default_limit_50(self):
        result = build_postgis_query([], spatial_context=None)
        assert result["limit"] == 50

    def test_custom_limit(self):
        result = build_postgis_query([], spatial_context=None, limit=10)
        assert result["limit"] == 10

    def test_entities_arg_accepted(self):
        """entities list is accepted without error (not used directly in this builder)."""
        from app.schemas.ner_schema import NerEntity
        entities = [NerEntity(type="BUSINESS_TYPE", value="spa", confidence=0.9, business_type="SPA_BEAUTY")]
        result = build_postgis_query(entities, spatial_context=self._ctx())
        assert result["use_postgis"] is True
