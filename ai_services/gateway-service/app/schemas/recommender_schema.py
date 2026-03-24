# app/schemas/recommender_schema.py
from pydantic import BaseModel, Field
from typing import List, Optional, Any, Dict


# ==============================
# REQUEST SCHEMAS
# ==============================

class HomeRecommenderRequest(BaseModel):
    user_id: str = Field(..., min_length=1)
    top_k: int = Field(default=5, ge=1, le=20)


class ChatbotRecommenderRequest(BaseModel):
    conversation_id: str
    query: str = Field(..., min_length=1)
    top_k: int = Field(default=3, ge=1, le=20)
    filtered_ids: Optional[List[str]] = None


# ==============================
# SERVICE DETAIL SCHEMA
# ==============================

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