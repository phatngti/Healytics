"""
ai_services/ner-service/app/schemas/ner_schema.py

Pydantic schemas for NER request/response.
Extended with normalized fields for downstream pre-filtering.
"""

from typing import List, Optional

from pydantic import BaseModel, Field, model_validator


class NerRequest(BaseModel):
    text: str = Field(..., min_length=1)
    current_lat: Optional[float] = Field(None, ge=-90, le=90, description="User's current latitude")
    current_lng: Optional[float] = Field(None, ge=-180, le=180, description="User's current longitude")
    user_registered_address: Optional[str] = Field(None, max_length=500, description="User's registered address for spatial fallback")


class NerEntity(BaseModel):
    type: str                                       # BUSINESS_TYPE / LOCATION / PRICE / RATING / CATEGORY / FEATURE_TAG
    value: str                                      # raw text từ query
    confidence: float = Field(..., ge=0.0, le=1.0)

    # Normalized fields — None = không map được (graceful degradation)
    business_type: Optional[str] = None             # VD: "SPA_BEAUTY" — khớp backend enum
    business_evidence: Optional[str] = None         # Chuỗi bằng chứng trích từ query để suy ra business_type
    business_phrase: Optional[str] = None           # Legacy alias giữ tương thích ngược
    location_code: Optional[str] = None             # VD: "01" (Hà Nội), "760" (Quận 1)
    location_level: Optional[str] = None            # PROVINCE / DISTRICT / WARD
    location_intent: Optional[bool] = None          # True nếu location là ràng buộc tìm kiếm
    category_slug: Optional[str] = None             # VD: "yoga-therapy"
    operator: Optional[str] = None                  # lte / gte / between
    amount: Optional[float] = None                  # giá trị số sau normalize
    amount_max: Optional[float] = None              # giới hạn trên nếu "từ X đến Y"

    # Spatial/Distance fields
    radius_meters: Optional[int] = None             # Extracted distance in meters (e.g., 5000 for "5km")
    distance_unit: Optional[str] = None             # Original unit ("km", "m", "cây số")
    proximity_intent: Optional[bool] = None         # True if implicit ("gần đây"), False if explicit
    fallback_to_registered_address: Optional[bool] = None  # True if using address fallback

    # Feature Tag fields (type == "FEATURE_TAG")
    tag_id:   Optional[str] = None   # UUID của product_feature_tags row
    tag_name: Optional[str] = None   # Tên tag, VD: "Đá nóng"
    tag_op:   Optional[str] = None   # "AND" | "OR" — group operator trong tagFilters


class NerResponse(BaseModel):
    entities: List[NerEntity]
    extraction_source: Optional[str] = None


# --- Pre-filter schemas ---

class PreFilterRequest(BaseModel):
    text: str = Field(..., min_length=1)
    limit: int = Field(default=50, ge=1, le=200)
    current_lat: Optional[float] = Field(None, ge=-90, le=90, description="User's current latitude")
    current_lng: Optional[float] = Field(None, ge=-180, le=180, description="User's current longitude")
    user_registered_address: Optional[str] = Field(None, max_length=500, description="User's registered address for spatial fallback")
    sort_by_distance: bool = Field(True, description="Sort results by distance if spatial params provided")


class PriceInfo(BaseModel):
    amount: int
    currency: str = "VND"


class RatingInfo(BaseModel):
    average: float
    total_reviews: int = 0


class LocationInfo(BaseModel):
    address: str = ""
    district: str = ""
    city: str = ""


class ServiceCandidate(BaseModel):
    service_id: str
    name: str
    image_url: Optional[str] = None
    badge: Optional[str] = None
    booked_count: Optional[int] = None
    price: Optional[PriceInfo] = None
    staff_name: Optional[str] = None
    rating: Optional[RatingInfo] = None
    location: Optional[LocationInfo] = None
    slots: Optional[List[str]] = None
    distance_meters: Optional[float] = None

    @model_validator(mode="before")
    @classmethod
    def _coerce_legacy_shape(cls, data):
        """
        Backward compatibility for legacy test/fixture payloads that still use
        old keys: id, imageUrl, vendorName, and string price/rating/location.
        """
        if not isinstance(data, dict):
            return data

        payload = dict(data)

        if "service_id" not in payload and "id" in payload:
            payload["service_id"] = payload.get("id")
        if "image_url" not in payload and "imageUrl" in payload:
            payload["image_url"] = payload.get("imageUrl")
        if "staff_name" not in payload and "vendorName" in payload:
            payload["staff_name"] = payload.get("vendorName")

        if isinstance(payload.get("price"), str):
            digits = "".join(ch for ch in payload["price"] if ch.isdigit())
            amount = int(digits) if digits else 0
            payload["price"] = {"amount": amount, "currency": "VND"}

        if isinstance(payload.get("rating"), str):
            numeric = payload["rating"].replace(",", ".")
            extracted = "".join(ch for ch in numeric if ch.isdigit() or ch == ".")
            avg = float(extracted) if extracted else 0.0
            payload["rating"] = {"average": avg, "total_reviews": 0}

        if isinstance(payload.get("location"), str):
            parts = [p.strip() for p in payload["location"].split(",")]
            district = parts[0] if parts else ""
            city = parts[-1] if len(parts) > 1 else ""
            payload["location"] = {
                "address": payload["location"],
                "district": district,
                "city": city,
            }

        return payload


class PreFilterResponse(BaseModel):
    text: str
    entities: List[NerEntity]
    query_params: dict
    candidates: List[ServiceCandidate]
    total: int
