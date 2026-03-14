"""
tests/test_extractor.py

Unit tests cho extractor module:
- Regex Price/Rating parser
- Keyword scan (BUSINESS_TYPE_ALIASES)
- LRU query cache hit
- underthesea tag merging
"""

from app.ner.extractor import (
    _parse_price,
    _parse_rating,
    _keyword_scan,
    _merge_ner_tags,
    _deduplicate,
    extract_entities,
    clear_query_cache,
)


# ============================================================================
# Price Parser
# ============================================================================

class TestParsePrice:

    def test_price_under_500k(self):
        results = _parse_price("giá dưới 500k")
        assert len(results) == 1
        assert results[0]["type"] == "PRICE"
        assert results[0]["operator"] == "lte"
        assert results[0]["amount"] == 500_000.0

    def test_price_above_300k(self):
        results = _parse_price("trên 300k")
        assert len(results) == 1
        assert results[0]["operator"] == "gte"
        assert results[0]["amount"] == 300_000.0

    def test_price_range_200k_to_1_trieu(self):
        results = _parse_price("từ 200k đến 1 triệu")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == 200_000.0
        assert results[0]["amount_max"] == 1_000_000.0

    def test_price_trieu_unit(self):
        results = _parse_price("dưới 2 triệu")
        assert len(results) == 1
        assert results[0]["amount"] == 2_000_000.0

    def test_price_tr_abbreviation(self):
        results = _parse_price("từ 1tr đến 3tr")
        assert len(results) == 1
        assert results[0]["operator"] == "between"
        assert results[0]["amount"] == 1_000_000.0
        assert results[0]["amount_max"] == 3_000_000.0

    def test_no_price_in_text(self):
        results = _parse_price("tìm spa ở Hà Nội")
        assert len(results) == 0


# ============================================================================
# Rating Parser
# ============================================================================

class TestParseRating:

    def test_rating_above_4(self):
        results = _parse_rating("trên 4 sao")
        assert len(results) == 1
        assert results[0]["type"] == "RATING"
        assert results[0]["operator"] == "gte"
        assert results[0]["amount"] == 4.0

    def test_rating_at_least_4_5(self):
        results = _parse_rating("ít nhất 4.5 điểm")
        assert len(results) == 1
        assert results[0]["operator"] == "gte"
        assert results[0]["amount"] == 4.5

    def test_no_rating_in_text(self):
        results = _parse_rating("tìm spa giá rẻ")
        assert len(results) == 0


# ============================================================================
# Keyword Scan
# ============================================================================

class TestKeywordScan:

    def test_keyword_scan_spa(self):
        results = _keyword_scan("tìm spa gần đây")
        assert len(results) >= 1
        spa_entity = results[0]
        assert spa_entity["type"] == "BUSINESS_TYPE"
        assert spa_entity["business_type"] == "SPA_BEAUTY"

    def test_keyword_scan_gym(self):
        results = _keyword_scan("gym ở quận 1")
        assert any(e["business_type"] == "FITNESS" for e in results)

    def test_keyword_scan_massage_tri_lieu(self):
        """Ưu tiên cụm dài: 'massage trị liệu' > 'massage'"""
        results = _keyword_scan("massage trị liệu ở đà nẵng")
        assert len(results) == 1
        assert results[0]["business_type"] == "MASSAGE_REHABILITATION"

    def test_keyword_scan_nha_khoa(self):
        results = _keyword_scan("nha khoa gần nhà")
        assert any(e["business_type"] == "DENTAL" for e in results)

    def test_keyword_scan_domain_specific(self):
        """underthesea thường miss từ này → keyword scan bắt được."""
        results = _keyword_scan("tìm chỗ nắn xương khớp")
        assert any(e["business_type"] == "MASSAGE_REHABILITATION" for e in results)

    def test_keyword_scan_empty(self):
        results = _keyword_scan("tôi muốn đặt lịch")
        assert len(results) == 0


# ============================================================================
# NER Tag Merging (underthesea output format)
# ============================================================================

class TestMergeNerTags:

    def test_merge_b_i_loc(self):
        """B-LOC + I-LOC → single LOC span."""
        tagged = [
            ("Hà", "N", "B-NP", "B-LOC"),
            ("Nội", "N", "I-NP", "I-LOC"),
        ]
        result = _merge_ner_tags(tagged)
        assert len(result) == 1
        assert result[0]["type"] == "LOC"
        assert result[0]["value"] == "Hà Nội"

    def test_merge_multiple_entities(self):
        tagged = [
            ("Tìm", "V", "B-VP", "O"),
            ("spa", "N", "B-NP", "B-ORG"),
            ("ở", "E", "B-PP", "O"),
            ("Hồ", "N", "B-NP", "B-LOC"),
            ("Chí", "N", "I-NP", "I-LOC"),
            ("Minh", "N", "I-NP", "I-LOC"),
        ]
        result = _merge_ner_tags(tagged)
        assert len(result) == 2
        types = [r["type"] for r in result]
        assert "ORG" in types
        assert "LOC" in types

    def test_merge_only_o_tags(self):
        tagged = [
            ("tìm", "V", "B-VP", "O"),
            ("cái", "N", "B-NP", "O"),
            ("gì", "P", "B-NP", "O"),
        ]
        result = _merge_ner_tags(tagged)
        assert len(result) == 0


# ============================================================================
# Deduplication
# ============================================================================

class TestDeduplicate:

    def test_dedup_same_type_same_value(self):
        entities = [
            {"type": "LOC", "value": "Hà Nội", "confidence": 0.85},
            {"type": "LOC", "value": "Hà Nội", "confidence": 0.90},
        ]
        result = _deduplicate(entities)
        assert len(result) == 1
        assert result[0]["confidence"] == 0.90   # Keep highest

    def test_dedup_different_type(self):
        entities = [
            {"type": "LOC", "value": "spa", "confidence": 0.85},
            {"type": "BUSINESS_TYPE", "value": "spa", "confidence": 0.90},
        ]
        result = _deduplicate(entities)
        assert len(result) == 2


# ============================================================================
# LRU Cache
# ============================================================================

class TestQueryCache:

    def test_cache_hit(self):
        clear_query_cache()
        text = "test cache hit query"
        # First call → cache miss
        r1 = extract_entities(text)
        # Second call → cache hit (same result)
        r2 = extract_entities(text)
        assert r1 == r2
