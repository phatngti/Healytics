# app/schemas/recommender_schema.py
from pydantic import BaseModel, ConfigDict, Field
from typing import List, Optional, Any, Dict
from uuid import UUID


# ==============================
# REQUEST SCHEMAS
# ==============================

class HomeRecommenderRequest(BaseModel):
    user_id: UUID
    top_k: int = Field(default=5, ge=1, le=20)


class ChatbotRecommenderRequest(BaseModel):
    conversation_id: str
    query: str = Field(..., min_length=1)
    top_k: int = Field(default=3, ge=1, le=20)
    filtered_ids: Optional[List[str]] = None


# ==============================
# SERVICE DETAIL SCHEMA
# ==============================

# Legacy nested shapes (giữ lại để tương thích với MOCK_SERVICES fallback).
class PriceInfo(BaseModel):
    amount: int
    currency: str = "VND"


class RatingInfo(BaseModel):
    average: float
    total_reviews: int


class LocationInfo(BaseModel):
    address: str
    district: str
    city: str


class ServiceDetail(BaseModel):
    """
    Chấp nhận 2 shape:
      1) Backend AI trả về (camelCase, flat string):
         {id, name, slug, imageUrl, category, duration, price:"₫450.000",
          rating:"0", vendorName, location:"Quận 3, TP.HCM", staffAvatars[], type}
      2) MOCK_SERVICES fallback (snake_case, nested object):
         {service_id, name, image_url, price:{amount,currency},
          rating:{average,total_reviews}, location:{address,district,city}, ...}
    """
    model_config = ConfigDict(populate_by_name=True, extra="allow")

    service_id: str = Field(alias="id")
    name: str
    slug: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    duration: Optional[str] = None
    type: Optional[str] = None
    badge: Optional[str] = None
    booked_count: Optional[int] = None
    staff_name: Optional[str] = None
    slots: Optional[List[str]] = None
    image_url: Optional[str] = Field(default=None, alias="imageUrl")
    vendor_name: Optional[str] = Field(default=None, alias="vendorName")
    staff_avatars: Optional[List[str]] = Field(default=None, alias="staffAvatars")
    price: Optional[Any] = None
    rating: Optional[Any] = None
    location: Optional[Any] = None


# ==============================
# RESPONSE SCHEMAS
# ==============================

class RecommendationResponse(BaseModel):
    recommendations: List[ServiceDetail]
    total: int
    timestamp: str


class ChatbotRecommendationResponse(BaseModel):
    conversation_id: str
    recommendations: List[ServiceDetail]
    total: int
    timestamp: str