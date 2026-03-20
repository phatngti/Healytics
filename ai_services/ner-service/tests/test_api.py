"""
tests/test_api.py

Integration tests cho NER API endpoints.
Dùng httpx.AsyncClient + FastAPI ASGITransport (no live server needed).

Changes from previous version:
- Default proximity radius updated to 5000m (was 3000m)
- Added TPHCM alias test, Quận 1 location test
- Added 3-case spatial routing tests (TH1/TH2/TH3)
- Added false-positive prevention tests (hiệu thuốc, làm đẹp)
"""

import pytest
import pytest_asyncio
from unittest.mock import patch, AsyncMock
from httpx import ASGITransport, AsyncClient

from app.main import app


@pytest_asyncio.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac


# ============================================================================
# POST /ner/extract — basic schema
# ============================================================================

class TestNerExtractEndpoint:

    async def test_extract_returns_200(self, client):
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa ở Hà Nội giá dưới 500k"},
        )
        assert response.status_code == 200

    async def test_extract_response_schema(self, client):
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa ở Hà Nội giá dưới 500k"},
        )
        data = response.json()
        assert "entities" in data
        assert isinstance(data["entities"], list)

    async def test_extract_finds_entities(self, client):
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa ở Hà Nội giá dưới 500k trên 4 sao"},
        )
        data = response.json()
        entities = data["entities"]
        types = [e["type"] for e in entities]
        assert "BUSINESS_TYPE" in types or "PRICE" in types

    async def test_extract_empty_text_returns_422(self, client):
        response = await client.post("/ner/extract", json={"text": ""})
        assert response.status_code == 422


# ============================================================================
# POST /ner/extract — entity extraction features
# ============================================================================

class TestNerExtractNewFeatures:

    async def test_nha_si_extracted_as_dental(self, client):
        """'nha sĩ' → BUSINESS_TYPE DENTAL."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Mình cần tìm phòng khám nha sĩ ở HCM"},
        )
        assert response.status_code == 200
        data = response.json()
        bt_entities = [e for e in data["entities"] if e["type"] == "BUSINESS_TYPE"]
        assert any(e.get("business_type") == "DENTAL" for e in bt_entities), \
            f"Expected DENTAL in {bt_entities}"

    async def test_explicit_distance_5km(self, client):
        """'cách đây 5km' → DISTANCE entity with radius_meters=5000."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa cách đây 5km"},
        )
        assert response.status_code == 200
        data = response.json()
        dist_entities = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert len(dist_entities) == 1
        assert dist_entities[0]["radius_meters"] == 5000
        assert dist_entities[0].get("proximity_intent") is False

    async def test_implicit_proximity_gan_day_default_5000m(self, client):
        """'gần đây' → DISTANCE entity with proximity_intent=True and default 5000m (not 3000m)."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm gym gần đây"},
        )
        assert response.status_code == 200
        data = response.json()
        dist_entities = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert len(dist_entities) == 1
        assert dist_entities[0]["radius_meters"] == 5000, \
            f"Default radius should be 5000m, got {dist_entities[0]['radius_meters']}"
        assert dist_entities[0].get("proximity_intent") is True

    async def test_explicit_distance_overrides_implicit(self, client):
        """'5km + gần đây' → explicit 5km wins, proximity_intent=False."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa gần đây khoảng 5km"},
        )
        assert response.status_code == 200
        data = response.json()
        dist_entities = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert len(dist_entities) == 1
        assert dist_entities[0]["radius_meters"] == 5000
        assert dist_entities[0].get("proximity_intent") is False

    async def test_price_no_modifier_gia_500k(self, client):
        """'giá 500k' → PRICE operator='between' ±15%."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa giá 500k"},
        )
        assert response.status_code == 200
        data = response.json()
        price_entities = [e for e in data["entities"] if e["type"] == "PRICE"]
        assert len(price_entities) == 1
        p = price_entities[0]
        assert p["operator"] == "between"
        assert p["amount"] == 425_000.0
        assert p["amount_max"] == 575_000.0

    async def test_rating_not_false_positive_on_distance(self, client):
        """'trên 3km' must NOT extract RATING (rating requires 'sao'/'điểm' unit)."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa cách nhà trên 3km"},
        )
        assert response.status_code == 200
        data = response.json()
        rating_entities = [e for e in data["entities"] if e["type"] == "RATING"]
        assert len(rating_entities) == 0, \
            f"Unexpected RATING entities from distance text: {rating_entities}"

    async def test_price_decimal_amount(self, client):
        """'dưới 1.5 triệu' → amount=1500000 (decimal preserved)."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa giá dưới 1.5 triệu"},
        )
        assert response.status_code == 200
        data = response.json()
        price_entities = [e for e in data["entities"] if e["type"] == "PRICE"]
        assert any(e["amount"] == 1_500_000.0 for e in price_entities), \
            f"Expected 1500000 in {[e['amount'] for e in price_entities]}"

    async def test_massage_tri_lieu_maps_to_rehabilitation(self, client):
        """'massage trị liệu' → MASSAGE_REHABILITATION (not MASSAGE_THERAPY)."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm dịch vụ massage trị liệu ở Bình Thạnh"},
        )
        assert response.status_code == 200
        data = response.json()
        bt_entities = [e for e in data["entities"] if e["type"] == "BUSINESS_TYPE"]
        assert any(e.get("business_type") == "MASSAGE_REHABILITATION" for e in bt_entities), \
            f"Expected MASSAGE_REHABILITATION in {bt_entities}"

    async def test_canh_do_500m_unit_meters(self, client):
        """'500m' → radius_meters=500."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa cách đây 500m"},
        )
        assert response.status_code == 200
        data = response.json()
        dist_entities = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert len(dist_entities) == 1
        assert dist_entities[0]["radius_meters"] == 500

    async def test_cay_so_unit_equals_1000m(self, client):
        """'2 cây số' = 2km = 2000m."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa cách đây 2 cây số"},
        )
        assert response.status_code == 200
        data = response.json()
        dist_entities = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert len(dist_entities) == 1
        assert dist_entities[0]["radius_meters"] == 2000, \
            f"Expected 2000m for '2 cây số', got {dist_entities[0]['radius_meters']}"


# ============================================================================
# POST /ner/extract — location bug fixes
# ============================================================================

class TestNerExtractLocationFixes:

    async def test_tphcm_recognized_as_hcm(self, client):
        """'TPHCM' alias → LOCATION with location_code='79'."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Nha khoa khoảng 1.5 triệu ở TPHCM"},
        )
        assert response.status_code == 200
        data = response.json()
        loc_entities = [e for e in data["entities"] if e["type"] == "LOCATION"]
        assert any(e.get("location_code") == "79" for e in loc_entities), \
            f"Expected location_code=79 for TPHCM, got {loc_entities}"

    async def test_quan_1_extracted_as_location(self, client):
        """'Quận 1' → LOCATION entity with a non-None location_code."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa ở Quận 1 TPHCM"},
        )
        assert response.status_code == 200
        data = response.json()
        loc_entities = [e for e in data["entities"] if e["type"] == "LOCATION"]
        assert len(loc_entities) >= 1, "Expected at least one LOCATION entity"
        # At least one location should have a code (Quận 1 or TPHCM)
        assert any(e.get("location_code") is not None for e in loc_entities), \
            f"No location_code resolved for Quận 1 / TPHCM: {loc_entities}"

    async def test_hieu_thuoc_no_false_loc(self, client):
        """'hiệu thuốc' must NOT produce a LOCATION entity ('hiệu' is not a location)."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm hiệu thuốc gần đây"},
        )
        assert response.status_code == 200
        data = response.json()
        loc_entities = [e for e in data["entities"] if e["type"] == "LOCATION"]
        loc_values = [e["value"].lower() for e in loc_entities]
        assert "hiệu" not in loc_values, \
            f"False positive 'hiệu' as location from 'hiệu thuốc': {loc_entities}"

    async def test_lam_dep_no_false_loc(self, client):
        """'làm đẹp' must NOT produce LOCATION for 'làm'."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm tiệm làm đẹp ở Hà Nội"},
        )
        assert response.status_code == 200
        data = response.json()
        loc_entities = [e for e in data["entities"] if e["type"] == "LOCATION"]
        loc_values = [e["value"].lower() for e in loc_entities]
        assert "làm" not in loc_values, \
            f"False positive 'làm' as location from 'làm đẹp': {loc_entities}"


# ============================================================================
# POST /ner/extract — backward compat & spatial field validation
# ============================================================================

class TestNerExtractSpatialFields:

    async def test_backward_compat_no_spatial_fields(self, client):
        """Old requests without spatial fields work unchanged."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa ở Quận 1"},
        )
        assert response.status_code == 200
        assert "entities" in response.json()

    async def test_spatial_fields_accepted_in_request(self, client):
        """New spatial fields are accepted without validation errors."""
        response = await client.post(
            "/ner/extract",
            json={
                "text": "Tìm spa gần đây",
                "current_lat": 10.7769,
                "current_lng": 106.7009,
                "user_registered_address": "TP. Hồ Chí Minh",
            },
        )
        assert response.status_code == 200

    async def test_max_one_distance_entity(self, client):
        """Pipeline returns at most 1 DISTANCE entity."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa gần đây trong vòng 5km"},
        )
        data = response.json()
        dist_entities = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert len(dist_entities) <= 1

    async def test_no_distance_without_proximity_term(self, client):
        """'Tìm spa ở Quận 1' (no proximity term) → no DISTANCE entity."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa ở Quận 1"},
        )
        data = response.json()
        types = [e["type"] for e in data["entities"]]
        assert "DISTANCE" not in types


# ============================================================================
# POST /internal/clear-cache
# ============================================================================

class TestClearCacheEndpoint:

    async def test_clear_cache_returns_200(self, client):
        response = await client.post("/internal/clear-cache")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "ok"


# ============================================================================
# POST /prefilter/search — schema validation
# ============================================================================

class TestPrefilterEndpoint:

    async def test_prefilter_empty_text_returns_422(self, client):
        response = await client.post("/prefilter/search", json={"text": ""})
        assert response.status_code == 422

    async def test_prefilter_invalid_lat_returns_422(self, client):
        """lat=-91 (below -90) → 422."""
        response = await client.post(
            "/prefilter/search",
            json={"text": "Tìm spa gần đây", "current_lat": -91.0, "current_lng": 106.7},
        )
        assert response.status_code == 422

    async def test_prefilter_invalid_lng_returns_422(self, client):
        """lng=200 (above 180) → 422."""
        response = await client.post(
            "/prefilter/search",
            json={"text": "Tìm spa gần đây", "current_lat": 10.77, "current_lng": 200.0},
        )
        assert response.status_code == 422

    async def test_prefilter_with_valid_spatial_fields_calls_db(self, client):
        """Valid spatial query reaches DB (mocked) and returns list of service IDs."""
        from app.schemas.ner_schema import ServiceCandidate
        mock_candidates = [
            ServiceCandidate(
                id="test-id",
                name="Spa Test",
                slug="spa-test",
                type="SPA",
                vendorName="Test Brand",
                category="Spa & Làm đẹp",
                duration="60 phút",
                price="250,000 ₫",
                rating="4.5 sao",
                location="Quận 1, TP. HCM",
                imageUrl=None,
                distance_meters=1200.0,
            )
        ]
        with patch(
            "app.utils.db_fetcher.fetch_candidates_from_db",
            new_callable=AsyncMock,
            return_value=mock_candidates,
        ):
            response = await client.post(
                "/prefilter/search",
                json={
                    "text": "Tìm spa gần đây",
                    "current_lat": 10.7769,
                    "current_lng": 106.7009,
                },
            )
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert data == ["test-id"]

    async def test_prefilter_th1_gps_no_distance_in_text_no_postgis(self, client):
        """Text-only query (no DISTANCE entity) → use_postgis=False, no spatial_params."""
        mock_candidates = []
        with patch(
            "app.utils.db_fetcher.fetch_candidates_from_db",
            new_callable=AsyncMock,
            return_value=mock_candidates,
        ) as mock_fetch:
            response = await client.post(
                "/prefilter/search",
                json={
                    "text": "Tìm spa ở Quận 1",
                    "current_lat": 10.7769,
                    "current_lng": 106.7009,
                },
            )
        assert response.status_code == 200
        # When called, use_postgis should be False (no DISTANCE entity in text)
        if mock_fetch.called:
            call_kwargs = mock_fetch.call_args
            # use_postgis kwarg or second positional arg should be False
            use_postgis_arg = call_kwargs.kwargs.get(
                "use_postgis",
                call_kwargs.args[1] if len(call_kwargs.args) > 1 else False
            )
            assert use_postgis_arg is False


# ============================================================================
# POST /ner/extract — more business type aliases via API
# ============================================================================

class TestNerExtractMoreAliases:

    async def test_yoga_extracted_as_fitness(self, client):
        response = await client.post("/ner/extract", json={"text": "tìm lớp yoga gần đây"})
        assert response.status_code == 200
        data = response.json()
        bt = [e for e in data["entities"] if e["type"] == "BUSINESS_TYPE"]
        assert any(e.get("business_type") == "FITNESS" for e in bt), \
            f"Expected FITNESS for 'yoga', got {bt}"

    async def test_tam_ly_extracted_as_psychology(self, client):
        response = await client.post("/ner/extract", json={"text": "tư vấn tâm lý ở Hà Nội"})
        assert response.status_code == 200
        data = response.json()
        bt = [e for e in data["entities"] if e["type"] == "BUSINESS_TYPE"]
        assert any(e.get("business_type") == "PSYCHOLOGY" for e in bt), \
            f"Expected PSYCHOLOGY for 'tâm lý', got {bt}"

    async def test_da_lieu_extracted_as_dermatology(self, client):
        response = await client.post("/ner/extract", json={"text": "phòng khám da liễu giá rẻ"})
        assert response.status_code == 200
        data = response.json()
        bt = [e for e in data["entities"] if e["type"] == "BUSINESS_TYPE"]
        assert any(e.get("business_type") == "DERMATOLOGY" for e in bt)

    async def test_dong_y_extracted_as_traditional_medicine(self, client):
        response = await client.post("/ner/extract", json={"text": "thầy đông y gần đây"})
        assert response.status_code == 200
        data = response.json()
        bt = [e for e in data["entities"] if e["type"] == "BUSINESS_TYPE"]
        assert any(e.get("business_type") == "TRADITIONAL_MEDICINE" for e in bt)

    async def test_vat_ly_tri_lieu_is_rehabilitation(self, client):
        response = await client.post("/ner/extract", json={"text": "vật lý trị liệu sau tai nạn"})
        assert response.status_code == 200
        data = response.json()
        bt = [e for e in data["entities"] if e["type"] == "BUSINESS_TYPE"]
        assert any(e.get("business_type") == "MASSAGE_REHABILITATION" for e in bt)


# ============================================================================
# POST /ner/extract — proximity patterns
# ============================================================================

class TestNerExtractProximity:

    async def test_xung_quanh_day_detected(self, client):
        """'xung quanh đây' → DISTANCE entity with proximity_intent=True."""
        response = await client.post("/ner/extract", json={"text": "spa xung quanh đây có gì không"})
        assert response.status_code == 200
        data = response.json()
        dist = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert len(dist) == 1 and dist[0].get("proximity_intent") is True

    async def test_o_gan_detected(self, client):
        """'ở gần đây' → proximity intent."""
        response = await client.post("/ner/extract", json={"text": "tìm spa ở gần đây"})
        assert response.status_code == 200
        data = response.json()
        dist = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert any(e.get("proximity_intent") is True for e in dist)

    async def test_gan_toi_detected(self, client):
        """'gần tôi' → proximity intent."""
        response = await client.post("/ner/extract", json={"text": "phòng khám gần tôi"})
        assert response.status_code == 200
        data = response.json()
        dist = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert any(e.get("proximity_intent") is True for e in dist)

    async def test_explicit_2_cay_so(self, client):
        """'2 cây số' → radius_meters=2000."""
        response = await client.post("/ner/extract", json={"text": "gym cách 2 cây số"})
        assert response.status_code == 200
        data = response.json()
        dist = [e for e in data["entities"] if e["type"] == "DISTANCE"]
        assert dist and dist[0]["radius_meters"] == 2000


# ============================================================================
# POST /ner/extract — price edge cases via API
# ============================================================================

class TestNerExtractPriceEdgeCases:

    async def test_khoang_400k_is_between(self, client):
        """'khoảng 400k' → PRICE operator=between ±15%."""
        response = await client.post("/ner/extract", json={"text": "massage khoảng 400k"})
        assert response.status_code == 200
        data = response.json()
        prices = [e for e in data["entities"] if e["type"] == "PRICE"]
        assert prices and prices[0]["operator"] == "between"
        assert abs(prices[0]["amount"] - 340_000) < 1

    async def test_tam_500k_is_between(self, client):
        """'tầm 500k' → PRICE operator=between."""
        response = await client.post("/ner/extract", json={"text": "spa tầm 500k"})
        assert response.status_code == 200
        data = response.json()
        prices = [e for e in data["entities"] if e["type"] == "PRICE"]
        assert prices and prices[0]["operator"] == "between"

    async def test_range_200k_to_1tr(self, client):
        """'từ 200k đến 1 triệu' → PRICE operator=between."""
        response = await client.post("/ner/extract", json={"text": "spa từ 200k đến 1 triệu"})
        assert response.status_code == 200
        data = response.json()
        prices = [e for e in data["entities"] if e["type"] == "PRICE"]
        assert prices and prices[0]["operator"] == "between"
        assert prices[0]["amount"] == 200_000.0
        assert prices[0]["amount_max"] == 1_000_000.0

    async def test_rating_and_price_both_extracted(self, client):
        """Both PRICE and RATING extracted from same query."""
        response = await client.post(
            "/ner/extract",
            json={"text": "Tìm spa dưới 500k trên 4 sao"},
        )
        assert response.status_code == 200
        data = response.json()
        types = [e["type"] for e in data["entities"]]
        assert "PRICE" in types
        assert "RATING" in types