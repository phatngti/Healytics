"""
tests/test_normalizer.py

Unit tests cho normalizer module:
- Location O(1) lookup (province + unknown)
- BusinessType alias matching (exact + fuzzy)
- Category fuzzy matching
- Price/Rating pass-through
- Hallucination-safe: unknown entities → None
"""

from unittest.mock import patch

from app.ner.normalizer import normalize_entities


# ============================================================================
# Location
# ============================================================================

class TestNormalizeLocation:

    def test_province_hanoi(self):
        raw = [{"type": "LOC", "value": "Hà Nội", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "LOCATION"
        assert result[0].location_code == "01"
        assert result[0].location_level == "PROVINCE"

    def test_province_hcm_alias(self):
        raw = [{"type": "LOC", "value": "HCM", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].location_code == "79"

    def test_province_saigon_alias(self):
        raw = [{"type": "LOC", "value": "Sài Gòn", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].location_code == "79"

    def test_unknown_location_returns_none(self):
        """Hallucination-safe: trả về location_code=None nếu không tìm thấy."""
        raw = [{"type": "LOC", "value": "Hành Tinh Mars", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "LOCATION"
        assert result[0].location_code is None
        assert result[0].confidence < 0.85   # Confidence giảm


# ============================================================================
# BusinessType (from keyword scan — already has business_type field)
# ============================================================================

class TestNormalizeBusinessType:

    def test_business_type_from_keyword_scan(self):
        raw = [{
            "type": "BUSINESS_TYPE",
            "value": "spa",
            "confidence": 0.90,
            "business_type": "SPA_BEAUTY",
        }]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "BUSINESS_TYPE"
        assert result[0].business_type == "SPA_BEAUTY"


# ============================================================================
# ORG/MISC → BusinessType alias → Category fuzzy
# ============================================================================

class TestNormalizeOrgMisc:

    def test_org_exact_match_business_type(self):
        """ORG 'spa' → exact match → SPA_BEAUTY."""
        raw = [{"type": "ORG", "value": "spa", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "BUSINESS_TYPE"
        assert result[0].business_type == "SPA_BEAUTY"

    def test_org_fuzzy_match_business_type(self):
        """ORG 'spaa' → fuzzy match → SPA_BEAUTY."""
        raw = [{"type": "ORG", "value": "spaa", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        # Fuzzy match should find SPA_BEAUTY
        assert result[0].business_type == "SPA_BEAUTY"

    def test_org_unknown_returns_none(self):
        """ORG unrecognizable → category_slug=None (hallucination-safe)."""
        raw = [{"type": "ORG", "value": "xyzabc123", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].business_type is None
        assert result[0].category_slug is None


# ============================================================================
# Price
# ============================================================================

class TestNormalizePrice:

    def test_price_passthrough(self):
        raw = [{
            "type": "PRICE",
            "value": "dưới 500k",
            "confidence": 1.0,
            "operator": "lte",
            "amount": 500000.0,
        }]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "PRICE"
        assert result[0].operator == "lte"
        assert result[0].amount == 500000.0

    def test_price_range_passthrough(self):
        raw = [{
            "type": "PRICE",
            "value": "từ 200k đến 1 triệu",
            "confidence": 1.0,
            "operator": "between",
            "amount": 200000.0,
            "amount_max": 1000000.0,
        }]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].operator == "between"
        assert result[0].amount == 200000.0
        assert result[0].amount_max == 1000000.0


# ============================================================================
# Rating
# ============================================================================

class TestNormalizeRating:

    def test_rating_passthrough(self):
        raw = [{
            "type": "RATING",
            "value": "trên 4 sao",
            "confidence": 1.0,
            "operator": "gte",
            "amount": 4.0,
        }]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "RATING"
        assert result[0].operator == "gte"
        assert result[0].amount == 4.0


# ============================================================================
# Skip unknown types
# ============================================================================

class TestSkipUnknown:

    def test_per_type_skipped(self):
        """PER entities (tên người) → skipped."""
        raw = [{"type": "PER", "value": "Nguyễn Văn A", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 0
