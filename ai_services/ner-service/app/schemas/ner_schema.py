"""
ai_services/ner-service/app/schemas/ner_schema.py

Pydantic schemas for NER request/response.
Extended with normalized fields for downstream pre-filtering.
"""

from typing import List, Optional
from uuid import UUID

from pydantic import BaseModel, Field


class NerRequest(BaseModel):
    conversation_id: UUID
    text: str = Field(..., min_length=1)


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


class NerResponse(BaseModel):
    conversation_id: UUID
    entities: List[NerEntity]
