from typing import List, Dict
from uuid import UUID
from pydantic import BaseModel, Field


class RecommendationItem(BaseModel):
    service_ids: List[str]
    scores: List[float]


class RecommendationResponse(BaseModel):
    recommendations: List[RecommendationItem]
    total: int


class HomeRecommenderRequest(BaseModel):
    """
    POST /recommender/home
    """

    user_id: str

    # user_profile: Dict[str, List[str]]

    # selected_services: List[str] = Field(default_factory=list)

    top_k: int = Field(default=5, ge=1, le=20)


class ChatbotRecommenderRequest(BaseModel):
    """
    POST /recommender/chatbot
    """

    conversation_id: UUID
    query: str = Field(..., min_length=1)

    top_k: int = Field(default=3, ge=1, le=20)


class ChatbotRecommenderResponse(RecommendationResponse):
    conversation_id: UUID