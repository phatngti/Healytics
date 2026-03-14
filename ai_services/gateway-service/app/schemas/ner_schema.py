# ai_services/gateway-service/app/schemas/ner_schema.py
from typing import List, Optional
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

    # Normalized fields from NER service
    business_type: Optional[str] = None
    location_code: Optional[str] = None
    location_level: Optional[str] = None
    category_slug: Optional[str] = None
    operator: Optional[str] = None
    amount: Optional[float] = None
    amount_max: Optional[float] = None


class NerResponse(BaseModel):
    conversation_id: UUID
    entities: List[NerEntity]


# --- Pre-filter schemas ---

class PreFilterRequest(BaseModel):
    text: str = Field(..., min_length=1)
    limit: int = Field(default=50, ge=1, le=200)


class PreFilterResponse(BaseModel):
    text: str
    entities: List[NerEntity]
    query_params: dict
    candidates: list
    total: int