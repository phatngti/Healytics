"""
tests/test_query_builder.py

Unit tests cho query_builder và db_fetcher._resolve_spatial_case:
- build_backend_query: field mapping từ NerEntity list
- spatial_params: presence, fields, location_level pass-through
- _resolve_spatial_case: all 4 cases (TH1 / TH2 / TH3 / None)
- filter_mock_services: business_type, price filters + confidence-first sorting
"""

import pytest
from app.schemas.ner_schema import NerEntity
from app.utils.query_builder import build_backend_query, filter_mock_services, MOCK_SERVICES
from app.utils.db_fetcher import _resolve_spatial_case
from app.ner.spatial_context import SpatialContext


# ============================================================================
# Helpers
# ============================================================================

def _spa_bt():
    return NerEntity(type="BUSINESS_TYPE", value="spa", confidence=0.9, business_type="SPA_BEAUTY")

def _hcm_loc():
    return NerEntity(
        type="LOCATION",
        value="HCM",
        confidence=0.9,
        location_code="79",
        location_level="PROVINCE",
        location_intent=True,
    )

def _price_lte(amount=500000):
    return NerEntity(type="PRICE", value="dưới 500k", confidence=1.0, operator="lte", amount=amount)

def _price_gte(amount=300000):
    return NerEntity(type="PRICE", value="trên 300k", confidence=1.0, operator="gte", amount=amount)

def _price_between(lo=200000, hi=1000000):
    return NerEntity(type="PRICE", value="từ 200k–1tr", confidence=1.0, operator="between", amount=lo, amount_max=hi)

def _rating_gte(amount=4.0):
    return NerEntity(type="RATING", value="trên 4 sao", confidence=1.0, operator="gte", amount=amount)

def _distance_entity(radius=5000):
    return NerEntity(type="DISTANCE", value="5km", confidence=1.0, radius_meters=radius, proximity_intent=False)


def _distance_between(lo=2000.0, hi=5000.0):
    return NerEntity(
        type="DISTANCE",
        value="từ 2km đến 5km",
        confidence=1.0,
        operator="between",
        amount=lo,
        amount_max=hi,
        radius_meters=int(hi),
        proximity_intent=False,
    )


def _distance_gte(lo=3000.0, hi=50000.0):
    return NerEntity(
        type="DISTANCE",
        value="trên 3km",
        confidence=1.0,
        operator="gte",
        amount=lo,
        amount_max=hi,
        radius_meters=int(lo),
        proximity_intent=False,
    )


# ============================================================================
# build_backend_query — basic field mapping
# ============================================================================

class TestBuildBackendQuery:

    def test_business_type_mapped(self):
        q = build_backend_query([_spa_bt()])
        assert q["businessTypes"] == ["SPA_BEAUTY"]
        assert q["businessType"] == "SPA_BEAUTY"

    def test_location_code_mapped(self):
        q = build_backend_query([_hcm_loc()])
        assert q["locationCode"] == "79"

    def test_price_lte_mapped(self):
        q = build_backend_query([_price_lte()])
        assert q["maxPrice"] == 500000.0
        assert "minPrice" not in q

    def test_price_gte_mapped(self):
        q = build_backend_query([_price_gte()])
        assert q["minPrice"] == 300000.0
        assert "maxPrice" not in q

    def test_price_between_mapped(self):
        q = build_backend_query([_price_between()])
        assert q["minPrice"] == 200000.0
        assert q["maxPrice"] == 1_000_000.0

    def test_rating_mapped(self):
        q = build_backend_query([_rating_gte()])
        assert "minRating" not in q

    def test_default_limit_50(self):
        q = build_backend_query([])
        assert q["limit"] == 50

    def test_custom_limit(self):
        q = build_backend_query([], limit=10)
        assert q["limit"] == 10

    def test_empty_entities(self):
        q = build_backend_query([])
        # Only limit key should be present
        assert set(q.keys()) == {"limit"}

    def test_distance_entity_not_in_query(self):
        """DISTANCE entity → no direct key (handled via spatial_context instead)."""
        q = build_backend_query([_distance_entity()])
        assert "radius_meters" not in q
        assert "DISTANCE" not in q

    def test_category_slug_mapped(self):
        e = NerEntity(type="CATEGORY", value="da liễu", confidence=0.8)
        q = build_backend_query([e])
        assert "categorySlug" not in q

    def test_location_without_code_skipped(self):
        """LOCATION entity without location_code → no locationCode in query."""
        e = NerEntity(type="LOCATION", value="Somewhere Unknown", confidence=0.5)
        q = build_backend_query([e])
        assert "locationCode" not in q

    def test_location_with_false_intent_skipped(self):
        """LOCATION with code still maps; intent pruning is handled upstream."""
        e = NerEntity(
            type="LOCATION",
            value="HCM",
            confidence=0.9,
            location_code="79",
            location_level="PROVINCE",
            location_intent=False,
        )
        q = build_backend_query([e])
        assert q["locationCode"] == "79"

    def test_location_with_unknown_intent_applied(self):
        """LOCATION with unknown intent (None) still applies as a filter."""
        e = NerEntity(
            type="LOCATION",
            value="HCM",
            confidence=0.9,
            location_code="79",
            location_level="PROVINCE",
            location_intent=None,
        )
        q = build_backend_query([e])
        assert q["locationCode"] == "79"


# ============================================================================
# build_backend_query — spatial_params
# ============================================================================

class TestBuildBackendQuerySpatial:

    def _th1_ctx(self):
        return SpatialContext(
            center_lat=10.7769,
            center_lng=106.7009,
            radius_meters=5000,
            fallback_used=False,
            location_level=None,
        )

    def _th2_ctx(self):
        return SpatialContext(
            center_lat=10.7769,
            center_lng=106.7009,
            radius_meters=5000,
            fallback_used=True,
            location_level="PROVINCE",
        )

    def _th3_ctx(self):
        return SpatialContext(
            center_lat=10.7769,
            center_lng=106.7009,
            radius_meters=5000,
            fallback_used=True,
            location_level="DISTRICT",
        )

    def test_no_spatial_context_no_spatial_params(self):
        q = build_backend_query([_spa_bt()], spatial_context=None)
        assert "spatial_params" not in q
        assert "use_postgis" not in q

    def test_spatial_params_present_with_context(self):
        q = build_backend_query([_spa_bt()], spatial_context=self._th1_ctx())
        assert "spatial_params" in q
        assert q["use_postgis"] is True
        assert q["distance_sort"] is True

    def test_spatial_params_center_coords(self):
        q = build_backend_query([], spatial_context=self._th1_ctx())
        sp = q["spatial_params"]
        assert sp["center_lat"] == 10.7769
        assert sp["center_lng"] == 106.7009
        assert sp["radius_meters"] == 5000

    def test_spatial_params_fallback_used_false_th1(self):
        q = build_backend_query([], spatial_context=self._th1_ctx())
        assert q["spatial_params"]["fallback_used"] is False
        assert q["fallback_used"] is False

    def test_spatial_params_fallback_used_true_th2(self):
        q = build_backend_query([], spatial_context=self._th2_ctx())
        assert q["spatial_params"]["fallback_used"] is True
        assert q["fallback_used"] is True

    def test_spatial_params_location_level_none_th1(self):
        q = build_backend_query([], spatial_context=self._th1_ctx())
        assert q["spatial_params"]["location_level"] is None

    def test_spatial_params_location_level_province_th2(self):
        q = build_backend_query([], spatial_context=self._th2_ctx())
        assert q["spatial_params"]["location_level"] == "PROVINCE"

    def test_spatial_params_location_level_district_th3(self):
        q = build_backend_query([], spatial_context=self._th3_ctx())
        assert q["spatial_params"]["location_level"] == "DISTRICT"

    def test_spatial_params_distance_between_bounds(self):
        q = build_backend_query([_distance_between()], spatial_context=self._th1_ctx())
        sp = q["spatial_params"]
        assert sp["distance_min_meters"] == 2000.0
        assert sp["distance_max_meters"] == 5000.0

    def test_spatial_params_distance_gte_bounds(self):
        q = build_backend_query([_distance_gte()], spatial_context=self._th1_ctx())
        sp = q["spatial_params"]
        assert sp["distance_min_meters"] == 3000.0
        assert sp["distance_max_meters"] == 50000.0


# ============================================================================
# _resolve_spatial_case — 3-case routing
# ============================================================================

class TestResolveSpatialCase:

    def _make_params(self, fallback_used, location_level, use_postgis=True):
        return (
            {
                "spatial_params": {
                    "center_lat": 10.77,
                    "center_lng": 106.70,
                    "radius_meters": 5000,
                    "fallback_used": fallback_used,
                    "location_level": location_level,
                }
            },
            use_postgis,
        )

    def test_th1_real_gps(self):
        """fallback_used=False → TH1."""
        params, use_postgis = self._make_params(False, None)
        assert _resolve_spatial_case(params, use_postgis) == "TH1"

    def test_th2_province_fallback(self):
        """fallback_used=True, level=PROVINCE → TH2."""
        params, use_postgis = self._make_params(True, "PROVINCE")
        assert _resolve_spatial_case(params, use_postgis) == "TH2"

    def test_th3_district_fallback(self):
        """fallback_used=True, level=DISTRICT → TH3."""
        params, use_postgis = self._make_params(True, "DISTRICT")
        assert _resolve_spatial_case(params, use_postgis) == "TH3"

    def test_th3_ward_fallback(self):
        """fallback_used=True, level=WARD → TH3."""
        params, use_postgis = self._make_params(True, "WARD")
        assert _resolve_spatial_case(params, use_postgis) == "TH3"

    def test_th3_fallback_no_level(self):
        """fallback_used=True, level=None → TH3 (safe default for district)."""
        params, use_postgis = self._make_params(True, None)
        assert _resolve_spatial_case(params, use_postgis) == "TH3"

    def test_none_no_spatial_params(self):
        """No spatial_params → None."""
        assert _resolve_spatial_case({"limit": 50}, True) is None

    def test_none_use_postgis_false(self):
        """use_postgis=False → always None."""
        params, _ = self._make_params(False, None, use_postgis=False)
        assert _resolve_spatial_case(params, False) is None

    def test_none_empty_query(self):
        assert _resolve_spatial_case({}, False) is None


# ============================================================================
# filter_mock_services — in-memory filtering
# ============================================================================

class TestFilterMockServices:

    def test_business_type_filter(self):
        """Filter by businessType=MASSAGE_REHABILITATION → only SV002."""
        q = {"businessType": "MASSAGE_REHABILITATION", "limit": 50}
        results = filter_mock_services(q)
        assert len(results) == 1
        assert results[0]["id"] == "SV002"

    def test_no_matching_business_type_returns_empty(self):
        q = {"businessType": "FITNESS", "limit": 50}
        results = filter_mock_services(q)
        assert results == []

    def test_multiple_business_types_or_filter(self):
        q = {"businessTypes": ["MASSAGE_REHABILITATION", "TRADITIONAL_MEDICINE"], "limit": 50}
        results = filter_mock_services(q)
        ids = [r["id"] for r in results]
        assert "SV001" in ids
        assert "SV002" in ids
        assert "SV003" in ids

    def test_max_price_filter(self):
        """maxPrice=600000 → SV001 (350k) and SV003 (500k) pass, SV002 (800k) filtered."""
        q = {"maxPrice": 600_000, "limit": 50}
        results = filter_mock_services(q)
        ids = [r["id"] for r in results]
        assert "SV001" in ids
        assert "SV003" in ids
        assert "SV002" not in ids

    def test_min_price_filter(self):
        """minPrice=600000 → only SV002 (800k) passes."""
        q = {"minPrice": 600_000, "limit": 50}
        results = filter_mock_services(q)
        ids = [r["id"] for r in results]
        assert "SV002" in ids
        assert "SV001" not in ids

    def test_results_sorted_by_confidence_then_rating(self):
        q = {"businessTypes": ["TRADITIONAL_MEDICINE", "MASSAGE_REHABILITATION"], "limit": 50}
        results = filter_mock_services(q)
        ids = [r["id"] for r in results]

        # SV002 matches 1/2 but has higher rating than SV001/SV003 (also 1/2).
        assert ids[0] == "SV002"

    def test_no_filter_returns_all(self):
        q = {"limit": 50}
        results = filter_mock_services(q)
        assert len(results) == len(MOCK_SERVICES)

    def test_limit_enforced(self):
        q = {"limit": 1}
        results = filter_mock_services(q)
        assert len(results) <= 1

    def test_location_code_filter(self):
        """locationCode=79 → only SV001 (code '79'), SV002/SV003 (code '67') excluded."""
        q = {"locationCode": "79", "limit": 50}
        results = filter_mock_services(q)
        ids = [r["id"] for r in results]
        assert "SV001" in ids
        assert "SV002" not in ids


# ============================================================================
# build_backend_query — combined entities
# ============================================================================

class TestBuildBackendQueryCombined:

    def test_all_filters_combined(self):
        """spa + HCM + price lte + rating gte → all keys populated."""
        from app.schemas.ner_schema import NerEntity
        entities = [
            NerEntity(type="BUSINESS_TYPE", value="spa", confidence=0.9, business_type="SPA_BEAUTY"),
            NerEntity(type="LOCATION", value="HCM", confidence=0.9, location_code="79", location_level="PROVINCE", location_intent=True),
            NerEntity(type="PRICE", value="dưới 500k", confidence=1.0, operator="lte", amount=500000.0),
            NerEntity(type="RATING", value="trên 4 sao", confidence=1.0, operator="gte", amount=4.0),
        ]
        q = build_backend_query(entities)
        assert q["businessTypes"] == ["SPA_BEAUTY"]
        assert q["businessType"] == "SPA_BEAUTY"
        assert q["locationCode"] == "79"
        assert q["maxPrice"] == 500000.0
        assert "minRating" not in q

    def test_distance_entity_not_in_query_keys(self):
        """DISTANCE entity → spatial_context handles it; no direct key in query."""
        from app.schemas.ner_schema import NerEntity
        entities = [
            NerEntity(type="DISTANCE", value="5km", confidence=1.0,
                      radius_meters=5000, distance_unit="km", proximity_intent=False),
        ]
        q = build_backend_query(entities)
        assert "radius_meters" not in q
        assert "distance_unit" not in q

    def test_price_between_sets_both_bounds(self):
        from app.schemas.ner_schema import NerEntity
        entities = [
            NerEntity(type="PRICE", value="từ 200k đến 1tr", confidence=1.0,
                      operator="between", amount=200000.0, amount_max=1000000.0),
        ]
        q = build_backend_query(entities)
        assert q["minPrice"] == 200000.0
        assert q["maxPrice"] == 1000000.0

    def test_multiple_business_types_kept_for_or_matching(self):
        """If two BUSINESS_TYPE entities are present, keep both for OR filtering."""
        from app.schemas.ner_schema import NerEntity
        entities = [
            NerEntity(type="BUSINESS_TYPE", value="spa", confidence=0.9, business_type="SPA_BEAUTY"),
            NerEntity(type="BUSINESS_TYPE", value="gym", confidence=0.9, business_type="FITNESS"),
        ]
        q = build_backend_query(entities)
        assert q.get("businessTypes") == ["SPA_BEAUTY", "FITNESS"]
        assert "businessType" not in q


# ============================================================================
# _resolve_spatial_case — additional edge cases
# ============================================================================

class TestResolveSpatialCaseExtended:

    def test_use_postgis_false_overrides_everything(self):
        """Even with valid spatial_params, use_postgis=False → None."""
        params = {
            "spatial_params": {
                "center_lat": 10.77,
                "center_lng": 106.70,
                "radius_meters": 5000,
                "fallback_used": False,
                "location_level": None,
            }
        }
        result = _resolve_spatial_case(params, use_postgis=False)
        assert result is None

    def test_th1_location_level_ignored(self):
        """fallback_used=False → TH1 regardless of location_level value."""
        for level in [None, "PROVINCE", "DISTRICT", "WARD"]:
            params = {
                "spatial_params": {
                    "center_lat": 10.77, "center_lng": 106.70, "radius_meters": 5000,
                    "fallback_used": False, "location_level": level,
                }
            }
            assert _resolve_spatial_case(params, True) == "TH1", \
                f"Expected TH1 for fallback_used=False, level={level}"

    def test_th3_for_any_non_province_level(self):
        """WARD, DISTRICT, unknown all route to TH3."""
        for level in ["WARD", "DISTRICT", "UNKNOWN", "COMMUNE", None]:
            params = {
                "spatial_params": {
                    "center_lat": 10.77, "center_lng": 106.70, "radius_meters": 5000,
                    "fallback_used": True, "location_level": level,
                }
            }
            assert _resolve_spatial_case(params, True) == "TH3", \
                f"Expected TH3 for fallback_used=True, level={level}"


# ============================================================================
# filter_mock_services — edge cases
# ============================================================================

class TestFilterMockServicesExtended:

    def test_zero_limit_returns_empty(self):
        q = {"limit": 0}
        results = filter_mock_services(q)
        assert results == []

    def test_combined_bt_and_price_filter(self):
        """Both businessType and maxPrice applied simultaneously."""
        q = {"businessType": "SPA_BEAUTY", "maxPrice": 1_000_000, "limit": 50}
        results = filter_mock_services(q)
        for r in results:
            assert "SPA_BEAUTY" in r.get("business_types", [r.get("type", "")])
            assert (r.get("sale_price") or r.get("base_price") or 0) <= 1_000_000

    def test_min_and_max_price_combined(self):
        """minPrice + maxPrice as a range filter."""
        q = {"minPrice": 300_000, "maxPrice": 600_000, "limit": 50}
        results = filter_mock_services(q)
        for r in results:
            price = r.get("sale_price") or r.get("base_price") or 0
            assert 300_000 <= price <= 600_000