# ai_services/gateway-service/app/schemas/ner_schema.py
from typing import List
from uuid import UUID
from pydantic import BaseModel, Field
from datetime import datetime

class NerRequest(BaseModel):
    conversation_id: UUID
    text: str = Field(..., min_length=1)


class NerEntity(BaseModel):
    type: str
    value: str
    confidence: float = Field(..., ge=0.0, le=1.0)


class NerResponse(BaseModel):
    conversation_id: UUID
    entities: List[NerEntity]