"""
ai_services/ner-service/app/schemas/ner_schema.py

Pydantic schemas for NER request/response.
Extended with normalized fields for downstream pre-filtering.
"""

from typing import List, Optional

from pydantic import BaseModel, Field


class NerRequest(BaseModel):
    text: str = Field(..., min_length=1)
    current_lat: Optional[float] = Field(None, ge=-90, le=90, description="User's current latitude")
    current_lng: Optional[float] = Field(None, ge=-180, le=180, description="User's current longitude")
    user_registered_address: Optional[str] = Field(None, max_length=500, description="User's registered address for spatial fallback")


class NerEntity(BaseModel):
    type: str                                       # BUSINESS_TYPE / LOCATION / PRICE / RATING / CATEGORY
    value: str                                      # raw text từ query
    confidence: float = Field(..., ge=0.0, le=1.0)

    # Normalized fields — None = không map được (graceful degradation)
    business_type: Optional[str] = None             # VD: "SPA_BEAUTY" — khớp backend enum
    location_code: Optional[str] = None             # VD: "01" (Hà Nội), "760" (Quận 1)
    location_level: Optional[str] = None            # PROVINCE / DISTRICT / WARD
    category_slug: Optional[str] = None             # VD: "yoga-therapy"
    operator: Optional[str] = None                  # lte / gte / between
    amount: Optional[float] = None                  # giá trị số sau normalize
    amount_max: Optional[float] = None              # giới hạn trên nếu "từ X đến Y"

    # Spatial/Distance fields
    radius_meters: Optional[int] = None             # Extracted distance in meters (e.g., 5000 for "5km")
    distance_unit: Optional[str] = None             # Original unit ("km", "m", "cây số")
    proximity_intent: Optional[bool] = None         # True if implicit ("gần đây"), False if explicit
    fallback_to_registered_address: Optional[bool] = None  # True if using address fallback


class NerResponse(BaseModel):
    entities: List[NerEntity]


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


class PreFilterResponse(BaseModel):
    text: str
    entities: List[NerEntity]
    query_params: dict
    candidates: List[ServiceCandidate]
    total: int
