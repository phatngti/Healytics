# ai_services/gateway-service/app/schemas/chatbot_schema.py
from typing import List, Optional
from uuid import UUID
from pydantic import BaseModel, ConfigDict, Field
from datetime import datetime

from app.core.enums import SSEEventType
from app.schemas.recommender_schema import ServiceDetail

class ChatbotRequest(BaseModel):
    """
    POST /generative_ai/stream
    """

    conversation_id: Optional[UUID] = None
    user_id: UUID

    message: str = Field(..., min_length=1)

    current_lat: Optional[float] = Field(
        default=None,
        ge=-90,
        le=90,
        description="User's current latitude",
    )
    current_lng: Optional[float] = Field(
        default=None,
        ge=-180,
        le=180,
        description="User's current longitude",
    )

    top_k: int = Field(default=3, ge=1, le=20)


class TokenEvent(BaseModel):
    event: SSEEventType = SSEEventType.TOKEN

    conversation_id: UUID
    text: str
    timestamp: datetime


class RecommendationItem(BaseModel):
    service_ids: List[str]
    scores: List[float]


class RecommendationEvent(BaseModel):
    event: SSEEventType = SSEEventType.RECOMMENDATION
    conversation_id: UUID
    recommendations: List[ServiceDetail]   # ← đổi từ List[RecommendationItem]
    total: int
    timestamp: datetime


class DoneEvent(BaseModel):
    event: SSEEventType = SSEEventType.DONE

    conversation_id: UUID
    status: str = "completed"
    timestamp: datetime

class ErrorEvent(BaseModel):
    event: SSEEventType = SSEEventType.ERROR

    conversation_id: UUID
    error_code: str
    message: str
    timestamp: datetime


class PaginationMeta(BaseModel):
    page: int
    limit: int
    total: int
    totalPages: int


class ConversationResponse(BaseModel):
    id: UUID
    userId: Optional[UUID]
    title: str
    createdAt: datetime
    updatedAt: datetime

    model_config = ConfigDict(from_attributes=True)


class ConversationsPageResponse(BaseModel):
    conversations: List[ConversationResponse]
    meta: PaginationMeta


class MessageResponse(BaseModel):
    id: UUID
    conversationId: UUID
    role: str
    content: str
    createdAt: datetime

    model_config = ConfigDict(from_attributes=True)


class MessagesPageResponse(BaseModel):
    messages: List[MessageResponse]
    meta: PaginationMeta