"""
tests/test_extractor.py

Unit tests cho extractor module:
- Keyword scan (returns tuple since refactor)
- Location fallback scan + excluded_ranges (prevent false-positive LOC)
- Price / Rating regex
- Distance extraction
- _normalize_amount decimal fix
- LRU cache behaviour
- Deduplication
"""

import pytest
from app.ner.extractor import (
    _parse_price,
    _parse_rating,
    _keyword_scan,
    _location_fallback_scan,
    _merge_ner_tags,
    _normalize_amount,
    _deduplicate,
    extract_entities,
    clear_query_cache,
    BUSINESS_TYPE_ALIASES,
)


# ============================================================================
# Keyword Scan — returns (entities, ranges) tuple since refactor
# ============================================================================

class TestKeywordScan:

    def test_returns_tuple(self):
        result = _keyword_scan("tìm spa gần đây")
        assert isinstance(result, tuple) and len(result) == 2

    def test_spa_extracted(self):
        entities, ranges = _keyword_scan("tìm spa gần đây")
        assert any(e["business_type"] == "SPA_BEAUTY" for e in entities)

    def test_gym_extracted(self):
        entities, ranges = _keyword_scan("gym ở Quận 1")
        assert any(e["business_type"] == "FITNESS" for e in entities)

    def test_longer_phrase_wins(self):
        """'massage trị liệu' > 'massage' — longer keyword has priority."""
        entities, ranges = _keyword_scan("massage trị liệu ở Đà Nẵng")
        assert len(entities) == 1
        assert entities[0]["business_type"] == "MASSAGE_REHABILITATION"

    def test_nha_si_extracted_as_dental(self):
        entities, ranges = _keyword_scan("tìm nha sĩ gần nhà")
        assert any(e["business_type"] == "DENTAL" for e in entities)

    def test_phong_kham_nha_si_extracted(self):
        entities, ranges = _keyword_scan("phòng khám nha sĩ ở HCM")
        assert any(e["business_type"] == "DENTAL" for e in entities)

    def test_hieu_thuoc_extracted_as_pharmacy(self):
        entities, ranges = _keyword_scan("hiệu thuốc bán thuốc gì")
        assert any(e["business_type"] == "PHARMACY" for e in entities)

    def test_lam_dep_extracted_as_spa(self):
        entities, ranges = _keyword_scan("tìm tiệm làm đẹp")
        assert any(e["business_type"] == "SPA_BEAUTY" for e in entities)

    def test_no_overlap_between_keywords(self):
        """'massage trị liệu' matched → 'massage' NOT matched again."""
        entities, ranges = _keyword_scan("dịch vụ massage trị liệu")
        bt_values = [e["business_type"] for e in entities]
        assert bt_values.count("MASSAGE_REHABILITATION") == 1
        assert "MASSAGE_THERAPY" not in bt_values

    def test_matched_ranges_returned(self):
        """ranges should contain char positions of matched keyword."""
        entities, ranges = _keyword_scan("tìm spa gần đây")
        assert len(ranges) == len(entities)
        for start, end in ranges:
            assert isinstance(start, int) and isinstance(end, int)
            assert start < end

    def test_empty_text(self):
        entities, ranges = _keyword_scan("tôi muốn đặt lịch")
        assert entities == []
        assert ranges == []


# ============================================================================
# Location Fallback Scan — excluded_ranges prevents false-positive
# ============================================================================

class TestLocationFallbackScan:

    def test_hieu_thuoc_no_false_loc(self):
        """'hiệu' in 'hiệu thuốc' must NOT be matched as WARD location."""
        _, keyword_ranges = _keyword_scan("hiệu thuốc gần đây")
        locs = _location_fallback_scan("hiệu thuốc gần đây", excluded_ranges=keyword_ranges)
        loc_values = [l["value"].lower() for l in locs]
        assert "hiệu" not in loc_values, f"False positive 'hiệu' as location: {locs}"

    def test_lam_dep_no_false_loc(self):
        """'làm' in 'làm đẹp' must NOT be matched as location."""
        _, keyword_ranges = _keyword_scan("tìm tiệm làm đẹp")
        locs = _location_fallback_scan("tìm tiệm làm đẹp", excluded_ranges=keyword_ranges)
        loc_values = [l["value"].lower() for l in locs]
        assert "làm" not in loc_values, f"False positive 'làm' as location: {locs}"

    def test_quan_1_found_via_direct_match(self):
        """'Quận 1' should match via direct _DISTRICT_FALLBACK lookup."""
        locs = _location_fallback_scan("Tìm spa ở Quận 1")
        found = [l["value"] for l in locs]
        assert any("Quận 1" in v or "quận 1" in v.lower() for v in found), \
            f"'Quận 1' not found in {found}"

    def test_without_excluded_ranges(self):
        """Calling without excluded_ranges still works."""
        locs = _location_fallback_scan("Tìm spa ở Hà Nội")
        assert isinstance(locs, list)

    def test_too_short_text_returns_empty(self):
        locs = _location_fallback_scan("ab")
        assert locs == []


# ============================================================================
# Price Parser
# ============================================================================

class TestParsePrice:

    def test_under_500k(self):
        results = _parse_price("giá dưới 500k")
        assert len(results) == 1
        assert results[0]["operator"] == "lte"
        assert results[0]["amount"] == 500_000.0

    def test_above_300k(self):
        results = _parse_price("trên 300k")
        assert len(results) == 1
        assert results[0]["operator"] == "gte"
        assert results[0]["amount"] == 300_000.0

    def test_range_200k_to_1_trieu(self):
        results = _parse_price("từ 200k đến 1 triệu")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == 200_000.0
        assert results[0]["amount_max"] == 1_000_000.0

    def test_khoang_modifier(self):
        """'khoảng 400k' → between 340k–460k (±15%)."""
        results = _parse_price("khoảng 400k")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert abs(results[0]["amount"] - 340_000) < 1
        assert abs(results[0]["amount_max"] - 460_000) < 1

    def test_gia_no_modifier(self):
        """'giá 500k' (no modifier) → between ±15% via _PRICE_NO_MODIFIER_PATTERN."""
        results = _parse_price("giá 500k")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == 425_000.0
        assert results[0]["amount_max"] == 575_000.0

    def test_chi_phi_no_modifier(self):
        results = _parse_price("chi phí 400k")
        assert len(results) == 1
        assert results[0]["operator"] == "between"

    def test_khong_price(self):
        results = _parse_price("tìm spa ở Hà Nội")
        assert len(results) == 0

    def test_distance_not_matched_as_price(self):
        """'trên 3km' must NOT generate a PRICE entity."""
        results = _parse_price("Tìm spa trên 3km")
        assert len(results) == 0

    def test_tren_5km_not_matched_as_price(self):
        results = _parse_price("cách đây trên 5km")
        assert len(results) == 0


# ============================================================================
# _normalize_amount — decimal preservation fix
# ============================================================================

class TestNormalizeAmount:

    def test_decimal_dot(self):
        """'1.5 triệu' → 1,500,000, not 1,500,000,000 (dot must not be stripped)."""
        assert _normalize_amount("1.5", "triệu") == 1_500_000.0

    def test_decimal_comma(self):
        """'1,5 triệu' → comma treated as decimal separator."""
        assert _normalize_amount("1,5", "triệu") == 1_500_000.0

    def test_integer_k(self):
        assert _normalize_amount("500", "k") == 500_000.0

    def test_integer_no_unit(self):
        """No unit → raw value (assume đồng)."""
        assert _normalize_amount("300000", None) == 300_000.0

    def test_tr_abbreviation(self):
        assert _normalize_amount("2", "tr") == 2_000_000.0


# ============================================================================
# Rating Parser
# ============================================================================

class TestParseRating:

    def test_tren_4_sao(self):
        results = _parse_rating("trên 4 sao")
        assert len(results) == 1
        assert results[0]["operator"] == "gte"
        assert results[0]["amount"] == 4.0

    def test_tren_4_5_diem(self):
        results = _parse_rating("ít nhất 4.5 điểm")
        assert len(results) == 1
        assert results[0]["amount"] == 4.5

    def test_false_positive_on_distance(self):
        """'trên 3km' MUST NOT generate a RATING → unit (sao/điểm) is required."""
        results = _parse_rating("chỗ có spa trên 3km")
        assert len(results) == 0

    def test_false_positive_on_price_k(self):
        """'trên 300k' MUST NOT generate a RATING."""
        results = _parse_rating("trên 300k")
        assert len(results) == 0

    def test_no_rating_in_text(self):
        results = _parse_rating("tìm spa giá rẻ")
        assert len(results) == 0

    def test_rating_out_of_range_ignored(self):
        """Score > 5 is not a valid rating → ignored."""
        results = _parse_rating("trên 10 sao")
        assert len(results) == 0


# ============================================================================
# NER Tag Merging
# ============================================================================

class TestMergeNerTags:

    def test_b_i_loc_merged(self):
        tagged = [
            ("Hà", "N", "B-NP", "B-LOC"),
            ("Nội", "N", "I-NP", "I-LOC"),
        ]
        result = _merge_ner_tags(tagged)
        assert len(result) == 1
        assert result[0]["type"] == "LOC"
        assert result[0]["value"] == "Hà Nội"

    def test_multiple_entities(self):
        tagged = [
            ("spa", "N", "B-NP", "B-ORG"),
            ("ở", "E", "B-PP", "O"),
            ("Hồ", "N", "B-NP", "B-LOC"),
            ("Chí", "N", "I-NP", "I-LOC"),
            ("Minh", "N", "I-NP", "I-LOC"),
        ]
        result = _merge_ner_tags(tagged)
        types = [r["type"] for r in result]
        assert "ORG" in types
        assert "LOC" in types

    def test_only_o_tags(self):
        tagged = [("tìm", "V", "B-VP", "O"), ("cái", "N", "B-NP", "O")]
        result = _merge_ner_tags(tagged)
        assert len(result) == 0


# ============================================================================
# Deduplication
# ============================================================================

class TestDeduplicate:

    def test_same_type_same_value_keeps_highest_conf(self):
        entities = [
            {"type": "LOC", "value": "Hà Nội", "confidence": 0.85},
            {"type": "LOC", "value": "Hà Nội", "confidence": 0.90},
        ]
        result = _deduplicate(entities)
        assert len(result) == 1
        assert result[0]["confidence"] == 0.90

    def test_different_types_both_kept(self):
        entities = [
            {"type": "LOC", "value": "spa", "confidence": 0.85},
            {"type": "BUSINESS_TYPE", "value": "spa", "confidence": 0.90},
        ]
        result = _deduplicate(entities)
        assert len(result) == 2

    def test_case_insensitive_dedup(self):
        entities = [
            {"type": "LOC", "value": "HCM", "confidence": 0.85},
            {"type": "LOC", "value": "hcm", "confidence": 0.90},
        ]
        result = _deduplicate(entities)
        assert len(result) == 1


# ============================================================================
# LRU Cache
# ============================================================================

class TestQueryCache:

    def test_cache_hit_returns_same_result(self):
        clear_query_cache()
        text = "unique test cache query xyz"
        r1 = extract_entities(text)
        r2 = extract_entities(text)
        assert r1 == r2

    def test_clear_cache(self):
        extract_entities("test clear cache")
        clear_query_cache()
        # Should not raise; after clear, next call is a fresh extraction
        result = extract_entities("test clear cache")
        assert isinstance(result, list)

    def test_different_texts_different_results(self):
        clear_query_cache()
        r1 = extract_entities("tìm spa")
        r2 = extract_entities("tìm gym")
        # Different queries may produce different results (or same if both return empty)
        # At minimum, the calls should succeed
        assert isinstance(r1, list)
        assert isinstance(r2, list)


# ============================================================================
# Extract Entities — integration (extractor only, no DB)
# ============================================================================

class TestExtractEntities:

    def test_empty_text_returns_empty(self):
        clear_query_cache()
        assert extract_entities("") == []
        assert extract_entities("   ") == []

    def test_spa_entity_extracted(self):
        clear_query_cache()
        entities = extract_entities("tìm spa giá rẻ")
        types = [e["type"] for e in entities]
        assert "BUSINESS_TYPE" in types

    def test_price_entity_extracted(self):
        clear_query_cache()
        entities = extract_entities("spa dưới 500k")
        types = [e["type"] for e in entities]
        assert "PRICE" in types

    def test_distance_entity_extracted(self):
        clear_query_cache()
        entities = extract_entities("spa gần đây")
        types = [e["type"] for e in entities]
        assert "DISTANCE" in types

    def test_no_distance_without_proximity_term(self):
        clear_query_cache()
        entities = extract_entities("tìm spa ở Quận 1")
        types = [e["type"] for e in entities]
        assert "DISTANCE" not in types

    def test_max_one_distance_entity(self):
        """Pipeline must produce at most 1 DISTANCE entity."""
        clear_query_cache()
        entities = extract_entities("tìm spa gần đây trong vòng 5km")
        dist = [e for e in entities if e["type"] == "DISTANCE"]
        assert len(dist) <= 1

    def test_explicit_overrides_implicit(self):
        """Explicit 5km takes priority over 'gần đây'."""
        clear_query_cache()
        entities = extract_entities("tìm spa gần đây trong vòng 5km")
        dist = [e for e in entities if e["type"] == "DISTANCE"]
        if dist:
            assert dist[0]["radius_meters"] == 5000
            assert dist[0]["proximity_intent"] is False

    def test_distance_between_kept_as_single_entity(self):
        """'trên 2km và dưới 5km' should merge into one DISTANCE between entity."""
        clear_query_cache()
        entities = extract_entities("tìm spa trên 2km và dưới 5km")
        dist = [e for e in entities if e["type"] == "DISTANCE"]
        assert len(dist) == 1
        assert dist[0].get("operator") == "between"
        assert dist[0].get("amount") == 2000.0
        assert dist[0].get("amount_max") == 5000.0

    def test_distance_range_phrase_not_price_false_positive(self):
        clear_query_cache()
        entities = extract_entities("gợi ý các dịch vụ spa và nha sĩ cách đây khoảng 2 tới 5km")
        dist = [e for e in entities if e["type"] == "DISTANCE"]
        price = [e for e in entities if e["type"] == "PRICE"]

        assert len(dist) == 1
        assert dist[0].get("operator") == "between"
        assert dist[0].get("amount") == 2000.0
        assert dist[0].get("amount_max") == 5000.0
        assert price == []

    def test_text_too_long_truncated(self):
        """Text > 2000 chars is truncated, not rejected."""
        long_text = "tìm spa " * 400  # ~3200 chars
        result = extract_entities(long_text)
        assert isinstance(result, list)


# ============================================================================
# BUSINESS_TYPE_ALIASES — extended alias coverage
# ============================================================================

class TestBusinessTypeAliasExtended:
    """Ensure every alias defined in BUSINESS_TYPE_ALIASES is mapped correctly."""

    def test_yoga_is_fitness(self):
        entities, _ = _keyword_scan("tìm lớp yoga gần đây")
        assert any(e["business_type"] == "FITNESS" for e in entities)

    def test_pilates_is_fitness(self):
        entities, _ = _keyword_scan("lớp pilates ở Hà Nội")
        assert any(e["business_type"] == "FITNESS" for e in entities)

    def test_phong_tap_is_fitness(self):
        entities, _ = _keyword_scan("phòng tập buổi sáng")
        assert any(e["business_type"] == "FITNESS" for e in entities)

    def test_tam_ly_is_psychology(self):
        entities, _ = _keyword_scan("cần tư vấn tâm lý")
        assert any(e["business_type"] == "PSYCHOLOGY" for e in entities)

    def test_da_lieu_is_dermatology(self):
        entities, _ = _keyword_scan("phòng khám da liễu")
        assert any(e["business_type"] == "DERMATOLOGY" for e in entities)

    def test_dong_y_is_traditional_medicine(self):
        entities, _ = _keyword_scan("bài thuốc đông y")
        assert any(e["business_type"] == "TRADITIONAL_MEDICINE" for e in entities)

    def test_nha_thuoc_is_pharmacy(self):
        entities, _ = _keyword_scan("nhà thuốc 24h")
        assert any(e["business_type"] == "PHARMACY" for e in entities)

    def test_bam_huyet_is_rehabilitation(self):
        entities, _ = _keyword_scan("liệu trình bấm huyệt")
        assert any(e["business_type"] == "MASSAGE_REHABILITATION" for e in entities)

    def test_nan_xuong_khop_is_rehabilitation(self):
        entities, _ = _keyword_scan("nắn xương khớp cột sống")
        assert any(e["business_type"] == "MASSAGE_REHABILITATION" for e in entities)

    def test_vat_ly_tri_lieu_is_rehabilitation(self):
        entities, _ = _keyword_scan("vật lý trị liệu sau phẫu thuật")
        assert any(e["business_type"] == "MASSAGE_REHABILITATION" for e in entities)

    def test_phuc_hoi_chuc_nang_is_rehabilitation(self):
        entities, _ = _keyword_scan("trung tâm phục hồi chức năng")
        assert any(e["business_type"] == "MASSAGE_REHABILITATION" for e in entities)

    def test_mat_xa_is_massage_therapy(self):
        entities, _ = _keyword_scan("mát xa thư giãn")
        assert any(e["business_type"] == "MASSAGE_THERAPY" for e in entities)

    def test_cham_soc_da_is_spa_beauty(self):
        entities, _ = _keyword_scan("dịch vụ chăm sóc da")
        assert any(e["business_type"] == "SPA_BEAUTY" for e in entities)

    def test_all_aliases_mapped_to_nonempty_value(self):
        for alias, bt_value in BUSINESS_TYPE_ALIASES.items():
            assert isinstance(bt_value, str) and len(bt_value) > 0, \
                f"Alias '{alias}' maps to empty/None"

    def test_ranges_count_matches_entities(self):
        """Number of ranges == number of entities for any text."""
        for text in ["tìm spa", "yoga pilates", "nha sĩ nhà thuốc", ""]:
            entities, ranges = _keyword_scan(text)
            assert len(entities) == len(ranges), \
                f"Mismatch for {text!r}: {len(entities)} entities vs {len(ranges)} ranges"


# ============================================================================
# Price Parser — extended
# ============================================================================

class TestParsePriceExtended:

    def test_toi_da_is_lte(self):
        results = _parse_price("tối đa 800k")
        assert results and results[0]["operator"] == "lte"
        assert results[0]["amount"] == 800_000.0

    def test_toi_thieu_is_gte(self):
        results = _parse_price("tối thiểu 200k")
        assert results and results[0]["operator"] == "gte"

    def test_tam_is_between(self):
        results = _parse_price("tầm 500k")
        assert results and results[0]["operator"] == "between"

    def test_co_is_between(self):
        results = _parse_price("cỡ 400k là ổn")
        assert results and results[0]["operator"] == "between"

    def test_hoc_phi_no_modifier(self):
        results = _parse_price("học phí 300k")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == pytest.approx(255_000.0)

    def test_phi_keyword(self):
        results = _parse_price("phí 150k")
        assert len(results) == 1 and results[0]["operator"] == "between"

    def test_unit_nghin(self):
        results = _parse_price("dưới 500 nghìn")
        assert results and results[0]["amount"] == 500_000.0

    def test_unit_ngan(self):
        results = _parse_price("dưới 500 ngàn")
        assert results and results[0]["amount"] == 500_000.0

    def test_unit_dong(self):
        results = _parse_price("dưới 300000 đồng")
        assert results and results[0]["amount"] == 300_000.0

    def test_unit_vnd(self):
        results = _parse_price("dưới 500000 vnđ")
        assert results and results[0]["amount"] == 500_000.0

    def test_decimal_trieu(self):
        results = _parse_price("dưới 1.5 triệu")
        assert results and results[0]["amount"] == 1_500_000.0

    def test_range_from_to_k(self):
        results = _parse_price("từ 300k đến 700k")
        assert results and results[0]["operator"] == "between"
        assert results[0]["amount"] == 300_000.0
        assert results[0]["amount_max"] == 700_000.0

    def test_range_mixed_units(self):
        results = _parse_price("từ 200k đến 2 triệu")
        assert results
        assert results[0]["amount"] == 200_000.0
        assert results[0]["amount_max"] == 2_000_000.0

    def test_zero_amount_ignored(self):
        assert _parse_price("dưới 0k") == []

    def test_range_wins_over_single(self):
        results = _parse_price("từ 200k đến 500k")
        assert len(results) == 1 and results[0]["operator"] == "between"


# ============================================================================
# Rating Parser — extended
# ============================================================================

class TestParseRatingExtended:

    def test_tu_4_sao_is_gte(self):
        results = _parse_rating("từ 4 sao trở lên")
        assert results and results[0]["operator"] == "gte"
        assert results[0]["amount"] == 4.0

    def test_duoi_3_sao_is_lte(self):
        results = _parse_rating("dưới 3 sao")
        assert results and results[0]["operator"] == "lte"
        assert results[0]["amount"] == 3.0

    def test_it_nhat_45_diem(self):
        results = _parse_rating("ít nhất 4.5 điểm")
        assert results and results[0]["amount"] == pytest.approx(4.5)
        assert results[0]["operator"] == "gte"

    def test_star_emoji_unit(self):
        results = _parse_rating("trên 4★")
        assert len(results) == 1 and results[0]["amount"] == 4.0

    def test_star_asterisk_unit(self):
        results = _parse_rating("trên 4*")
        assert len(results) == 1

    def test_5_sao_boundary_valid(self):
        results = _parse_rating("trên 5 sao")
        assert len(results) == 1 and results[0]["amount"] == 5.0

    def test_6_sao_out_of_range(self):
        assert _parse_rating("trên 6 sao") == []

    def test_price_k_not_rating(self):
        assert _parse_rating("dưới 500k") == []


# ============================================================================
# _normalize_amount — extended unit coverage
# ============================================================================

class TestNormalizeAmountExtended:

    def test_unit_dong(self):
        assert _normalize_amount("300000", "đồng") == 300_000.0

    def test_unit_vnd(self):
        assert _normalize_amount("500000", "vnđ") == 500_000.0

    def test_trieu_decimal_comma(self):
        assert _normalize_amount("2,5", "triệu") == 2_500_000.0

    def test_trieu_decimal_dot(self):
        assert _normalize_amount("2.5", "triệu") == 2_500_000.0

    def test_invalid_string_returns_zero(self):
        assert _normalize_amount("abc", "k") == 0.0

    def test_no_unit_raw_value(self):
        assert _normalize_amount("150000", None) == 150_000.0

    def test_float_with_k(self):
        assert _normalize_amount("1.5", "k") == 1_500.0


# ============================================================================
# _merge_ner_tags — extended edge cases
# ============================================================================

class TestMergeNerTagsExtended:

    def test_single_b_loc_token(self):
        tagged = [("HCM", "N", "B-NP", "B-LOC")]
        result = _merge_ner_tags(tagged)
        assert len(result) == 1 and result[0]["value"] == "HCM"

    def test_entity_at_end_flushed(self):
        """Entity at end of sequence (no trailing O) must be emitted."""
        tagged = [
            ("Hồ", "N", "B-NP", "B-LOC"),
            ("Chí", "N", "I-NP", "I-LOC"),
            ("Minh", "N", "I-NP", "I-LOC"),
        ]
        result = _merge_ner_tags(tagged)
        assert len(result) == 1 and "Hồ Chí Minh" in result[0]["value"]

    def test_empty_tagged_returns_empty(self):
        assert _merge_ner_tags([]) == []

    def test_confidence_is_085(self):
        tagged = [("Hà Nội", "N", "B-NP", "B-LOC")]
        result = _merge_ner_tags(tagged)
        assert result[0]["confidence"] == 0.85


# ============================================================================
# _deduplicate — extended
# ============================================================================

class TestDeduplicateExtended:

    def test_three_duplicates_keeps_highest_conf(self):
        entities = [
            {"type": "LOC", "value": "HCM", "confidence": 0.80},
            {"type": "LOC", "value": "HCM", "confidence": 0.95},
            {"type": "LOC", "value": "HCM", "confidence": 0.70},
        ]
        result = _deduplicate(entities)
        assert len(result) == 1 and result[0]["confidence"] == 0.95

    def test_different_values_both_kept(self):
        entities = [
            {"type": "LOC", "value": "Hà Nội", "confidence": 0.90},
            {"type": "LOC", "value": "HCM", "confidence": 0.90},
        ]
        assert len(_deduplicate(entities)) == 2

    def test_empty_returns_empty(self):
        assert _deduplicate([]) == []

    def test_single_entity_unchanged(self):
        e = {"type": "PRICE", "value": "dưới 500k", "confidence": 1.0}
        assert _deduplicate([e]) == [e]
