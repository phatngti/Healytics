"""
tests/test_normalizer.py

Unit tests cho normalizer module:
- Location O(1) lookup (province + unknown)
- TPHCM alias (code '79'), Quận 1 (district lookup)
- BusinessType alias matching (exact + fuzzy)
- Category fuzzy matching
- Price/Rating/Distance pass-through
- Hallucination-safe: unknown entities → None
"""

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

    def test_province_tphcm_alias(self):
        """'TPHCM' is a recognized alias for Hồ Chí Minh (code '79')."""
        raw = [{"type": "LOC", "value": "TPHCM", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].location_code == "79"

    def test_province_saigon_alias(self):
        raw = [{"type": "LOC", "value": "Sài Gòn", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].location_code == "79"

    def test_district_quan_1(self):
        """'Quận 1' → district lookup returns a location_code."""
        raw = [{"type": "LOC", "value": "Quận 1", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "LOCATION"
        # location_code should be populated (not None) for a known district
        assert result[0].location_code is not None, \
            "Quận 1 should resolve to a location_code via district fallback"

    def test_unknown_location_returns_none(self):
        """Hallucination-safe: trả về location_code=None nếu không tìm thấy."""
        raw = [{"type": "LOC", "value": "Hành Tinh Mars", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "LOCATION"
        assert result[0].location_code is None
        assert result[0].confidence < 0.85   # Confidence giảm

    def test_location_intent_not_scored_in_normalizer(self):
        raw = [{
            "type": "LOC",
            "value": "Hà Nội",
            "confidence": 0.85,
            "source_query": "tìm spa ở Hà Nội",
        }]
        result = normalize_entities(raw)
        assert result[0].location_intent is None


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

    def test_dental_from_keyword_scan(self):
        raw = [{
            "type": "BUSINESS_TYPE",
            "value": "nha sĩ",
            "confidence": 0.90,
            "business_type": "DENTAL",
        }]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].business_type == "DENTAL"


# ============================================================================
# ORG/MISC → BusinessType alias + semantic business type
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
        """ORG 'thẩm mỹ viện' → semantic match → SPA_BEAUTY."""
        raw = [{"type": "ORG", "value": "thẩm mỹ viện", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "BUSINESS_TYPE"

    def test_org_unknown_returns_none(self):
        """ORG unrecognizable → no mapped business type (hallucination-safe)."""
        raw = [{"type": "ORG", "value": "xyzabc123", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].business_type is None


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


# ============================================================================
# Location — extended province & district coverage
# ============================================================================

class TestNormalizeLocationExtended:

    def test_full_tp_ho_chi_minh(self):
        """'Thành phố Hồ Chí Minh' → canonical strips prefix → code '79'."""
        raw = [{"type": "LOC", "value": "Thành phố Hồ Chí Minh", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].location_code == "79"

    def test_full_thanh_pho_ha_noi(self):
        raw = [{"type": "LOC", "value": "Thành phố Hà Nội", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result[0].location_code == "01"

    def test_da_nang_resolved(self):
        raw = [{"type": "LOC", "value": "Đà Nẵng", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result[0].location_code == "48"

    def test_hue_alias(self):
        raw = [{"type": "LOC", "value": "Huế", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result[0].location_code is not None

    def test_binh_thanh_district(self):
        raw = [{"type": "LOC", "value": "Bình Thạnh", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result[0].location_code is not None
        assert result[0].location_level == "DISTRICT"

    def test_go_vap_district(self):
        raw = [{"type": "LOC", "value": "Gò Vấp", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].location_code is not None

    def test_quan_7_district(self):
        raw = [{"type": "LOC", "value": "Quận 7", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].location_code is not None

    def test_phu_nhuan(self):
        raw = [{"type": "LOC", "value": "Phú Nhuận", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].location_code is not None

    def test_thu_duc(self):
        raw = [{"type": "LOC", "value": "Thủ Đức", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].location_code is not None


# ============================================================================
# BusinessType — extended ORG alias mapping
# ============================================================================

class TestNormalizeBusinessTypeExtended:

    def test_org_yoga_is_fitness(self):
        raw = [{"type": "ORG", "value": "yoga", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].business_type == "FITNESS"

    def test_org_pilates_is_fitness(self):
        raw = [{"type": "ORG", "value": "pilates", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].business_type == "FITNESS"

    def test_org_nha_khoa_is_dental(self):
        raw = [{"type": "ORG", "value": "nha khoa", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].business_type == "DENTAL"

    def test_org_massage_is_massage_therapy(self):
        raw = [{"type": "ORG", "value": "massage", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].business_type == "MASSAGE_THERAPY"

    def test_org_dong_y(self):
        raw = [{"type": "ORG", "value": "đông y", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert result and result[0].business_type == "TRADITIONAL_MEDICINE"

    def test_business_type_entity_passthrough(self):
        raw = [{
            "type": "BUSINESS_TYPE",
            "value": "thẩm mỹ",
            "confidence": 0.90,
            "business_type": "SPA_BEAUTY",
        }]
        result = normalize_entities(raw)
        assert result and result[0].business_type == "SPA_BEAUTY"


# ============================================================================
# Rating — extended
# ============================================================================

class TestNormalizeRatingExtended:

    def test_lte_rating(self):
        raw = [{"type": "RATING", "value": "dưới 3 sao", "confidence": 1.0, "operator": "lte", "amount": 3.0}]
        result = normalize_entities(raw)
        assert result and result[0].operator == "lte" and result[0].amount == 3.0

    def test_between_rating(self):
        raw = [{"type": "RATING", "value": "từ 4 đến 5 sao", "confidence": 1.0,
                "operator": "between", "amount": 4.0, "amount_max": 5.0}]
        result = normalize_entities(raw)
        assert result and result[0].amount == 4.0 and result[0].amount_max == 5.0


# ============================================================================
# Price (continued) — range passthrough test
# ============================================================================

class TestNormalizePriceRange:

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
# Distance — pass-through with spatial fields
# ============================================================================

class TestNormalizeDistance:

    def test_distance_type_preserved(self):
        raw = [{
            "type": "DISTANCE",
            "value": "5km",
            "confidence": 1.0,
            "radius_meters": 5000,
            "distance_unit": "km",
            "proximity_intent": False,
        }]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "DISTANCE"

    def test_distance_radius_preserved(self):
        raw = [{
            "type": "DISTANCE",
            "value": "5km",
            "confidence": 1.0,
            "radius_meters": 5000,
            "distance_unit": "km",
            "proximity_intent": False,
        }]
        result = normalize_entities(raw)
        assert result[0].radius_meters == 5000

    def test_distance_unit_preserved(self):
        raw = [{
            "type": "DISTANCE",
            "value": "5km",
            "confidence": 1.0,
            "radius_meters": 5000,
            "distance_unit": "km",
            "proximity_intent": False,
        }]
        result = normalize_entities(raw)
        assert result[0].distance_unit == "km"

    def test_distance_proximity_intent_preserved(self):
        raw = [{
            "type": "DISTANCE",
            "value": "gần đây",
            "confidence": 0.85,
            "radius_meters": 5000,
            "distance_unit": "implicit",
            "proximity_intent": True,
        }]
        result = normalize_entities(raw)
        assert result[0].proximity_intent is True

    def test_distance_implicit_radius_5000(self):
        """Default proximity radius is now 5000m (updated from 3000m)."""
        raw = [{
            "type": "DISTANCE",
            "value": "gần đây",
            "confidence": 0.85,
            "radius_meters": 5000,
            "distance_unit": "implicit",
            "proximity_intent": True,
        }]
        result = normalize_entities(raw)
        assert result[0].radius_meters == 5000

    def test_cay_so_2000m(self):
        """'2 cây số' = 2000m pass-through."""
        raw = [{
            "type": "DISTANCE",
            "value": "2cây số",
            "confidence": 1.0,
            "radius_meters": 2000,
            "distance_unit": "cây số",
            "proximity_intent": False,
        }]
        result = normalize_entities(raw)
        assert result[0].radius_meters == 2000

    def test_distance_between_passthrough(self):
        raw = [{
            "type": "DISTANCE",
            "value": "từ 2km đến 5km",
            "confidence": 1.0,
            "operator": "between",
            "amount": 2000.0,
            "amount_max": 5000.0,
            "radius_meters": 5000,
            "distance_unit": "km",
            "proximity_intent": False,
        }]
        result = normalize_entities(raw)
        assert result[0].operator == "between"
        assert result[0].amount == 2000.0
        assert result[0].amount_max == 5000.0

    def test_distance_gte_passthrough(self):
        raw = [{
            "type": "DISTANCE",
            "value": "trên 3km",
            "confidence": 1.0,
            "operator": "gte",
            "amount": 3000.0,
            "amount_max": 50000.0,
            "radius_meters": 3000,
            "distance_unit": "km",
            "proximity_intent": False,
        }]
        result = normalize_entities(raw)
        assert result[0].operator == "gte"
        assert result[0].amount == 3000.0
        assert result[0].amount_max == 50000.0


# ============================================================================
# Skip unknown types
# ============================================================================

class TestSkipUnknown:

    def test_per_type_skipped(self):
        """PER entities (tên người) → skipped."""
        raw = [{"type": "PER", "value": "Nguyễn Văn A", "confidence": 0.85}]
        result = normalize_entities(raw)
        assert len(result) == 0

    def test_mixed_types_skips_per(self):
        """Mixed list: PER skipped, PRICE kept."""
        raw = [
            {"type": "PER", "value": "Nguyễn Văn A", "confidence": 0.85},
            {"type": "PRICE", "value": "dưới 500k", "confidence": 1.0, "operator": "lte", "amount": 500000.0},
        ]
        result = normalize_entities(raw)
        assert len(result) == 1
        assert result[0].type == "PRICE"

