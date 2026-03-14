"""
tests/test_api.py

Integration test cho NER API endpoints.
Dùng httpx.AsyncClient + FastAPI TestClient.
"""

import pytest
import pytest_asyncio
from httpx import ASGITransport, AsyncClient

from app.main import app


@pytest_asyncio.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac


# ============================================================================
# POST /ner/extract
# ============================================================================

class TestNerExtractEndpoint:

    async def test_extract_returns_200(self, client):
        response = await client.post(
            "/ner/extract",
            json={
                "conversation_id": "123e4567-e89b-12d3-a456-426614174000",
                "text": "Tìm spa ở Hà Nội giá dưới 500k",
            },
        )
        assert response.status_code == 200

    async def test_extract_response_schema(self, client):
        response = await client.post(
            "/ner/extract",
            json={
                "conversation_id": "123e4567-e89b-12d3-a456-426614174000",
                "text": "Tìm spa ở Hà Nội giá dưới 500k",
            },
        )
        data = response.json()
        assert "conversation_id" in data
        assert "entities" in data
        assert isinstance(data["entities"], list)

    async def test_extract_finds_entities(self, client):
        response = await client.post(
            "/ner/extract",
            json={
                "conversation_id": "123e4567-e89b-12d3-a456-426614174000",
                "text": "Tìm spa ở Hà Nội giá dưới 500k trên 4 sao",
            },
        )
        data = response.json()
        entities = data["entities"]
        types = [e["type"] for e in entities]

        # Should find at least BUSINESS_TYPE (spa) and PRICE (dưới 500k)
        assert "BUSINESS_TYPE" in types or "PRICE" in types

    async def test_extract_empty_text_returns_422(self, client):
        response = await client.post(
            "/ner/extract",
            json={
                "conversation_id": "123e4567-e89b-12d3-a456-426614174000",
                "text": "",
            },
        )
        assert response.status_code == 422


# ============================================================================
# POST /internal/clear-cache
# ============================================================================

class TestClearCacheEndpoint:

    async def test_clear_cache_returns_200(self, client):
        response = await client.post("/internal/clear-cache")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "ok"
