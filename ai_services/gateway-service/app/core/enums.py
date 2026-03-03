# ai_services/gateway-service/app/core/enums.py
from enum import Enum

class SSEEventType(str, Enum):
    TOKEN = "token"
    NER = "ner"
    RECOMMENDATION = "recommendation"
    DONE = "done"
    ERROR = "error"