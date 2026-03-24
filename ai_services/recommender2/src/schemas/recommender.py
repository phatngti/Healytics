# recommender2/src/schemas/recommender.py
from pydantic import BaseModel, Field
from typing import List, Optional


# ==============================
# REQUEST SCHEMAS (Gateway -> Recommender)
# ==============================

class HomeRecommenderRequest(BaseModel):
    """
    Gateway chỉ gửi identity.
    Service tự query DB/profile.
    """

    user_id: str = Field(..., min_length=1)

    top_k: int = Field(
        default=5,
        ge=1,
        le=20
    )


class ChatbotRecommenderRequest(BaseModel):
    """
    Recommendation từ chat query.
    """

    conversation_id: str
    query: str = Field(..., min_length=1)

    top_k: int = Field(
        default=3,
        ge=1,
        le=20
    )
    filtered_ids: Optional[List[str]] = None


# ==============================
# RESPONSE SCHEMAS
# ==============================

class RecommendationItem(BaseModel):
    service_ids: List[str]
    scores: List[float]


class RecommendationResponse(BaseModel):
    recommendations: List[RecommendationItem]
    total: int


class ChatbotRecommendationResponse(RecommendationResponse):
    conversation_id: str