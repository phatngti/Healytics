"""
tests/test_db_fetcher.py

Unit tests for db_fetcher SQL helper builders.
"""

from app.utils.db_fetcher import (
    _extract_business_types,
    _build_business_type_or_clause,
    _build_distance_conditions,
)


def test_extract_business_types_from_legacy_key():
    params = {"businessType": "FITNESS"}
    assert _extract_business_types(params) == ["FITNESS"]


def test_extract_business_types_dedup_and_strip():
    params = {
        "businessTypes": [" SPA_BEAUTY ", "FITNESS", "SPA_BEAUTY", None, ""],
        "businessType": "FITNESS",
    }
    assert _extract_business_types(params) == ["SPA_BEAUTY", "FITNESS"]


def test_build_business_type_or_clause_default_prefix():
    clause, bind = _build_business_type_or_clause(["SPA_BEAUTY", "FITNESS"])

    assert clause == "(:bt_0 = ANY(string_to_array(hpp.business_type, ',')) OR :bt_1 = ANY(string_to_array(hpp.business_type, ',')))"
    assert bind == {"bt_0": "SPA_BEAUTY", "bt_1": "FITNESS"}


def test_build_business_type_or_clause_custom_prefix():
    clause, bind = _build_business_type_or_clause(["DENTAL"], bind_prefix="rbt")

    assert clause == "(:rbt_0 = ANY(string_to_array(hpp.business_type, ',')))"
    assert bind == {"rbt_0": "DENTAL"}


def test_build_distance_conditions_between():
    conditions, bind = _build_distance_conditions(
        {
            "radius_meters": 5000,
            "distance_min_meters": 2000,
            "distance_max_meters": 5000,
        }
    )

    assert any("ST_DWithin" in c for c in conditions)
    assert any("ST_Distance" in c and ">=" in c for c in conditions)
    assert bind["radius_m"] == 5000
    assert bind["distance_min_m"] == 2000


def test_build_distance_conditions_lte_only():
    conditions, bind = _build_distance_conditions({"radius_meters": 3000})

    assert len(conditions) == 1
    assert "ST_DWithin" in conditions[0]
    assert bind == {"radius_m": 3000}


def test_build_distance_conditions_gte_only_with_cap():
    conditions, bind = _build_distance_conditions(
        {
            "radius_meters": 50000,
            "distance_min_meters": 3000,
        }
    )

    assert any("ST_DWithin" in c for c in conditions)
    assert any("ST_Distance" in c and ">=" in c for c in conditions)
    assert bind["radius_m"] == 50000
    assert bind["distance_min_m"] == 3000
