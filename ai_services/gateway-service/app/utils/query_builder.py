# ai_services/gateway-service/app/utils/query_builder.py
"""
Chuyển đổi NerEntity list → query params dict.
Dùng để gọi backend search API hoặc filter mock data.
"""

import logging
from typing import Any, Dict, List

logger = logging.getLogger(__name__)


def build_backend_query(entities: List[Dict[str, Any]], limit: int = 50) -> Dict[str, Any]:
    """
    Chuyển danh sách NerEntity dict → dict query params cho backend.

    Mapping:
      BUSINESS_TYPE → businessType
      LOCATION      → locationCode, locationLevel
      CATEGORY      → categorySlug
      PRICE         → minPrice / maxPrice (tùy operator)
      RATING        → minRating
    """
    query: Dict[str, Any] = {}

    for e in entities:
        e_type = e.get("type", "")

        if e_type == "BUSINESS_TYPE" and e.get("business_type"):
            query["businessType"] = e["business_type"]

        elif e_type == "LOCATION" and e.get("location_code"):
            query["locationCode"] = e["location_code"]
            query["locationLevel"] = e.get("location_level")

        elif e_type == "CATEGORY" and e.get("category_slug"):
            query["categorySlug"] = e["category_slug"]

        elif e_type == "PRICE" and e.get("amount") is not None:
            op = e.get("operator")
            if op == "lte":
                query["maxPrice"] = e["amount"]
            elif op == "gte":
                query["minPrice"] = e["amount"]
            elif op == "between":
                query["minPrice"] = e["amount"]
                query["maxPrice"] = e.get("amount_max")

        elif e_type == "RATING" and e.get("amount") is not None:
            op = e.get("operator")
            if op in ("gte", "between"):
                query["minRating"] = e["amount"]

    query["limit"] = limit
    return query


def filter_mock_services(
    query: Dict[str, Any],
    services: Dict[str, Dict],
) -> List[Dict]:
    """
    Lọc MOCK_SERVICES theo query params.
    Tạm thời dùng cho dev — sau thay bằng backend API call.
    """
    results: List[Dict] = []
    limit = query.get("limit", 50)

    for sid, svc in services.items():
        # Business type filter — check name keywords (mock không có enum field)
        bt = query.get("businessType")
        if bt:
            name_lower = svc.get("name", "").lower()
            desc_lower = svc.get("description", "").lower()
            bt_keywords = _business_type_keywords(bt)
            if not any(kw in name_lower or kw in desc_lower for kw in bt_keywords):
                continue

        # Location filter — match city/district
        loc_code = query.get("locationCode")
        if loc_code:
            location = svc.get("location", {})
            city = location.get("city", "").lower()
            district = location.get("district", "").lower()
            # Simple check: province code → city name mapping
            if not _location_matches(loc_code, city, district):
                continue

        # Price filter
        price_amount = svc.get("price", {}).get("amount", 0)
        max_price = query.get("maxPrice")
        min_price = query.get("minPrice")
        if max_price is not None and price_amount > max_price:
            continue
        if min_price is not None and price_amount < min_price:
            continue

        # Rating filter
        min_rating = query.get("minRating")
        if min_rating is not None:
            avg_rating = svc.get("rating", {}).get("average", 0)
            if avg_rating < min_rating:
                continue

        results.append(svc)
        if len(results) >= limit:
            break

    return results


# ---------------------------------------------------------------------------
# Private helpers
# ---------------------------------------------------------------------------

def _business_type_keywords(bt: str) -> list[str]:
    """Map business_type enum → search keywords for mock filtering."""
    mapping = {
        "SPA_BEAUTY": ["spa", "làm đẹp", "chăm sóc da"],
        "FITNESS": ["gym", "yoga", "pilates", "thể hình", "fitness", "tập", "aerobic", "zumba", "crossfit", "hiit", "bơi", "chạy", "đạp xe"],
        "DENTAL": ["nha khoa", "răng", "niềng"],
        "MASSAGE_THERAPY": ["massage", "mát xa"],
        "MASSAGE_REHABILITATION": ["trị liệu", "phục hồi", "vật lý trị liệu", "nắn xương"],
        "PSYCHOLOGY": ["tâm lý", "trầm cảm", "lo âu", "stress", "căng thẳng"],
        "PSYCHIATRY": ["tâm thần"],
        "DERMATOLOGY": ["da liễu", "mụn", "thẩm mỹ"],
        "NUTRITION": ["dinh dưỡng", "ăn kiêng", "giảm cân", "keto", "ăn chay"],
        "TRADITIONAL_MEDICINE": ["đông y", "châm cứu", "bấm huyệt"],
        "PHARMACY": ["dược", "thuốc"],
    }
    return mapping.get(bt, [bt.lower()])


def _location_matches(code: str, city: str, district: str) -> bool:
    """Simple province code → city match for mock data."""
    code_city_map = {
        "79": "hồ chí minh",
        "01": "hà nội",
        "48": "đà nẵng",
        "92": "cần thơ",
        "31": "hải phòng",
    }
    expected_city = code_city_map.get(code, "")
    if expected_city and expected_city in city:
        return True
    # If code not in map, pass through (don't filter)
    if code not in code_city_map:
        return True
    return False
