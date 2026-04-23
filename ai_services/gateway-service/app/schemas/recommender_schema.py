# app/schemas/recommender_schema.py
from pydantic import AliasChoices, BaseModel, ConfigDict, Field
from typing import List, Optional, Any
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
# AI RECOMMENDATION ITEM DTO
# ==============================

class AiRecommendationItemDto(BaseModel):
    """
    Pass-through DTO, match 1:1 với backend `/backend/ai/recommendations`.

    - Chấp nhận cả "service_id" và "id" ở input (backend hiện trả "id",
      mock fallback trả "service_id").
    - Output luôn dùng tên field Python (service_id, imageUrl, vendorName, staffAvatars)
      để khớp spec frontend.
    - `extra="allow"` để backend thêm field mới không cần update DTO.
    """
    model_config = ConfigDict(populate_by_name=True, extra="allow")

    service_id: Optional[str] = Field(
        default=None,
        validation_alias=AliasChoices("service_id", "id"),
    )
    name: Optional[str] = None
    slug: Optional[str] = None
    imageUrl: Optional[str] = None
    category: Optional[str] = None
    duration: Optional[str] = None
    price: Optional[str] = None
    rating: Optional[str] = None
    vendorName: Optional[str] = None
    location: Optional[str] = None
    staffAvatars: Optional[List[str]] = None
    type: Optional[str] = None


# ==============================
# RESPONSE SCHEMAS
# ==============================

class RecommendationResponse(BaseModel):
    recommendations: List[AiRecommendationItemDto]
    total: int
    timestamp: str


class ChatbotRecommendationResponse(BaseModel):
    conversation_id: str
    recommendations: List[AiRecommendationItemDto]
    total: int
    timestamp: str