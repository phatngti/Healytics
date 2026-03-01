from typing import List
from uuid import UUID
from pydantic import BaseModel, Field

from app.core.enums import SSEEventType

class ChatbotRequest(BaseModel):
    """
    POST /generative_ai/stream
    """

    conversation_id: UUID
    user_id: str

    message: str = Field(..., min_length=1)

    top_k: int = Field(default=3, ge=1, le=20)

    enable_recommendation: bool = True
    enable_ner: bool = True



class TokenEvent(BaseModel):
    event: SSEEventType = SSEEventType.TOKEN

    conversation_id: UUID
    text: str
    index: int



class NerEntity(BaseModel):
    type: str
    value: str
    confidence: float = Field(..., ge=0.0, le=1.0)


class NerEvent(BaseModel):
    event: SSEEventType = SSEEventType.NER

    conversation_id: UUID
    entities: List[NerEntity]


class RecommendationItem(BaseModel):
    service_ids: List[str]
    scores: List[float]


class RecommendationEvent(BaseModel):
    event: SSEEventType = SSEEventType.RECOMMENDATION

    conversation_id: UUID
    recommendations: List[RecommendationItem]
    total: int


class DoneEvent(BaseModel):
    event: SSEEventType = SSEEventType.DONE

    conversation_id: UUID
    status: str = "completed"

class ErrorEvent(BaseModel):
    event: SSEEventType = SSEEventType.ERROR

    conversation_id: UUID
    error_code: str
    message: str