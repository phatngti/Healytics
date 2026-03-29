# ai_services/ner-service/app/utils/query_builder.py
"""
Chuyển đổi NerEntity list → query params dict.
Dùng để gọi backend search API hoặc filter mock data nội bộ.
"""

import logging
from typing import Any, Dict, List
from app.schemas.ner_schema import NerEntity

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Mock service data — thay bằng gọi API thật khi backend sẵn sàng
# ---------------------------------------------------------------------------

MOCK_SERVICES: Dict[str, Dict] = {
    # Data structure aligned with ServiceDetail / ServiceRecommendationItemDto
    "SV001": {
        "service_id": "SV001",
        "name": "Tư vấn tim mạch trực tuyến",
        "image_url": "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop",
        "badge": "Chuyên khoa",
        "booked_count": 980,
        "staff_name": "BS Nguyễn Văn An",
        "location": {
            "address": "234 Tô Hiến Thành",
            "district": "Quận 10",
            "city": "Hồ Chí Minh",
        },
        "slots": ["2026-03-20T09:00:00", "2026-03-20T14:00:00"],
        "_internal": {
            "basePrice": 350000,
            "ratingValue": 4.8,
            "totalReviews": 210,
            "businessType": ["TRADITIONAL_MEDICINE"],
            "categorySlug": "tim-mach",
            "locationCode": "79",
        },
    },
    "SV002": {
        "service_id": "SV002",
        "name": "Vật lý trị liệu thoát vị đĩa đệm",
        "image_url": "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop",
        "badge": "Premium",
        "booked_count": 1200,
        "staff_name": "BS Nguyễn Văn A",
        "location": {
            "address": "45 Lê Duẩn",
            "district": "Nhân Cơ",
            "city": "Đắk Nông",
        },
        "slots": ["2026-03-21T09:00:00", "2026-03-21T14:00:00"],
        "_internal": {
            "basePrice": 800000,
            "ratingValue": 4.9,
            "totalReviews": 124,
            "businessType": ["MASSAGE_REHABILITATION"],
            "categorySlug": "vat-ly-tri-lieu",
            "locationCode": "67",
        },
    },
    "SV003": {
        "service_id": "SV003",
        "name": "Châm cứu bấm huyệt tại gia",
        "image_url": "https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?w=400&h=300&fit=crop",
        "badge": "Phổ biến",
        "booked_count": 650,
        "staff_name": "Lương y Trần Thị Hoa",
        "location": {
            "address": "12 Trần Phú",
            "district": "Nhân Cơ",
            "city": "Đắk Nông",
        },
        "slots": ["2026-03-22T08:00:00", "2026-03-22T15:00:00"],
        "_internal": {
            "basePrice": 500000,
            "ratingValue": 4.7,
            "totalReviews": 88,
            "businessType": ["TRADITIONAL_MEDICINE"],
            "categorySlug": "dong-y",
            "locationCode": "67",
        },
    },
}


def build_backend_query(entities: List[NerEntity], limit: int = 50, spatial_context=None) -> Dict[str, Any]:
    """
    Chuyển danh sách NerEntity → dict query params cho backend.
    Sử dụng đúng field name theo entity trong backend (Product, Partner).

    Optional spatial_context: SpatialContext object for spatial queries.
    """
    query: Dict[str, Any] = {}
    business_types: list[str] = []
    seen_business_types: set[str] = set()

    for e in entities:
        e_type = e.type

        if e_type == "BUSINESS_TYPE" and e.business_type:
            # Backend Partner.businessType là enum (SPA_BEAUTY, FITNESS, ...)
            if e.business_type not in seen_business_types:
                seen_business_types.add(e.business_type)
                business_types.append(e.business_type)

        elif e_type == "LOCATION" and e.location_code:
            # LOCATION pruning/disambiguation happens upstream; apply resolved location directly.
            query["locationCode"] = e.location_code

        elif e_type == "CATEGORY" and e.category_slug:
            # Backend Category.slug
            query["categorySlug"] = e.category_slug

        elif e_type == "PRICE" and e.amount is not None:
            # Backend Product.basePrice/salePrice
            op = e.operator
            if op == "lte":
                query["maxPrice"] = e.amount
            elif op == "gte":
                query["minPrice"] = e.amount
            elif op == "between":
                query["minPrice"] = e.amount
                query["maxPrice"] = e.amount_max

        elif e_type == "RATING" and e.amount is not None:
            op = e.operator
            if op in ("gte", "between"):
                query["minRating"] = e.amount

    if business_types:
        query["businessTypes"] = business_types
        # Keep backward compatibility for downstream consumers expecting singular key.
        if len(business_types) == 1:
            query["businessType"] = business_types[0]

    # Add spatial parameters if spatial context provided
    if spatial_context:
        query["spatial_params"] = {
            "center_lat": spatial_context.center_lat,
            "center_lng": spatial_context.center_lng,
            "radius_meters": spatial_context.radius_meters,
            "fallback_used": spatial_context.fallback_used,
            "location_level": spatial_context.location_level,  # PROVINCE / DISTRICT / WARD / None
        }
        query["distance_sort"] = True
        query["fallback_used"] = spatial_context.fallback_used
        query["use_postgis"] = True

    query["limit"] = limit
    return query


def filter_mock_services(
    query: Dict[str, Any],
    services: Dict[str, Dict] = MOCK_SERVICES,
) -> List[Dict]:
    """
    Lọc MOCK_SERVICES theo query params.
    Tạm thời dùng cho dev — sau thay bằng backend API call.
    """
    results: List[Dict] = []
    limit = query.get("limit", 50)
    if limit is None or limit <= 0:
        return []

    for sid, svc in services.items():
        internal = svc.get("_internal", {})

        # Business type filter - OR semantics for list input
        target_bts = query.get("businessTypes")
        if not target_bts:
            target_bt = query.get("businessType")
            if target_bt:
                target_bts = [target_bt]

        if target_bts:
            svc_bts = internal.get("businessType", [])
            if not any(bt in svc_bts for bt in target_bts):
                continue

        # Location filter - match code
        target_loc_code = query.get("locationCode")
        if target_loc_code:
            svc_loc_code = internal.get("locationCode")
            if svc_loc_code != target_loc_code:
                continue

        # Category filter - match slug
        target_cat_slug = query.get("categorySlug")
        if target_cat_slug:
            svc_cat_slug = internal.get("categorySlug")
            if svc_cat_slug != target_cat_slug:
                continue

        # Price filter
        price_amount = internal.get("basePrice", 0)
        max_price = query.get("maxPrice")
        min_price = query.get("minPrice")
        if max_price is not None and price_amount > max_price:
            continue
        if min_price is not None and price_amount < min_price:
            continue

        # Rating filter
        min_rating = query.get("minRating")
        if min_rating is not None:
            avg_rating = internal.get("ratingValue", 0)
            if avg_rating < min_rating:
                continue

        normalized = dict(svc)
        internal = normalized.get("_internal", {})
        # Backward-compatible aliases used by legacy tests/consumers.
        normalized.setdefault("id", normalized.get("service_id"))
        normalized.setdefault("base_price", internal.get("basePrice"))
        normalized.setdefault("sale_price", None)
        normalized.setdefault("business_types", internal.get("businessType", []))
        if normalized.get("business_types"):
            normalized.setdefault("type", normalized["business_types"][0])

        results.append(normalized)
        if len(results) >= limit:
            break

    return results


# ---------------------------------------------------------------------------
# Private helpers
# ---------------------------------------------------------------------------

def _business_type_keywords(bt: str) -> list[str]:
    mapping = {
        "SPA_BEAUTY": ["spa", "làm đẹp", "chăm sóc da"],
        "FITNESS": ["gym", "yoga", "pilates", "thể hình", "fitness", "tập"],
        "DENTAL": ["nha khoa", "răng", "niềng"],
        "MASSAGE_THERAPY": ["massage", "mát xa"],
        "MASSAGE_REHABILITATION": ["trị liệu", "phục hồi", "vật lý trị liệu", "nắn xương"],
        "PSYCHOLOGY": ["tâm lý", "trầm cảm", "lo âu", "stress"],
        "PSYCHIATRY": ["tâm thần"],
        "DERMATOLOGY": ["da liễu", "mụn", "thẩm mỹ"],
        "NUTRITION": ["dinh dưỡng", "ăn kiêng", "giảm cân"],
        "TRADITIONAL_MEDICINE": ["đông y", "châm cứu", "bấm huyệt"],
        "PHARMACY": ["dược", "thuốc"],
    }
    return mapping.get(bt, [bt.lower()])


def _location_matches(code: str, city: str, district: str) -> bool:
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
    if code not in code_city_map:
        return True
    return False
