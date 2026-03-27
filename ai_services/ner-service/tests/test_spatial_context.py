"""
tests/test_spatial_context.py

Unit tests cho spatial_context module:
- SpatialContext dataclass fields
- resolve_spatial_context priority logic (TH1 GPS / TH2 address / TH3 location)
- resolve_registered_address via PROVINCE_MAP
- resolve_location_code_to_coordinates via PROVINCE_CENTERS
- No DISTANCE entity → None returned
- location_level assignment
"""

import pytest
from unittest.mock import patch

from app.ner.spatial_context import (
    SpatialContext,
    resolve_spatial_context,
    resolve_registered_address,
    resolve_location_code_to_coordinates,
)
from app.schemas.ner_schema import NerEntity


# ============================================================================
# Helpers — build test entities
# ============================================================================

def _distance_entity(radius_meters=5000, proximity_intent=False):
    return NerEntity(
        type="DISTANCE",
        value="5km",
        confidence=1.0,
        radius_meters=radius_meters,
        distance_unit="km",
        proximity_intent=proximity_intent,
    )


def _location_entity(location_code="79", location_level="PROVINCE"):
    return NerEntity(
        type="LOCATION",
        value="Hồ Chí Minh",
        confidence=0.9,
        location_code=location_code,
        location_level=location_level,
    )


# ============================================================================
# SpatialContext Dataclass
# ============================================================================

class TestSpatialContextDataclass:

    def test_all_fields_populated(self):
        ctx = SpatialContext(
            center_lat=10.7769,
            center_lng=106.7009,
            radius_meters=5000,
            fallback_used=False,
            location_level=None,
        )
        assert ctx.center_lat == 10.7769
        assert ctx.center_lng == 106.7009
        assert ctx.radius_meters == 5000
        assert ctx.fallback_used is False
        assert ctx.location_level is None

    def test_defaults(self):
        ctx = SpatialContext(center_lat=10.0, center_lng=106.0, radius_meters=3000)
        assert ctx.fallback_used is False
        assert ctx.location_level is None


# ============================================================================
# Priority 1 — GPS coordinates provided (TH1)
# ============================================================================

class TestPriority1GPS:

    def test_gps_coords_used(self):
        entities = [_distance_entity(radius_meters=5000)]
        ctx = resolve_spatial_context(
            entities,
            current_lat=10.7769,
            current_lng=106.7009,
            user_registered_address=None,
        )
        assert ctx is not None
        assert ctx.center_lat == 10.7769
        assert ctx.center_lng == 106.7009
        assert ctx.radius_meters == 5000

    def test_gps_fallback_used_false(self):
        """Real GPS → fallback_used=False."""
        entities = [_distance_entity()]
        ctx = resolve_spatial_context(
            entities, current_lat=10.77, current_lng=106.70, user_registered_address=None
        )
        assert ctx.fallback_used is False

    def test_gps_location_level_none(self):
        """Real GPS → location_level=None (no admin boundary needed)."""
        entities = [_distance_entity()]
        ctx = resolve_spatial_context(
            entities, current_lat=10.77, current_lng=106.70, user_registered_address=None
        )
        assert ctx.location_level is None

    def test_gps_ignores_address(self):
        """When GPS provided, registered address is irrelevant."""
        entities = [_distance_entity()]
        ctx = resolve_spatial_context(
            entities,
            current_lat=21.0285,
            current_lng=105.8542,
            user_registered_address="Hồ Chí Minh",
        )
        # GPS takes priority — lat/lng should match provided coords, not address center
        assert ctx.center_lat == 21.0285
        assert ctx.center_lng == 105.8542

    def test_radius_from_distance_entity(self):
        """radius_meters taken from DISTANCE entity, not a hardcoded default."""
        entities = [_distance_entity(radius_meters=2000)]
        ctx = resolve_spatial_context(
            entities, current_lat=10.0, current_lng=106.0, user_registered_address=None
        )
        assert ctx.radius_meters == 2000


# ============================================================================
# Priority 2 — registered address fallback (TH2)
# ============================================================================

class TestPriority2RegisteredAddress:

    def test_address_hcm_resolves(self):
        """'Hồ Chí Minh' registered address → coords for code '79'."""
        entities = [_distance_entity()]
        ctx = resolve_spatial_context(
            entities,
            current_lat=None,
            current_lng=None,
            user_registered_address="Hồ Chí Minh",
        )
        assert ctx is not None
        assert ctx.center_lat == pytest.approx(10.7769, abs=0.01)
        assert ctx.center_lng == pytest.approx(106.7009, abs=0.01)

    def test_address_fallback_used_true(self):
        """Address fallback → fallback_used=True."""
        entities = [_distance_entity()]
        ctx = resolve_spatial_context(
            entities,
            current_lat=None,
            current_lng=None,
            user_registered_address="Hà Nội",
        )
        assert ctx is not None
        assert ctx.fallback_used is True

    def test_address_location_level_province(self):
        """Registered address resolves at PROVINCE level."""
        entities = [_distance_entity()]
        ctx = resolve_spatial_context(
            entities,
            current_lat=None,
            current_lng=None,
            user_registered_address="Đà Nẵng",
        )
        assert ctx is not None
        assert ctx.location_level == "PROVINCE"

    def test_unknown_address_falls_to_location_entity(self):
        """Unknown address → falls through to Priority 3 (LOCATION entity)."""
        entities = [
            _distance_entity(),
            _location_entity(location_code="79", location_level="PROVINCE"),
        ]
        ctx = resolve_spatial_context(
            entities,
            current_lat=None,
            current_lng=None,
            user_registered_address="Không Biết Ở Đâu XYZ",
        )
        # Should still resolve via location entity
        assert ctx is not None


# ============================================================================
# Priority 3 — LOCATION entity fallback (TH2 or TH3)
# ============================================================================

class TestPriority3LocationEntity:

    def test_province_location_code_resolves(self):
        """LOCATION entity with code '79' (HCM) resolves to province center."""
        entities = [
            _distance_entity(),
            _location_entity(location_code="79", location_level="PROVINCE"),
        ]
        ctx = resolve_spatial_context(
            entities,
            current_lat=None,
            current_lng=None,
            user_registered_address=None,
        )
        assert ctx is not None
        assert ctx.center_lat == pytest.approx(10.7769, abs=0.01)
        assert ctx.fallback_used is True
        assert ctx.location_level == "PROVINCE"

    def test_district_location_level_preserved(self):
        """LOCATION entity with level 'DISTRICT' → location_level=DISTRICT."""
        entities = [
            _distance_entity(),
            _location_entity(location_code="48", location_level="DISTRICT"),
        ]
        ctx = resolve_spatial_context(
            entities,
            current_lat=None,
            current_lng=None,
            user_registered_address=None,
        )
        assert ctx is not None
        assert ctx.location_level == "DISTRICT"

    def test_no_location_code_returns_none(self):
        """LOCATION entity without location_code → can't resolve → None."""
        entities = [
            _distance_entity(),
            NerEntity(type="LOCATION", value="Hành Tinh Lạ", confidence=0.5),
        ]
        ctx = resolve_spatial_context(
            entities,
            current_lat=None,
            current_lng=None,
            user_registered_address=None,
        )
        assert ctx is None


# ============================================================================
# No DISTANCE entity → always None
# ============================================================================

class TestNoDistanceEntity:

    def test_no_entities_returns_none(self):
        ctx = resolve_spatial_context([], None, None, None)
        assert ctx is None

    def test_only_business_type_returns_none(self):
        entities = [NerEntity(type="BUSINESS_TYPE", value="spa", confidence=0.9, business_type="SPA_BEAUTY")]
        ctx = resolve_spatial_context(entities, 10.0, 106.0, None)
        assert ctx is None

    def test_only_price_returns_none(self):
        entities = [
            NerEntity(type="PRICE", value="dưới 500k", confidence=1.0, operator="lte", amount=500000)
        ]
        ctx = resolve_spatial_context(entities, None, None, None)
        assert ctx is None


# ============================================================================
# resolve_registered_address
# ============================================================================

class TestResolveRegisteredAddress:

    def test_hcm_resolves(self):
        result = resolve_registered_address("Hồ Chí Minh")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(10.7769, abs=0.01)

    def test_ha_noi_resolves(self):
        result = resolve_registered_address("Hà Nội")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(21.0285, abs=0.01)

    def test_unknown_returns_none(self):
        result = resolve_registered_address("Xyz Unknown Province")
        assert result is None

    def test_empty_returns_none(self):
        result = resolve_registered_address("")
        assert result is None


# ============================================================================
# resolve_location_code_to_coordinates
# ============================================================================

class TestResolveLocationCode:

    def test_code_79_hcm(self):
        result = resolve_location_code_to_coordinates("79")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(10.7769, abs=0.01)

    def test_code_01_hanoi(self):
        result = resolve_location_code_to_coordinates("01")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(21.0285, abs=0.01)

    def test_code_48_danang(self):
        result = resolve_location_code_to_coordinates("48")
        assert result is not None

    def test_unknown_code_returns_none(self):
        result = resolve_location_code_to_coordinates("999")
        assert result is None

    def test_empty_code_returns_none(self):
        result = resolve_location_code_to_coordinates("")
        assert result is None


# ============================================================================
# resolve_location_code_to_coordinates — extended coordinate assertions
# ============================================================================

class TestResolveLocationCodeExtended:

    def test_code_31_hai_phong_lat(self):
        lat, lng = resolve_location_code_to_coordinates("31")
        assert lat == pytest.approx(20.8449, abs=0.01)

    def test_code_31_hai_phong_lng(self):
        lat, lng = resolve_location_code_to_coordinates("31")
        assert lng == pytest.approx(106.6881, abs=0.01)

    def test_code_46_hue_lat_lng(self):
        result = resolve_location_code_to_coordinates("46")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(16.4637, abs=0.01)
        assert lng == pytest.approx(107.5909, abs=0.01)

    def test_code_56_khanh_hoa_lat_lng(self):
        result = resolve_location_code_to_coordinates("56")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(12.2381, abs=0.01)
        assert lng == pytest.approx(109.1967, abs=0.01)

    def test_code_92_can_tho_lat_lng(self):
        result = resolve_location_code_to_coordinates("92")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(10.0341, abs=0.01)
        assert lng == pytest.approx(105.7880, abs=0.01)

    def test_code_96_ca_mau_lat_lng(self):
        result = resolve_location_code_to_coordinates("96")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(9.1769, abs=0.01)
        assert lng == pytest.approx(105.1524, abs=0.01)

    def test_code_22_quang_ninh_lat_lng(self):
        result = resolve_location_code_to_coordinates("22")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(21.0064, abs=0.01)
        assert lng == pytest.approx(107.2925, abs=0.01)

    def test_code_79_lng_assertion(self):
        """HCM longitude check (supplement existing lat test)."""
        lat, lng = resolve_location_code_to_coordinates("79")
        assert lng == pytest.approx(106.7009, abs=0.01)

    def test_code_01_lng_assertion(self):
        """Hà Nội longitude check."""
        lat, lng = resolve_location_code_to_coordinates("01")
        assert lng == pytest.approx(105.8542, abs=0.01)

    def test_code_10_lao_cai(self):
        result = resolve_location_code_to_coordinates("10")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(22.4810, abs=0.01)
        assert lng == pytest.approx(103.9753, abs=0.01)

    def test_code_11_dien_bien(self):
        result = resolve_location_code_to_coordinates("11")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(21.3860, abs=0.01)
        assert lng == pytest.approx(103.0233, abs=0.01)

    def test_code_68_lam_dong(self):
        result = resolve_location_code_to_coordinates("68")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(11.9230, abs=0.01)
        assert lng == pytest.approx(108.4420, abs=0.01)

    def test_code_79_returns_tuple_of_2(self):
        result = resolve_location_code_to_coordinates("79")
        assert isinstance(result, tuple)
        assert len(result) == 2

    def test_coords_are_floats(self):
        for code in ["01", "48", "79", "92", "96", "22", "46"]:
            lat, lng = resolve_location_code_to_coordinates(code)
            assert isinstance(lat, float), f"Code {code}: lat is not float"
            assert isinstance(lng, float), f"Code {code}: lng is not float"


# ============================================================================
# Coordinate bounds — all 63 provinces within Vietnam geographic bounds
# ============================================================================

class TestCoordinateBounds:
    """Validate all province center coordinates lie within Vietnam's geographic bounds."""

    VIETNAM_LAT_MIN = 8.0
    VIETNAM_LAT_MAX = 24.0
    VIETNAM_LNG_MIN = 102.0
    VIETNAM_LNG_MAX = 110.0

    ALL_CODES = [
        "01", "02", "04", "06", "08", "10", "11", "12", "14", "15",
        "17", "19", "20", "22", "24", "25", "26", "27", "30", "31",
        "33", "34", "35", "36", "37", "38", "40", "42", "44", "45",
        "46", "48", "49", "51", "52", "54", "56", "58", "60", "62",
        "64", "66", "67", "68", "70", "72", "74", "75", "77", "79",
        "80", "82", "83", "84", "86", "87", "89", "91", "92", "93",
        "94", "95", "96",
    ]

    def test_total_code_count_is_63(self):
        """Vietnam has 63 administrative units (provinces + centrally-governed cities)."""
        assert len(self.ALL_CODES) == 63

    def test_all_codes_resolve_non_none(self):
        for code in self.ALL_CODES:
            result = resolve_location_code_to_coordinates(code)
            assert result is not None, f"Province code '{code}' returned None"

    def test_all_latitudes_within_vietnam(self):
        for code in self.ALL_CODES:
            lat, lng = resolve_location_code_to_coordinates(code)
            assert self.VIETNAM_LAT_MIN <= lat <= self.VIETNAM_LAT_MAX, \
                f"Code '{code}' lat={lat} out of Vietnam bounds [{self.VIETNAM_LAT_MIN}, {self.VIETNAM_LAT_MAX}]"

    def test_all_longitudes_within_vietnam(self):
        for code in self.ALL_CODES:
            lat, lng = resolve_location_code_to_coordinates(code)
            assert self.VIETNAM_LNG_MIN <= lng <= self.VIETNAM_LNG_MAX, \
                f"Code '{code}' lng={lng} out of Vietnam bounds [{self.VIETNAM_LNG_MIN}, {self.VIETNAM_LNG_MAX}]"

    def test_ha_giang_is_northernmost(self):
        """Hà Giang (02) has the highest latitude among all provinces."""
        ha_giang_lat, _ = resolve_location_code_to_coordinates("02")
        for code in self.ALL_CODES:
            lat, _ = resolve_location_code_to_coordinates(code)
            assert ha_giang_lat >= lat, \
                f"Hà Giang lat={ha_giang_lat} expected >= code '{code}' lat={lat}"

    def test_ca_mau_is_southernmost(self):
        """Cà Mau (96) has the lowest latitude among all provinces."""
        ca_mau_lat, _ = resolve_location_code_to_coordinates("96")
        for code in self.ALL_CODES:
            lat, _ = resolve_location_code_to_coordinates(code)
            assert ca_mau_lat <= lat, \
                f"Cà Mau lat={ca_mau_lat} expected <= code '{code}' lat={lat}"

    def test_dien_bien_is_westernmost(self):
        """Điện Biên (11) has the lowest longitude (westernmost) among all provinces."""
        _, dien_bien_lng = resolve_location_code_to_coordinates("11")
        for code in self.ALL_CODES:
            _, lng = resolve_location_code_to_coordinates(code)
            assert dien_bien_lng <= lng, \
                f"Điện Biên lng={dien_bien_lng} expected <= code '{code}' lng={lng}"

    def test_hcm_south_of_hanoi(self):
        hanoi_lat, _ = resolve_location_code_to_coordinates("01")
        hcm_lat, _ = resolve_location_code_to_coordinates("79")
        assert hcm_lat < hanoi_lat

    def test_danang_between_hanoi_and_hcm_latitude(self):
        hanoi_lat, _ = resolve_location_code_to_coordinates("01")
        danang_lat, _ = resolve_location_code_to_coordinates("48")
        hcm_lat, _ = resolve_location_code_to_coordinates("79")
        assert hcm_lat < danang_lat < hanoi_lat

    def test_all_lngs_east_of_prime_meridian(self):
        """All Vietnam provinces must have positive longitude (east hemisphere)."""
        for code in self.ALL_CODES:
            _, lng = resolve_location_code_to_coordinates(code)
            assert lng > 0, f"Code '{code}' lng={lng} is not east hemisphere"

    def test_all_lats_in_northern_hemisphere(self):
        """All Vietnam provinces are north of the equator."""
        for code in self.ALL_CODES:
            lat, _ = resolve_location_code_to_coordinates(code)
            assert lat > 0, f"Code '{code}' lat={lat} is not northern hemisphere"


# ============================================================================
# resolve_registered_address — extended address resolution
# ============================================================================

class TestResolveRegisteredAddressExtended:

    def test_da_nang_lat(self):
        result = resolve_registered_address("Đà Nẵng")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(16.0544, abs=0.1)

    def test_da_nang_lng(self):
        result = resolve_registered_address("Đà Nẵng")
        assert result is not None
        lat, lng = result
        assert lng == pytest.approx(108.2022, abs=0.1)

    def test_hai_phong_lat(self):
        result = resolve_registered_address("Hải Phòng")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(20.8449, abs=0.1)

    def test_can_tho_lat(self):
        result = resolve_registered_address("Cần Thơ")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(10.0341, abs=0.1)

    def test_hue_alias_resolves(self):
        """'Huế' is an alias for code '46' in PROVINCE_MAP."""
        result = resolve_registered_address("Huế")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(16.4637, abs=0.1)

    def test_nha_trang_alias_resolves(self):
        """'Nha Trang' is alias for Khánh Hòa (code '56')."""
        result = resolve_registered_address("Nha Trang")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(12.2381, abs=0.1)

    def test_sai_gon_alias_resolves(self):
        """'Sài Gòn' is alias for HCM City (code '79')."""
        result = resolve_registered_address("Sài Gòn")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(10.7769, abs=0.1)

    def test_vung_tau_alias_resolves(self):
        """'Vũng Tàu' is alias for Bà Rịa - Vũng Tàu (code '77')."""
        result = resolve_registered_address("Vũng Tàu")
        assert result is not None

    def test_da_lat_alias_resolves(self):
        """'Đà Lạt' is alias for Lâm Đồng (code '68')."""
        result = resolve_registered_address("Đà Lạt")
        assert result is not None
        lat, lng = result
        assert lat == pytest.approx(11.9230, abs=0.1)

    def test_result_is_tuple_of_floats(self):
        result = resolve_registered_address("Hà Nội")
        assert isinstance(result, tuple)
        lat, lng = result
        assert isinstance(lat, float)
        assert isinstance(lng, float)

    def test_resolved_coords_within_vietnam(self):
        """Every resolved address must lie within Vietnam's geographic bounds."""
        addresses = ["Hà Nội", "Đà Nẵng", "Cần Thơ", "Hải Phòng"]
        for addr in addresses:
            result = resolve_registered_address(addr)
            assert result is not None, f"'{addr}' returned None"
            lat, lng = result
            assert 8.0 <= lat <= 24.0, f"'{addr}' lat={lat} out of bounds"
            assert 102.0 <= lng <= 110.0, f"'{addr}' lng={lng} out of bounds"

    def test_partial_name_returns_none(self):
        """Partial fragment 'Nội' shouldn't match any entry."""
        assert resolve_registered_address("Nội") is None

    def test_numeric_string_returns_none(self):
        assert resolve_registered_address("12345") is None

    def test_whitespace_only_returns_none(self):
        assert resolve_registered_address("   ") is None
